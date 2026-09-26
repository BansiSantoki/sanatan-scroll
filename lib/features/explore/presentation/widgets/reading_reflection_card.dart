import 'package:flutter/material.dart';

import '../../../../theme/app_typography.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../models/sacred_book_model.dart';
import '../../../../models/sacred_chapter_model.dart';
import '../../../../models/sacred_verse_model.dart';

import 'reader_header.dart';

class ReadingReflectionCard extends StatelessWidget {
  const ReadingReflectionCard({
    super.key,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.languageCode,
    required this.isSaved,
    required this.onToggleSave,
    required this.onShare,
    required this.onBack,
    required this.onNextCard,
    this.totalCards = 3,
  });

  final SacredBookModel book;
  final SacredChapterModel chapter;
  final SacredVerseModel verse;
  final String languageCode;
  final bool isSaved;
  final VoidCallback onToggleSave;
  final VoidCallback onShare;
  final VoidCallback onBack;
  final VoidCallback onNextCard;
  final int totalCards;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 600 ? 32.0 : 20.0;
    final locale = Locale(languageCode);
    final l10n = AppLocalizations.of(context);

    final reflectionText = verse.getReflectionFullText(languageCode);
    final bookTitle = book.getLocalizedTitle(languageCode);
    final chapterWord = l10n.chapter;

    String topSubtitle;
    if (book.id == 'ramayana' || verse.kandaNumber != null || verse.sargaNumber != null || chapter.chapterNumber >= 1000) {
      final kanda = verse.kandaNumber ?? (chapter.chapterNumber >= 1000 ? chapter.chapterNumber ~/ 1000 : chapter.chapterNumber);
      final sarga = verse.sargaNumber ?? (chapter.chapterNumber >= 1000 ? chapter.chapterNumber % 1000 : 1);
      final isBalaKanda = kanda == 1;
      final kandaName = isBalaKanda ? 'Bala Kanda' : 'Kanda $kanda';
      topSubtitle = '$bookTitle · $kandaName (Sarga $sarga)';
    } else {
      topSubtitle = '$bookTitle · $chapterWord ${chapter.chapterNumber}';
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? const Color(0xFFF0F2F0) : const Color(0xFF18392C);
    final labelTextColor = isDark ? const Color(0xFFA0A6A0) : const Color(0xFF736B5E);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF141714) : const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReaderHeader(
                subtitle: topSubtitle,
                isSaved: isSaved,
                onBack: onBack,
                onToggleSave: onToggleSave,
                onShare: onShare,
                languageCode: languageCode,
              ),

              // Main Reflection Body Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // REFLECTION Section Header Label
                      Text(
                        l10n.reflection,
                        style: AppTypography.sectionLabel(
                          languageCode,
                          color: labelTextColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Reflection Body Paragraphs
                      Text(
                        reflectionText,
                        style: AppTypography.reflectionContext(
                          languageCode,
                          color: primaryTextColor,
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Bar: 02 / 03 | Progress Bars | Swipe ->
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    // Card number e.g. "02 / 03"
                    Text(
                      '02 / 0$totalCards',
                      style: AppTextStyles.getFontForLocale(
                        locale,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Progress indicators
                    Expanded(
                      child: Row(
                        children: List.generate(totalCards, (index) {
                          final isActive = index == 1;
                          return Expanded(
                            child: Container(
                              height: 4,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFFEF6523)
                                    : (isDark ? const Color(0xFF38291E) : const Color(0xFFF9D6C4)),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Swipe button
                    GestureDetector(
                      onTap: onNextCard,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.swipe,
                            style: AppTextStyles.getFontForLocale(
                              locale,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: primaryTextColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
