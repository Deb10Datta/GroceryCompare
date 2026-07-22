import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Market palette ──────────────────────────────────────────────────────────
// Warm editorial look, lifted from the "Market" direction of the app's
// Claude Design project: cream canvas, tangerine accent, soft warm-tinted
// shadows instead of hard borders. Instrument Serif carries headlines, Plus
// Jakarta Sans carries everything else. Every screen reads these through
// Theme.of(context) — nothing below is theme-agnostic except the flat
// category tints (mock_categories.dart), which have no BuildContext to read
// brightness from and so intentionally share the light-mode hex values.

const accentColor = Color(0xFFFF5E1F); // primary CTA / selected state
const accent2Color = Color(0xFFF0451F); // gradient end / "urgent" text
const leafColor = Color(0xFF1F7A4D); // success
const berryColor = Color(0xFFE23A6E); // secondary accent
const ochreColor = Color(0xFFE0A537); // category tint — muted gold
const slateBlueColor = Color(0xFF4A7FBF); // category tint — dusty blue

// Light tokens
const _lightBg = Color(0xFFFBF5EC);
const _lightSurface = Colors.white;
const _lightSurface2 = Color(0xFFFDEBDD);
const _lightInk = Color(0xFF1C1710);
const _lightSub = Color(0xFF857767);
const _lightLine = Color(0xFFF0E7D9);
const _lightAccent = accentColor;
const _lightAccent2 = accent2Color;
const _lightOnAccent = Colors.white;
const _lightLeaf = leafColor;
const _lightBerry = berryColor;
const _lightError = Color(0xFFD64545);
const _lightShadow = Color(0xFF4A2A0F); // warm brown, matches the design's rgba(120,70,20,…) card shadow

// Dark tokens
const _darkBg = Color(0xFF14100A);
const _darkSurface = Color(0xFF211A12);
const _darkSurface2 = Color(0xFF2A2012);
const _darkInk = Color(0xFFF6EEE1);
const _darkSub = Color(0xFFA6957F);
const _darkLine = Color(0xFF2E2519);
const _darkAccent = Color(0xFFFF8A3F);
const _darkAccent2 = Color(0xFFFF9A4D);
const _darkOnAccent = Color(0xFF201005);
const _darkLeaf = Color(0xFF4FCB86);
const _darkBerry = Color(0xFFFF7BA0);
const _darkError = Color(0xFFFFB4AB);
const _darkShadow = Colors.black;

/// Design tokens the Material `ColorScheme` has no slot for: the semantic
/// success/urgent tints used across coupon countdowns, savings badges and
/// price-drop copy, plus the gradient "cheapest price" hero treatment.
/// Carried through `Theme.of(context).extension<AppPalette>()!` so every
/// widget gets the right light/dark value without a `Brightness` check.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color success;
  final Color urgent;
  final Color onGradient;
  final Gradient heroGradient;

  const AppPalette({
    required this.success,
    required this.urgent,
    required this.onGradient,
    required this.heroGradient,
  });

  @override
  AppPalette copyWith({
    Color? success,
    Color? urgent,
    Color? onGradient,
    Gradient? heroGradient,
  }) {
    return AppPalette(
      success: success ?? this.success,
      urgent: urgent ?? this.urgent,
      onGradient: onGradient ?? this.onGradient,
      heroGradient: heroGradient ?? this.heroGradient,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      success: Color.lerp(success, other.success, t)!,
      urgent: Color.lerp(urgent, other.urgent, t)!,
      onGradient: Color.lerp(onGradient, other.onGradient, t)!,
      heroGradient: Gradient.lerp(heroGradient, other.heroGradient, t)!,
    );
  }
}

ThemeData buildAppTheme() => _buildTheme(
      ColorScheme.light(
        primary: _lightAccent,
        onPrimary: _lightOnAccent,
        primaryContainer: _lightSurface2,
        onPrimaryContainer: _lightInk,
        secondary: _lightBerry,
        onSecondary: Colors.white,
        secondaryContainer: const Color(0xFFFDE4EA),
        onSecondaryContainer: _lightInk,
        tertiary: _lightLeaf,
        onTertiary: Colors.white,
        tertiaryContainer: const Color(0xFFE3F3E9),
        onTertiaryContainer: _lightInk,
        error: _lightError,
        onError: Colors.white,
        errorContainer: const Color(0xFFFFD9D3),
        onErrorContainer: const Color(0xFF3B0A00),
        surface: _lightSurface,
        onSurface: _lightInk,
        onSurfaceVariant: _lightSub,
        surfaceContainerHighest: _lightSurface2,
        outline: _lightLine,
        outlineVariant: _lightLine,
        shadow: _lightShadow,
      ),
      AppPalette(
        success: _lightLeaf,
        urgent: _lightAccent2,
        onGradient: _lightOnAccent,
        heroGradient: const LinearGradient(
          begin: Alignment(-0.6, -1),
          end: Alignment(0.6, 1),
          colors: [Color(0xFFFF7A33), Color(0xFFF0451F)],
        ),
      ),
      scaffoldBg: _lightBg,
    );

