import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';
import 'home.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Builds the accessibility tree up front so screen readers (and text search) can read the page.
  SemanticsBinding.instance.ensureSemantics();
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  static const _prefKey = 'theme';
  ThemeMode _mode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      final saved = prefs.getString(_prefKey);
      if (!mounted || saved == null) return;
      setState(
        () => _mode = saved == 'dark' ? ThemeMode.dark : ThemeMode.light,
      );
    });
  }

  void _toggleTheme(Brightness current) {
    final next = current == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    setState(() => _mode = next);
    SharedPreferences.getInstance().then(
      (prefs) =>
          prefs.setString(_prefKey, next == ThemeMode.dark ? 'dark' : 'light'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$ownerName — $ownerRole',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Palette.light, Brightness.light),
      darkTheme: buildTheme(Palette.dark, Brightness.dark),
      themeMode: _mode,
      themeAnimationDuration: const Duration(milliseconds: 250),
      home: Builder(
        builder: (context) => HomePage(
          onToggleTheme: () => _toggleTheme(Theme.of(context).brightness),
        ),
      ),
    );
  }
}
