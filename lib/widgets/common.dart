import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme.dart';

Future<void> openUrl(String url) async {
  await launchUrl(
    Uri.parse(url),
    webOnlyWindowName: url.startsWith('mailto:') ? '_self' : '_blank',
  );
}

/// Gives descendants (e.g. [Reveal]) access to the page's scroll controller.
class ScrollScope extends InheritedWidget {
  const ScrollScope({
    super.key,
    required this.controller,
    required super.child,
  });
  final ScrollController controller;

  static ScrollController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ScrollScope>()?.controller;

  @override
  bool updateShouldNotify(ScrollScope oldWidget) =>
      oldWidget.controller != controller;
}

/// Centered, max-width page column with responsive side padding.
class PageContainer extends StatelessWidget {
  const PageContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1152),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Bp.sm(context) ? 32 : 20),
          child: child,
        ),
      ),
    );
  }
}

/// A page section. `alt` sections get the tinted surface background, like the Nuxt site.
class Section extends StatelessWidget {
  const Section({super.key, required this.child, this.alt = false});
  final Widget child;
  final bool alt;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Container(
      width: double.infinity,
      decoration: alt
          ? BoxDecoration(
              color: p.surface,
              border: Border.symmetric(horizontal: BorderSide(color: p.border)),
            )
          : null,
      padding: EdgeInsets.symmetric(vertical: Bp.md(context) ? 112 : 80),
      child: PageContainer(child: child),
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.7,
      color: context.pal.accent,
    ),
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.lead,
  });
  final String eyebrow;
  final String title;
  final String? lead;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 672),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(eyebrow),
          const SizedBox(height: 12),
          Semantics(
            header: true,
            child: Text(
              title,
              style: TextStyle(
                fontSize: Bp.sm(context) ? 36 : 30,
                height: 1.15,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.8,
                color: p.text,
              ),
            ),
          ),
          if (lead != null) ...[
            const SizedBox(height: 16),
            Text(
              lead!,
              style: TextStyle(
                fontSize: Bp.md(context) ? 18 : 16,
                height: 1.6,
                color: p.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Bordered card. With [onTap] or [hover] it highlights its border on hover.
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.hover = false,
    this.onTap,
    this.color,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool hover;
  final VoidCallback? onTap;
  final Color? color;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final interactive = widget.hover || widget.onTap != null;
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.color ?? p.bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _hovered && interactive
              ? p.accent.withValues(alpha: 0.45)
              : p.border,
        ),
      ),
      child: widget.child,
    );
    if (!interactive) return card;
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      ),
    );
  }
}

class TagChip extends StatelessWidget {
  const TagChip(this.text, {super.key, this.large = false});
  final String text;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: large ? 6 : 4),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: p.border),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: large ? 13 : 12,
          fontWeight: FontWeight.w500,
          color: p.muted,
        ),
      ),
    );
  }
}

enum ButtonKind { primary, secondary }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.leadingIcon,
    this.kind = ButtonKind.primary,
    this.loading = false,
    this.expand = false,
    this.semanticLabel,
    this.dense = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? leadingIcon;
  final ButtonKind kind;
  final bool loading;
  final bool expand;
  final String? semanticLabel;

  /// Shorter (36px) variant used in the header.
  final bool dense;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final primary = widget.kind == ButtonKind.primary;
    final enabled = widget.onPressed != null && !widget.loading;
    final bg = primary
        ? (_hovered ? p.accentStrong : p.accent)
        : (_hovered ? p.surface : p.bg);
    final fg = primary ? p.onAccent : p.text;

    final content = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.loading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          ),
          const SizedBox(width: 8),
        ] else if (widget.leadingIcon != null) ...[
          Icon(widget.leadingIcon, size: 18, color: fg),
          if (widget.label.isNotEmpty) const SizedBox(width: 8),
        ],
        if (widget.label.isNotEmpty)
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: fg,
            ),
          ),
        if (widget.icon != null) ...[
          const SizedBox(width: 8),
          AnimatedSlide(
            duration: const Duration(milliseconds: 200),
            offset: Offset(_hovered ? 0.15 : 0, 0),
            child: Icon(widget.icon, size: 18, color: fg),
          ),
        ],
      ],
    );

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      enabled: enabled,
      child: MouseRegion(
        cursor: enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: enabled ? widget.onPressed : null,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: enabled || widget.loading ? 1 : 0.6,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: widget.label.isEmpty
                    ? 12
                    : (widget.dense ? 16 : 20),
                vertical: widget.dense ? 8 : 12,
              ),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(8),
                border: primary ? null : Border.all(color: p.border),
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

