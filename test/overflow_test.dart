import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panha_portfolio/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Renders the whole portfolio at common screen sizes (and with the menu, dialogs and chat open)
/// and fails if any widget overflows its space.
void main() {
  const sizes = <Size>[
    Size(320, 568), // small phone
    Size(360, 740),
    Size(390, 844), // iPhone 12-15
    Size(640, 900), // sm breakpoint
    Size(768, 1024), // tablet / md
    Size(1024, 768), // lg breakpoint
    Size(1280, 800),
    Size(1440, 900),
  ];

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false; // no network in tests; fall back to default font
    SharedPreferences.setMockInitialValues({});
  });

  for (final size in sizes) {
    for (final dark in [false, true]) {
      testWidgets('no overflow at ${size.width.toInt()}x${size.height.toInt()} ${dark ? 'dark' : 'light'}',
          (tester) async {
        final overflows = <String>[];
        final previous = FlutterError.onError;
        FlutterError.onError = (details) {
          final text = details.exceptionAsString();
          if (text.contains('overflowed') || text.contains('OVERFLOW')) {
            overflows.add(text.split('\n').first);
          }
          // Font-loading errors (no network in tests) are ignored.
        };
        addTearDown(() => FlutterError.onError = previous);

        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.platformBrightnessTestValue = dark ? Brightness.dark : Brightness.light;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

        await tester.pumpWidget(const PortfolioApp());
        await tester.pump(const Duration(seconds: 2));

        // Mobile/tablet menu.
        final menu = find.byTooltip('Toggle navigation menu');
        if (menu.evaluate().isNotEmpty) {
          await tester.tap(menu);
          await tester.pump(const Duration(milliseconds: 400));
          await tester.tap(menu);
          await tester.pump(const Duration(milliseconds: 400));
        }

        // Project details dialog.
        final details = find.text('View details');
        if (details.evaluate().isNotEmpty) {
          await tester.ensureVisible(details.first);
          await tester.pump(const Duration(milliseconds: 100));
          await tester.tap(details.first, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 400));
          await tester.tap(find.byTooltip('Close').last, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 400));
        }

        // Article reader dialog.
        final read = find.text('Read');
        if (read.evaluate().isNotEmpty) {
          await tester.ensureVisible(read.first);
          await tester.pump(const Duration(milliseconds: 100));
          await tester.tap(read.first, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 400));
          await tester.tap(find.byTooltip('Close').last, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 400));
        }

        // Chat panel.
        await tester.tap(find.bySemanticsLabel('Open chat assistant'), warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 400));

        // Drain timers (reveal delays, copy-button reset, etc.).
        await tester.pump(const Duration(seconds: 3));

        expect(overflows, isEmpty, reason: overflows.toSet().join('\n'));
      });
    }
  }
}
