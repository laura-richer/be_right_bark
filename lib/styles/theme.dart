import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:be_right_bark/styles/colors.dart';
import 'package:be_right_bark/styles/typography.dart';

ThemeData brbTheme() {
  return ThemeData(
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        iconSize: 18,
        minimumSize: const Size(30, 30), // tap target
      ),
    ),

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: BrbColors.green,
      onPrimary: BrbColors.white,
      primaryContainer: BrbColors.cream,
      secondary: BrbColors.yellow,
      onSecondary: BrbColors.green,
      tertiary: BrbColors.orange,
      surface: BrbColors.white,
      onSurface: BrbColors.darkGrey,
      onSurfaceVariant: BrbColors.green,
      outline: BrbColors.green,
      outlineVariant: BrbColors.beige,
      shadow: BrbColors.orange,
      error: BrbColors.red,
      onError: BrbColors.white,
    ),
    scaffoldBackgroundColor: BrbColors.cream,

    textTheme: TextTheme(
      displayLarge: GoogleFonts.quicksand(
        fontSize: BrbFontSize.xl,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.lilitaOne(fontSize: BrbFontSize.xl),
      titleMedium: GoogleFonts.lilitaOne(fontSize: BrbFontSize.md),
      titleSmall: GoogleFonts.lilitaOne(fontSize: BrbFontSize.sm),
      headlineLarge: GoogleFonts.lilitaOne(fontSize: BrbFontSize.md),
      bodyLarge: GoogleFonts.nunito(fontSize: BrbFontSize.md),
      bodySmall: GoogleFonts.nunito(fontSize: BrbFontSize.sm),
      labelLarge: GoogleFonts.lilitaOne(fontSize: BrbFontSize.xl),
      labelMedium: GoogleFonts.lilitaOne(fontSize: BrbFontSize.md),
      labelSmall: GoogleFonts.nunito(
        fontSize: BrbFontSize.sm,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
