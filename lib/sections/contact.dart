import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets/common.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  static const _types = [
    ('Mobile App Development', 'Mobile app (Flutter)'),
    ('Full-Stack Web Development', 'Web application (Nuxt / Vue)'),
    ('Backend / API', 'Backend or API'),
    ('Full-time Role', 'Full-time role'),
    ('General Inquiry', 'Something else'),
  ];

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  String _type = _types.first.$1;
  bool _sending = false;
  bool _copied = false;
  ({bool ok, String text})? _status;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _copyEmail() async {
    await Clipboard.setData(const ClipboardData(text: email));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  Future<void> _submit() async {
    if (_sending) return;
    final name = _name.text.trim(), mail = _email.text.trim(), message = _message.text.trim();
    if (name.isEmpty || mail.isEmpty || message.isEmpty) {
      setState(() => _status = (ok: false, text: 'Please fill in your name, email and message.'));
      return;
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(mail)) {
      setState(() => _status = (ok: false, text: 'Please enter a valid email address.'));
      return;
    }
    setState(() {
      _sending = true;
      _status = null;
    });
    try {
      await Api.sendContact(name: name, email: mail, type: _type, message: message);
      _name.clear();
      _email.clear();
      _message.clear();
      setState(() => _status = (ok: true, text: "Thanks! Your message has been sent. I'll reply soon."));
    } on ApiException catch (e) {
      setState(() => _status = (ok: false, text: e.message));
    } catch (_) {
      setState(() => _status = (ok: false, text: 'Something went wrong. Please email me at $email.'));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;

    Widget infoRow(IconData icon, Widget content, {Widget? trailing}) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 20, color: p.muted),
                const SizedBox(width: 12),
                Expanded(child: content),
                ?trailing,
              ],
            ),
          ),
        );

    TextStyle linkStyle() => TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: p.text);

    final info = Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            eyebrow: 'Contact',
            title: "Let's work together",
            lead:
                "Have a mobile app, web platform or backend project in mind? Send me a message and I'll get back to you within one or two working days.",
          ),
          const SizedBox(height: 40),
          infoRow(
            Icons.mail_outline,
            InkWell(
              onTap: () => openUrl('mailto:$email'),
              child: Text(email, overflow: TextOverflow.ellipsis, style: linkStyle()),
            ),
            trailing: AppButton(
              label: _copied ? 'Copied' : 'Copy',
              leadingIcon: _copied ? Icons.check : Icons.content_copy,
              kind: ButtonKind.secondary,
              semanticLabel: _copied ? 'Email copied' : 'Copy email address',
              onPressed: _copyEmail,
            ),
          ),
          infoRow(
            Icons.send_outlined,
            InkWell(
              onTap: () => openUrl(telegramUrl),
              child: Text('Telegram: $telegramHandle', style: linkStyle()),
            ),
          ),
          infoRow(
            Icons.location_on_outlined,
            Text.rich(TextSpan(children: [
              TextSpan(text: location, style: linkStyle()),
              TextSpan(text: '  (UTC+7)', style: TextStyle(fontSize: 14, color: p.muted)),
            ])),
          ),
        ],
      ),
    );

    Widget field(String label, Widget input) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: p.text)),
            const SizedBox(height: 6),
            input,
          ],
        );

    final nameField = field(
      'Name',
      TextField(
        controller: _name,
        maxLength: 120,
        autofillHints: const [AutofillHints.name],
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(counterText: ''),
      ),
    );
    final emailField = field(
      'Email',
      TextField(
        controller: _email,
        maxLength: 200,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(counterText: ''),
      ),
    );

    final form = Reveal(
      delay: const Duration(milliseconds: 120),
      child: AppCard(
        padding: EdgeInsets.all(Bp.sm(context) ? 32 : 24),
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (Bp.sm(context))
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Expanded(child: nameField), const SizedBox(width: 20), Expanded(child: emailField)],
                )
              else ...[nameField, const SizedBox(height: 20), emailField],
              const SizedBox(height: 20),
              field(
                'What can I help with?',
                DropdownButtonFormField<String>(
                  initialValue: _type,
                  isExpanded: true,
                  dropdownColor: p.bg,
                  borderRadius: BorderRadius.circular(8),
                  style: TextStyle(fontSize: 14, color: p.text),
                  items: [
                    for (final (value, label) in _types) DropdownMenuItem(value: value, child: Text(label)),
                  ],
                  onChanged: (v) => setState(() => _type = v ?? _type),
                ),
              ),
              const SizedBox(height: 20),
              field(
                'Message',
                TextField(
                  controller: _message,
                  maxLength: 5000,
                  minLines: 5,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: 'A few lines about the project, timeline and budget.',
                  ),
                ),
              ),
              if (_status != null) ...[
                const SizedBox(height: 20),
                Semantics(
                  liveRegion: true,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: (_status!.ok ? p.success : Colors.red).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: (_status!.ok ? p.success : Colors.red).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(_status!.ok ? Icons.check_circle_outline : Icons.error_outline,
                            size: 18, color: _status!.ok ? p.success : Colors.red.shade400),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_status!.text, style: TextStyle(fontSize: 14, color: p.text))),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: AppButton(
                  label: _sending ? 'Sending…' : 'Send message',
                  loading: _sending,
                  expand: !Bp.sm(context),
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Section(
      child: Bp.lg(context)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: info),
                const SizedBox(width: 48),
                Expanded(flex: 7, child: form),
              ],
            )
          : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [info, const SizedBox(height: 40), form]),
    );
  }
}

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final links = Wrap(
      spacing: 20,
      runSpacing: 8,
      children: [
        for (final (label, icon, url) in [
          ('GitHub', Icons.code, githubUrl),
          ('Telegram', Icons.send_outlined, telegramUrl),
          ('Email', Icons.mail_outline, 'mailto:$email'),
        ])
          InkWell(
            onTap: () => openUrl(url),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: p.muted),
                const SizedBox(width: 6),
                Text(label, style: TextStyle(fontSize: 14, color: p.muted)),
              ],
            ),
          ),
      ],
    );
    final copyright =
        Text('© ${DateTime.now().year} $ownerName. All rights reserved.', style: TextStyle(fontSize: 14, color: p.muted));

    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: p.border))),
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: PageContainer(
        child: Bp.sm(context)
            ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [copyright, links])
            : Column(children: [copyright, const SizedBox(height: 16), links]),
      ),
    );
  }
}
