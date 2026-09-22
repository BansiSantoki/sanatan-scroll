import 'package:flutter/material.dart';

/// Centralized Multilingual Typography & Text-Rendering System
/// Strictly follows Sanatan Scroll Typography & Text Handoff specification.
/// Supports: English, Hindi, Gujarati, Sanskrit offline using local bundled fonts.
class AppTypography {
  AppTypography._();

  // Local Font Family Names (Registered in pubspec.yaml)
  static const String fontLora = 'Lora';
  static const String fontDMSans = 'DM Sans';
  static const String fontNotoSansDevanagari = 'Noto Sans Devanagari';
  static const String fontNotoSansGujarati = 'Noto Sans Gujarati';

  // Approved Primary Text Color (Primary text color: #18392C - No pure black)
  static const Color primaryText = Color(0xFF18392C);
  static const Color darkText = Color(0xFF18392C);
  static const Color secondaryText = Color(0xFF4A4A4A);
  static const Color labelText = Color(0xFF666666);

  /// Get heading font family based on language code
  static String getHeadingFontFamily(String langCode) {
    switch (langCode) {
      case 'gu':
        return fontNotoSansGujarati;
      case 'hi':
      case 'sa':
        return fontNotoSansDevanagari;
      case 'en':
      default:
        return fontLora;
    }
  }

  /// Get body/UI font family based on language code
  static String getBodyFontFamily(String langCode) {
    switch (langCode) {
      case 'gu':
        return fontNotoSansGujarati;
      case 'hi':
      case 'sa':
        return fontNotoSansDevanagari;
      case 'en':
      default:
        return fontDMSans;
    }
  }

  /// Sanskrit scripture font family is ALWAYS Devanagari regardless of active UI language
  static String getScriptureFontFamily() {
    return fontNotoSansDevanagari;
  }

  /// Helper for general font family lookup
  static String getFontFamily(String langCode, {bool isHeading = false}) {
    return isHeading ? getHeadingFontFamily(langCode) : getBodyFontFamily(langCode);
  }

  /// Tracking / Letter spacing helper: Indic scripts must NOT use wide letter spacing
  static double getSectionLabelTracking(String langCode) {
    if (langCode == 'hi' || langCode == 'gu' || langCode == 'sa') {
      return 0.2; // Indic tracking ~0 to 0.4
    }
    return 1.4; // English uppercase tracking ~1.4
  }

  /// Responsive Sanskrit Shlok Font Size Calculation:
  /// Short/normal: 32sp, Medium-long: 30sp, Long: 28sp, Very long: 26sp (minimum). Never below 26sp.
  static double getShlokFontSize(int textLength) {
    if (textLength <= 60) return 32.0;
    if (textLength <= 110) return 30.0;
    if (textLength <= 170) return 28.0;
    return 26.0; // Minimum size cap
  }

  // ===========================================================================
  // CENTRALIZED TYPOGRAPHY TOKENS
  // ===========================================================================

  /// 1. LARGE PAGE TITLE (Lora / Indic 36–40sp, height 1.08–1.15, Weight 600)
  static TextStyle pageTitle(String langCode, {Color? color, double? fontSize}) {
    final font = getHeadingFontFamily(langCode);
    final size = fontSize ?? 36.0;
    return TextStyle(
      fontFamily: font,
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color ?? primaryText,
      height: 1.10,
    );
  }

  /// 2. SECTION HEADING (Lora / Indic 26–30sp, height 1.12–1.20, Weight 600)
  static TextStyle sectionHeading(String langCode, {Color? color, double? fontSize}) {
    final font = getHeadingFontFamily(langCode);
    final size = fontSize ?? 26.0;
    return TextStyle(
      fontFamily: font,
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color ?? primaryText,
      height: 1.15,
    );
  }

  /// 3. CARD / LIST TITLE (Lora / Indic 18–21sp, height 1.20–1.28, Weight 500–600)
  static TextStyle cardTitle(String langCode, {Color? color, double? fontSize, FontWeight? fontWeight}) {
    final font = getHeadingFontFamily(langCode);
    final size = fontSize ?? 19.0;
    return TextStyle(
      fontFamily: font,
      fontSize: size,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? primaryText,
      height: 1.25,
    );
  }

  /// 4. BODY COPY (DM Sans / Devanagari / Gujarati 17–19sp, height EN 1.45–1.55, HI/GU 1.52)
  static TextStyle body(String langCode, {Color? color, double? fontSize, FontWeight? fontWeight, double? height}) {
    final font = getBodyFontFamily(langCode);
    final size = fontSize ?? 18.0;
    final lineH = height ?? (langCode == 'en' ? 1.50 : 1.52);
    return TextStyle(
      fontFamily: font,
      fontSize: size,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? primaryText,
      height: lineH,
    );
  }

  /// 5. COMPACT UI / BODY (15–17sp, height 1.35–1.45, Weight 400–500)
  static TextStyle compact(String langCode, {Color? color, double? fontSize, FontWeight? fontWeight}) {
    final font = getBodyFontFamily(langCode);
    final size = fontSize ?? 16.0;
    return TextStyle(
      fontFamily: font,
      fontSize: size,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? primaryText,
      height: 1.40,
    );
  }

