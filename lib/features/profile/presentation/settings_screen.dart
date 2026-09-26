import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../providers/locale_provider.dart';
import '../../../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showLanguageDialog(BuildContext context) {
    final localeProvider = context.read<LocaleProvider>();
    final currentCode = localeProvider.languageCode;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final l10n = dialogContext.l10n;
        final options = [
          {'code': 'en', 'label': l10n.english},
          {'code': 'hi', 'label': l10n.hindi},
          {'code': 'gu', 'label': l10n.gujarati},
        ];

        return AlertDialog(
          backgroundColor: Theme.of(dialogContext).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            dialogContext.l10n.selectLanguage,
            style: AppTextStyles.getFont(
              dialogContext,
              fontSize: 22,
              fontWeight: FontWeight.w700,
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
                tileColor: isSelected
                    ? const Color(0xFFC85A32).withValues(alpha: 0.15)
                    : Colors.transparent,
                title: Text(
                  label,
                  style: AppTextStyles.getFont(
                    dialogContext,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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

  void _showThemeDialog(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final currentMode = themeProvider.themeMode;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final l10n = dialogContext.l10n;
        final options = [
          {'mode': ThemeMode.light, 'label': l10n.lightMode, 'icon': Icons.light_mode_outlined},
          {'mode': ThemeMode.dark, 'label': l10n.darkMode, 'icon': Icons.dark_mode_outlined},
          {'mode': ThemeMode.system, 'label': l10n.systemDefault, 'icon': Icons.settings_brightness_outlined},
        ];

        return AlertDialog(
          backgroundColor: Theme.of(dialogContext).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            l10n.selectTheme,
            style: AppTextStyles.getFont(
              dialogContext,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((opt) {
              final mode = opt['mode'] as ThemeMode;
              final label = opt['label'] as String;
              final icon = opt['icon'] as IconData;
              final isSelected = currentMode == mode;

              return ListTile(
                leading: Icon(icon, color: isSelected ? const Color(0xFFC85A32) : null),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: isSelected
                    ? const Color(0xFFC85A32).withValues(alpha: 0.15)
                    : Colors.transparent,
                title: Text(
                  label,
                  style: AppTextStyles.getFont(
                    dialogContext,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle_rounded, color: Color(0xFFC85A32))
                    : null,
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  themeProvider.setThemeMode(mode);
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
    final themeProvider = context.watch<ThemeProvider>();

    String currentThemeLabel;
    if (themeProvider.themeMode == ThemeMode.dark) {
      currentThemeLabel = l10n.darkMode;
    } else if (themeProvider.themeMode == ThemeMode.system) {
      currentThemeLabel = l10n.systemDefault;
    } else {
      currentThemeLabel = l10n.lightMode;
    }

    final cardColor = Theme.of(context).cardTheme.color ?? const Color(0xFFFFFDF9);
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white12
        : const Color(0xFFE8DEC8).withValues(alpha: 0.8);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: AppTextStyles.getFont(context, fontSize: 18),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settings,
                style: AppTextStyles.getFont(
                  context,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),

              // Language Card
              Card(
                color: cardColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: borderColor),
                ),
                child: ListTile(
                  leading: const Icon(Icons.language_rounded, color: Color(0xFFC85A32)),
                  title: Text(
                    l10n.language,
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    localeProvider.currentLanguageName,
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showLanguageDialog(context),
                ),
              ),

              const SizedBox(height: 12),

              // Theme Mode Card (Dark / Light Mode)
              Card(
                color: cardColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: borderColor),
                ),
                child: ListTile(
                  leading: Icon(
                    themeProvider.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: const Color(0xFFC85A32),
                  ),
                  title: Text(
                    l10n.themeMode,
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    currentThemeLabel,
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: themeProvider.isDark,
                        activeThumbColor: const Color(0xFFC85A32),
                        onChanged: (val) {
                          themeProvider.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                        },
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                  onTap: () => _showThemeDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
