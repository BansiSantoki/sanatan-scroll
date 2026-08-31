import 'package:flutter/material.dart';

import '../../../../app/theme/app_text_styles.dart';
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
  });

  final SacredBookModel book;
  final SacredChapterModel chapter;
  final SacredVerseModel verse;
  final String languageCode;
  final bool isSaved;
  final VoidCallback onToggleSave;
  final bool isPlayingAudio;
  final VoidCallback onToggleAudio;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 600 ? 32.0 : 20.0;
    final locale = Locale(languageCode);

    final quoteText = verse.getQuoteText(languageCode);
    final translationText = verse.getLocalizedTranslation(languageCode);
    final bookTitle = book.getLocalizedTitle(languageCode);
    final verseRef = '$bookTitle ${chapter.chapterNumber}.${verse.verseNumber}';

    return Scaffold(
      backgroundColor: const Color(0xFFF7762D),
      body: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Background Warm Orange Fill & Custom Artwork Painter
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF7762D),
                      Color(0xFFF65B1C),
                    ],
                  ),
                ),
              ),
            ),

            // Background Custom Painter for Sun, Star, Leaves & Hill Art
            Positioned.fill(
              child: CustomPaint(
                painter: _WisdomBackgroundPainter(),
              ),
            ),

            // Main Foreground Content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Top Header Row (WISDOM + Save Icon)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WISDOM',
                              style: AppTextStyles.getFontForLocale(
                                locale,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF2A1808),
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Container(
                              width: 22,
                              height: 2,
                              color: const Color(0xFF2A1808),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: onToggleSave,
                          tooltip: isSaved ? 'Unsave' : 'Save',
                          icon: Icon(
                            isSaved
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_outline_rounded,
                            color: const Color(0xFF2A1808),
                            size: 26,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Main Scrollable Wisdom Body Content
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Quotation mark
                            Text(
                              '“',
                              style: AppTextStyles.getFontForLocale(
                                locale,
                                fontSize: 54,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1B1B1B),
                                height: 0.8,
                                isSerif: true,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Main Quote / Heading
                            Text(
                              quoteText,
                              style: AppTextStyles.getFontForLocale(
                                locale,
                                fontSize: width >= 600 ? 36 : 30,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1B1B1B),
                                height: 1.15,
                                isSerif: true,
                              ),
                            ),

                            const SizedBox(height: 20),
                            const Divider(
                              color: Color(0x3B1B1B1B),
                              height: 1,
                              thickness: 1,
                            ),
                            const SizedBox(height: 16),

                            // SANSKRIT Section
                            Text(
                              'SANSKRIT',
                              style: AppTextStyles.getFontForLocale(
                                locale,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF2A1808),
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              verse.sanskrit,
                              style: AppTextStyles.getFontForLocale(
                                const Locale('hi'),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1B1B1B),
                                height: 1.45,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Scripture Reference Pill (e.g. Bhagavad Gita 2.48)
                            Row(
                              children: [
                                const Icon(
                                  Icons.filter_vintage_outlined,
                                  size: 18,
                                  color: Color(0xFF2A1808),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    verseRef,
                                    style: AppTextStyles.getFontForLocale(
                                      locale,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1B1B1B),
                                      isSerif: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            const Divider(
                              color: Color(0x3B1B1B1B),
                              height: 1,
                              thickness: 1,
                            ),
                            const SizedBox(height: 16),

                            // TRANSLATION Section
                            Text(
                              'TRANSLATION',
                              style: AppTextStyles.getFontForLocale(
                                locale,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF2A1808),
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              translationText,
                              style: AppTextStyles.getFontForLocale(
                                locale,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1B1B1B),
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),

                    // Audio Player Pill at bottom (Reference Image 2)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF79E53).withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: const Color(0xFFFBB374),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: onToggleAudio,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1F2E1E),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPlayingAudio
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Listen to Audio',
                            style: AppTextStyles.getFontForLocale(
                              locale,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1B1B1B),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(4, (index) {
                              final heights = [10.0, 16.0, 12.0, 18.0];
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                width: 3,
                                height: isPlayingAudio ? heights[index] : 10,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1F2E1E),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Swipe up indicator
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.keyboard_arrow_up_rounded,
                            size: 20,
                            color: Color(0xFF2A1808),
                          ),
                          Text(
                            'Swipe up for more',
                            style: AppTextStyles.getFontForLocale(
                              locale,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF2A1808),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Background painter for Sun, Star, Leaf & Hill art
class _WisdomBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Golden Sun Circle (Upper Right)
    final sunPaint = Paint()
      ..color = const Color(0xFFFBC05A).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.76, size.height * 0.16),
      size.width * 0.16,
      sunPaint,
    );

    // 2. Star / Sparkle Motif (Middle Right)
    final starPaint = Paint()
      ..color = const Color(0xFFF3A756).withValues(alpha: 0.9)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final starCenter = Offset(size.width * 0.84, size.height * 0.32);
    const starRadius = 18.0;
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(
          starCenter.dx - starRadius * 0.8 * (i % 2 == 0 ? 1 : 0.7) * (i == 1 || i == 3 ? -1 : 1),
          starCenter.dy,
        ),
        Offset(
          starCenter.dx + starRadius * 0.8 * (i % 2 == 0 ? 1 : 0.7) * (i == 1 || i == 3 ? -1 : 1),
          starCenter.dy,
        ),
        starPaint,
      );
    }

    // 3. Dark Green Hill / Arch Shape (Bottom Right)
    final hillPaint = Paint()
      ..color = const Color(0xFF2B4D34)
      ..style = PaintingStyle.fill;
    final hillPath = Path()
      ..moveTo(size.width * 0.65, size.height)
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 0.92,
        size.width,
        size.height * 0.95,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(hillPath, hillPaint);

    // 4. Sage Leaf Line-Art (Bottom Left)
    final leafPaint = Paint()
      ..color = const Color(0xFF3B4E26).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    final leafPath1 = Path()
      ..moveTo(0, size.height * 0.86)
      ..quadraticBezierTo(
        size.width * 0.12,
        size.height * 0.84,
        size.width * 0.18,
        size.height * 0.92,
      )
      ..quadraticBezierTo(
        size.width * 0.08,
        size.height * 0.96,
        0,
        size.height * 0.94,
      )
      ..close();
    canvas.drawPath(leafPath1, leafPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
