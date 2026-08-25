import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../providers/explore_provider.dart';
import 'widgets/category_chip.dart';
import 'widgets/sacred_text_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Explore Wisdom', style: AppTextStyles.pageHeading),
                    const SizedBox(height: 4),
                    Text(
                      'Discover timeless teachings',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: AppDimensions.spacing20),
                    Consumer<ExploreProvider>(
                      builder: (context, explore, _) {
                        return CustomSearchBar(
                          controller: _searchController,
                          hintText: 'Search wisdom, topics, scriptures...',
                          onChanged: explore.setSearchQuery,
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    Consumer<ExploreProvider>(
                      builder: (context, explore, _) {
                        return SizedBox(
                          height: 36,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: AppConstants.exploreCategories
                                .map(
                                  (cat) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: CategoryChip(
                                      label: cat,
                                      isSelected:
                                          explore.selectedCategory == cat,
                                      onTap: () => explore.setCategory(cat),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.spacing20),
                    Consumer<ExploreProvider>(
                      builder: (context, explore, _) {
                        final featured = explore.featuredText;
                        if (featured == null) return const SizedBox.shrink();
                        return _FeaturedCard(
                          title: featured.title,
                          subtitle: 'Timeless wisdom for modern life',
                          gradientIndex: featured.gradientIndex,
                          emoji: featured.iconEmoji,
                          onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.sacredTextDetail,
                            arguments: featured.id,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.spacing20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sacred Texts',
                            style: AppTextStyles.sectionHeading),
                        TextButton(
                          onPressed: () => Navigator.of(context).pushNamed(
                            AppRoutes.allSacredTexts,
                          ),
                          child: Text(
                            'See All',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primaryBurgundy,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Consumer<ExploreProvider>(
              builder: (context, explore, _) {
                final texts = explore.filteredTexts;
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final text = texts[index];
                        return SacredTextCard(
                          text: text,
                          onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.sacredTextDetail,
                            arguments: text.id,
                          ),
                        );
                      },
                      childCount: texts.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.title,
    required this.subtitle,
    required this.gradientIndex,
    required this.emoji,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final int gradientIndex;
  final String emoji;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.sacredCard(gradientIndex),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 20,
              top: 20,
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: 80,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.sectionHeading.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white.withValues(alpha: 0.8),
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
}
