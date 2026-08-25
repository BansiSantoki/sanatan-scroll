import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../providers/saved_provider.dart';
import 'widgets/saved_content_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saved', style: AppTextStyles.pageHeading),
                  const SizedBox(height: 4),
                  Text(
                    'Your personal collection of wisdom',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Consumer<SavedProvider>(
              builder: (context, saved, _) {
                return SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: AppConstants.savedFilters.map((filter) {
                      final isSelected = saved.activeFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () => saved.setFilter(filter),
                          child: Column(
                            children: [
                              Text(
                                filter,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isSelected
                                      ? AppColors.primaryBurgundy
                                      : AppColors.secondaryText,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: isSelected ? 24 : 0,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBurgundy,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Expanded(
              child: Consumer<SavedProvider>(
                builder: (context, saved, _) {
                  final items = saved.items;
                  if (items.isEmpty) {
                    return EmptyStateWidget(
                      title: 'No saved items yet',
                      subtitle:
                          'Bookmark verses and readings to see them here.',
                      icon: Icons.bookmark_outline_rounded,
                    );
                  }
                  return ListView.separated(
                    padding:
                        const EdgeInsets.all(AppDimensions.horizontalPadding),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return SavedContentCard(
                        item: item,
                        onRemove: () => saved.removeItem(item.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
