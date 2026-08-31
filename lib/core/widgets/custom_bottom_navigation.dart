import 'package:flutter/material.dart';

import '../../app/theme/app_text_styles.dart';
import '../constants/app_constants.dart';
import '../localization/app_localizations.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

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
        return l10n.feed;
      case 4:
        return l10n.profile;
      default:
        return AppConstants.bottomNavigationItems[index].label;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = AppConstants.bottomNavigationItems;

    return Container(
      color: const Color(0xFFFAF5ED),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: SafeArea(
        top: false,
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFDF9),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: const Color(0xFFE8DEC8).withValues(alpha: 0.8),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
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
              final activeColor = const Color(0xFFC85A32);
              final inactiveColor = const Color(0xFF4A4B46);
              final label = _getLocalizedLabel(context, index);

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFDECDA)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected ? activeColor : inactiveColor,
                          size: 22,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          label,
                          style: AppTextStyles.getFont(
                            context,
                            fontSize: 11.5,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected ? activeColor : inactiveColor,
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
