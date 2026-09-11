// FlutterFlow Page Implementation: SacredTextReaderPage
// Route: /sacred-text-reading
// Target FlutterFlow Project: sanatan-scroll-gxh7pn

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../flutterflow_custom_code/custom_widgets/tts_audio_player_widget.dart';

class SacredTextReaderPageWidget extends StatefulWidget {
  final String textId;
  final int initialChapterNumber;

  const SacredTextReaderPageWidget({
    super.key,
    required this.textId,
    required this.initialChapterNumber,
  });

  @override
  State<SacredTextReaderPageWidget> createState() => _SacredTextReaderPageWidgetState();
}

class _SacredTextReaderPageWidgetState extends State<SacredTextReaderPageWidget> {
  int _currentVerse = 1;
  final int _totalVerses = 10;
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    const sanskritText = 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥';
    const translationText = 'You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions.';

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
          'Chapter ${widget.initialChapterNumber} — Verse $_currentVerse',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B1B1B),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: const Color(0xFF6B1F2A),
            ),
            onPressed: () => setState(() => _isSaved = !_isSaved),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Audio Player Custom Widget Wrapper
                    const TtsAudioPlayerWidget(
                      width: double.infinity,
                      height: 48,
                      textToSpeak: translationText,
                      languageCode: 'en',
                    ),

                    const SizedBox(height: 32),

                    // Sanskrit Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                        child: Text(
                          sanskritText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6B1F2A),
                            height: 1.6,
                          ),
                        ),
                    ),

                    const SizedBox(height: 24),

                    // Translation Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F0E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TRANSLATION',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF827777),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            translationText,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF2E2525),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Pagination Control Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE9E4DE))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: _currentVerse > 1
                        ? () => setState(() => _currentVerse--)
                        : null,
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Previous'),
                  ),
                  Text(
                    '$_currentVerse / $_totalVerses',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  TextButton.icon(
                    onPressed: _currentVerse < _totalVerses
                        ? () => setState(() => _currentVerse++)
                        : null,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
