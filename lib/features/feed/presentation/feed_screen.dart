import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../data/mock_wisdom_data.dart';
import '../../../../data/sacred_books_data.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/chapter_completion_provider.dart';
import '../../../../providers/reading_progress_provider.dart';
import 'widgets/wisdom_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Timer? _completionTimer;
  bool _isShowingCompletion = false;

  static const List<Color> _backgroundColors = [
    Color(0xFFA57625),
    Color(0xFFE9CA9B),
    Color(0xFFD4A96D),
    Color(0xFFC0A275),
  ];

  @override
  void dispose() {
    _completionTimer?.cancel();
    super.dispose();
  }

  Future<void> _showPendingCompletion(BuildContext context) async {
    if (!mounted || _isShowingCompletion) {
      return;
    }

    final completion =
        context.read<ChapterCompletionProvider>().takePending();

    if (completion == null) {
      return;
    }

    _isShowingCompletion = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return _CompletionDialog(
          bookTitle: completion.bookTitle,
          chapterTitle: completion.chapterTitle,
        );
      },
    );

    _isShowingCompletion = false;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final horizontalPadding = width >= 900
        ? 40.0
        : width >= 600
            ? 28.0
            : 16.0;

    final maxContentWidth = width >= 900 ? 900.0 : double.infinity;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPendingCompletion(context);
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _backgroundColors,
            stops: [0.0, 0.35, 0.68, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxContentWidth,
              ),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(
                    child: _FeedHeader(),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          const SizedBox(height: 8),

                          // DAILY WISDOM
                          WisdomCard(
                            wisdom: MockWisdomData.dailyWisdom,
                          ),

                          const SizedBox(height: 12),

                          // CONTINUE YOUR JOURNEY
                          const _ContinueScripturesRow(),

                          const SizedBox(height: 36),

                          // EXPLORE SCRIPTURES
                          const _ExplorePreview(),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// FEED HEADER
// ============================================================

class _FeedHeader extends StatelessWidget {
  const _FeedHeader();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final userName = auth.firstName;

    final width = MediaQuery.sizeOf(context).width;

    final horizontalPadding = width >= 900
        ? 40.0
        : width >= 600
            ? 28.0
            : 16.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        16,
        horizontalPadding,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'NAMASTE, ${userName.toUpperCase()}',
              maxLines: 2,
              softWrap: true,
              style: AppTextStyles.pageHeading.copyWith(
                fontSize: width >= 900
                    ? 25
                    : width >= 600
                        ? 23
                        : 21,
                color: AppColors.primaryBurgundy,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department_outlined,
                  size: 18,
                  color: AppColors.primaryBurgundy,
                ),
                const SizedBox(width: 6),
                Text(
                  '7 Days',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CONTINUE YOUR JOURNEY
// ============================================================

class _ContinueScripturesRow extends StatelessWidget {
  const _ContinueScripturesRow();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final cardWidth = width >= 900
        ? 520.0
        : width >= 600
            ? 440.0
            : width * 0.86;

    final books = [
      {
        'id': 'bhagavad_gita',
        'title': 'Bhagavad Gita',
        'subtitle': 'Continue where you left off',
      },
      {
        'id': 'ramayana',
        'title': 'Ramayana',
        'subtitle': 'The Epic of Duty',
      },
    ];

    final readingProvider =
        context.watch<ReadingProgressProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Continue Your Journey',
            style: AppTextStyles.caption.copyWith(
              fontSize: 12,
              color: AppColors.secondaryText,
            ),
          ),
        ),

        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: books.length,
            separatorBuilder: (_, __) {
              return const SizedBox(width: 12);
            },
            itemBuilder: (context, index) {
              final info = books[index];

              final bookId = info['id'] as String;
              final title = info['title'] as String;
              final subtitle = info['subtitle'] as String;

              final savedPos =
                  readingProvider.positionFor(bookId);

              final bookModel =
                  SacredBooksData.findById(bookId);

              double progress = 0.0;

              if (savedPos != null && bookModel != null) {
                progress =
                    (savedPos.chapterNumber - 1) /
                        bookModel.totalChapters;

                progress = progress.clamp(0.0, 1.0);
              }

              return SizedBox(
                width: cardWidth,
                child: GestureDetector(
                  onTap: () {
                    if (savedPos != null) {
                      Navigator.of(context).pushNamed(
                        AppRoutes.sacredTextReading,
                        arguments: {
                          'textId': bookId,
                          'chapterNumber':
                              savedPos.chapterNumber,
                        },
                      );
                    } else {
                      Navigator.of(context).pushNamed(
                        AppRoutes.sacredTextReading,
                        arguments: bookId,
                      );
                    }
                  },
                  child: Material(
                    color: Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(
                      AppDimensions.radiusLarge,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.82),
                        borderRadius:
                            BorderRadius.circular(
                          AppDimensions.radiusLarge,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.80),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style:
                                AppTextStyles.cardTitle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            style:
                                AppTextStyles.caption.copyWith(
                              fontSize: 12,
                              color:
                                  AppColors.secondaryText,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                  child:
                                      LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 6,
                                    backgroundColor:
                                        AppColors.softBeige,
                                    color:
                                        const Color(0xFFA57625),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  if (savedPos != null) {
                                    Navigator.of(context)
                                        .pushNamed(
                                      AppRoutes
                                          .sacredTextReading,
                                      arguments: {
                                        'textId': bookId,
                                        'chapterNumber':
                                            savedPos
                                                .chapterNumber,
                                      },
                                    );
                                  } else {
                                    Navigator.of(context)
                                        .pushNamed(
                                      AppRoutes
                                          .sacredTextReading,
                                      arguments: bookId,
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.volume_up_rounded,
                                  color:
                                      AppColors.secondaryText,
                                ),
                                tooltip: 'Open',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================
// EXPLORE SCRIPTURES
// ============================================================

class _ExplorePreview extends StatelessWidget {
  const _ExplorePreview();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    /*
     * BOOK IMAGE RATIO
     *
     * Real book covers are portrait.
     *
     * width : height
     * 0.66  : 1
     *
     * So we calculate the height from the width.
     * This prevents the white/empty container problem.
     */

    final double bookWidth;

    if (width >= 900) {
      bookWidth = 300.0;
    } else if (width >= 600) {
      bookWidth = width * 0.40;
    } else {
      bookWidth = width * 0.48;
    }

    final double bookHeight = bookWidth / 0.66;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore Scriptures',
          style: AppTextStyles.sectionHeading.copyWith(
            color: AppColors.darkText,
            fontSize: width >= 600 ? 30 : 28,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 18),

        /*
         * ONLY TWO BOOKS
         *
         * Horizontal scrolling is kept so the UI
         * remains comfortable on smaller phones.
         */
        SizedBox(
          height: bookHeight + 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: SacredBooksData.all.length >= 2
                ? 2
                : SacredBooksData.all.length,
            separatorBuilder: (_, __) {
              return const SizedBox(width: 22);
            },
            itemBuilder: (context, index) {
              final book = SacredBooksData.all[index];

              final imagePath =
                  'assets/images/${book.id}.png';

              return _ScripturePreviewCard(
                title: book.title,
                subtitle: book.subtitle,
                imagePath: imagePath,
                width: bookWidth,
                height: bookHeight,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.sacredTextDetail,
                    arguments: book.id,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================
// BOOK IMAGE CARD
// ============================================================

class _ScripturePreviewCard extends StatelessWidget {
  const _ScripturePreviewCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.width,
    required this.height,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String imagePath;
  final double width;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
             * IMPORTANT:
             *
             * NO WHITE CONTAINER
             * NO CARD BACKGROUND
             *
             * The actual book image itself is shown.
             */

            SizedBox(
              width: width,
              height: height,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(18),
                child: Image.asset(
                  imagePath,

                  /*
                   * BoxFit.fill is intentionally NOT used.
                   *
                   * BoxFit.cover keeps the book artwork
                   * filling the exact portrait area.
                   */
                  fit: BoxFit.cover,

                  alignment: Alignment.center,

                  filterQuality: FilterQuality.high,

                  errorBuilder:
                      (context, error, stackTrace) {
                    return Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        gradient:
                            AppGradients.sacredCard(0),
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        title.characters
                            .take(2)
                            .toString(),
                        style:
                            AppTextStyles.cardTitle.copyWith(
                          color: AppColors.white,
                          fontSize: 36,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  AppTextStyles.cardTitle.copyWith(
                color: AppColors.darkText,
                fontSize: width < 200 ? 15 : 17,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  AppTextStyles.caption.copyWith(
                color: AppColors.secondaryText,
                fontSize: width < 200 ? 11 : 12,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// COMPLETION DIALOG
// ============================================================

class _CompletionDialog extends StatelessWidget {
  const _CompletionDialog({
    required this.bookTitle,
    required this.chapterTitle,
  });

  final String bookTitle;
  final String chapterTitle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(
          milliseconds: 700,
        ),
        curve: Curves.elasticOut,
        tween: Tween(
          begin: 0.65,
          end: 1,
        ),
        builder: (
          context,
          scale,
          child,
        ) {
          return Transform.scale(
            scale: scale,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                24,
                22,
                24,
                18,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.peachHighlight,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      _CelebrationIcon(),
                      SizedBox(width: 12),
                      _CelebrationIcon(),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'You completed $chapterTitle',
                    textAlign: TextAlign.center,
                    style:
                        AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bookTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          AppColors.primaryBurgundy,
                    ),
                    child: const Text(
                      'Continue journey',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// CELEBRATION ICON
// ============================================================

class _CelebrationIcon extends StatelessWidget {
  const _CelebrationIcon();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(
        milliseconds: 900,
      ),
      tween: Tween(
        begin: -0.12,
        end: 0.12,
      ),
      curve: Curves.easeInOut,
      builder: (
        context,
        angle,
        child,
      ) {
        return Transform.rotate(
          angle: angle,
          child: const Icon(
            Icons.auto_awesome,
            color: AppColors.warmOrange,
            size: 27,
          ),
        );
      },
    );
  }
}