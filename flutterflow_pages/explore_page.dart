// FlutterFlow Page Implementation: ExplorePage
// Route: /explore
// Target FlutterFlow Project: sanatan-scroll-gxh7pn

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExplorePageWidget extends StatefulWidget {
  const ExplorePageWidget({super.key});

  @override
  State<ExplorePageWidget> createState() => _ExplorePageWidgetState();
}

class _ExplorePageWidgetState extends State<ExplorePageWidget> {
  String _searchQuery = '';

  final List<Map<String, String>> _books = [
    {
      'id': 'bhagavad_gita',
      'title': 'Bhagavad Gita',
      'subtitle': 'The Song of the Divine',
      'chapters': '18 Chapters',
      'image': 'assets/images/bhagavad_gita.png',
      'color': '0xFF4A1018',
    },
    {
      'id': 'ramayana',
      'title': 'Ramayana',
      'subtitle': 'The Epic of Duty',
      'chapters': '7 Kandas',
      'image': 'assets/images/ramayana.png',
      'color': '0xFF2C1810',
    },
    {
      'id': 'upanishads',
      'title': 'Upanishads',
      'subtitle': 'Wisdom of the Self',
      'chapters': '108 Texts',
      'image': 'assets/images/upanishads.png',
      'color': '0xFF1A2E1A',
    },
    {
      'id': 'mahabharata',
      'title': 'Mahabharata',
      'subtitle': 'The Great Epic',
      'chapters': '18 Parvas',
      'image': 'assets/images/mahabharat_page.png',
      'color': '0xFF3D1F00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _books.where((b) {
      return b['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b['subtitle']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Sacred Scriptures',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B1B1B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Explore timeless teachings and eternal dharma',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF827777),
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search scriptures, chapters...',
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF827777)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Grid List
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final colorValue = int.parse(item['color']!);
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(colorValue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/sacred-text-detail',
                              arguments: item['id'],
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title']!,
                                        style: GoogleFonts.cormorantGaramond(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['subtitle']!,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: Colors.white.withValues(alpha: 0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          item['chapters']!,
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