/// Small icon-only square button (theme toggle, menu, close).
class IconSquare extends StatelessWidget {
  const IconSquare({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.bordered = true,
  });
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: p.surface,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: bordered ? Border.all(color: p.border) : null,
            ),
            child: Icon(icon, size: 20, color: p.muted),
          ),
        ),
      ),
    );
  }
}

/// Text link with an arrow that nudges right on hover.
class ArrowLink extends StatefulWidget {
  const ArrowLink({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<ArrowLink> createState() => _ArrowLinkState();
}

class _ArrowLinkState extends State<ArrowLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: p.accent,
                decoration: _hovered ? TextDecoration.underline : null,
                decorationColor: p.accent,
              ),
            ),
            const SizedBox(width: 4),
            AnimatedSlide(
              duration: const Duration(milliseconds: 200),
              offset: Offset(_hovered ? 0.2 : 0, 0),
              child: Icon(Icons.arrow_forward, size: 16, color: p.accent),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fades and slides its child in the first time it scrolls into view.
/// Uses only opacity + transform, and respects the OS "reduce motion" setting.
///
/// With [onLoad] the animation starts as soon as the widget is first laid out (used for the
/// hero, which is always on screen when the page opens) instead of waiting for visibility.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.onLoad = false,
  });
  final Widget child;
  final Duration delay;
  final bool onLoad;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  ScrollController? _scroll;
  bool _started = false;
  int _retries = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scroll = ScrollScope.maybeOf(context);
    if (scroll != _scroll) {
      _scroll?.removeListener(_check);
      _scroll = scroll;
      if (!_started) _scroll?.addListener(_check);
    }
    _checkAfterFrame();
  }

  // The window was resized (e.g. layout switched at a breakpoint): look again.
  @override
  void didChangeMetrics() => _checkAfterFrame();

  void _checkAfterFrame() {
    if (_started) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
    WidgetsBinding.instance.scheduleFrame();
  }

  void _start() {
    _started = true;
    _scroll?.removeListener(_check);
    WidgetsBinding.instance.removeObserver(this);
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  void _check() {
    if (_started || !mounted) return;
    final box = context.findRenderObject();
    final viewport =
        View.of(context).physicalSize.height /
        View.of(context).devicePixelRatio;
    // Layout or window size not settled yet: try again next frame instead of giving up.
    if (box is! RenderBox || !box.attached || !box.hasSize || viewport <= 0) {
      if (_retries++ < 120) _checkAfterFrame();
      return;
    }
    if (widget.onLoad || box.localToGlobal(Offset.zero).dy < viewport * 0.92) {
      _start();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scroll?.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return FadeTransition(
      opacity: _curve,
      child: AnimatedBuilder(
        animation: _curve,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, 14 * (1 - _curve.value)),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

/// Grid whose rows share the height of their tallest item, so cards line up.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.columns,
    required this.children,
    this.gap = 20,
  });
  final int columns;
  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      final cells = <Widget>[];
      for (var c = 0; c < columns; c++) {
        if (c > 0) cells.add(SizedBox(width: gap));
        final index = i + c;
        cells.add(
          Expanded(
            child: index < children.length ? children[index] : const SizedBox(),
          ),
        );
      }
      if (rows.isNotEmpty) rows.add(SizedBox(height: gap));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cells,
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}
