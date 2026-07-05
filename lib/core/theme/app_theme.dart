import 'package:flutter/material.dart';

// ── Neon palette ────────────────────────────────────────────────────────────
// Electric accents on a near-black midnight-blue canvas. The same five neon
// hues are reused for category tiles in mock_categories.dart so the whole app
// feels like one glowing arcade.
const neonBlue = Color(0xFF00E5FF);
const neonRed = Color(0xFFFF1744);
const neonYellow = Color(0xFFFFEA00);
const neonPurple = Color(0xFFD500F9);
const neonGreen = Color(0xFF00E676);

const _bg = Color(0xFF070B14); // near-black midnight blue
const _surface = Color(0xFF10182B); // cards, sheets
const _surfaceHigh = Color(0xFF1A2440); // chips, inactive tracks
const _inkOnNeon = Color(0xFF04121A); // dark text on glowing buttons

ThemeData buildAppTheme() {
  const scheme = ColorScheme.dark(
    primary: neonBlue,
    onPrimary: _inkOnNeon,
    primaryContainer: Color(0xFF06333F),
    onPrimaryContainer: Color(0xFFA8F4FF),
    secondary: neonPurple,
    onSecondary: _inkOnNeon,
    secondaryContainer: Color(0xFF3A0B4E),
    onSecondaryContainer: Color(0xFFF3C8FF),
    tertiary: neonGreen,
    onTertiary: _inkOnNeon,
    tertiaryContainer: Color(0xFF06381F),
    onTertiaryContainer: Color(0xFFB3FFD1),
    error: neonRed,
    onError: Colors.white,
    errorContainer: Color(0xFF4A0716),
    onErrorContainer: Color(0xFFFFB3C0),
    surface: _surface,
    onSurface: Color(0xFFE8ECF7),
    onSurfaceVariant: Color(0xFF9FA8C3),
    surfaceContainerHighest: _surfaceHigh,
    outline: Color(0xFF3A4566),
    outlineVariant: Color(0xFF232D4A),
  );

  final base = ThemeData(useMaterial3: true, colorScheme: scheme);

  return base.copyWith(
    scaffoldBackgroundColor: _bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: _bg,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.4,
      ),
    ),
    cardTheme: CardThemeData(
      color: _surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: neonBlue.withValues(alpha: 0.14)),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: _surfaceHigh,
      selectedColor: neonPurple.withValues(alpha: 0.28),
      side: BorderSide(color: neonPurple.withValues(alpha: 0.35)),
      labelStyle: const TextStyle(color: Color(0xFFE8ECF7)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: neonBlue,
        foregroundColor: _inkOnNeon,
        textStyle: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: neonGreen,
        side: BorderSide(color: neonGreen.withValues(alpha: 0.6)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: neonYellow),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: neonYellow,
      foregroundColor: _inkOnNeon,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF0B1120),
      indicatorColor: neonPurple.withValues(alpha: 0.30),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? neonPurple : const Color(0xFF9FA8C3),
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
          color: states.contains(WidgetState.selected) ? neonPurple : const Color(0xFF9FA8C3),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surfaceHigh.withValues(alpha: 0.5),
      labelStyle: const TextStyle(color: Color(0xFF9FA8C3)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3A4566)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: neonBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: neonRed.withValues(alpha: 0.7)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: neonRed, width: 2),
      ),
      errorStyle: const TextStyle(color: neonRed),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _surfaceHigh,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: neonGreen.withValues(alpha: 0.4)),
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF232D4A)),
    listTileTheme: const ListTileThemeData(iconColor: Color(0xFF9FA8C3)),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: neonGreen,
      linearTrackColor: _surfaceHigh,
    ),
  );
}
