import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../data/sacred_books_data.dart';
import '../../../../models/sacred_book_model.dart';
import '../../../../models/sacred_chapter_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/guest_access_provider.dart';
import '../../../../providers/navigation_provider.dart';

class SacredChapterListScreen extends StatelessWidget {
  const SacredChapterListScreen({
    super.key,
    required this.textId,
  });

  final String textId;

  @override
  Widget build(BuildContext context) {
    final book = _findBook(textId);

    if (book == null) {
      return _bookNotFound(context);
    }

    final width = MediaQuery.sizeOf(context).width;

    final horizontalPadding = width >= 900
        ? 40.0
        : width >= 600
            ? 28.0
            : 20.0;

    final maxContentWidth = width >= 900 ? 900.0 : double.infinity;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF5ED),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 3,
        onTap: (index) {
          context.read<NavigationProvider>().setIndex(index);
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),

                // Top Back Arrow
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding - 8),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 26,
                      color: Color(0xFF1B1B1B),
                    ),
                  ),
                ),

                // Header Area with Title & Chariot Image
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Subtle Sun background artwork
                      Positioned(
                        right: -10,
                        top: -15,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF0D8).withValues(alpha: 0.75),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      // Chariot Line-Art Image at upper right (Enlarged 25-30%)
                      Positioned(
                        right: -12,
                        top: -10,
                        width: width >= 600 ? 280 : 215,
                        height: width >= 600 ? 190 : 145,
                        child: Image.asset(
                          'assets/images/chariot_lineart.png',
                          fit: BoxFit.contain,
                          alignment: Alignment.topRight,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox.shrink(),
                        ),
                      ),

                      // Header Text (Title, Subtitle, Chapter count)
                      Padding(
                        padding: EdgeInsets.only(right: width >= 600 ? 220 : 155),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 38,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1B1B1B),
                                height: 1.05,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              book.subtitle.isNotEmpty
                                  ? book.subtitle
                                  : 'The Divine Song of Lord Krishna',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF555555),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${book.totalChapters} Chapters',
                              style: GoogleFonts.manrope(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF8C6647),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Select a Chapter Section Heading
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Text(
                    'Select a Chapter',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B1B1B),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Chapter Cards List
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      top: 4,
                      bottom: 24,
                    ),
                    itemCount: book.chapters.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final chapter = book.chapters[index];
                      return _buildChapterCard(context, book, chapter, index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CHAPTER CARD WIDGET
  // ============================================================

  Widget _buildChapterCard(
    BuildContext context,
    SacredBookModel book,
    SacredChapterModel chapter,
    int index,
  ) {
    final boxStyle = _getChapterBoxStyle(index);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final auth = context.read<AuthProvider>();
          final guestAccess = context.read<GuestAccessProvider>();

          if (!guestAccess.canOpenChapter(
            isAuthenticated: auth.isAuthenticated,
          )) {
            _showSignInPrompt(context);
            return;
          }

          Navigator.of(context).pushNamed(
            AppRoutes.sacredTextReading,
            arguments: {
              'textId': book.id,
              'chapterNumber': chapter.chapterNumber,
            },
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9F0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFEAE2D2),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left Chapter Number Badge (Alternating Soft Colors)
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: boxStyle.backgroundColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '${chapter.chapterNumber}',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: boxStyle.textColor,
                    height: 1.0,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Center Chapter Title & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.title,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1B1B1B),
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${chapter.subtitle} • Chapter ${chapter.chapterNumber}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Right Arrow Chevron
              const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFF666666),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Alternating Warm Box Colors for Chapter Numbers
  _BoxStyleConfig _getChapterBoxStyle(int index) {
    final styles = const [
      _BoxStyleConfig(
        backgroundColor: Color(0xFF8A9A68), // Sage green
        textColor: Colors.white,
      ),
      _BoxStyleConfig(
        backgroundColor: Color(0xFFE47B3E), // Warm orange
        textColor: Colors.white,
      ),
      _BoxStyleConfig(
        backgroundColor: Color(0xFFEBD5AA), // Soft gold
        textColor: Color(0xFF1B1B1B),
      ),
      _BoxStyleConfig(
        backgroundColor: Color(0xFFB2C498), // Light sage green
        textColor: Color(0xFF1B1B1B),
      ),
      _BoxStyleConfig(
        backgroundColor: Color(0xFFF4A75E), // Warm yellow/orange
        textColor: Color(0xFF1B1B1B),
      ),
      _BoxStyleConfig(
        backgroundColor: Color(0xFFC6D0AC), // Soft olive green
        textColor: Color(0xFF1B1B1B),
      ),
    ];

    return styles[index % styles.length];
  }

  // ============================================================
  // FIND BOOK HELPER
  // ============================================================

  SacredBookModel? _findBook(String id) {
    final normalizedId = id.trim().toLowerCase();

    for (final book in SacredBooksData.all) {
      if (book.id.trim().toLowerCase() == normalizedId) {
        return book;
      }
    }

    if (normalizedId == 'bhagavad_gita' ||
        normalizedId == 'bhagavad-gita' ||
        normalizedId == 'bhagavadgita' ||
        normalizedId == 'gita') {
      return SacredBooksData.all.firstWhere(
        (book) => book.id.trim().toLowerCase() == 'bhagavad_gita',
        orElse: () => throw Exception(
          'Bhagavad Gita not found in SacredBooksData.all',
        ),
      );
    }

    return null;
  }

  // ============================================================
  // BOOK NOT FOUND
  // ============================================================

  Widget _bookNotFound(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5ED),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  size: 80,
                  color: Color(0xFFC85A32),
                ),
                const SizedBox(height: 20),
                Text(
                  'Book not found',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B1B1B),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Book ID: $textId',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    color: const Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC85A32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 34,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SIGN IN PROMPT
  // ============================================================

  void _showSignInPrompt(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Continue your journey'),
          content: const Text(
            'You have completed your free chapter. Sign in now to continue reading all sacred books and chapters.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Later'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pushNamed(AppRoutes.auth);
              },
              child: const Text('Sign in now'),
            ),
          ],
        );
      },
    );
  }
}

class _BoxStyleConfig {
  final Color backgroundColor;
  final Color textColor;

  const _BoxStyleConfig({
    required this.backgroundColor,
    required this.textColor,
  });
}