
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../models/saved_item_model.dart';
import '../../../../providers/saved_provider.dart';
import '../../../../data/mock_sacred_texts.dart';

class SacredTextDetailScreen extends StatelessWidget {
  const SacredTextDetailScreen({
    super.key,
    required this.textId,
  });

  final String textId;

  @override
  Widget build(BuildContext context) {
    final text =
        MockSacredTexts.findById(textId) ?? MockSacredTexts.all.first;

    return Scaffold(
      // FIX:
      // AppColors.background તમારા project માં defined નથી.
      // તેથી existing AppColors.cardBackground use કર્યું છે.
      backgroundColor: AppColors.cardBackground,

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // =====================================================
          // HERO SECTION
          // =====================================================
          SliverToBoxAdapter(
            child: _HeroSection(text: text),
          ),

          // =====================================================
          // CONTENT
          // =====================================================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(
                AppDimensions.horizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =====================================================
                  // SACRED SCRIPTURE LABEL
                  // =====================================================
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.peachHighlight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'SACRED SCRIPTURE',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.warmOrange,
                        fontSize: 10,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: AppDimensions.spacing12,
                  ),

                  // =====================================================
                  // TITLE
                  // =====================================================
                  Text(
                    text.title,
                    style: AppTextStyles.pageHeading,
                  ),

                  const SizedBox(height: 4),

                  // =====================================================
                  // SUBTITLE
                  // =====================================================
                  Text(
                    text.subtitle,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),

                  const SizedBox(
                    height: AppDimensions.spacing24,
                  ),

                  // =====================================================
                  // STATS
                  // =====================================================
                  _StatsRow(
                    chapters: text.chapters,
                    verses: text.verses,
                    pages: text.pages,
                  ),

                  const SizedBox(
                    height: AppDimensions.spacing32,
                  ),

                  // =====================================================
                  // ABOUT THIS TEXT
                  // =====================================================
                  Text(
                    'About this text',
                    style: AppTextStyles.sectionHeading,
                  ),

                  const SizedBox(
                    height: AppDimensions.spacing12,
                  ),

                  Text(
                    text.description,
                    style: AppTextStyles.body.copyWith(
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(
                    height: AppDimensions.spacing32,
                  ),

                  // =====================================================
                  // KEY TEACHINGS
                  // =====================================================
                  Text(
                    'Key Teachings',
                    style: AppTextStyles.sectionHeading,
                  ),

                  const SizedBox(
                    height: AppDimensions.spacing12,
                  ),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: text.keyTeachings.map((teaching) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softBeige,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.divider,
                          ),
                        ),
                        child: Text(
                          teaching,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryBurgundy,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(
                    height: AppDimensions.spacing40,
                  ),

                  // =====================================================
                  // START READING BUTTON
                  // =====================================================
                  GradientButton(
                    label: 'Start Reading',
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.sacredChapterList,
                        arguments: textId,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),

                  const SizedBox(
                    height: AppDimensions.spacing32,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// HERO SECTION
// =====================================================

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.text,
  });

  final dynamic text;

  // =====================================================
  // HERO IMAGES
  // =====================================================
  //
  // Bhagavad Gita:
  // assets/images/bhagavat_gita_book.png
  //
  // Ramayana:
  // assets/images/ramayan_home.png
  //
  // Upanishads:
  // assets/images/upanishads.png
  // =====================================================

  static const Map<String, String> _heroImages = {
    'bhagavad_gita': 'assets/images/bhagavat_gita_book.png',
    'ramayana': 'assets/images/ramayan_home.png',
    'upanishads': 'assets/images/upanishads.png',
  };

  @override
  Widget build(BuildContext context) {
    final savedProvider = context.watch<SavedProvider>();

    final isSaved = savedProvider.isSaved(text.id);

    final topPadding = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: 320 + topPadding,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // =====================================================
          // HERO IMAGE
          // =====================================================
          Padding(
            padding: EdgeInsets.only(
              top: topPadding,
            ),
            child: _buildHeroBackground(),
          ),

          // =====================================================
          // DARK OVERLAY
          // =====================================================
          Padding(
            padding: EdgeInsets.only(
              top: topPadding,
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.heroOverlay,
              ),
            ),
          ),

          // =====================================================
          // BACK + BOOKMARK BUTTON
          // =====================================================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // BACK
                  _CircleButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),

                  // BOOKMARK
                  _CircleButton(
                    icon: isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    onTap: () {
                      savedProvider.toggleItem(
                        SavedItemModel(
                          id: text.id,
                          type: SavedItemType.reading,
                          title: text.title,
                          content: text.description,
                          source: '${text.chapters} chapters',
                          savedAt: DateTime.now(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // =====================================================
          // HERO TITLE
          // =====================================================
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Text(
              text.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.pageHeading.copyWith(
                color: AppColors.white,
                fontSize: 34,
                fontWeight: FontWeight.w700,
                shadows: const [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // HERO BACKGROUND IMAGE
  // =====================================================

  Widget _buildHeroBackground() {
    final String? imagePath =
        _heroImages[text.id as String? ?? ''];

    // =====================================================
    // NO IMAGE FOUND
    // =====================================================

    if (imagePath == null) {
      return Container(
        decoration: BoxDecoration(
          gradient: AppGradients.sacredCard(
            text.gradientIndex,
          ),
        ),
        child: Center(
          child: Text(
            text.iconEmoji,
            style: const TextStyle(
              fontSize: 100,
            ),
          ),
        ),
      );
    }

    // =====================================================
    // ACTUAL IMAGE
    // =====================================================

    return Image.asset(
      imagePath,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,

      // =====================================================
      // IMAGE ERROR FALLBACK
      // =====================================================

      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return Container(
          decoration: BoxDecoration(
            gradient: AppGradients.sacredCard(
              text.gradientIndex,
            ),
          ),
          child: Center(
            child: Text(
              text.iconEmoji,
              style: const TextStyle(
                fontSize: 100,
              ),
            ),
          ),
        );
      },
    );
  }
}

// =====================================================
// CIRCLE BUTTON
// =====================================================

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(
              alpha: 0.35,
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}

// =====================================================
// STATS ROW
// =====================================================

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.chapters,
    required this.verses,
    required this.pages,
  });

  final int chapters;
  final int verses;
  final int pages;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppDimensions.spacing20,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(
          AppDimensions.radiusLarge,
        ),
        border: Border.all(
          color: AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          // CHAPTERS
          _StatItem(
            label: 'CHAPTERS',
            value: '$chapters',
          ),

          _divider(),

          // VERSES
          _StatItem(
            label: 'VERSES',
            value: verses > 0 ? '$verses' : '—',
          ),

          _divider(),

          // PAGES
          _StatItem(
            label: 'PAGES',
            value: '$pages',
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.divider,
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
    );
  }
}

// =====================================================
// STAT ITEM
// =====================================================

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              fontSize: 9,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            value,
            style: AppTextStyles.cardTitle.copyWith(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