  /// 6. PRIMARY BUTTON (DM Sans / Indic 18sp, height 1.20, Weight 500–600)
  static TextStyle button(String langCode, {Color? color, double? fontSize, FontWeight? fontWeight}) {
    final font = getBodyFontFamily(langCode);
    final size = fontSize ?? 18.0;
    return TextStyle(
      fontFamily: font,
      fontSize: size,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? primaryText,
      height: 1.20,
    );
  }

  /// 7. SMALL METADATA (14–15sp, height 1.25–1.35, Weight 400–500)
  static TextStyle metadata(String langCode, {Color? color, double? fontSize, FontWeight? fontWeight}) {
    final font = getBodyFontFamily(langCode);
    final size = fontSize ?? 14.5;
    return TextStyle(
      fontFamily: font,
      fontSize: size,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? secondaryText,
      height: 1.30,
    );
  }

  /// 8. SANSKRIT SHLOK (Noto Sans Devanagari, Responsive 26–32sp, height 1.40, Weight 500)
  static TextStyle sanskritShlok({int textLength = 0, Color? color, double? fontSize, FontWeight? fontWeight}) {
    final size = fontSize ?? getShlokFontSize(textLength);
    return TextStyle(
      fontFamily: fontNotoSansDevanagari,
      fontSize: size,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? primaryText,
      height: 1.40,
      letterSpacing: 0.2, // Indic script tracking rule
    );
  }

  /// 9. SCRIPTURE TRANSLATION (21sp, height EN 1.50 / HI, GU 1.52, Weight 400)
  static TextStyle scriptureTranslation(String langCode, {Color? color, double? fontSize}) {
    final font = getBodyFontFamily(langCode);
    final size = fontSize ?? 21.0;
    final lineH = langCode == 'en' ? 1.50 : 1.52;
    return TextStyle(
      fontFamily: font,
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color ?? primaryText,
      height: lineH,
    );
  }

  /// 10. REFLECTION / CONTEXT (21sp, height EN 1.50 / HI, GU 1.52, Weight 400)
  static TextStyle reflectionContext(String langCode, {Color? color, double? fontSize}) {
    final font = getBodyFontFamily(langCode);
    final size = fontSize ?? 21.0;
    final lineH = langCode == 'en' ? 1.50 : 1.52;
    return TextStyle(
      fontFamily: font,
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color ?? primaryText,
      height: lineH,
    );
  }

  /// 11. TOP LOCATION (Lora / Indic 18sp, height 1.25, Weight 500)
  static TextStyle topLocation(String langCode, {Color? color}) {
    final font = getHeadingFontFamily(langCode);
    return TextStyle(
      fontFamily: font,
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: color ?? secondaryText,
      height: 1.25,
    );
  }

  /// 12. VERSE REFERENCE (Lora / Indic 18sp, height 1.25, Weight 500)
  static TextStyle verseReference(String langCode, {Color? color}) {
    final font = getHeadingFontFamily(langCode);
    return TextStyle(
      fontFamily: font,
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: color ?? primaryText,
      height: 1.25,
    );
  }

  /// 13. SECTION LABEL (14sp, height 1.20, Weight 600)
  static TextStyle sectionLabel(String langCode, {Color? color}) {
    final font = getBodyFontFamily(langCode);
    final tracking = getSectionLabelTracking(langCode);
    return TextStyle(
      fontFamily: font,
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: color ?? labelText,
      height: 1.20,
      letterSpacing: tracking,
    );
  }

  /// 14. AUDIO LABEL (18sp, height 1.20–1.25, Weight 600)
  static TextStyle audioLabel(String langCode, {Color? color}) {
    final font = getBodyFontFamily(langCode);
    return TextStyle(
      fontFamily: font,
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: color ?? primaryText,
      height: 1.22,
    );
  }

  /// 15. PROGRESS INDICATOR CURRENT (DM Sans 19sp, height 1.20, Weight 700)
  static TextStyle progressCurrent({Color? color}) {
    return TextStyle(
      fontFamily: fontDMSans,
      fontSize: 19.0,
      fontWeight: FontWeight.w700,
      color: color ?? primaryText,
      height: 1.20,
    );
  }

  /// 16. PROGRESS INDICATOR TOTAL (DM Sans 17sp, height 1.20, Weight 400)
  static TextStyle progressTotal({Color? color}) {
    return TextStyle(
      fontFamily: fontDMSans,
      fontSize: 17.0,
      fontWeight: FontWeight.w400,
      color: color ?? primaryText,
      height: 1.20,
    );
  }

  // ===========================================================================
  // HELPER FUNCTIONS FOR CONVENIENCE
  // ===========================================================================

  static TextStyle getBodyTextStyle(String langCode, {Color? color, double? fontSize, FontWeight? fontWeight}) {
    return body(langCode, color: color, fontSize: fontSize, fontWeight: fontWeight);
  }

  static TextStyle getHeadingTextStyle(String langCode, {Color? color, double? fontSize, FontWeight? fontWeight}) {
    return sectionHeading(langCode, color: color, fontSize: fontSize);
  }

  static TextStyle getScriptureTextStyle({int textLength = 0, Color? color, double? fontSize}) {
    return sanskritShlok(textLength: textLength, color: color, fontSize: fontSize);
  }

  static TextStyle getTranslationTextStyle(String langCode, {Color? color, double? fontSize}) {
    return scriptureTranslation(langCode, color: color, fontSize: fontSize);
  }
}
