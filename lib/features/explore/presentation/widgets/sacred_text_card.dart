import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../models/sacred_text_model.dart';

class SacredTextCard extends StatelessWidget {
  const SacredTextCard({
    super.key,
    required this.text,
    required this.onTap,
    this.showBookmark = true,
  });

  final SacredTextModel text;
  final VoidCallback onTap;
  final bool showBookmark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppGradients.sacredCard(text.gradientIndex),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusLarge),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Text(
                      text.iconEmoji,
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                  ),
                  if (showBookmark)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withValues(alpha: 0.2),
                        ),
                        child: const Icon(
                          Icons.bookmark_outline_rounded,
                          size: 16,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  Center(
                    child: Text(
                      text.iconEmoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text.title,
            style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            text.subtitle,
            style: AppTextStyles.caption.copyWith(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
