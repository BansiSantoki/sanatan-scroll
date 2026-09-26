import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../providers/onboarding_provider.dart';

class OnboardingOption {
  final String title;
  final Color defaultBgColor;
  final Color selectedBgColor;
  final Color defaultTextColor;
  final Color selectedTextColor;
  final Color? borderColor;
  final IconData iconData;

  const OnboardingOption({
    required this.title,
    required this.defaultBgColor,
    required this.selectedBgColor,
    required this.defaultTextColor,
    required this.selectedTextColor,
    this.borderColor,
    required this.iconData,
  });
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  List<OnboardingOption> _getOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      OnboardingOption(
        title: l10n.understandScriptures,
        defaultBgColor: const Color(0xFFFBC07E),
        selectedBgColor: const Color(0xFFF9A852),
        defaultTextColor: const Color(0xFF141814),
        selectedTextColor: const Color(0xFF141814),
        iconData: Icons.menu_book_outlined,
      ),
      OnboardingOption(
        title: l10n.learnAboutRoots,
        defaultBgColor: const Color(0xFF858D5C),
        selectedBgColor: const Color(0xFF747C4B),
        defaultTextColor: Colors.white,
        selectedTextColor: Colors.white,
        iconData: Icons.home_outlined,
      ),
      OnboardingOption(
        title: l10n.dealWithOverthinking,
        defaultBgColor: const Color(0xFFFDF3E9),
        selectedBgColor: const Color(0xFFFDF3E9),
        defaultTextColor: const Color(0xFF141814),
        selectedTextColor: const Color(0xFF141814),
        borderColor: const Color(0xFFD6CDBF),
        iconData: Icons.psychology_outlined,
      ),
      OnboardingOption(
        title: l10n.buildSpiritualHabit,
        defaultBgColor: const Color(0xFFE0DCB7),
        selectedBgColor: const Color(0xFFD0CBA3),
        defaultTextColor: const Color(0xFF141814),
        selectedTextColor: const Color(0xFF141814),
        iconData: Icons.calendar_today_outlined,
      ),
      OnboardingOption(
        title: l10n.findGreaterPeace,
        defaultBgColor: const Color(0xFFFDD3A3),
        selectedBgColor: const Color(0xFFFBBF83),
        defaultTextColor: const Color(0xFF141814),
        selectedTextColor: const Color(0xFF141814),
        iconData: Icons.waves,
      ),
      OnboardingOption(
        title: l10n.findPurpose,
        defaultBgColor: const Color(0xFFFDF3E9),
        selectedBgColor: const Color(0xFFFDF3E9),
        defaultTextColor: const Color(0xFF141814),
        selectedTextColor: const Color(0xFF141814),
        borderColor: const Color(0xFFD6CDBF),
        iconData: Icons.explore_outlined,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final l10n = AppLocalizations.of(context);
    final options = _getOptions(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF0E4),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth < 360 ? 20.0 : 26.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Centered Sanatan Scroll Brand Logo (Increased size)
                    Center(
                      child: Image.asset(
                        'assets/images/sanatan_logo.png',
                        width: screenWidth < 360 ? 70 : 88,
                        height: screenWidth < 360 ? 70 : 88,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(height: 80);
                        },
                      ),
                    ),

                    SizedBox(height: screenHeight < 650 ? 14 : 22),

                    // Title: "What brings you to\nSanatan Scroll?"
                    Text(
                      l10n.whatBringsYouToSanatanScroll,
                      style: AppTextStyles.getFont(
                        context,
                        fontSize: screenWidth < 360 ? 30 : 36,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF141814),
                        height: 1.15,
                        isSerif: true,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle: "Select your spiritual aspirations..."
                    Text(
                      l10n.selectAspirationsSubtitle,
                      style: AppTextStyles.getFont(
                        context,
                        fontSize: screenWidth < 360 ? 14 : 15.5,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF2D352E),
                        height: 1.35,
                      ),
                    ),

                    SizedBox(height: screenHeight < 650 ? 20 : 26),

                    // 6 Interactive Selection Cards
                    Consumer<OnboardingProvider>(
                      builder: (context, provider, _) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: options.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final option = options[index];
                            final isSelected =
                                provider.isSelected(option.title);

                            return _OptionCardWidget(
                              option: option,
                              isSelected: isSelected,
                              onTap: () {
                                provider.toggleInterest(option.title);
                              },
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom "Continue ->" Pill Button
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth < 360 ? 20.0 : 26.0,
                8.0,
                screenWidth < 360 ? 20.0 : 26.0,
                20.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.main,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF212121),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.continueButton,
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCardWidget extends StatelessWidget {
  final OnboardingOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCardWidget({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isSelected ? option.selectedBgColor : option.defaultBgColor;

    final textColor =
        isSelected ? option.selectedTextColor : option.defaultTextColor;

    final borderColor = isSelected
        ? (option.borderColor ?? Colors.transparent)
        : (option.borderColor ?? Colors.transparent);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderColor,
          width: option.borderColor != null ? 1.2 : 0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 18.0,
            ),
            child: Row(
              children: [
                // Icon
                Icon(
                  option.iconData,
                  size: 26,
                  color: textColor,
                ),

                const SizedBox(width: 16),

                // Card Title
                Expanded(
                  child: Text(
                    option.title,
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),

                // Selected Checkmark Badge (white circle with checkmark)
                if (isSelected)
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(left: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 20,
                      color: Color(0xFF141814),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
