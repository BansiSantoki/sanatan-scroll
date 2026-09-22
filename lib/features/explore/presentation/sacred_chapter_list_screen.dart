import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_typography.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/share_service.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../data/sacred_books_data.dart';
import '../../../../data/sacred_books_repository.dart';
import '../../../../models/sacred_book_model.dart';
import '../../../../models/sacred_chapter_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/guest_access_provider.dart';
import '../../../../providers/locale_provider.dart';
import '../../../../providers/navigation_provider.dart';

class SacredChapterListScreen extends StatefulWidget {
  const SacredChapterListScreen({
    super.key,
    required this.textId,
  });

  final String textId;

  @override
  State<SacredChapterListScreen> createState() => _SacredChapterListScreenState();
}

class _SacredChapterListScreenState extends State<SacredChapterListScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SacredBookModel?>(
      stream: SacredBooksRepository.streamBookById(widget.textId),
      builder: (context, snapshot) {
        final book = snapshot.data ?? SacredBooksData.findById(widget.textId);

        if (book == null) {
          return _bookNotFound(context);
        }

        final config = _BookUiConfig.fromBookId(book.id);
        final width = MediaQuery.sizeOf(context).width;

        final horizontalPadding = width >= 900
            ? 40.0
            : width >= 600
                ? 28.0
                : 20.0;

        final maxContentWidth = width >= 900 ? 900.0 : double.infinity;
        final langCode = context.watch<LocaleProvider>().languageCode;

        final localizedTitle = book.getLocalizedTitle(langCode);
        final rawSubtitle = book.getLocalizedSubtitle(langCode);
        final localizedSubtitle = rawSubtitle.isNotEmpty
            ? rawSubtitle
            : config.defaultSubtitle;

        final countText = '${book.totalChapters} ${config.unitName(book.totalChapters)}';

        return Scaffold(
          backgroundColor: const Color(0xFFFAF7F2),
          bottomNavigationBar: CustomBottomNavigation(
            currentIndex: 0,
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

                    // Top Action Bar with Back Arrow and Share Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding - 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 26,
                              color: Color(0xFF1B1B1B),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final textToShare = '$localizedTitle — $localizedSubtitle\n\nSanatan Scroll';
                              ShareService.showOptions(
                                context: context,
                                title: localizedTitle,
                                text: textToShare,
                              );
                            },
                            icon: const Icon(
                              Icons.share_outlined,
                              size: 24,
                              color: Color(0xFF1B1B1B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Book Header Artwork Card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: config.headerBgColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: config.headerBgColor.withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            children: [
                              // Artwork on right
                              Positioned(
                                right: -10,
                                bottom: -10,
                                top: -10,
                                width: width >= 600 ? 260 : 185,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Image.asset(
                                    config.artworkAsset,
                                    fit: BoxFit.contain,
                                    alignment: Alignment.centerRight,
                                    filterQuality: FilterQuality.high,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const SizedBox.shrink(),
                                  ),
                                ),
                              ),

                              // Text details on left
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 22,
                                  top: 22,
                                  bottom: 22,
                                  right: width >= 600 ? 240 : 160,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'SACRED SCRIPTURE',
                                      style: AppTextStyles.getFont(
                                        context,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2C1810),
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      localizedTitle,
                                      style: AppTextStyles.getFont(
                                        context,
                                        fontSize: 34,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1B1B1B),
                                        height: 1.05,
                                        isSerif: true,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      localizedSubtitle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.getFont(
                                        context,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF333333),
                                        height: 1.25,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      countText,
                                      style: AppTextStyles.getFont(
                                        context,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2C1810),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section Heading (Select a Chapter / Kanda)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Text(
                        config.sectionTitle,
                        style: AppTypography.sectionHeading(
                          langCode,
                          color: const Color(0xFF18392C),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Chapter / Kanda Cards List
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
                          return _buildChapterCard(
                            context,
                            book,
                            chapter,
                            index,
                            config,
                            langCode,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // REUSABLE CHAPTER / KANDA CARD WIDGET
  // ============================================================

  Widget _buildChapterCard(
    BuildContext context,
    SacredBookModel book,
    SacredChapterModel chapter,
    int index,
    _BookUiConfig config,
    String langCode,
  ) {
    final chapterTitle = _getChapterTitle(book.id, chapter, langCode);
    final chapterSubtitle = _getChapterSubtitle(book.id, chapter, langCode);

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
              // Left Chapter Number Badge
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: config.badgeBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '${chapter.chapterNumber}',
                  style: AppTextStyles.getFont(
                    context,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: config.badgeTextColor,
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
                      chapterTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.cardTitle(
                        langCode,
                        color: const Color(0xFF18392C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chapterSubtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.compact(
                        langCode,
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
                color: Color(0xFF7A6B5D),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getChapterTitle(String bookId, SacredChapterModel chapter, String langCode) {
    if (langCode == 'gu' && chapter.titleGu != null && chapter.titleGu!.isNotEmpty) {
      return chapter.titleGu!;
    }
    if (langCode == 'hi' && chapter.titleHi != null && chapter.titleHi!.isNotEmpty) {
      return chapter.titleHi!;
    }
    if (chapter.titleEn != null && chapter.titleEn!.isNotEmpty) {
      return chapter.titleEn!;
    }
    return chapter.title;
  }

  String _getChapterSubtitle(String bookId, SacredChapterModel chapter, String langCode) {
    if (langCode == 'gu' && chapter.subtitleGu != null && chapter.subtitleGu!.isNotEmpty) {
      return chapter.subtitleGu!;
    }
    if (langCode == 'hi' && chapter.subtitleHi != null && chapter.subtitleHi!.isNotEmpty) {
      return chapter.subtitleHi!;
    }
    if (chapter.subtitleEn != null && chapter.subtitleEn!.isNotEmpty) {
      return chapter.subtitleEn!;
    }
    if (chapter.subtitle.isNotEmpty && !chapter.subtitle.startsWith('Bhagavad Gita Chapter') && !chapter.subtitle.startsWith('Ramayana Kanda')) {
      return chapter.subtitle;
    }

    // Default reference subtitles for Gita & Ramayana when raw subtitle is generic
    if (bookId == 'bhagavad_gita') {
      const gitaSubtitles = [
        'The Yoga of Grief',
        'The Yoga of Knowledge',
        'The Yoga of Action',
        'The Yoga of Wisdom',
        'The Yoga of Renunciation',
        'The Yoga of Meditation',
        'The Yoga of Knowledge and Wisdom',
        'The Yoga of Eternal Brahman',
        'The Yoga of Royal Knowledge',
        'The Yoga of Divine Glories',
        'The Vision of Cosmic Form',
        'The Yoga of Devotion',
        'The Field and Knower',
        'The Three Gunas',
        'The Supreme Person',
        'Divine and Demonic Natures',
        'The Threefold Faith',
        'The Yoga of Liberation',
      ];
      final idx = chapter.chapterNumber - 1;
      if (idx >= 0 && idx < gitaSubtitles.length) {
        return gitaSubtitles[idx];
      }
    }

    return chapter.subtitle;
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
          context.l10n.scriptureNotFound,
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

class _BookUiConfig {
  final Color headerBgColor;
  final Color badgeBgColor;
  final Color badgeTextColor;
  final String artworkAsset;
  final String defaultSubtitle;
  final String sectionTitle;
  final String Function(int count) unitName;

  const _BookUiConfig({
    required this.headerBgColor,
    required this.badgeBgColor,
    required this.badgeTextColor,
    required this.artworkAsset,
    required this.defaultSubtitle,
    required this.sectionTitle,
    required this.unitName,
  });

  factory _BookUiConfig.fromBookId(String bookId) {
    switch (bookId) {
      case 'ramayana':
        return _BookUiConfig(
          headerBgColor: const Color(0xFFCBD1AE), // Muted sage olive (Ref 2)
          badgeBgColor: const Color(0xFFEAEFD8),
          badgeTextColor: const Color(0xFF5A6C38),
          artworkAsset: 'assets/images/trishual.png',
          defaultSubtitle: 'The Epic of Duty',
          sectionTitle: 'Select a Kanda',
          unitName: (c) => c == 1 ? 'Kanda' : 'Kandas',
        );

      case 'mahabharata':
        return _BookUiConfig(
          headerBgColor: const Color(0xFFDFB874), // Warm golden amber
          badgeBgColor: const Color(0xFFF9EED4),
          badgeTextColor: const Color(0xFF8C6647),
          artworkAsset: 'assets/images/mahabharat_page.png',
          defaultSubtitle: 'The Epic of Dharma & Duty',
          sectionTitle: 'Select a Chapter',
          unitName: (c) => c == 1 ? 'Chapter' : 'Chapters',
        );

      case 'upanishads':
        return _BookUiConfig(
          headerBgColor: const Color(0xFFA5B288), // Soft leaf sage
          badgeBgColor: const Color(0xFFEAF0D8),
          badgeTextColor: const Color(0xFF5A6C38),
          artworkAsset: 'assets/images/upnishad_page.png',
          defaultSubtitle: 'The Ultimate Truth & Wisdom',
          sectionTitle: 'Select a Chapter',
          unitName: (c) => c == 1 ? 'Chapter' : 'Chapters',
        );

      case 'bhagavad_gita':
      default:
        return _BookUiConfig(
          headerBgColor: const Color(0xFFE48D53), // Warm orange (Ref 1)
          badgeBgColor: const Color(0xFFFDECDA),
          badgeTextColor: const Color(0xFFC85A32),
          artworkAsset: 'assets/images/chariot_lineart.png',
          defaultSubtitle: 'The Divine Song of Lord Krishna',
          sectionTitle: 'Select a Chapter',
          unitName: (c) => c == 1 ? 'Chapter' : 'Chapters',
        );
    }
  }
}