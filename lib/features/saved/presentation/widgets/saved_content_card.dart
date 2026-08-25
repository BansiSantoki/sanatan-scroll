import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/services/share_service.dart';
import '../../../../models/saved_item_model.dart';

class SavedContentCard extends StatelessWidget {
  const SavedContentCard({
    super.key,
    required this.item,
    required this.onRemove,
  });

  final SavedItemModel item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.peachHighlight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.typeLabel.toUpperCase(),
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.warmOrange,
                    fontSize: 9,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onRemove,
                child: const Icon(
                  Icons.bookmark_rounded,
                  color: AppColors.primaryBurgundy,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing12),
          Text(item.title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 6),
          Text(
            item.content,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              color: AppColors.secondaryText,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Row(
            children: [
              Text(item.source, style: AppTextStyles.caption),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.share_outlined, size: 18),
                color: AppColors.secondaryText,
                tooltip: 'Share ${item.typeLabel.toLowerCase()}',
                onPressed: () => ShareService.showOptions(
                  context: context,
                  title: item.title,
                  text:
                      '${item.title}\n\n${item.content}\n\n${item.source}\n\nSanatan Scroll',
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
