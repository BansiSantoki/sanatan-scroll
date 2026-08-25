import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _serif => GoogleFonts.cormorantGaramond();
  static TextStyle get _sans => GoogleFonts.manrope();

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
    color: Color(0xCCFFFFFF),
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
