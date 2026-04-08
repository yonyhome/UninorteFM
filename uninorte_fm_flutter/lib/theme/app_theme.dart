import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFFD42020);
  static const primaryDark = Color(0xFFA81818);
  static const primaryLight = Color(0xFFE84040);
  static const background = Color(0xFF000000);
  static const surface = Color(0xFF0E0E0E);
  static const surfaceElevated = Color(0xFF111111);
  static const border = Color(0xFF1E1E1E);
  static const borderLight = Color(0xFF2A2A2A);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xCCFFFFFF); // 80%
  static const textMuted = Color(0x80FFFFFF); // 50%
}

class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.mulishTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: Color(0x80FFFFFF),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
