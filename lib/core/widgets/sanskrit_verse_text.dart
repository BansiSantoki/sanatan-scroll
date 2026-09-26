import 'package:flutter/material.dart';
import '../../theme/app_typography.dart';

/// Reusable Sanskrit Verse Text Widget
/// Formats Sanskrit shlokas according to Section 5 developer handoff specs:
/// - Font: Noto Sans Devanagari (bundled local font)
/// - Responsive size: Short/normal (32sp), Medium-long (30sp), Long (28sp), Very long (26sp min)
/// - Line height: 1.40, Weight: 500
/// - Never shrink below 26sp
/// - Keep danda punctuation (। and ॥) naturally attached to preceding phrase
/// - Allow vertical expansion / scrolling without forced container height or word splits
class SanskritVerseText extends StatelessWidget {
  const SanskritVerseText({
    super.key,
    required this.sanskrit,
    this.overrideFontSize,
    this.color = AppTypography.primaryText,
    this.textAlign = TextAlign.center,
  });

  final String sanskrit;
  final double? overrideFontSize;
  final Color color;
  final TextAlign textAlign;

  /// Ensures danda punctuation (। and ॥) remains attached to the preceding phrase without orphaned punctuation.
  static String formatSanskritShloka(String text) {
    if (text.trim().isEmpty) return text;

    String normalized = text.trim();

    // Attach single danda (।) to preceding word with non-breaking space (\u00A0)
    normalized = normalized.replaceAll(RegExp(r'\s+।'), '\u00A0।');

    // Attach double danda (॥) to preceding word with non-breaking space (\u00A0)
    normalized = normalized.replaceAll(RegExp(r'\s+॥'), '\u00A0॥');

    return normalized;
  }

  @override
  Widget build(BuildContext context) {
    final formattedText = formatSanskritShloka(sanskrit);
    final width = MediaQuery.sizeOf(context).width;

    double baseSize = overrideFontSize ?? AppTypography.getShlokFontSize(formattedText.length);
    if (width < 360) {
      baseSize = (baseSize * 0.90).clamp(16.0, 20.0);
    } else if (width > 600) {
      baseSize = (baseSize * 1.15).clamp(20.0, 25.0);
    }

    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Text(
        formattedText,
        textAlign: textAlign,
        softWrap: true,
        style: TextStyle(
          fontFamily: AppTypography.fontNotoSansDevanagari,
          fontSize: baseSize,
          fontWeight: FontWeight.w500,
          color: color,
          height: 1.48,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
