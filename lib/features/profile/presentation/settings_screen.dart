import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showLanguageDialog(BuildContext context) {
    final localeProvider = context.read<LocaleProvider>();
    final currentCode = localeProvider.languageCode;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final options = [
          {'code': 'en', 'label': 'English'},
          {'code': 'hi', 'label': 'हिंदी'},
          {'code': 'gu', 'label': 'ગુજરાતી'},
        ];

        return AlertDialog(
          backgroundColor: const Color(0xFFFFFDF9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            dialogContext.l10n.selectLanguage,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1B1B1B),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((opt) {
              final code = opt['code']!;
              final label = opt['label']!;
              final isSelected = currentCode == code;

              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: isSelected ? const Color(0xFFFDECDA) : Colors.transparent,
                title: Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: const Color(0xFF23180C),
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle_rounded, color: Color(0xFFC85A32))
                    : null,
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  localeProvider.setLanguageCode(code);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.darkText,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.settings, style: AppTextStyles.pageHeading),
              const SizedBox(height: 16),
              Card(
                color: const Color(0xFFFFFDF9),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: const Color(0xFFE8DEC8).withValues(alpha: 0.8),
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.language_rounded, color: Color(0xFFC85A32)),
                  title: Text(
                    l10n.language,
                    style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    localeProvider.currentLanguageName,
                    style: GoogleFonts.manrope(color: Colors.black54),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showLanguageDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
