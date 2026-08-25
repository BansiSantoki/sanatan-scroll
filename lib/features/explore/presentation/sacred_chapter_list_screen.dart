import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/routes/app_routes.dart';

import '../../../../data/sacred_books_data.dart';
import '../../../../models/sacred_book_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/guest_access_provider.dart';

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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.screenBackground,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              _buildTopBar(context, book),

              _buildBookHeader(book),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  10,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select a Chapter',
                    style: AppTextStyles.sectionHeading.copyWith(
                      color: AppColors.darkText,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    4,
                    20,
                    30,
                  ),
                  itemCount: book.chapters.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final chapter = book.chapters[index];

                    return _buildChapterCard(
                      context,
                      book,
                      chapter,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FIND BOOK
  // ============================================================
SacredBookModel? _findBook(String id) {
  final normalizedId = id.trim().toLowerCase();

  for (final book in SacredBooksData.all) {
    if (book.id.trim().toLowerCase() == normalizedId) {
      return book;
    }
  }

  // Direct Bhagavad Gita fallback
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
  // TOP BAR
  // ============================================================

  Widget _buildTopBar(
    BuildContext context,
    SacredBookModel book,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        8,
        2,
        8,
        12,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
            ),
            color: AppColors.darkText,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

          Expanded(
            child: Text(
              book.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.sectionHeading.copyWith(
                color: AppColors.darkText,
                fontSize: 20,
              ),
            ),
          ),

          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ============================================================
  // BOOK HEADER
  // ============================================================

  Widget _buildBookHeader(
    SacredBookModel book,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        24,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.softBeige,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.divider,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                book.iconEmoji,
                style: const TextStyle(
                  fontSize: 42,
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style:
                        AppTextStyles.sectionHeading.copyWith(
                      fontSize: 22,
                      color: AppColors.darkText,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    book.subtitle,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.secondaryText,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${book.totalChapters} Chapters',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryBurgundy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CHAPTER CARD
  // ============================================================

  Widget _buildChapterCard(
    BuildContext context,
    SacredBookModel book,
    dynamic chapter,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          final auth =
              context.read<AuthProvider>();

          final guestAccess =
              context.read<GuestAccessProvider>();

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
              'chapterNumber':
                  chapter.chapterNumber,
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.divider,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.04,
                ),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.softBeige,
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Text(
                  '${chapter.chapterNumber}',
                  style:
                      AppTextStyles.cardTitle.copyWith(
                    color:
                        AppColors.primaryBurgundy,
                    fontSize: 21,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.title,
                      style: AppTextStyles.bodyMedium
                          .copyWith(
                        color: AppColors.darkText,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      chapter.subtitle,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          AppTextStyles.caption.copyWith(
                        color:
                            AppColors.secondaryText,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '${chapter.totalVerses} Verses Available',
                      style:
                          AppTextStyles.caption.copyWith(
                        color:
                            AppColors.primaryBurgundy,
                        fontWeight:
                            FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
                color: AppColors.secondaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOOK NOT FOUND
  // ============================================================

  Widget _bookNotFound(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.screenBackground,
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 80,
                    color:
                        AppColors.primaryBurgundy,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Book not found',
                    style:
                        AppTextStyles.pageHeading.copyWith(
                      color: AppColors.darkText,
                      fontSize: 28,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Book ID: $textId',
                    style:
                        AppTextStyles.body.copyWith(
                      color:
                          AppColors.secondaryText,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primaryBurgundy,
                      foregroundColor:
                          AppColors.white,
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 34,
                        vertical: 15,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Go Back',
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

  // ============================================================
  // SIGN IN
  // ============================================================

  void _showSignInPrompt(
    BuildContext context,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Continue your journey',
          ),
          content: const Text(
            'You have completed your free chapter. Sign in now to continue reading all sacred books and chapters.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop();
              },
              child: const Text(
                'Later',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop();

                Navigator.of(context).pushNamed(
                  AppRoutes.auth,
                );
              },
              child: const Text(
                'Sign in now',
              ),
            ),
          ],
        );
      },
    );
  }
}