import 'package:flutter/material.dart';
import '../core/data/local_database.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _languageKey = 'app_language';

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
  ];

  Locale _locale = const Locale('en');

  LocaleProvider() {
    _loadSavedLocale();
  }

  Locale get locale => _locale;

  String get languageCode => _locale.languageCode;

  String get currentLanguageName {
    switch (_locale.languageCode) {
      case 'gu':
        return 'ગુજરાતી';
      case 'hi':
        return 'हिंदी';
      case 'en':
      default:
        return 'English';
    }
  }

  Future<void> _loadSavedLocale() async {
    try {
      final savedCode = await LocalDatabase.instance.getSetting(_languageKey);
      if (savedCode != null && _isSupported(savedCode)) {
        _locale = Locale(savedCode);
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> setLocale(Locale newLocale) async {
    if (!_isSupported(newLocale.languageCode)) return;
    if (_locale.languageCode == newLocale.languageCode) return;

    _locale = newLocale;
    notifyListeners();

    try {
      await LocalDatabase.instance.setSetting(_languageKey, newLocale.languageCode);
    } catch (_) {}
  }

  Future<void> setLanguageCode(String code) async {
    await setLocale(Locale(code));
  }

  bool _isSupported(String code) {
    return supportedLocales.any((loc) => loc.languageCode == code);
  }
}
