// FlutterFlow Page Implementation: SettingsPage
// Route: /settings
// Target FlutterFlow Project: sanatan-scroll-gxh7pn

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPageWidget extends StatefulWidget {
  const SettingsPageWidget({super.key});

  @override
  State<SettingsPageWidget> createState() => _SettingsPageWidgetState();
}

class _SettingsPageWidgetState extends State<SettingsPageWidget> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF1B1B1B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B1B1B),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LANGUAGE',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF827777),
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              _LanguageRadioTile(
                languageName: 'English',
                subtitle: 'English',
                isSelected: _selectedLanguage == 'English',
                onTap: () => setState(() => _selectedLanguage = 'English'),
              ),
              const SizedBox(height: 10),
              _LanguageRadioTile(
                languageName: 'ગુજરાતી',
                subtitle: 'Gujarati',
                isSelected: _selectedLanguage == 'Gujarati',
                onTap: () => setState(() => _selectedLanguage = 'Gujarati'),
              ),
              const SizedBox(height: 10),
              _LanguageRadioTile(
                languageName: 'हिंदी',
                subtitle: 'Hindi',
                isSelected: _selectedLanguage == 'Hindi',
                onTap: () => setState(() => _selectedLanguage = 'Hindi'),
              ),

              const SizedBox(height: 32),

              Text(
                'ABOUT APP',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF827777),
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE9E4DE)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Version', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
                    Text('1.0.0+1', style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF827777))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageRadioTile extends StatelessWidget {
  final String languageName;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageRadioTile({
    required this.languageName,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF6B1F2A) : const Color(0xFFE9E4DE),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          languageName,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF6B1F2A) : const Color(0xFF1B1B1B),
          ),
        ),
        subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF827777))),
        trailing: isSelected
            ? const Icon(Icons.check_circle_rounded, color: Color(0xFF6B1F2A))
            : const Icon(Icons.circle_outlined, color: Color(0xFF827777)),
      ),
    );
  }
}
