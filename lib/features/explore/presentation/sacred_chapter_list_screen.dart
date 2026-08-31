import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../data/sacred_books_data.dart';
import '../../../../models/sacred_book_model.dart';
import '../../../../models/sacred_chapter_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/guest_access_provider.dart';
import '../../../../providers/locale_provider.dart';
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

                      // Chariot Line-Art Image at upper right
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
                        child: Builder(
                          builder: (context) {
                            final langCode = context.watch<LocaleProvider>().languageCode;
                            final l10n = context.l10n;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.getLocalizedTitle(langCode),
                                  style: AppTextStyles.getFont(
                                    context,
                                    fontSize: 38,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1B1B1B),
                                    height: 1.05,
                                    isSerif: true,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  book.getLocalizedSubtitle(langCode).isNotEmpty
                                      ? book.getLocalizedSubtitle(langCode)
                                      : 'The Divine Song of Lord Krishna',
                                  style: AppTextStyles.getFont(
                                    context,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF555555),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${book.totalChapters} ${l10n.chapters}',
                                  style: AppTextStyles.getFont(
                                    context,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF8C6647),
                                  ),
                                ),
                              ],
                            );
                          },
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
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B1B1B),
                      isSerif: true,
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
                  style: AppTextStyles.getFont(
                    context,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: boxStyle.textColor,
                    height: 1.0,
                    isSerif: true,
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
                      style: AppTextStyles.getFont(
                        context,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1B1B1B),
                        height: 1.1,
                        isSerif: true,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${chapter.subtitle} • Chapter ${chapter.chapterNumber}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.getFont(
                        context,
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
                color: Color(0xFF8C6647),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _ChapterBoxStyle _getChapterBoxStyle(int index) {
    switch (index % 4) {
      case 0:
        return const _ChapterBoxStyle(
          backgroundColor: Color(0xFFFDECDA),
          textColor: Color(0xFFC85A32),
        );
      case 1:
        return const _ChapterBoxStyle(
          backgroundColor: Color(0xFFEAEFD8),
          textColor: Color(0xFF5A6C38),
        );
      case 2:
        return const _ChapterBoxStyle(
          backgroundColor: Color(0xFFF9EED4),
          textColor: Color(0xFF8C6647),
        );
      case 3:
      default:
        return const _ChapterBoxStyle(
          backgroundColor: Color(0xFFFDE6D5),
          textColor: Color(0xFFD96E28),
        );
    }
  }

  SacredBookModel? _findBook(String id) {
    try {
      return SacredBooksData.all.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  Widget _bookNotFound(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1B1B1B)),
      ),
      body: Center(
        child: Text(
          'Scripture not found',
          style: AppTextStyles.getFont(
            context,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showSignInPrompt(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Unlock Full Access',
                style: AppTextStyles.getFont(
                  ctx,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  isSerif: true,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Guest users can read Chapter 1 for free. Sign in to access all chapters.',
                textAlign: TextAlign.center,
                style: AppTextStyles.getFont(
                  ctx,
                  fontSize: 14,
                  color: const Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.of(context).pushNamed(AppRoutes.auth);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1B1B1B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Sign In',
                    style: AppTextStyles.getFont(
                      ctx,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChapterBoxStyle {
  final Color backgroundColor;
  final Color textColor;

  const _ChapterBoxStyle({
    required this.backgroundColor,
    required this.textColor,
  });
}