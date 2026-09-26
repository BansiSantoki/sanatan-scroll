import 'package:flutter/material.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

class ReaderHeader extends StatelessWidget {
  const ReaderHeader({
    super.key,
    required this.subtitle,
    required this.isSaved,
    required this.onBack,
    required this.onToggleSave,
    required this.onShare,
    required this.languageCode,
  });

  final String subtitle;
  final bool isSaved;
  final VoidCallback onBack;
  final VoidCallback onToggleSave;
  final VoidCallback onShare;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Locale(languageCode);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentColor = isDark ? const Color(0xFFF0F2F0) : const Color(0xFF18392C);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // Top Header Row (Back Arrow + [ Bookmark ] [ Share ])
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onBack,
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: contentColor,
              ),
              splashRadius: 22,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onShare,
                  tooltip: l10n.share,
                  icon: Icon(
                    Icons.ios_share_outlined,
                    color: contentColor,
                    size: 24,
                  ),
                  splashRadius: 22,
                ),
                IconButton(
                  onPressed: onToggleSave,
                  tooltip: isSaved ? l10n.savedAction : l10n.save,
                  icon: Icon(
                    isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    color: contentColor,
                    size: 25,
                  ),
                  splashRadius: 22,
                ),
              ],
            ),
          ],
        ),

        // Subtitle under Header: e.g. "Bhagavad Gita · Chapter 3"
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 12, right: 12),
          child: Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.getFontForLocale(
              locale,
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: contentColor,
              isSerif: true,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
