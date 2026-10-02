import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../theme/app_typography.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../providers/locale_provider.dart';
import '../../../../providers/saved_provider.dart';
import 'widgets/saved_content_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final horizontalPadding = width >= 900
        ? 40.0
        : width >= 600
            ? 28.0
            : 20.0;

    final maxContentWidth = width >= 900 ? 900.0 : double.infinity;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF141714) : const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Header (Saved Title & Subtitle)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.saved,
                        style: AppTypography.pageTitle(
                          context.watch<LocaleProvider>().languageCode,
                          color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF18392C),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        context.l10n.savedWisdom,
                        style: AppTypography.compact(
                          context.watch<LocaleProvider>().languageCode,
                          color: isDark ? Colors.white60 : const Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Horizontal Category Tabs
                Consumer<SavedProvider>(
                  builder: (context, saved, _) {
                    return SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        itemCount: AppConstants.savedFilters.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 24),
                        itemBuilder: (context, index) {
                          final filter = AppConstants.savedFilters[index];
                          final isSelected = saved.activeFilter == filter;

                          return GestureDetector(
                            onTap: () => saved.setFilter(filter),
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  filter,
                                  style: AppTextStyles.getFont(
                                    context,
                                    fontSize: 14.5,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? const Color(0xFFC85A32)
                                        : (isDark ? Colors.white60 : const Color(0xFF4A4B46)),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: isSelected ? 32 : 0,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC85A32),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Saved Cards List
                Expanded(
                  child: Consumer<SavedProvider>(
                    builder: (context, saved, _) {
                      final items = saved.items;

                      if (items.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC85A32).withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.bookmark_outline_rounded,
                                    size: 32,
                                    color: Color(0xFFC85A32),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  context.l10n.noSavedWisdomYet,
                                  style: AppTextStyles.getFont(
                                    context,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B),
                                    isSerif: true,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  context.l10n.saveVersesPrompt,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.getFont(
                                    context,
                                    fontSize: 14,
                                    color: isDark ? Colors.white60 : const Color(0xFF666666),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: horizontalPadding,
                          right: horizontalPadding,
                          top: 4,
                          bottom: 24,
                        ),
                        itemCount: items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return SavedContentCard(
                            item: item,
                            index: index,
                            onRemove: () => saved.removeItem(item.id),
                            onTap: () {
                              final location = item.resolveLocation();
                              if (kDebugMode) {
                                debugPrint('[SAVED] Tapped saved item "${item.title}": bookId=${location.bookId}, chapter=${location.chapterNumber}, kanda=${location.kandaNumber}, sarga=${location.sargaNumber}, verse=${location.verseNumber}, mantra=${location.mantraNumber}');
                              }
                              Navigator.of(context).pushNamed(
                                AppRoutes.sacredTextReading,
                                arguments: location.toRouteArguments(),
                              );
                            },
                          );
                        },
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
  }
}
