import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens shared by every section. Mirrors the Nuxt site's palette:
/// one neutral scale plus a single indigo accent.
@immutable
class Palette extends ThemeExtension<Palette> {
  const Palette({
    required this.bg,
    required this.surface,
    required this.border,
    required this.text,
    required this.muted,
    required this.accent,
    required this.accentStrong,
    required this.onAccent,
    required this.success,
  });

  final Color bg;
  final Color surface;
  final Color border;
  final Color text;
  final Color muted;
  final Color accent;
  final Color accentStrong;
  final Color onAccent;
  final Color success;

  static const light = Palette(
    bg: Color(0xFFFFFFFF),
    surface: Color(0xFFF8FAFC),
    border: Color(0xFFE2E8F0),
    text: Color(0xFF0F172A),
    muted: Color(0xFF475569),
    accent: Color(0xFF4F46E5),
    accentStrong: Color(0xFF4338CA),
    onAccent: Colors.white,
    success: Color(0xFF10B981),
  );

  static const dark = Palette(
    bg: Color(0xFF09090B),
    surface: Color(0xFF141417),
    border: Color(0xFF27272A),
    text: Color(0xFFF4F4F5),
    muted: Color(0xFFA1A1AA),
    accent: Color(0xFF818CF8),
    accentStrong: Color(0xFFA5B4FC),
    onAccent: Color(0xFF09090B),
    success: Color(0xFF34D399),
  );

  @override
  Palette copyWith() => this;

  @override
  Palette lerp(ThemeExtension<Palette>? other, double t) {
    if (other is! Palette) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return Palette(
      bg: l(bg, other.bg),
      surface: l(surface, other.surface),
      border: l(border, other.border),
      text: l(text, other.text),
      muted: l(muted, other.muted),
      accent: l(accent, other.accent),
      accentStrong: l(accentStrong, other.accentStrong),
      onAccent: l(onAccent, other.onAccent),
      success: l(success, other.success),
    );
  }
}

extension PaletteContext on BuildContext {
  Palette get pal => Theme.of(this).extension<Palette>()!;
}

ThemeData buildTheme(Palette p, Brightness brightness) {
  final base = ThemeData(
    brightness: brightness,
    useMaterial3: true,
    // Inter everywhere (loaded by google_fonts on first use).
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme.fromSeed(seedColor: p.accent, brightness: brightness).copyWith(
      primary: p.accent,
      onPrimary: p.onAccent,
      surface: p.bg,
      onSurface: p.text,
      outline: p.border,
    ),
    scaffoldBackgroundColor: p.bg,
    dividerColor: p.border,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    extensions: [p],
  );

  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: c, width: w),
      );

  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: p.text, displayColor: p.text),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: p.accent,
      selectionColor: p.accent.withValues(alpha: 0.25),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: p.bg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: TextStyle(color: p.muted.withValues(alpha: 0.7), fontSize: 14),
      border: border(p.border),
      enabledBorder: border(p.border),
      focusedBorder: border(p.accent, 1.5),
      errorBorder: border(Colors.redAccent),
      focusedErrorBorder: border(Colors.redAccent, 1.5),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(color: p.text, borderRadius: BorderRadius.circular(6)),
      textStyle: TextStyle(color: p.bg, fontSize: 12),
    ),
  );
}

/// Breakpoints (match the Tailwind ones used by the Nuxt site).
class Bp {
  static bool sm(BuildContext c) => MediaQuery.sizeOf(c).width >= 640;
  static bool md(BuildContext c) => MediaQuery.sizeOf(c).width >= 768;
  static bool lg(BuildContext c) => MediaQuery.sizeOf(c).width >= 1024;
}

TextStyle mono(double size, Color color) => GoogleFonts.jetBrainsMono(fontSize: size, color: color);
