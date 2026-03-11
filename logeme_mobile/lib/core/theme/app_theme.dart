import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.secondary,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: GoogleFonts.inter(color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.inter(color: AppColors.textSecondary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
