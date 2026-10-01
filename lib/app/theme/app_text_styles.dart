import 'package:flutter/material.dart';
import '../../theme/app_typography.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle getFont(
    BuildContext context, {
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double height = 1.2,
    double? letterSpacing,
    bool isSerif = false,
    TextDecoration decoration = TextDecoration.none,
  }) {
    final locale = Localizations.localeOf(context);
    return getFontForLocale(
      locale,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      isSerif: isSerif,
      decoration: decoration,
    );
  }

  static TextStyle getFontForLocale(
    Locale locale, {
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double height = 1.2,
    double? letterSpacing,
    bool isSerif = false,
    TextDecoration decoration = TextDecoration.none,
  }) {
    final String gujaratiFont = AppTypography.fontNotoSansGujarati;
    final String devanagariFont = AppTypography.fontNotoSansDevanagari;
    final String englishSerif = AppTypography.fontLora;
    final String englishSans = AppTypography.fontDMSans;

    String primaryFont;
    List<String> fallbacks;

    final code = locale.languageCode.toLowerCase().split('-').first.split('_').first.trim();

    if (code == 'gu') {
      primaryFont = gujaratiFont;
      fallbacks = [gujaratiFont, devanagariFont, englishSerif, englishSans];
    } else if (code == 'hi' || code == 'sa') {
      primaryFont = devanagariFont;
      fallbacks = [devanagariFont, gujaratiFont, englishSerif, englishSans];
    } else {
      primaryFont = isSerif ? englishSerif : englishSans;
      fallbacks = [primaryFont, gujaratiFont, devanagariFont];
    }

    // Indic scripts (HI, GU, SA) must NOT use wide English-style letter spacing
    final double? adjustedLetterSpacing = (code == 'hi' ||
            code == 'gu' ||
            code == 'sa')
        ? (letterSpacing != null && letterSpacing > 0.4 ? 0.2 : letterSpacing)
        : letterSpacing;

    return TextStyle(
      fontFamily: primaryFont,
      fontFamilyFallback: fallbacks,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.darkText,
      height: height,
      letterSpacing: adjustedLetterSpacing,
      decoration: decoration,
    );
  }

  static final List<String> _fallbacks = [
    AppTypography.fontNotoSansGujarati,
    AppTypography.fontNotoSansDevanagari,
    AppTypography.fontLora,
    AppTypography.fontDMSans,
  ];

  static TextStyle get _serif => TextStyle(fontFamily: AppTypography.fontLora, fontFamilyFallback: _fallbacks);
  static TextStyle get _sans => TextStyle(fontFamily: AppTypography.fontDMSans, fontFamilyFallback: _fallbacks);

  static TextStyle pageHeading = _serif.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
    height: 1.10,
  );

  static TextStyle sectionHeading = _serif.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
    height: 1.15,
  );

  static TextStyle cardTitle = _serif.copyWith(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
    height: 1.25,
  );

  static TextStyle body = _sans.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.darkText,
    height: 1.50,
  );

  static TextStyle bodyMedium = _sans.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.darkText,
    height: 1.50,
  );

  static TextStyle caption = _sans.copyWith(
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
    height: 1.30,
  );

  static TextStyle label = _sans.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryText,
    letterSpacing: 1.4,
    height: 1.20,
  );

  static TextStyle button = _sans.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.20,
  );

  static TextStyle splashTitle = _serif.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.5,
    height: 1.10,
  );

  static TextStyle splashSubtitle = _sans.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: const Color(0xCCFFFFFF),
    letterSpacing: 1.4,
    height: 1.40,
  );

  static TextStyle quote = _serif.copyWith(
    fontSize: 21,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryBurgundy,
    fontStyle: FontStyle.italic,
    height: 1.50,
  );

  static TextStyle sanskrit = TextStyle(
    fontFamily: AppTypography.fontNotoSansDevanagari,
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: AppColors.darkText,
    height: 1.40,
  );

  static TextStyle navLabel = _sans.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.20,
  );
}
