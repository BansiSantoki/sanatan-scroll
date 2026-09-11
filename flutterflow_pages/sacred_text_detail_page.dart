// FlutterFlow Page Implementation: SacredTextDetailPage
// Route: /sacred-text-detail
// Target FlutterFlow Project: sanatan-scroll-gxh7pn

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SacredTextDetailPageWidget extends StatelessWidget {
  final String bookId;

  const SacredTextDetailPageWidget({
    super.key,
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    final title = switch (bookId) {
      'ramayana' => 'Ramayana',
      'upanishads' => 'Upanishads',
      'mahabharata' => 'Mahabharata',
      _ => 'Bhagavad Gita',
    };

    final subtitle = switch (bookId) {
      'ramayana' => 'The Epic of Duty',
      'upanishads' => 'Wisdom of the Self',
      'mahabharata' => 'The Great Epic',
      _ => 'The Song of the Divine',
    };

    final aboutText = switch (bookId) {
      'ramayana' => 'The Ramayana is an ancient epic depicting the life of Lord Rama, his devotion to dharma, and his timeless triumph over evil.',
      'upanishads' => 'The Upanishads are supreme philosophical texts exploring Brahman, Atman, and ultimate spiritual liberation.',
      'mahabharata' => 'The Mahabharata is a vast epic exploring righteous duty, cosmic order, politics, and devotion.',
      _ => 'The Bhagavad Gita is a 700-verse sacred conversation between Lord Krishna and Arjuna on karma, devotion, and self-realization.',
    };

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
          title,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B1B1B),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A1018), Color(0xFF7A2630)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // About Section
              Text(
                'ABOUT',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF827777),
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                aboutText,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF2E2525),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B1F2A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/sacred-text-reading',
                            arguments: {'textId': bookId, 'chapterNumber': 1},
                          );
                        },
                        child: Text(
                          'Start Reading',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF6B1F2A), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/sacred-chapter-list',
                            arguments: bookId,
                          );
                        },
                        child: Text(
                          'View Chapters',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6B1F2A),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
