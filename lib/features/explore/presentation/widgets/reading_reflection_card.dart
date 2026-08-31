import 'package:flutter/material.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../models/sacred_book_model.dart';
import '../../../../models/sacred_chapter_model.dart';
import '../../../../models/sacred_verse_model.dart';

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
  });

  final SacredBookModel book;
  final SacredChapterModel chapter;
  final SacredVerseModel verse;
  final String languageCode;
  final bool isSaved;
  final VoidCallback onToggleSave;
  final VoidCallback onShare;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 600 ? 32.0 : 20.0;
    final locale = Locale(languageCode);

    final reflectionText = verse.getReflectionFullText(languageCode);
    final oneThingToNotice = verse.getOneThingToNotice(languageCode);
    final tryThis = verse.getTryThis(languageCode);
    final carryThisWithYou = verse.getCarryThisWithYou(languageCode);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 3,
        onTap: (index) {},
      ),
      body: SafeArea(
        bottom: false,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              // Top-Right Orange Decorative Blob & Lotus Art
              Positioned(
                top: 10,
                right: -15,
                child: CustomPaint(
                  size: const Size(140, 150),
                  painter: _ReflectionTopArtPainter(),
                ),
              ),

              // Main Layout Column
              Column(
                children: [
                  // Top Header Row (Back Arrow, REFLECTION Title, Save Icon)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding - 8,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: onBack,
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: Color(0xFF1B1B1B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'REFLECTION',
                          style: AppTextStyles.getFontForLocale(
                            locale,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFD96E28),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: onToggleSave,
                          icon: Icon(
                            isSaved
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_outline_rounded,
                            size: 26,
                            color: const Color(0xFF1B1B1B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main Reflection Content Body
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),

                          // Reflection Body Text Paragraphs
                          Text(
                            reflectionText,
                            style: AppTextStyles.getFontForLocale(
                              locale,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF232323),
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 24),
                          const Divider(
                            color: Color(0xFFE5DEC8),
                            thickness: 1,
                          ),
                          const SizedBox(height: 16),

                          // ONE THING TO NOTICE TODAY
                          _buildSectionRow(
                            locale: locale,
                            icon: Icons.remove_red_eye_outlined,
                            title: 'ONE THING TO NOTICE TODAY',
                            content: oneThingToNotice,
                          ),

                          const SizedBox(height: 18),
                          const Divider(
                            color: Color(0xFFEFE8D6),
                            height: 1,
                          ),
                          const SizedBox(height: 18),

                          // TRY THIS
                          _buildSectionRow(
                            locale: locale,
                            icon: Icons.track_changes_rounded,
                            title: 'TRY THIS',
                            content: tryThis,
                          ),

                          const SizedBox(height: 18),
                          const Divider(
                            color: Color(0xFFEFE8D6),
                            height: 1,
                          ),
                          const SizedBox(height: 18),

                          // CARRY THIS WITH YOU
                          _buildSectionRow(
                            locale: locale,
                            icon: Icons.favorite_border_rounded,
                            title: 'CARRY THIS WITH YOU',
                            content: carryThisWithYou,
                          ),

                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Action Bar: Save | Set Wallpaper | Share
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 10,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E7D3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE7D8BD),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // 1. Save button
                          InkWell(
                            onTap: onToggleSave,
                            child: Row(
                              children: [
                                Icon(
                                  isSaved
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_outline_rounded,
                                  size: 20,
                                  color: const Color(0xFF1B1B1B),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isSaved ? 'Saved' : 'Save',
                                  style: AppTextStyles.getFontForLocale(
                                    locale,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1B1B1B),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 1,
                            height: 20,
                            color: const Color(0xFFDFD1B8),
                          ),

                          // 2. Set Wallpaper button
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text('Wallpaper setting feature triggered!'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.crop_original_rounded,
                                  size: 20,
                                  color: Color(0xFF1B1B1B),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Set Wallpaper',
                                  style: AppTextStyles.getFontForLocale(
                                    locale,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1B1B1B),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 1,
                            height: 20,
                            color: const Color(0xFFDFD1B8),
                          ),

                          // 3. Share button
                          InkWell(
                            onTap: onShare,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.share_outlined,
                                  size: 20,
                                  color: Color(0xFF1B1B1B),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Share',
                                  style: AppTextStyles.getFontForLocale(
                                    locale,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1B1B1B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionRow({
    required Locale locale,
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF6B784B),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.getFontForLocale(
                  locale,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF6B784B),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: AppTextStyles.getFontForLocale(
                  locale,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2B2B2B),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReflectionTopArtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final blobPaint = Paint()
      ..color = const Color(0xFFE28C59).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.3, 0)
      ..cubicTo(
        size.width * 0.1,
        size.height * 0.3,
        size.width * 0.4,
        size.height * 0.9,
        size.width,
        size.height * 0.7,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, blobPaint);

    final lotusPaint = Paint()
      ..color = const Color(0xFFFAF7F2).withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width * 0.75, size.height * 0.45);
    canvas.drawCircle(center, 12, lotusPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
