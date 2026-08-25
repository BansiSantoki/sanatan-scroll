import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/services/share_service.dart';
import '../../../../core/widgets/tts_audio_button.dart';
import '../../../../models/saved_item_model.dart';
import '../../../../models/wisdom_model.dart';
import '../../../../providers/saved_provider.dart';

class WisdomCard extends StatelessWidget {
  const WisdomCard({
    super.key,
    required this.wisdom,
  });

  final WisdomModel wisdom;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final quoteSize = width >= 700 ? 20.0 : 17.0;

    final savedProvider = context.watch<SavedProvider>();
    final isSaved = savedProvider.isSaved(wisdom.id);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppDimensions.cardPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: AppColors.peachHighlight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'DAILY WISDOM',
              style: AppTextStyles.label.copyWith(
                color: AppColors.warmOrange,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(
            height: AppDimensions.spacing16,
          ),
          if (wisdom.sanskrit != null) ...[
            Text(
              wisdom.sanskrit!,
              style: AppTextStyles.sanskrit,
            ),
            const SizedBox(
              height: AppDimensions.spacing12,
            ),
          ],
          Text(
            wisdom.quote,
            style: AppTextStyles.quote.copyWith(
              fontSize: quoteSize,
            ),
          ),
          const SizedBox(
            height: AppDimensions.spacing16,
          ),
          Row(
            children: [
              Container(
                width: 3,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.warmOrange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wisdom.source,
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      '${wisdom.chapter} · ${wisdom.verse}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (wisdom.sageAdvice != null) ...[
            const SizedBox(
              height: AppDimensions.spacing16,
            ),
            Text(
              'SAGE ADVICE',
              style: AppTextStyles.label.copyWith(
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              wisdom.sageAdvice!,
              style: AppTextStyles.body.copyWith(
                fontSize: width >= 600 ? 14 : 13,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(
            height: AppDimensions.spacing12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ActionIcon(
                icon: isSaved
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_outline_rounded,
                tooltip: isSaved ? 'Remove bookmark' : 'Save wisdom',
                onTap: () => savedProvider.toggleItem(
                  SavedItemModel(
                    id: wisdom.id,
                    type: SavedItemType.reflection,
                    title: wisdom.source,
                    content: wisdom.quote,
                    source: '${wisdom.chapter} · ${wisdom.verse}',
                    savedAt: DateTime.now(),
                  ),
                ),
              ),
              SizedBox(width: 16),
              _ActionIcon(
                icon: Icons.share_outlined,
                tooltip: 'Share wisdom',
                onTap: () => ShareService.showOptions(
                  context: context,
                  title: wisdom.source,
                  text:
                      '${wisdom.source} · ${wisdom.chapter} · ${wisdom.verse}\n\n${wisdom.sanskrit ?? ''}\n\n${wisdom.quote}\n\nSanatan Scroll',
                ),
              ),
              SizedBox(width: 16),
              TtsAudioButton(
                text: [
                  wisdom.sanskrit,
                  wisdom.quote,
                  wisdom.source,
                  '${wisdom.chapter} ${wisdom.verse}',
                  wisdom.sageAdvice,
                ].whereType<String>().join('. '),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      color: const Color.fromARGB(255, 109, 99, 99),
      tooltip: tooltip,
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
