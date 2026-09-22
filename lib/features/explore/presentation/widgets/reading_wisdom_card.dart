import 'package:flutter/material.dart';

import '../../../../theme/app_typography.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/sanskrit_verse_text.dart';
import '../../../../models/sacred_book_model.dart';
import '../../../../models/sacred_chapter_model.dart';
import '../../../../models/sacred_verse_model.dart';

class ReadingWisdomCard extends StatelessWidget {
  const ReadingWisdomCard({
    super.key,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.languageCode,
    required this.isSaved,
    required this.onToggleSave,
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

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Top Header Row (Back Arrow + Book/Chapter Subtitle + Bookmark Icon)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: onBack,
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          color: Color(0xFF18392C),
                        ),
                        splashRadius: 22,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: onToggleSave,
                    tooltip: isSaved ? l10n.savedAction : l10n.save,
                    icon: Icon(
                      isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_outline_rounded,
                      color: const Color(0xFF18392C),
                      size: 26,
                    ),
                    splashRadius: 22,
                  ),
                ],
              ),

              // Subtitle under Header: e.g. "Bhagavad Gita · Chapter 3"
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 12),
                child: Text(
                  topSubtitle,
                  style: AppTextStyles.getFontForLocale(
                    locale,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF18392C),
                    isSerif: true,
                    decoration: TextDecoration.none,
                  ),
                ),
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
                          color: const Color(0xFF736B5E),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Sanskrit Verse Text
                      SanskritVerseText(
                        sanskrit: verse.sanskrit,
                        textAlign: TextAlign.left,
                        color: const Color(0xFF18392C),
                      ),

                      const SizedBox(height: 14),

                      // Verse Reference (e.g. Bhagavad Gita 3.25)
                      Text(
                        verseRef,
                        style: AppTypography.verseReference(
                          languageCode,
                          color: const Color(0xFF18392C),
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Divider(
                        color: Color(0xFFE8E2DA),
                        height: 1,
                        thickness: 1,
                      ),
                      const SizedBox(height: 20),

                      // TRANSLATION Section Header Label
                      Text(
                        l10n.translation,
                        style: AppTypography.sectionLabel(
                          languageCode,
                          color: const Color(0xFF736B5E),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Translation Body Text
                      Text(
                        translationText,
                        style: AppTypography.scriptureTranslation(
                          languageCode,
                          color: const Color(0xFF18392C),
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
                                color: const Color(0xFF18392C),
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
                        color: const Color(0xFF18392C),
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
                                    : const Color(0xFFF9D6C4),
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
                              color: const Color(0xFF18392C),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: Color(0xFF18392C),
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
