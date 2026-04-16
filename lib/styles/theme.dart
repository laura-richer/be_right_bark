import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';
import 'sizes.dart';

ThemeData brbTheme() {
  return ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: BrbColors.green,
      onPrimary: BrbColors.cream,
      primaryContainer: BrbColors.beige,
      onPrimaryContainer: BrbColors.green,
      secondary: BrbColors.orange,
      onSecondary: BrbColors.white,
      secondaryContainer: BrbColors.gold,
      onSecondaryContainer: BrbColors.darkText,
      tertiary: BrbColors.yellow,
      onTertiary: BrbColors.darkText,
      surface: BrbColors.cream,
      onSurface: BrbColors.darkText,
      error: Color(0xFFB00020),
      onError: BrbColors.white,
    ),
    scaffoldBackgroundColor: BrbColors.cream,

    textTheme: TextTheme(
      displayLarge: GoogleFonts.quicksand(
        fontSize: BrbFontSize.xl,
        fontWeight: FontWeight.w700,
        color: BrbColors.orange,
      ),
      titleLarge: GoogleFonts.lilitaOne(
        fontSize: BrbFontSize.xl,
        color: BrbColors.green,
      ),
      titleMedium: GoogleFonts.lilitaOne(
        fontSize: BrbFontSize.md,
         color: BrbColors.green,
      ),
      titleSmall: GoogleFonts.lilitaOne(
        fontSize: BrbFontSize.sm,
         color: BrbColors.green,
      ),
      headlineLarge: GoogleFonts.lilitaOne(
        fontSize: BrbFontSize.md,
         color: BrbColors.green,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: BrbFontSize.sm,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: BrbFontSize.xs,
      ),
      labelLarge: GoogleFonts.lilitaOne(
        fontSize: BrbFontSize.xl,
        color: BrbColors.green,
      ),
      labelMedium: GoogleFonts.lilitaOne(
        fontSize: BrbFontSize.md,
        color: BrbColors.green,
      ),
      labelSmall: GoogleFonts.nunito(
        fontSize: BrbFontSize.sm,
        color: BrbColors.green,
      ),
    ),
  );
}
