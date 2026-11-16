import 'dart:convert';

import 'package:http/http.dart' as http;

/// Client for the small server API (contact form + AI chat).
///
/// The secrets (Gemini, Telegram, Supabase service-role) stay on the server; this app only
/// calls `/api/contact` and `/api/chat`. By default it calls the same origin the site is served
/// from. For local development against another server, build or run with
/// `--dart-define=API_BASE=http://localhost:3000`.
class Api {
  static const _base = String.fromEnvironment('API_BASE');

  static Uri _uri(String path) => _base.isEmpty ? Uri.base.resolve(path) : Uri.parse('$_base$path');

  static Future<void> sendContact({
    required String name,
    required String email,
    required String type,
    required String message,
  }) async {
    final res = await http.post(
      _uri('/api/contact'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'type': type, 'message': message}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) return;
    throw ApiException(_errorMessage(res.body) ?? 'Something went wrong. Please email me directly.');
  }

  /// [history] is a list of (role, text) pairs, role being 'user' or 'model'.
  static Future<String> chat(String prompt, List<(String, String)> history) async {
    final res = await http.post(
      _uri('/api/chat'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'prompt': prompt,
        'history': [
          for (final (role, text) in history)
            {
              'role': role,
              'parts': [
                {'text': text}
              ]
            }
        ],
      }),
    );
    if (res.statusCode != 200) throw ApiException('Chat is unavailable right now.');
    final data = jsonDecode(res.body);
    return (data is Map && data['responseText'] is String) ? data['responseText'] as String : '';
  }

  static String? _errorMessage(String body) {
    try {
      final data = jsonDecode(body);
      if (data is Map) return (data['statusMessage'] ?? data['message']) as String?;
    } catch (_) {}
    return null;
  }
}

class ApiException implements Exception {
  ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}
