import 'package:flutter/material.dart';

import 'sections/chat.dart';
import 'sections/contact.dart';
import 'sections/content.dart';
import 'sections/header.dart';
import 'sections/hero.dart';
import 'widgets/common.dart';

/// The single-page portfolio: fixed header over a scrolling column of sections.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onToggleTheme});
  final VoidCallback onToggleTheme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _headerHeight = 64.0;

  final _scroll = ScrollController();
  final _keys = {for (final s in Sec.values) s: GlobalKey(debugLabel: s.name)};
  final _scrolled = ValueNotifier(false);
  final _active = ValueNotifier<Sec?>(null);
  bool _ticking = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _scrolled.dispose();
    _active.dispose();
    super.dispose();
  }

  // At most one update per frame.
  void _onScroll() {
    if (_ticking) return;
    _ticking = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ticking = false;
      if (!mounted || !_scroll.hasClients) return;
      _scrolled.value = _scroll.offset > 8;

      Sec? current;
      for (final s in Sec.values) {
        final box = _keys[s]!.currentContext?.findRenderObject() as RenderBox?;
        if (box != null && box.attached && box.localToGlobal(Offset.zero).dy <= 140) current = s;
      }
      if (_scroll.offset >= _scroll.position.maxScrollExtent - 40) current = Sec.contact;
      _active.value = current == Sec.hero ? null : current;
    });
  }

  void _goTo(Sec s) {
    final box = _keys[s]!.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !_scroll.hasClients) return;
    final target = s == Sec.hero ? 0.0 : _scroll.offset + box.localToGlobal(Offset.zero).dy - _headerHeight + 1;
    _scroll.animateTo(
      target.clamp(0.0, _scroll.position.maxScrollExtent),
      duration: Duration(milliseconds: MediaQuery.disableAnimationsOf(context) ? 1 : 700),
      curve: Curves.easeInOutCubic,
    );
  }

  Widget _section(Sec s, Widget child) => KeyedSubtree(key: _keys[s], child: child);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollScope(
        controller: _scroll,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                controller: _scroll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _section(Sec.hero, HeroSection(onNavigate: _goTo)),
                    _section(Sec.about, const AboutSection()),
                    _section(Sec.experience, const ExperienceSection()),
                    _section(Sec.projects, const ProjectsSection()),
                    _section(Sec.skills, const SkillsSection()),
                    _section(Sec.writing, const WritingSection()),
                    _section(Sec.contact, const ContactSection()),
                    const SiteFooter(),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SiteHeader(
                scrolled: _scrolled,
                active: _active,
                onNavigate: _goTo,
                onToggleTheme: widget.onToggleTheme,
              ),
            ),
            const Positioned(right: 24, bottom: 24, child: ChatLauncher()),
          ],
        ),
      ),
    );
  }
}
