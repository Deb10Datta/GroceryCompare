import 'package:flutter/material.dart';

// ── Pop palette ─────────────────────────────────────────────────────────────
// Bright neo-brutalist look: orange, yellow, blue and green doing the
// heavy lifting on a warm cream canvas, with every section framed by a
// thick black outline. The same hues colour the category tiles in
// mock_categories.dart so the whole app reads as one system.
const popOrange = Color(0xFFFF6B2C);
const popYellow = Color(0xFFFFC91F);
const popBlue = Color(0xFF2E86FF);
const popGreen = Color(0xFF00A651);
const popRed = Color(0xFFE6003D); // errors only — not a brand colour

const _ink = Color(0xFF121212); // borders + text
const _bg = Color(0xFFFFF6E6); // warm cream canvas
const _surface = Colors.white; // cards, sheets
const _surfaceHigh = Color(0xFFFFF0CE); // chips, inactive tracks

ThemeData buildAppTheme() {
  const scheme = ColorScheme.light(
    primary: popOrange,
    onPrimary: _ink,
    primaryContainer: Color(0xFFFFE1CC),
    onPrimaryContainer: Color(0xFF5A2200),
    secondary: popYellow,
    onSecondary: _ink,
    secondaryContainer: Color(0xFFFFF0BF),
    onSecondaryContainer: Color(0xFF4A3B00),
    tertiary: popBlue,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFD6E7FF),
    onTertiaryContainer: Color(0xFF00316B),
    error: popRed,
    onError: Colors.white,
    errorContainer: Color(0xFFFFD9DF),
    onErrorContainer: Color(0xFF66001B),
    surface: _surface,
    onSurface: _ink,
    onSurfaceVariant: Color(0xFF4F4A40),
    surfaceContainerHighest: _surfaceHigh,
    outline: _ink,
    outlineVariant: _ink,
  );

  final base = ThemeData(useMaterial3: true, colorScheme: scheme);

  // The thick black frame every "section" (cards, buttons, fields, chips)
  // wears — the signature of the whole look.
  const inkBorder = BorderSide(color: _ink, width: 2.5);

  return base.copyWith(
    scaffoldBackgroundColor: _bg,
    // Web-app style navigation: pages fade in and rise instead of the
    // platform-default slide, on every target.
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _bg,
      foregroundColor: _ink,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: _ink,
        fontSize: 20,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.4,
      ),
      shape: Border(bottom: BorderSide(color: _ink, width: 2.5)),
    ),
    cardTheme: CardThemeData(
      color: _surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: inkBorder,
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: _surface,
      selectedColor: popYellow,
      side: const BorderSide(color: _ink, width: 1.8),
      labelStyle: const TextStyle(color: _ink, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: popOrange,
        foregroundColor: _ink,
        disabledBackgroundColor: const Color(0xFFE8DCC8),
        disabledForegroundColor: const Color(0xFF8A8478),
        textStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        side: inkBorder,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _ink,
        backgroundColor: _surface,
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
        side: const BorderSide(color: _ink, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: popBlue,
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: popYellow,
      foregroundColor: _ink,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: inkBorder,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _surface,
      elevation: 0,
      indicatorColor: popYellow,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _ink, width: 1.8),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? _ink : const Color(0xFF6E685C),
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected) ? FontWeight.w800 : FontWeight.w600,
          color: _ink,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surface,
      labelStyle: const TextStyle(color: Color(0xFF4F4A40)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _ink, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: popBlue, width: 3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: popRed, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: popRed, width: 3),
      ),
      errorStyle: const TextStyle(color: popRed, fontWeight: FontWeight.w600),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _ink,
      contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: popYellow, width: 2),
      ),
    ),
    dividerTheme: const DividerThemeData(color: _ink, thickness: 1.5),
    listTileTheme: const ListTileThemeData(iconColor: _ink),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: popGreen,
      linearTrackColor: _surfaceHigh,
    ),
  );
}
