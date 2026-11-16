import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:panha_portfolio/data.dart';
import 'package:panha_portfolio/home.dart';
import 'package:panha_portfolio/main.dart';
import 'package:panha_portfolio/sections/content.dart';
import 'package:panha_portfolio/theme.dart';
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
    useWebFonts = false; // no network in tests; use the default font
    SharedPreferences.setMockInitialValues({});
  });

  for (final size in sizes) {
    for (final dark in [false, true]) {
      testWidgets(
        'no overflow at ${size.width.toInt()}x${size.height.toInt()} ${dark ? 'dark' : 'light'}',
        (tester) async {
          final overflows = <String>[];
          final previous = FlutterError.onError;
          FlutterError.onError = (details) {
            final text = details.exceptionAsString();
            if (text.contains('overflowed') || text.contains('OVERFLOW')) {
              // Include where in lib/ the overflowing widget was created.
              final where =
                  RegExp(r'lib/[\w/]+\.dart:\d+')
                      .firstMatch(details.toString())
                      ?.group(0) ??
                  '?';
              overflows.add('${text.split('\n').first}  ($where)');
            } else {
              previous?.call(details);
            }
          };

          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          tester.platformDispatcher.platformBrightnessTestValue = dark
              ? Brightness.dark
              : Brightness.light;
          addTearDown(tester.view.reset);
          addTearDown(
            tester.platformDispatcher.clearPlatformBrightnessTestValue,
          );

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

          final pageContext = tester.element(find.byType(HomePage));

          // Every project details dialog.
          for (final project in projects) {
            showProjectDialog(pageContext, project);
            await tester.pump(const Duration(milliseconds: 400));
            Navigator.of(pageContext).pop();
            await tester.pump(const Duration(milliseconds: 400));
          }

          // Every article in the reader dialog.
          for (final post in posts) {
            showPostDialog(pageContext, post);
            await tester.pump(const Duration(milliseconds: 400));
            Navigator.of(pageContext).pop();
            await tester.pump(const Duration(milliseconds: 400));
          }

          // Chat panel.
          await tester.tap(find.byIcon(Icons.forum_outlined));
          await tester.pump(const Duration(milliseconds: 400));
          expect(find.text('Ask about Panha'), findsOneWidget);

          // Drain timers (reveal delays etc.).
          await tester.pump(const Duration(seconds: 3));

          FlutterError.onError = previous;
          expect(overflows, isEmpty, reason: overflows.toSet().join('\n'));
        },
      );
    }
  }
}
