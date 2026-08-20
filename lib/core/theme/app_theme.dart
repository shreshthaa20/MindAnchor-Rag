import 'package:flutter/material.dart';

/// Central design tokens for the app. Keeping colors/gradients/blur
/// values here (instead of scattered magic numbers in each screen)
/// means the whole visual direction can be tuned from one file.
class AppTheme {
  // ── Core palette — refined for more glow against the dark background ──
  static const Color pink = Color(0xFFFF4FA3);
  static const Color violet = Color(0xFF9D5CFF);
  static const Color blue = Color(0xFF4F8CFF);
  static const Color deepSpace = Color(0xFF382461);
  static const Color surface = Color(0xFF1C1440);

  // ── New: glassmorphism-specific tokens ──
  // Glass panels are semi-transparent white over a colorful/dark
  // background, blurred, with a soft light border to catch the "edge".
  static const Color glassFill = Color(0x265A1A40); // 15% opacity muted magenta/berry
  static const Color glassBorder = Color(0x3DFF4FA3); // 24% opacity soft pink border
  static const double glassBlur = 18.0; // backdrop blur strength (sigma)
  static const double glassRadius = 24.0; // corner rounding used app-wide

  /// The background gradient sits BEHIND every glass panel — glass only
  /// reads as "glass" when there's something colorful blurring through it.
  /// Using the existing pink/violet/blue palette keeps this on-brand.
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4A2B7A), // lighter violet
      Color(0xFF382461), // lighter mid-violet
      Color(0xFF5A2A70), // lighter magenta-violet in the corner
    ],
    stops: [0.0, 0.55, 1.0],
  );

  /// A secondary accent gradient — used sparingly, for the ONE hero
  /// element per screen you want to draw the eye to (a primary button,
  /// the selected nav icon, a headline score).
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pink, violet],
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: deepSpace,
    colorScheme: const ColorScheme.dark(
      primary: pink,
      secondary: violet,
      tertiary: blue,
      surface: surface,
      onSurface: Colors.white,
      primaryContainer: Color(0xFF9D174D),
      secondaryContainer: Color(0xFF5B21B6),
    ),
    cardTheme: const CardThemeData(
      color: surface,
      elevation: 0, // glass panels use their own soft border, not a drop shadow
    ),
    // Explicit SnackBar styling — without this, Material 3's default
    // SnackBar colors (derived from inverseSurface) don't reliably
    // contrast against our custom violet palette, which is what was
    // causing messages to blend into the background and be unreadable.
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surface,
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: glassBorder),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white70,
        height: 1.4,
      ),
    ),
  );

  // Kept for backward compatibility with main.dart's `AppTheme.lightTheme`
  // reference — same dark theme under the old name, so nothing else in
  // the app needs to change to pick this up.
  static ThemeData get lightTheme => darkTheme;
}