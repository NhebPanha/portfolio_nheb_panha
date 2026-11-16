import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets/common.dart';

enum Sec { hero, about, experience, projects, skills, writing, contact }

const navItems = [
  (Sec.about, 'About'),
  (Sec.experience, 'Experience'),
  (Sec.projects, 'Projects'),
  (Sec.skills, 'Skills'),
  (Sec.writing, 'Writing'),
  (Sec.contact, 'Contact'),
];

class SiteHeader extends StatefulWidget {
  const SiteHeader({
    super.key,
    required this.scrolled,
    required this.active,
    required this.onNavigate,
    required this.onToggleTheme,
  });

  final ValueListenable<bool> scrolled;
  final ValueListenable<Sec?> active;
  final void Function(Sec) onNavigate;
  final VoidCallback onToggleTheme;

  @override
  State<SiteHeader> createState() => _SiteHeaderState();
}

class _SiteHeaderState extends State<SiteHeader> {
  bool _menuOpen = false;

  void _go(Sec s) {
    setState(() => _menuOpen = false);
    widget.onNavigate(s);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wide = Bp.lg(context);

    return ValueListenableBuilder<bool>(
      valueListenable: widget.scrolled,
      builder: (context, scrolled, _) {
        final solid = scrolled || _menuOpen;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: solid
                ? p.bg.withValues(alpha: 0.94)
                : p.bg.withValues(alpha: 0),
            border: Border(
              bottom: BorderSide(
                color: solid ? p.border : p.border.withValues(alpha: 0),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 64,
                child: PageContainer(
                  child: Row(
                    children: [
                      // Logo
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _go(Sec.hero),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF18181B),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: p.border),
                                ),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                ownerName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: p.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Links take the space between logo and buttons and shrink only if they must.
                      if (wide)
                        Expanded(
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: ValueListenableBuilder<Sec?>(
                                valueListenable: widget.active,
                                builder: (context, active, _) => Row(
                                  children: [
                                    for (final (sec, label) in navItems)
                                      _NavLink(
                                        label: label,
                                        active: active == sec,
                                        onTap: () => _go(sec),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        const Spacer(),
                      IconSquare(
                        icon: isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        tooltip: isDark
                            ? 'Switch to light theme'
                            : 'Switch to dark theme',
                        onTap: widget.onToggleTheme,
                      ),
                      if (Bp.sm(context)) ...[
                        const SizedBox(width: 8),
                        AppButton(
                          label: 'Contact me',
                          dense: true,
                          onPressed: () => _go(Sec.contact),
                        ),
                      ],
                      if (!wide) ...[
                        const SizedBox(width: 8),
                        IconSquare(
                          icon: _menuOpen ? Icons.close : Icons.menu,
                          tooltip: 'Toggle navigation menu',
                          onTap: () => setState(() => _menuOpen = !_menuOpen),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Mobile menu
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: !_menuOpen || wide
                    ? const SizedBox(width: double.infinity)
                    : Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: p.border)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: PageContainer(
                          child: ValueListenableBuilder<Sec?>(
                            valueListenable: widget.active,
                            builder: (context, active, _) => Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (final (sec, label) in navItems)
                                  InkWell(
                                    onTap: () => _go(sec),
                                    borderRadius: BorderRadius.circular(6),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: active == sec
                                              ? p.accent
                                              : p.text,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                AppButton(
                                  label: 'Contact me',
                                  expand: true,
                                  onPressed: () => _go(Sec.contact),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Semantics(
      link: true,
      selected: widget.active,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: widget.active || _hovered ? p.text : p.muted,
              ),
              child: Text(widget.label),
            ),
          ),
        ),
      ),
    );
  }
}
