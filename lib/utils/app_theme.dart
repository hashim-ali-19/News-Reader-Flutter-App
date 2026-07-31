import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design language: "Editorial Modern"
/// A warm, magazine-inspired palette (ink + paper + amber accent) paired
/// with a serif display face for headlines and a clean grotesk for body
/// copy — meant to feel more like a curated reading app than a generic
/// news list.
class AppColors {
  // Light palette
  static const Color paper = Color(0xFFFBF8F3);
  static const Color paperElevated = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF1A1A1A);
  static const Color inkMuted = Color(0xFF6B6660);
  static const Color accent = Color(0xFFE8632C); // burnt amber
  static const Color accentSoft = Color(0xFFFCE4D6);
  static const Color divider = Color(0xFFE8E2D8);

  // Dark palette
  static const Color night = Color(0xFF14130F);
  static const Color nightElevated = Color(0xFF1F1D18);
  static const Color paperDark = Color(0xFFF2EDE4);
  static const Color inkMutedDark = Color(0xFFA8A29A);
  static const Color accentDark = Color(0xFFFF8A50);
  static const Color dividerDark = Color(0xFF322F28);

  static const List<Color> categoryPalette = [
    Color(0xFFE8632C),
    Color(0xFF2C6E8E),
    Color(0xFF5B7B3C),
    Color(0xFF9C4A6B),
    Color(0xFFB8862E),
    Color(0xFF4A5FA8),
    Color(0xFF6B4A9C),
  ];
}

class AppTheme {
  static TextTheme _textTheme(Color base, Color muted) {
    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        color: base,
        fontWeight: FontWeight.w700,
        fontSize: 32,
        height: 1.15,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        color: base,
        fontWeight: FontWeight.w700,
        fontSize: 26,
        height: 1.2,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        color: base,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        height: 1.25,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        color: base,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        height: 1.3,
      ),
      titleMedium: GoogleFonts.inter(
        color: base,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
      bodyLarge: GoogleFonts.inter(
        color: base,
        fontWeight: FontWeight.w400,
        fontSize: 15,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        color: muted,
        fontWeight: FontWeight.w400,
        fontSize: 13.5,
        height: 1.45,
      ),
      labelLarge: GoogleFonts.inter(
        color: base,
        fontWeight: FontWeight.w600,
        fontSize: 13,
        letterSpacing: 0.2,
      ),
      labelMedium: GoogleFonts.inter(
        color: muted,
        fontWeight: FontWeight.w500,
        fontSize: 11.5,
        letterSpacing: 0.3,
      ),
    );
  }

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.light,
      surface: AppColors.paper,
      primary: AppColors.accent,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paper,
      colorScheme: scheme,
      textTheme: _textTheme(AppColors.ink, AppColors.inkMuted),
      dividerColor: AppColors.divider,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.paper,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.ink,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.paperElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.paperElevated,
        selectedColor: AppColors.accent,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        shape: StadiumBorder(side: BorderSide(color: AppColors.divider)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.paperElevated,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.inkMuted,
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.accentDark,
      brightness: Brightness.dark,
      surface: AppColors.night,
      primary: AppColors.accentDark,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.night,
      colorScheme: scheme,
      textTheme: _textTheme(AppColors.paperDark, AppColors.inkMutedDark),
      dividerColor: AppColors.dividerDark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.night,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.paperDark,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: AppColors.paperDark,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.nightElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.nightElevated,
        selectedColor: AppColors.accentDark,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        shape: StadiumBorder(side: BorderSide(color: AppColors.dividerDark)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.nightElevated,
        selectedItemColor: AppColors.accentDark,
        unselectedItemColor: AppColors.inkMutedDark,
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }

  static Color categoryColor(String category) {
    final index = category.hashCode % AppColors.categoryPalette.length;
    return AppColors.categoryPalette[index.abs()];
  }
}
