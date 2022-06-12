import 'package:flutter/material.dart';
import 'package:gallerybox/pages/home.dart';

void main() {
  runApp(const Gallerybox());
}

class Gallerybox extends StatelessWidget {
  const Gallerybox({Key? key}) : super(key: key);

  static const Color _darkFillColor = Colors.white;
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gallerybox',
        theme: _buildThemeData(_buildColorScheme(), _darkFocusColor),
        themeMode: ThemeMode.dark,
        home: const HomePage());
  }

  _buildThemeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
        colorScheme: colorScheme,
        primaryColor: colorScheme.background,
        focusColor: focusColor,
        highlightColor: Colors.transparent,
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.background,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: colorScheme.surface,
          selectedItemColor: const Color(0xFFbdbdbd),
          unselectedItemColor: colorScheme.secondary,
        ));
  }

  _buildColorScheme() {
    return const ColorScheme(
      primary: _darkFillColor,
      secondary: Colors.white38,
      surface: Color(0xF2222222),
      background: Color(0xFF000000),
      error: _darkFillColor,
      onPrimary: _darkFillColor,
      onSecondary: _darkFillColor,
      onSurface: _darkFillColor,
      onBackground: _darkFillColor,
      onError: _darkFillColor,
      brightness: Brightness.dark,
    );
  }
}
