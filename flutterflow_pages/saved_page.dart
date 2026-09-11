// FlutterFlow Page Implementation: SavedPage
// Route: /saved
// Target FlutterFlow Project: sanatan-scroll-gxh7pn

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../flutterflow_custom_code/custom_widgets/watermark_painters_widget.dart';

class SavedPageWidget extends StatefulWidget {
  const SavedPageWidget({super.key});

  @override
  State<SavedPageWidget> createState() => _SavedPageWidgetState();
}

class _SavedPageWidgetState extends State<SavedPageWidget> {
  final List<Map<String, String>> _savedItems = [
    {
      'id': 'gita_2_47',
      'title': 'Bhagavad Gita — Ch 2, Verse 47',
      'source': 'Bhagavad Gita',
      'content': 'You have the right to work, but never to the fruit of work.',
      'type': 'Verse',
    },
    {
      'id': 'ramayana_1_1',
      'title': 'Ramayana — Bala Kanda',
      'source': 'Ramayana',
      'content': 'Dharma protects those who protect dharma.',
      'type': 'Verse',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saved Wisdom',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B1B1B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Verses and teachings saved for reflection',
                style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF827777)),
              ),
              const SizedBox(height: 20),

              _savedItems.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bookmark_border_rounded, size: 64, color: const Color(0xFF827777).withValues(alpha: 0.5)),
                            const SizedBox(height: 16),
                            Text(
                              'No saved wisdom yet',
                              style: GoogleFonts.cormorantGaramond(fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bookmark verses and reflections that inspire you.',
                              style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF827777)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        itemCount: _savedItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final item = _savedItems[index];
                          return Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFFE9E4DE)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item['source']!,
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF6B1F2A),
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.bookmark_rounded, color: Color(0xFF6B1F2A), size: 20),
                                          onPressed: () {
                                            setState(() {
                                              _savedItems.removeAt(index);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '“${item['content']}”',
                                      style: GoogleFonts.cormorantGaramond(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2E2525),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item['title']!,
                                      style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF827777)),
                                    ),
                                  ],
                                ),
                              ),
                              const Positioned(
                                right: 12,
                                bottom: 12,
                                child: WatermarkBackgroundWidget(
                                  width: 80,
                                  height: 80,
                                  type: WatermarkType.lotus,
                                  opacity: 0.05,
                                ),
                              ),
                            ],
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
