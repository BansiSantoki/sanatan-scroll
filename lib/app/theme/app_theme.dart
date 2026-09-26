import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_typography.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => getThemeForLocale(const Locale('en'), isDark: false);
  static ThemeData get dark => getThemeForLocale(const Locale('en'), isDark: true);

  static ThemeData getThemeForLocale(Locale locale, {bool isDark = false}) {
    final String gujaratiFont = AppTypography.fontNotoSansGujarati;
    final String devanagariFont = AppTypography.fontNotoSansDevanagari;
    final String englishFont = AppTypography.fontDMSans;

    List<String> fallbacks;
    String primaryFont;

    if (locale.languageCode == 'gu') {
      primaryFont = gujaratiFont;
      fallbacks = [gujaratiFont, devanagariFont, englishFont];
    } else if (locale.languageCode == 'hi' || locale.languageCode == 'sa') {
      primaryFont = devanagariFont;
      fallbacks = [devanagariFont, gujaratiFont, englishFont];
    } else {
      primaryFont = englishFont;
      fallbacks = [englishFont, gujaratiFont, devanagariFont];
    }

    final TextTheme baseTextTheme = isDark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    final Color textColor = isDark ? const Color(0xFFE6E8E6) : AppColors.darkText;

    final TextTheme localizedTextTheme = baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
      displayMedium: baseTextTheme.displayMedium?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
      displaySmall: baseTextTheme.displaySmall?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
      titleLarge: baseTextTheme.titleLarge?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
      titleMedium: baseTextTheme.titleMedium?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
      titleSmall: baseTextTheme.titleSmall?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
      bodySmall: baseTextTheme.bodySmall?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
      labelLarge: baseTextTheme.labelLarge?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
      labelMedium: baseTextTheme.labelMedium?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
      labelSmall: baseTextTheme.labelSmall?.copyWith(fontFamily: primaryFont, fontFamilyFallback: fallbacks, color: textColor),
    );

    final cardBg = isDark ? const Color(0xFF222722) : AppColors.cardBackground;

    return ThemeData(
      useMaterial3: true,
      fontFamily: primaryFont,
      fontFamilyFallback: fallbacks,
      textTheme: localizedTextTheme,
      primaryTextTheme: localizedTextTheme,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDark ? const Color(0xFF141714) : Colors.transparent,
      colorScheme: isDark
          ? const ColorScheme.dark(
              primary: Color(0xFFE88B60),
              secondary: Color(0xFFE8B36B),
              surface: Color(0xFF222722),
              onPrimary: Colors.black,
              onSecondary: Colors.black,
              onSurface: Color(0xFFE6E8E6),
            )
          : ColorScheme.light(
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
        foregroundColor: isDark ? const Color(0xFFE6E8E6) : AppColors.darkText,
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        titleTextStyle: AppTextStyles.cardTitle.copyWith(color: isDark ? const Color(0xFFE6E8E6) : AppColors.darkText),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? Colors.white24 : AppColors.divider,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? const Color(0xFF2C322C) : AppColors.softBeige,
        selectedColor: isDark ? const Color(0xFFE88B60) : AppColors.primaryBurgundy,
        labelStyle: AppTextStyles.caption.copyWith(color: isDark ? const Color(0xFFE6E8E6) : AppColors.darkText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide(color: isDark ? Colors.white24 : AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide(color: isDark ? Colors.white24 : AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide(color: isDark ? const Color(0xFFE88B60) : AppColors.primaryBurgundy),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing12,
        ),
        hintStyle: AppTextStyles.body.copyWith(color: isDark ? Colors.white54 : AppColors.secondaryText),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1C201C) : AppColors.cardBackground,
        selectedItemColor: isDark ? const Color(0xFFE88B60) : AppColors.primaryBurgundy,
        unselectedItemColor: isDark ? Colors.white54 : AppColors.mutedBrown,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
