import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/tts_audio_button.dart';

class DailyFlowCard extends StatelessWidget {
  const DailyFlowCard({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(
        AppDimensions.radiusLarge,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppDimensions.radiusLarge,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(
              AppDimensions.radiusLarge,
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.80),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Continue Your Journey
              Text(
                'Continue Your Journey',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 10),

              /// Bhagavad Gita
              Text(
                'Bhagavad Gita',
                style: AppTextStyles.cardTitle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),

              const SizedBox(height: 5),

              /// Chapter
              Text(
                'Chapter 3: Karma Yoga • Verse 12',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TtsAudioButton(
                    text:
                        'Continue Your Journey. Bhagavad Gita. Chapter 3: Karma Yoga, Verse 12.',
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.60,
                  minHeight: 6,
                  backgroundColor: AppColors.softBeige,
                  color: const Color.fromARGB(
                    255,
                    165,
                    118,
                    37,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
