// FlutterFlow Page Implementation: FeedPage
// Target FlutterFlow Project ID: sanatan-scroll-gxh7pn
// Replaces / refines the existing FeedPage in FlutterFlow while preserving visual source of truth.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedPageWidget extends StatefulWidget {
  const FeedPageWidget({super.key});

  @override
  State<FeedPageWidget> createState() => _FeedPageWidgetState();
}

class _FeedPageWidgetState extends State<FeedPageWidget> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName?.split(' ').first ?? 'Seeker';
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width >= 600 ? 32.0 : 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Header Row: Namaste Greeting & Streak Pill
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Namaste, $userName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1B1B1B),
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7BE78),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          size: 18,
                          color: Color(0xFFE46D24),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '1 Day',
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF23180C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Daily Wisdom Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6B1F2A), Color(0xFF8B2730)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B1F2A).withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'DAILY WISDOM',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '“You have the right to work, but never to the fruit of work.”',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Bhagavad Gita — Chapter 2, Verse 47',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Explore Scriptures Section Header
              Text(
                'EXPLORE SCRIPTURES',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF827777),
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 14),

              // Scriptures Grid Card Items
              _ScriptureCard(
                title: 'Bhagavad Gita',
                subtitle: 'The Song of the Divine',
                color: const Color(0xFF4A1018),
                imagePath: 'assets/images/bhagavad_gita.png',
                onTap: () {
                  Navigator.of(context).pushNamed('/sacred-text-detail', arguments: 'bhagavad_gita');
                },
              ),
              const SizedBox(height: 12),
              _ScriptureCard(
                title: 'Ramayana',
                subtitle: 'The Epic of Duty',
                color: const Color(0xFF2C1810),
                imagePath: 'assets/images/ramayana.png',
                onTap: () {
                  Navigator.of(context).pushNamed('/sacred-text-detail', arguments: 'ramayana');
                },
              ),
              const SizedBox(height: 12),
              _ScriptureCard(
                title: 'Upanishads',
                subtitle: 'Wisdom of the Self',
                color: const Color(0xFF1A2E1A),
                imagePath: 'assets/images/upanishads.png',
                onTap: () {
                  Navigator.of(context).pushNamed('/sacred-text-detail', arguments: 'upanishads');
                },
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScriptureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final String imagePath;
  final VoidCallback onTap;

  const _ScriptureCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
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
                        title,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.8),
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
  }
}
