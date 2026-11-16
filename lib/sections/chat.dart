import 'package:flutter/material.dart';

import '../api.dart';
import '../theme.dart';

/// Floating "Ask about Panha" assistant. Talks to /api/chat (Gemini runs server-side).
class ChatLauncher extends StatefulWidget {
  const ChatLauncher({super.key});

  @override
  State<ChatLauncher> createState() => _ChatLauncherState();
}

class _ChatLauncherState extends State<ChatLauncher> {
  static const _quick = {
    'Skills': 'What are Panha’s main skills?',
    'Projects': 'What projects has Panha built?',
    'Experience': 'What is Panha’s work experience?',
    'Availability': 'Is Panha available for new work?',
  };

  bool _open = false;
  bool _typing = false;
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();
  final List<(String role, String text)> _messages = [
    ('model', 'Hi! I can answer questions about Panha’s experience, projects and skills.'),
  ];

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _toBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _send([String? text]) async {
    final prompt = (text ?? _input.text).trim();
    if (prompt.isEmpty || _typing) return;
    final history = List.of(_messages);
    setState(() {
      _messages.add(('user', prompt));
      _input.clear();
      _typing = true;
    });
    _toBottom();
    String reply;
    try {
      reply = await Api.chat(prompt, history);
      if (reply.isEmpty) reply = 'Sorry, I didn’t catch that. Could you rephrase?';
    } catch (_) {
      reply = 'The assistant is unavailable right now. You can reach Panha through the contact form.';
    }
    if (!mounted) return;
    setState(() {
      _messages.add(('model', reply));
      _typing = false;
    });
    _toBottom();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final size = MediaQuery.sizeOf(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(anim),
              child: child,
            ),
          ),
          child: !_open
              ? const SizedBox.shrink()
              : Container(
                  key: const ValueKey('panel'),
                  margin: const EdgeInsets.only(bottom: 16),
                  width: size.width - 32 < 360 ? size.width - 32 : 360,
                  height: size.height - 120 < 500 ? size.height - 120 : 500,
                  decoration: BoxDecoration(
                    color: p.bg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: p.border),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 30, offset: const Offset(0, 12)),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Material(color: p.bg, child: _panel(p)),
                ),
        ),
        Semantics(
          button: true,
          label: _open ? 'Close chat' : 'Open chat assistant',
          child: Material(
            color: p.accent,
            shape: const CircleBorder(),
            elevation: 6,
            shadowColor: Colors.black38,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                setState(() => _open = !_open);
                if (_open) {
                  _toBottom();
                  _focus.requestFocus();
                }
              },
              child: SizedBox(
                width: 56,
                height: 56,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) => RotationTransition(
                    turns: Tween(begin: 0.75, end: 1.0).animate(anim),
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: Icon(_open ? Icons.close : Icons.forum_outlined,
                      key: ValueKey(_open), color: p.onAccent, size: 26),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _panel(Palette p) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: p.border))),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: p.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.smart_toy_outlined, size: 20, color: p.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ask about Panha', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.text)),
                    Row(
                      children: [
                        Container(
                            width: 6, height: 6, decoration: BoxDecoration(color: p.success, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text('AI assistant · usually instant', style: TextStyle(fontSize: 12, color: p.muted)),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Close chat',
                icon: Icon(Icons.close, size: 20, color: p.muted),
                onPressed: () => setState(() => _open = false),
              ),
            ],
          ),
        ),
        // Quick questions
        Container(
          height: 44,
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: p.border))),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              for (final entry in _quick.entries)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () => _send(entry.value),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: p.border),
                      ),
                      alignment: Alignment.center,
                      child: Text(entry.key, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: p.muted)),
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Messages
        Expanded(
          child: Container(
            color: p.surface,
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_typing ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == _messages.length) return _bubble(p, 'model', null);
                final (role, text) = _messages[i];
                return _bubble(p, role, text);
              },
            ),
          ),
        ),
        // Input
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: p.border))),
          child: TextField(
            controller: _input,
            focusNode: _focus,
            enabled: !_typing,
            maxLength: 1000,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _send(),
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Ask about skills, projects or availability',
              suffixIcon: Padding(
                padding: const EdgeInsets.all(6),
                child: Material(
                  color: p.accent,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _typing ? null : () => _send(),
                    child: Tooltip(
                      message: 'Send message',
                      child: Icon(Icons.send, size: 16, color: p.onAccent),
                    ),
                  ),
                ),
              ),
              suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bubble(Palette p, String role, String? text) {
    final user = role == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: Text(user ? 'You' : 'Assistant',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: p.muted)),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 270),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: user ? p.accent : p.bg,
                border: user ? null : Border.all(color: p.border),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(user ? 14 : 4),
                  topRight: Radius.circular(user ? 4 : 14),
                  bottomLeft: const Radius.circular(14),
                  bottomRight: const Radius.circular(14),
                ),
              ),
              child: text == null
                  ? SizedBox(
                      width: 28,
                      height: 14,
                      child: Center(child: LinearProgressIndicator(color: p.muted, backgroundColor: p.border)),
                    )
                  : SelectableText(text,
                      style: TextStyle(fontSize: 13.5, height: 1.5, color: user ? p.onAccent : p.text)),
            ),
          ),
        ],
      ),
    );
  }
}
