import 'package:flutter/material.dart';

class LoveTheme {
  // Primary Romantic Dark Palette
  static const Color backgroundDark = Color(0xFF0D0B14);
  static const Color backgroundGradientStart = Color(0xFF0F0F1A);
  static const Color backgroundGradientMid = Color(0xFF1F122B);
  static const Color backgroundGradientEnd = Color(0xFF2D0B22);

  // Vibrant Accents
  static const Color primaryNeonPink = Color(0xFFFF2A6D);
  static const Color secondaryRose = Color(0xFFFF7597);
  static const Color accentFuchsia = Color(0xFFD16BA5);
  static const Color glowingPurple = Color(0xFF8B5CF6);
  static const Color cardGlass = Color(0x1AFFFFFF);
  static const Color cardBorderGlass = Color(0x33FFFFFF);

  // Linear Gradients
  static const LinearGradient romanticGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      backgroundGradientStart,
      backgroundGradientMid,
      backgroundGradientEnd,
    ],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      primaryNeonPink,
      secondaryRose,
    ],
  );

  static const LinearGradient terminalGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF05130D),
      Color(0xFF0D1F17),
    ],
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryNeonPink,
        secondary: secondaryRose,
        surface: Color(0xFF161426),
      ),
    );
  }
}
