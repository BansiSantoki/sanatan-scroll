import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../core/widgets/loading_state_widget.dart';
import '../../../models/app_settings_admin_model.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/books_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _featuredBookId;
  late bool _maintenanceMode;
  late bool _dailyReadingEnabled;
  late List<String> _languages;
  bool _initialized = false;

  void _initSettings(AppSettingsAdminModel settings) {
    if (!_initialized) {
      _featuredBookId = settings.featuredBookId;
      _maintenanceMode = settings.maintenanceMode;
      _dailyReadingEnabled = settings.dailyReadingEnabled;
      _languages = List<String>.from(settings.supportedLanguages);
      _initialized = true;
    }
  }

  void _handleSave() async {
    final newSettings = AppSettingsAdminModel(
      featuredBookId: _featuredBookId,
      maintenanceMode: _maintenanceMode,
      dailyReadingEnabled: _dailyReadingEnabled,
      supportedLanguages: _languages,
      updatedAt: DateTime.now(),
    );

    final success = await context.read<SettingsProvider>().saveSettings(newSettings);
    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Global App Settings persisted to Firestore.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final books = context.watch<BooksProvider>().rawBooks;

    if (settingsProvider.isLoading && !_initialized) {
      return const LoadingStateWidget(message: 'Loading Global App Settings...');
    }

    _initSettings(settingsProvider.settings);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Global Application Settings',
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AdminColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Configuration settings stored in Firestore document `app_settings/global` consumed directly by mobile apps.',
                        style: GoogleFonts.inter(fontSize: 13, color: AdminColors.textSecondary),
                      ),
                      const Divider(height: 32),

                      // Featured Book Selector
                      Text('Featured Scripture Book', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: books.any((b) => b.id == _featuredBookId)
                            ? _featuredBookId
                            : (books.isNotEmpty ? books.first.id : 'bhagavad_gita'),
                        decoration: const InputDecoration(),
                        items: books.map((b) {
                          return DropdownMenuItem<String>(
                            value: b.id,
                            child: Text('${b.iconEmoji} ${b.title} (${b.id})'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _featuredBookId = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      // Daily Reading Toggle
                      SwitchListTile(
                        title: Text('Daily Reading Module', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        subtitle: const Text('Enable daily wisdom scroll on mobile app feed.'),
                        activeColor: AdminColors.success,
                        value: _dailyReadingEnabled,
                        onChanged: (val) {
                          setState(() {
                            _dailyReadingEnabled = val;
                          });
                        },
                      ),
                      const Divider(height: 24),

                      // Maintenance Mode Toggle
                      SwitchListTile(
                        title: Text('Maintenance Mode', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        subtitle: const Text('Temporarily display maintenance screen on mobile apps for database upgrades.'),
                        activeColor: AdminColors.error,
                        value: _maintenanceMode,
                        onChanged: (val) {
                          setState(() {
                            _maintenanceMode = val;
                          });
                        },
                      ),
                      const Divider(height: 24),

                      // Supported Languages
                      Text('Supported Application Languages', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: [
                          FilterChip(
                            label: const Text('English (en)'),
                            selected: _languages.contains('en'),
                            onSelected: (selected) {
                              setState(() {
                                selected ? _languages.add('en') : _languages.remove('en');
                              });
                            },
                          ),
                          FilterChip(
                            label: const Text('Gujarati - ગુજરાતી (gu)'),
                            selected: _languages.contains('gu'),
                            onSelected: (selected) {
                              setState(() {
                                selected ? _languages.add('gu') : _languages.remove('gu');
                              });
                            },
                          ),
                          FilterChip(
                            label: const Text('Hindi - हिंदी (hi)'),
                            selected: _languages.contains('hi'),
                            onSelected: (selected) {
                              setState(() {
                                selected ? _languages.add('hi') : _languages.remove('hi');
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _handleSave,
                          child: const Text('Save Global Settings'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
