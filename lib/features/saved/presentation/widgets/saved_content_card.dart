import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../theme/app_typography.dart';
import '../../../../core/services/share_service.dart';
import '../../../../models/saved_item_model.dart';
import '../../../../providers/locale_provider.dart';

class SavedContentCard extends StatelessWidget {
  const SavedContentCard({
    super.key,
    required this.item,
    required this.onRemove,
    this.onTap,
    this.index = 0,
  });

  final SavedItemModel item;
  final VoidCallback onRemove;
  final VoidCallback? onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardStyle = _getCardStyle(index, item.title, item.source, isDark);
    final langCode = context.watch<LocaleProvider>().languageCode;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: cardStyle.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white12 : const Color(0xFFEAE2D2),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 16, 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTypography.cardTitle(
                        langCode,
                        color: cardStyle.titleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.content,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.body(
                        langCode,
                        color: cardStyle.textColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      item.source,
                      style: AppTypography.compact(
                        langCode,
                        fontWeight: FontWeight.w500,
                        color: cardStyle.sourceColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Right Side Actions (Bookmark Top & Share Bottom)
              SizedBox(
                height: 110,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: onRemove,
                      behavior: HitTestBehavior.opaque,
                      child: Icon(
                        Icons.bookmark_rounded,
                        color: cardStyle.bookmarkColor,
                        size: 24,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => ShareService.share(
                        title: item.title,
                        text:
                            'Sanatan Scroll\n\n${item.title}\n\n${item.content}\n\nReference: ${item.verseReference ?? item.source}',
                      ),
                      behavior: HitTestBehavior.opaque,
                      child: Icon(
                        Icons.share_outlined,
                        color: isDark ? Colors.white60 : const Color(0xFF5A5A5A),
                        size: 19,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _CardStyleConfig _getCardStyle(int index, String title, String source, bool isDark) {
    final titleLower = title.toLowerCase();

    if (isDark) {
      if (titleLower.contains('ramayana') || index % 2 == 1) {
        return _CardStyleConfig(
          gradientColors: const [Color(0xFF1F281B), Color(0xFF192016)],
          titleColor: const Color(0xFFE6E8E6),
          textColor: const Color(0xFFD0D4D0),
          bookmarkColor: const Color(0xFFA5B888),
          sourceColor: const Color(0xFFA5B888),
        );
      }
      return _CardStyleConfig(
        gradientColors: const [Color(0xFF2A2017), Color(0xFF221A12)],
        titleColor: const Color(0xFFE88B60),
        textColor: const Color(0xFFE6E8E6),
        bookmarkColor: const Color(0xFFE88B60),
        sourceColor: const Color(0xFFC89A75),
      );
    }

    if (titleLower.contains('ramayana') || index % 2 == 1) {
      return _CardStyleConfig(
        gradientColors: const [Color(0xFFEFF2E4), Color(0xFFE5EAD4)],
        titleColor: const Color(0xFF18392C),
        textColor: const Color(0xFF233B31),
        bookmarkColor: const Color(0xFF495736),
        sourceColor: const Color(0xFF495736),
      );
    }

    return _CardStyleConfig(
      gradientColors: const [Color(0xFFFFF7EF), Color(0xFFFDE8D4)],
      titleColor: const Color(0xFFC85A32),
      textColor: const Color(0xFF3B2A1F),
      bookmarkColor: const Color(0xFFC85A32),
      sourceColor: const Color(0xFF8C6647),
    );
  }
}

class _CardStyleConfig {
  final List<Color> gradientColors;
  final Color titleColor;
  final Color textColor;
  final Color bookmarkColor;
  final Color sourceColor;

  const _CardStyleConfig({
    required this.gradientColors,
    required this.titleColor,
    required this.textColor,
    required this.bookmarkColor,
    required this.sourceColor,
  });
}
