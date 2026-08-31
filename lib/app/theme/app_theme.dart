import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => getThemeForLocale(const Locale('en'));

  static ThemeData getThemeForLocale(Locale locale) {
    final String gujaratiFont = GoogleFonts.notoSansGujarati().fontFamily!;
    final String devanagariFont = GoogleFonts.notoSansDevanagari().fontFamily!;
    final String englishFont = GoogleFonts.manrope().fontFamily!;

    List<String> fallbacks;
    String primaryFont;

    if (locale.languageCode == 'gu') {
      primaryFont = gujaratiFont;
      fallbacks = [gujaratiFont, devanagariFont, englishFont];
    } else if (locale.languageCode == 'hi') {
      primaryFont = devanagariFont;
      fallbacks = [devanagariFont, gujaratiFont, englishFont];
    } else {
      primaryFont = englishFont;
      fallbacks = [englishFont, gujaratiFont, devanagariFont];
    }

    return ThemeData(
      useMaterial3: true,
      fontFamily: primaryFont,
      fontFamilyFallback: fallbacks,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryBurgundy,
        secondary: AppColors.warmOrange,
        surface: AppColors.cardBackground,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.darkText,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkText,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTextStyles.cardTitle,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.softBeige,
        selectedColor: AppColors.primaryBurgundy,
        labelStyle: AppTextStyles.caption,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primaryBurgundy),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing12,
        ),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.secondaryText),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.primaryBurgundy,
        unselectedItemColor: AppColors.mutedBrown,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
