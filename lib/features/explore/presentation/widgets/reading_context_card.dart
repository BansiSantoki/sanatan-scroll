import 'package:flutter/material.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../models/sacred_book_model.dart';
import '../../../../models/sacred_chapter_model.dart';
import '../../../../models/sacred_verse_model.dart';

class ReadingContextCard extends StatelessWidget {
  const ReadingContextCard({
    super.key,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.languageCode,
    required this.isSaved,
    required this.onToggleSave,
    required this.onBack,
    required this.onTapReflection,
    required this.isBhagavadGita,
  });

  final SacredBookModel book;
  final SacredChapterModel chapter;
  final SacredVerseModel verse;
  final String languageCode;
  final bool isSaved;
  final VoidCallback onToggleSave;
  final VoidCallback onBack;
  final VoidCallback onTapReflection;
  final bool isBhagavadGita;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 600 ? 32.0 : 20.0;
    final locale = Locale(languageCode);

    final contextText = verse.getContextText(languageCode);
    final whyItMatters = verse.getWhyItMattersText(languageCode);
    final reflectionPreview = verse.getReflectionPreviewText(languageCode);

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
              // Top Right Green Blob & Star Decorative Artwork
              Positioned(
                top: 10,
                right: -10,
                child: CustomPaint(
                  size: const Size(140, 160),
                  painter: _ContextTopArtPainter(),
                ),
              ),

              // Middle Right Leaf Artwork
              Positioned(
                bottom: 120,
                right: 10,
                child: CustomPaint(
                  size: const Size(60, 120),
                  painter: _ContextLeafArtPainter(),
                ),
              ),

              // Main Content Area
              Column(
                children: [
                  // Top Action Bar (Back Arrow & Bookmark Button)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding - 8,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: onBack,
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: Color(0xFF1B1B1B),
                          ),
                        ),
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

                  // Body Content Scroll
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          // CONTEXT Heading
                          Text(
                            'CONTEXT',
                            style: AppTextStyles.getFontForLocale(
                              locale,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF6B784B),
                              letterSpacing: 1.0,
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Context Main Text Body
                          Text(
                            contextText,
                            style: AppTextStyles.getFontForLocale(
                              locale,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1B1B1B),
                              height: 1.45,
                              isSerif: true,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // WHY THIS MATTERS NOW Section
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline_rounded,
                                size: 18,
                                color: Color(0xFF7A7E5A),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'WHY THIS MATTERS NOW',
                                style: AppTextStyles.getFontForLocale(
                                  locale,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF7A7E5A),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF2E4),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE2E7D4),
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              whyItMatters,
                              style: AppTextStyles.getFontForLocale(
                                locale,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2B331F),
                                height: 1.45,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                          const Divider(
                            color: Color(0xFFE5DEC8),
                            thickness: 1,
                          ),
                          const SizedBox(height: 16),

                          // REFLECTION PREVIEW Section
                          Row(
                            children: [
                              const Icon(
                                Icons.remove_red_eye_outlined,
                                size: 18,
                                color: Color(0xFF7A7E5A),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'REFLECTION PREVIEW',
                                style: AppTextStyles.getFontForLocale(
                                  locale,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF7A7E5A),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Padding(
                            padding: EdgeInsets.only(right: width >= 600 ? 80 : 40),
                            child: Text(
                              reflectionPreview,
                              style: AppTextStyles.getFontForLocale(
                                locale,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF2A2A2A),
                                height: 1.5,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Dark Green CTA Button "Tap for full reflection" (Bhagavad Gita only)
                          if (isBhagavadGita)
                            GestureDetector(
                              onTap: onTapReflection,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4D5C37),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF4D5C37).withValues(alpha: 0.25),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.filter_vintage_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Tap for full reflection',
                                        style: AppTextStyles.getFontForLocale(
                                          locale,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          const SizedBox(height: 24),
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
}

class _ContextTopArtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final blobPaint = Paint()
      ..color = const Color(0xFF90A175).withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.4, 0)
      ..cubicTo(
        size.width * 0.1,
        size.height * 0.2,
        size.width * 0.3,
        size.height * 0.8,
        size.width,
        size.height * 0.7,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, blobPaint);

    final starPaint = Paint()
      ..color = const Color(0xFFE28C59)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final starCenter = Offset(size.width * 0.75, size.height * 0.5);
    const radius = 14.0;
    canvas.drawLine(
      Offset(starCenter.dx - radius, starCenter.dy),
      Offset(starCenter.dx + radius, starCenter.dy),
      starPaint,
    );
    canvas.drawLine(
      Offset(starCenter.dx, starCenter.dy - radius),
      Offset(starCenter.dx, starCenter.dy + radius),
      starPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ContextLeafArtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final leafPaint = Paint()
      ..color = const Color(0xFFBCC6A8).withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.5, 0)
      ..quadraticBezierTo(size.width, size.height * 0.3, size.width * 0.5, size.height * 0.6)
      ..quadraticBezierTo(0, size.height * 0.3, size.width * 0.5, 0)
      ..close();
    canvas.drawPath(path, leafPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
