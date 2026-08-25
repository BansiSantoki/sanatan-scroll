import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../data/mock_wisdom_data.dart';
import '../../../../providers/daily_progress_provider.dart';

class DailyReadingScreen extends StatelessWidget {
  const DailyReadingScreen({super.key});

  static const List<Color> _backgroundColors = [
    Color.fromARGB(255, 165, 118, 37),
    Color.fromARGB(255, 233, 202, 155),
    Color.fromARGB(255, 212, 169, 109),
    Color.fromARGB(255, 192, 162, 117),
  ];

  @override
  Widget build(BuildContext context) {
    final wisdom = MockWisdomData.dailyWisdom;
    final width = MediaQuery.sizeOf(context).width;

    final horizontalPadding = width >= 900
        ? 40.0
        : width >= 600
            ? 28.0
            : 16.0;

    final maxContentWidth = width >= 900 ? 850.0 : double.infinity;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: 'Daily Flow',
        showBack: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_horiz_rounded,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _backgroundColors,
            stops: [0.0, 0.35, 0.68, 1.0],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxContentWidth,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  20,
                  horizontalPadding,
                  32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top banner image (replace asset with your image)
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusLarge),
                      child: Container(
                        width: double.infinity,
                        height: 260,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/bhagavat_gita_book.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.45),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Bhagavad Gita',
                            style: AppTextStyles.body.copyWith(
                              fontSize: 28,
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing24),
                    const _SectionLabel('MORNING WISDOM'),
                    const SizedBox(
                      height: AppDimensions.spacing12,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(
                        AppDimensions.cardPadding,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.84,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLarge,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: 0.75,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (wisdom.sanskrit != null)
                            Text(
                              wisdom.sanskrit!,
                              style: AppTextStyles.sanskrit,
                            ),
                          if (wisdom.sanskrit != null)
                            const SizedBox(
                              height: AppDimensions.spacing12,
                            ),
                          Text(
                            wisdom.quote,
                            style: AppTextStyles.quote.copyWith(
                              fontSize: width >= 700 ? 22 : 18,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${wisdom.source} — ${wisdom.chapter}, ${wisdom.verse}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: AppDimensions.spacing32,
                    ),
                    const _SectionLabel('REFLECTION'),
                    const SizedBox(
                      height: AppDimensions.spacing12,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(
                        AppDimensions.cardPadding,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.72,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLarge,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: 0.70,
                          ),
                        ),
                      ),
                      child: Text(
                        MockWisdomData.morningWisdomReflection,
                        style: AppTextStyles.body.copyWith(
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppDimensions.spacing32,
                    ),
                    const _SectionLabel(
                      "TODAY'S PRACTICE",
                    ),
                    const SizedBox(
                      height: AppDimensions.spacing12,
                    ),
                    Consumer<DailyProgressProvider>(
                      builder: (
                        context,
                        progress,
                        _,
                      ) {
                        return Column(
                          children: progress.activities.map(
                            (activity) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusMedium,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      progress.toggleActivity(
                                        activity.id,
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusMedium,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(
                                        16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.80,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.radiusMedium,
                                        ),
                                        border: Border.all(
                                          color: activity.isCompleted
                                              ? AppColors.primaryBurgundy
                                                  .withValues(
                                                  alpha: 0.40,
                                                )
                                              : Colors.white.withValues(
                                                  alpha: 0.70,
                                                ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 220,
                                            ),
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: activity.isCompleted
                                                  ? AppColors.primaryBurgundy
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: activity.isCompleted
                                                    ? AppColors.primaryBurgundy
                                                    : AppColors.lightSand,
                                                width: 2,
                                              ),
                                            ),
                                            child: activity.isCompleted
                                                ? const Icon(
                                                    Icons.check,
                                                    size: 15,
                                                    color: AppColors.white,
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(
                                            width: 14,
                                          ),
                                          Expanded(
                                            child: Text(
                                              activity.title,
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                decoration: activity.isCompleted
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                                color: activity.isCompleted
                                                    ? AppColors.secondaryText
                                                    : AppColors.darkText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        );
                      },
                    ),
                    const SizedBox(
                      height: AppDimensions.spacing16,
                    ),
                    Consumer<DailyProgressProvider>(
                      builder: (
                        context,
                        progress,
                        _,
                      ) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Daily Progress',
                                  style: AppTextStyles.bodyMedium,
                                ),
                                Text(
                                  '${progress.completedCount} of ${progress.totalCount} completed',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primaryBurgundy,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progress.progress,
                                minHeight: 8,
                                backgroundColor: AppColors.softBeige,
                                color: AppColors.primaryBurgundy,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.label.copyWith(
        color: AppColors.darkBurgundy,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
