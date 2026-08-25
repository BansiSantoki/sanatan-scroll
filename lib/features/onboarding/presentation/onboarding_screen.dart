import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../providers/onboarding_provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 165, 118, 37),
              Color.fromARGB(255, 233, 202, 155),
              Color.fromARGB(255, 212, 169, 109),
              Color.fromARGB(255, 192, 162, 117),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _OnboardingBanner(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    padding,
                    20,
                    padding,
                    10,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'What brings you to Sanatan Scroll?',
                        style: AppTextStyles.pageHeading.copyWith(
                          color: AppColors.darkBurgundy,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: AppDimensions.spacing12,
                      ),
                      Text(
                        'Select your spiritual aspirations to personalize your daily reading path.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.secondaryText,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: AppDimensions.spacing24,
                      ),
                      Consumer<OnboardingProvider>(
                        builder: (context, provider, child) {
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children:
                                AppConstants.interestOptions.map((interest) {
                              final isSelected = provider.isSelected(interest);

                              return _InterestChip(
                                label: interest,
                                isSelected: isSelected,
                                onTap: () {
                                  provider.toggleInterest(interest);
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  padding,
                  10,
                  padding,
                  24,
                ),
                child: Consumer<OnboardingProvider>(
                  builder: (context, provider, child) {
                    return GradientButton(
                      label: 'Continue',
                      isEnabled: provider.hasSelection,
                      onPressed: () {
                        if (!provider.hasSelection) return;

                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.beginJourney,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingBanner extends StatelessWidget {
  const _OnboardingBanner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 165, 118, 37),
                  Color.fromARGB(255, 233, 202, 155),
                  Color.fromARGB(255, 212, 169, 109),
                  Color.fromARGB(255, 192, 162, 117),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Image.asset(
            'assets/images/sanatan_page.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.mainBackground.withValues(alpha: 0.20),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  const _InterestChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [
                        Color(0xFF7A2027),
                        Color(0xFFB44A3D),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: isSelected ? null : AppColors.cardBackground,
              border: Border.all(
                color: isSelected ? Colors.transparent : AppColors.divider,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? const Color(0xFF7A2027).withValues(alpha: 0.16)
                      : Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? AppColors.white : AppColors.darkText,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: Color(0xFFFFD77A),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
