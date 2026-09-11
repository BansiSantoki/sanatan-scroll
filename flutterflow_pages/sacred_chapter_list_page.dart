// FlutterFlow Page Implementation: SacredChapterListPage
// Route: /sacred-chapter-list
// Target FlutterFlow Project: sanatan-scroll-gxh7pn

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SacredChapterListPageWidget extends StatelessWidget {
  final String textId;

  const SacredChapterListPageWidget({
    super.key,
    required this.textId,
  });

  @override
  Widget build(BuildContext context) {
    final title = switch (textId) {
      'ramayana' => 'Ramayana Chapters',
      'upanishads' => 'Upanishads Texts',
      'mahabharata' => 'Mahabharata Parvas',
      _ => 'Bhagavad Gita Chapters',
    };

    final chapterCount = switch (textId) {
      'ramayana' => 7,
      'upanishads' => 12,
      'mahabharata' => 18,
      _ => 18,
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
        child: ListView.separated(
          padding: const EdgeInsets.all(20.0),
          itemCount: chapterCount,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final chapterNumber = index + 1;
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE9E4DE)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF6B1F2A).withValues(alpha: 0.1),
                  child: Text(
                    '$chapterNumber',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF6B1F2A),
                    ),
                  ),
                ),
                title: Text(
                  'Chapter $chapterNumber',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E2525),
                  ),
                ),
                subtitle: Text(
                  'Teachings of timeless wisdom',
                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF827777)),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Color(0xFF827777),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/sacred-text-reading',
                    arguments: {
                      'textId': textId,
                      'chapterNumber': chapterNumber,
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