ThemeData buildAppDarkTheme() => _buildTheme(
      ColorScheme.dark(
        primary: _darkAccent,
        onPrimary: _darkOnAccent,
        primaryContainer: _darkSurface2,
        onPrimaryContainer: _darkInk,
        secondary: _darkBerry,
        onSecondary: const Color(0xFF3B0A18),
        secondaryContainer: const Color(0xFF3A1F27),
        onSecondaryContainer: _darkInk,
        tertiary: _darkLeaf,
        onTertiary: const Color(0xFF072913),
        tertiaryContainer: const Color(0xFF16301F),
        onTertiaryContainer: _darkInk,
        error: _darkError,
        onError: const Color(0xFF3B0A00),
        errorContainer: const Color(0xFF5C1A0F),
        onErrorContainer: const Color(0xFFFFD9D3),
        surface: _darkSurface,
        onSurface: _darkInk,
        onSurfaceVariant: _darkSub,
        surfaceContainerHighest: _darkSurface2,
        outline: _darkLine,
        outlineVariant: _darkLine,
        shadow: _darkShadow,
      ),
      AppPalette(
        success: _darkLeaf,
        urgent: _darkAccent2,
        onGradient: _darkOnAccent,
        heroGradient: const LinearGradient(
          begin: Alignment(-0.6, -1),
          end: Alignment(0.6, 1),
          colors: [Color(0xFFFF9A4D), Color(0xFFFF5E1F)],
        ),
      ),
      scaffoldBg: _darkBg,
    );

TextTheme _buildTextTheme(ColorScheme scheme) {
  final base =
      (scheme.brightness == Brightness.light
              ? Typography.material2021().black
              : Typography.material2021().white)
          .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);
  final sans = GoogleFonts.plusJakartaSansTextTheme(base);

  TextStyle serif(TextStyle? style) => GoogleFonts.instrumentSerif(
        textStyle: style,
        fontWeight: FontWeight.w400,
      );

  return sans.copyWith(
    displayLarge: serif(sans.displayLarge),
    displayMedium: serif(sans.displayMedium),
    displaySmall: serif(sans.displaySmall),
    headlineLarge: serif(sans.headlineLarge),
    headlineMedium: serif(sans.headlineMedium),
    headlineSmall: serif(sans.headlineSmall),
    titleLarge: serif(sans.titleLarge),
  );
}

ThemeData _buildTheme(
  ColorScheme scheme,
  AppPalette palette, {
  required Color scaffoldBg,
}) {
  final textTheme = _buildTextTheme(scheme);
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: textTheme,
  );
  final overlayStyle = scheme.brightness == Brightness.light
      ? SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent)
      : SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent);

  return base.copyWith(
    scaffoldBackgroundColor: scaffoldBg,
    extensions: [palette],
    // Web-app style navigation: pages fade in and rise instead of the
    // platform-default slide, on every target — keeps transitions identical
    // whether the app is running on Android or iOS.
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
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: false,
      // Explicit per-brightness status bar style so the icon color reads
      // consistently on both Android and iOS instead of each platform
      // falling back to its own default.
      systemOverlayStyle: overlayStyle,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontSize: 21,
        color: scheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: scheme.surface,
      selectedColor: scheme.primary,
      side: BorderSide(color: scheme.outline),
      labelStyle: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
      secondaryLabelStyle: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w700),
      shape: const StadiumBorder(),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        disabledBackgroundColor: scheme.surfaceContainerHighest,
        disabledForegroundColor: scheme.onSurfaceVariant,
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.onSurface,
        backgroundColor: scheme.surface,
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.secondary,
      foregroundColor: scheme.onSecondary,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface,
      elevation: 0,
      height: 68,
      surfaceTintColor: Colors.transparent,
      // Flat icon+label nav, matching the design — no pill indicator.
      indicatorColor: Colors.transparent,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.onSurfaceVariant,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 11,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w800
              : FontWeight.w600,
          color: states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.onSurfaceVariant,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
      labelStyle: TextStyle(color: scheme.onSurfaceVariant),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.error, width: 1.6),
      ),
      errorStyle: TextStyle(color: scheme.error, fontWeight: FontWeight.w600),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: scheme.onSurface,
      contentTextStyle: TextStyle(color: scheme.surface, fontWeight: FontWeight.w600),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1),
    listTileTheme: ListTileThemeData(iconColor: scheme.onSurfaceVariant),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: palette.success,
      linearTrackColor: scheme.surfaceContainerHighest,
    ),
  );
}
