import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'header.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onNavigate});
  final void Function(Sec) onNavigate;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final wide = Bp.lg(context);
    const step = Duration(milliseconds: 60);

    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Reveal(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: p.bg,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: p.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: p.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Available for freelance and full-time roles',
                    style: TextStyle(fontSize: 14, color: p.muted),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Reveal(
          delay: step,
          child: Semantics(
            header: true,
            child: Text(
              ownerName,
              style: TextStyle(
                fontSize: Bp.sm(context) ? 60 : 46,
                height: 1.05,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.6,
                color: p.text,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Reveal(
          delay: step * 2,
          child: Text(
            ownerRole,
            style: TextStyle(
              fontSize: Bp.sm(context) ? 24 : 20,
              fontWeight: FontWeight.w500,
              color: p.muted,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Reveal(
          delay: step * 3,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 576),
            child: Text(
              heroIntro,
              style: TextStyle(
                fontSize: Bp.md(context) ? 18 : 16,
                height: 1.65,
                color: p.muted,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Reveal(
          delay: step * 4,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppButton(
                label: 'View my work',
                icon: Icons.arrow_forward,
                onPressed: () => onNavigate(Sec.projects),
              ),
              AppButton(
                label: 'Get in touch',
                kind: ButtonKind.secondary,
                onPressed: () => onNavigate(Sec.contact),
              ),
              AppButton(
                label: '',
                leadingIcon: Icons.code,
                kind: ButtonKind.secondary,
                semanticLabel: 'GitHub profile',
                onPressed: () => openUrl(githubUrl),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        Reveal(
          delay: step * 5,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 512),
            child: Container(
              padding: const EdgeInsets.only(top: 24),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: p.border)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final fact in heroFacts)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fact.label.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w500,
                              color: p.muted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            fact.value,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: p.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    final portrait = Reveal(delay: step * 2, child: const _Portrait());

    return Stack(
      children: [
        const Positioned.fill(child: _Backdrop()),
        Padding(
          padding: EdgeInsets.only(
            top: Bp.md(context) ? 160 : 128,
            bottom: Bp.md(context) ? 112 : 80,
          ),
          child: PageContainer(
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 7, child: intro),
                      const SizedBox(width: 40),
                      Expanded(
                        flex: 5,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: portrait,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      intro,
                      const SizedBox(height: 56),
                      Center(child: portrait),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _Portrait extends StatelessWidget {
  const _Portrait();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 384),
      child: Padding(
        // Room for the outer ring and the location card that hangs below the photo.
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -12,
              top: -12,
              right: -12,
              bottom: -12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: p.border),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: p.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 30,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    'assets/images/panha_portrait.jpg',
                    fit: BoxFit.cover,
                    semanticLabel: 'Portrait of $ownerName',
                    // Fade the photo in once decoded instead of popping in.
                    frameBuilder: (context, child, frame, wasSyncLoaded) {
                      if (wasSyncLoaded) return child;
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: -20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: p.bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: p.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 18, color: p.muted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        location,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: p.text,
                        ),
                      ),
                    ),
                    Text('UTC+7', style: mono(12, p.muted)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Soft accent wash + faint grid fading out from the top, drawn once (no blur filters).
class _Backdrop extends StatelessWidget {
  const _Backdrop();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _BackdropPainter(accent: p.accent, line: p.border),
        ),
      ),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  _BackdropPainter({required this.accent, required this.line});
  final Color accent;
  final Color line;

  @override
  void paint(Canvas canvas, Size size) {
    final wash = Paint()
      ..shader =
          RadialGradient(
            center: Alignment.topCenter,
            radius: 0.9,
            colors: [
              accent.withValues(alpha: 0.14),
              accent.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromLTWH(0, -size.height * 0.2, size.width, size.height * 1.1),
          );
    canvas.drawRect(Offset.zero & size, wash);

    const cell = 56.0;
    final center = Offset(size.width / 2, 0);
    final maxDist = size.height * 0.75;
    final paint = Paint()..strokeWidth = 1;
    // Each grid segment fades with its distance from the top centre.
    for (double x = (size.width / 2) % cell; x < size.width; x += cell) {
      for (double y = 0; y < size.height; y += cell) {
        final d = (Offset(x, y + cell / 2) - center).distance / maxDist;
        if (d >= 1) continue;
        paint.color = line.withValues(alpha: 0.6 * (1 - d));
        canvas.drawLine(Offset(x, y), Offset(x, y + cell), paint);
      }
    }
    for (double y = 0; y < size.height; y += cell) {
      for (
        double x = (size.width / 2) % cell - cell;
        x < size.width;
        x += cell
      ) {
        final d = (Offset(x + cell / 2, y) - center).distance / maxDist;
        if (d >= 1) continue;
        paint.color = line.withValues(alpha: 0.6 * (1 - d));
        canvas.drawLine(Offset(x, y), Offset(x + cell, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_BackdropPainter old) =>
      old.accent != accent || old.line != line;
}
