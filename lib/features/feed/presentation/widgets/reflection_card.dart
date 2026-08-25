import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../data/mock_wisdom_data.dart';

class ReflectionCard extends StatefulWidget {
  const ReflectionCard({super.key});

  @override
  State<ReflectionCard> createState() => _ReflectionCardState();
}

class _ReflectionCardState extends State<ReflectionCard> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.peachHighlight.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: AppColors.peachHighlight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Take a Moment', style: AppTextStyles.cardTitle),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            MockWisdomData.reflectionQuestion,
            style: AppTextStyles.body.copyWith(
              color: AppColors.primaryBurgundy,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing12),
          TextField(
            controller: _controller,
            maxLines: 3,
            style: AppTextStyles.body.copyWith(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Write your reflection...',
              hintStyle: AppTextStyles.caption,
              filled: true,
              fillColor: AppColors.cardBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ],
      ),
    );
  }
}
