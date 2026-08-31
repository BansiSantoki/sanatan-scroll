import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final String gujaratiFont = GoogleFonts.notoSansGujarati().fontFamily!;
    final String devanagariFont = GoogleFonts.notoSansDevanagari().fontFamily!;
    final String englishSerif = GoogleFonts.cormorantGaramond().fontFamily!;
    final String englishSans = GoogleFonts.manrope().fontFamily!;

    String primaryFont;
    List<String> fallbacks;

    if (locale.languageCode == 'gu') {
      primaryFont = gujaratiFont;
      fallbacks = [gujaratiFont, devanagariFont, englishSerif, englishSans];
    } else if (locale.languageCode == 'hi') {
      primaryFont = devanagariFont;
      fallbacks = [devanagariFont, gujaratiFont, englishSerif, englishSans];
    } else {
      primaryFont = isSerif ? englishSerif : englishSans;
      fallbacks = [primaryFont, gujaratiFont, devanagariFont];
    }

    return TextStyle(
      fontFamily: primaryFont,
      fontFamilyFallback: fallbacks,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.darkText,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  static final List<String> _fallbacks = [
    GoogleFonts.notoSansGujarati().fontFamily!,
    GoogleFonts.notoSansDevanagari().fontFamily!,
    GoogleFonts.cormorantGaramond().fontFamily!,
    GoogleFonts.manrope().fontFamily!,
  ];

  static TextStyle get _serif => GoogleFonts.cormorantGaramond().copyWith(fontFamilyFallback: _fallbacks);
  static TextStyle get _sans => GoogleFonts.manrope().copyWith(fontFamilyFallback: _fallbacks);

  static TextStyle pageHeading = _serif.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.darkText,
    height: 1.2,
  );

  static TextStyle sectionHeading = _serif.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
    height: 1.3,
  );

  static TextStyle cardTitle = _sans.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
    height: 1.3,
  );

  static TextStyle body = _sans.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.darkText,
    height: 1.5,
  );

  static TextStyle bodyMedium = _sans.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.darkText,
    height: 1.5,
  );

  static TextStyle caption = _sans.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
    height: 1.4,
  );

  static TextStyle label = _sans.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryText,
    letterSpacing: 1.2,
    height: 1.4,
  );

  static TextStyle button = _sans.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );

  static TextStyle splashTitle = _serif.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.5,
    height: 1.2,
  );

  static TextStyle splashSubtitle = _sans.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: const Color(0xCCFFFFFF),
    letterSpacing: 2.0,
    height: 1.4,
  );

  static TextStyle quote = _serif.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryBurgundy,
    fontStyle: FontStyle.italic,
    height: 1.5,
  );

  static TextStyle sanskrit = _serif.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBurgundy,
    height: 1.4,
  );

  static TextStyle navLabel = _sans.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
}
