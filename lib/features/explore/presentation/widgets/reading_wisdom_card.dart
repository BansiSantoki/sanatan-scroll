import 'package:flutter/material.dart';

import '../../../../theme/app_typography.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/sanskrit_verse_text.dart';
import '../../../../models/sacred_book_model.dart';
import '../../../../models/sacred_chapter_model.dart';
import '../../../../models/sacred_verse_model.dart';

import 'reader_header.dart';

class ReadingWisdomCard extends StatelessWidget {
  const ReadingWisdomCard({
    super.key,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.languageCode,
    required this.isSaved,
    required this.onToggleSave,
    required this.onShare,
    required this.isPlayingAudio,
    required this.onToggleAudio,
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
  final bool isPlayingAudio;
  final VoidCallback onToggleAudio;
  final VoidCallback onBack;
  final VoidCallback onNextCard;
  final int totalCards;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 600 ? 32.0 : 20.0;
    final locale = Locale(languageCode);
    final l10n = AppLocalizations.of(context);

    final translationText = verse.getLocalizedTranslation(languageCode);
    final bookTitle = book.getLocalizedTitle(languageCode);
    final chapterWord = l10n.chapter;

    String verseRef;
    String topSubtitle;

    if (book.id == 'ramayana' || verse.kandaNumber != null || verse.sargaNumber != null || chapter.chapterNumber >= 1000) {
      final kanda = verse.kandaNumber ?? (chapter.chapterNumber >= 1000 ? chapter.chapterNumber ~/ 1000 : chapter.chapterNumber);
      final sarga = verse.sargaNumber ?? (chapter.chapterNumber >= 1000 ? chapter.chapterNumber % 1000 : 1);

      verseRef = '$bookTitle $kanda.$sarga.${verse.verseNumber}';
      final isBalaKanda = kanda == 1;
      final kandaName = isBalaKanda ? 'Bala Kanda' : 'Kanda $kanda';
      topSubtitle = '$bookTitle · $kandaName (Sarga $sarga)';
    } else {
      verseRef = '$bookTitle ${chapter.chapterNumber}.${verse.verseNumber}';
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

              // Main Scrollable Scripture + Translation Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // SANSKRIT Section Header Label
                      Text(
                        l10n.sanskrit,
                        style: AppTypography.sectionLabel(
                          languageCode,
                          color: labelTextColor,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Sanskrit Verse Text
                      SanskritVerseText(
                        sanskrit: verse.sanskrit,
                        textAlign: TextAlign.left,
                        color: primaryTextColor,
                      ),

                      const SizedBox(height: 14),

                      // Verse Reference (e.g. Bhagavad Gita 3.25)
                      Text(
                        verseRef,
                        style: AppTypography.verseReference(
                          languageCode,
                          color: primaryTextColor,
                        ),
                      ),

                      const SizedBox(height: 20),
                      Divider(
                        color: isDark ? Colors.white12 : const Color(0xFFE8E2DA),
                        height: 1,
                        thickness: 1,
                      ),
                      const SizedBox(height: 20),

                      // TRANSLATION Section Header Label
                      Text(
                        l10n.translation,
                        style: AppTypography.sectionLabel(
                          languageCode,
                          color: labelTextColor,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Translation Body Text
                      Text(
                        translationText,
                        style: AppTypography.scriptureTranslation(
                          languageCode,
                          color: primaryTextColor,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Audio Player Button ("Listen to Sanskrit")
                      GestureDetector(
                        onTap: onToggleAudio,
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF6523),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPlayingAudio
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              l10n.listenToSanskrit,
                              style: AppTextStyles.getFontForLocale(
                                locale,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: primaryTextColor,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Bar: 01 / 03 | Progress Bars | Swipe ->
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    // Card number e.g. "01 / 03"
                    Text(
                      '01 / 0$totalCards',
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
                          final isActive = index == 0;
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

                    // Swipe / Next verse button
                    GestureDetector(
                      onTap: onNextCard,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            totalCards > 1 ? l10n.swipe : l10n.nextVerse,
                            style: AppTextStyles.getFontForLocale(
                              locale,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            totalCards > 1 ? Icons.arrow_forward_rounded : Icons.arrow_upward_rounded,
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
