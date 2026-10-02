import 'package:flutter/material.dart';

import '../../app/theme/app_text_styles.dart';
import '../constants/app_constants.dart';
import '../localization/app_localizations.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.activeColor,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? activeColor;

  String _getLocalizedLabel(BuildContext context, int index) {
    final l10n = context.l10n;
    switch (index) {
      case 0:
        return l10n.home;
      case 1:
        return l10n.streak;
      case 2:
        return l10n.saved;
      case 3:
        return l10n.profile;
      default:
        return AppConstants.bottomNavigationItems[index].label;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = AppConstants.bottomNavigationItems;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final outerBg = isDark ? const Color(0xFF141714) : const Color(0xFFFAF7F2);
    final pillBg = isDark ? const Color(0xFF1C201C) : const Color(0xFFFAF7F2);
    final effectiveActiveColor = activeColor ?? (isDark ? const Color(0xFFE88B60) : const Color(0xFFC85A32));
    final selectedBg = isDark 
        ? effectiveActiveColor.withValues(alpha: 0.25)
        : effectiveActiveColor.withValues(alpha: 0.12);
    final borderColor = isDark ? Colors.white12 : const Color(0xFFE8DEC8).withValues(alpha: 0.8);
    final inactiveColor = isDark ? const Color(0xFFA0A6A0) : const Color(0xFF4A4B46);

    return Container(
      color: outerBg,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: SafeArea(
        top: false,
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: pillBg,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: borderColor,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = currentIndex == index;
              final label = _getLocalizedLabel(context, index);

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? selectedBg : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected ? effectiveActiveColor : inactiveColor,
                          size: 22,
                        ),
                        const SizedBox(height: 3),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            label,
                            maxLines: 1,
                            style: AppTextStyles.getFont(
                              context,
                              fontSize: 11.5,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected ? effectiveActiveColor : inactiveColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
