// FlutterFlow Standard Page Structure: HomeWidget
// File: lib/pages/home/home_widget.dart
// Route: /home
// FlutterFlow Project: sanatan-scroll-gxh7pn

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = (user?.displayName != null && user!.displayName!.trim().isNotEmpty)
        ? user.displayName!.trim().split(' ').first
        : (user?.email != null && user!.email!.trim().isNotEmpty)
            ? user.email!.trim().split('@').first
            : 'Seeker';

    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 600 ? 32.0 : 20.0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFFAF7F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
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
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: user != null
                          ? FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('streak')
                              .doc('current')
                              .snapshots()
                          : const Stream.empty(),
                      builder: (context, snapshot) {
                        final streakCount = (snapshot.hasData && snapshot.data!.exists)
                            ? (snapshot.data!.data()?['currentStreak'] as num?)?.toInt() ?? 1
                            : 1;

                        return InkWell(
                          onTap: () => Navigator.of(context).pushNamed('/streak'),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
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
                                  '$streakCount ${streakCount == 1 ? "Day" : "Days"}',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF23180C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Daily Wisdom Hero Card
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('daily_readings')
                      .limit(1)
                      .snapshots(),
                  builder: (context, snapshot) {
                    String quote = '“You have the right to work, but never to the fruit of work.”';
                    String source = 'Bhagavad Gita — Chapter 2, Verse 47';

                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      final data = snapshot.data!.docs.first.data();
                      quote = '“${data['quote'] ?? quote}”';
                      source = '${data['source'] ?? "Bhagavad Gita"} — ${data['verse'] ?? ""}';
                    }

                    return Container(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'TODAY\'S SCROLL',
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
                          const SizedBox(height: 12),
                          Text(
                            quote,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  source,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE8B36B),
                                  foregroundColor: const Color(0xFF4A1018),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/daily-reading');
                                },
                                child: Text(
                                  'Read Scroll',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Continue Your Journey Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE9E4DE)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF6B1F2A).withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.auto_stories_rounded,
                          color: Color(0xFF6B1F2A),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Continue Your Journey',
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1B1B1B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Bhagavad Gita — Chapter 1',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF827777),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B1F2A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/sacred-text-reading',
                            arguments: {'textId': 'bhagavad_gita', 'chapterNumber': 1},
                          );
                        },
                        child: Text(
                          'Resume',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Explore Scriptures Header
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

                _ScriptureCard(
                  title: 'Bhagavad Gita',
                  subtitle: 'The Song of the Divine',
                  color: const Color(0xFF4A1018),
                  imagePath: 'assets/images/bhagavad_gita.png',
                  onTap: () => Navigator.of(context).pushNamed('/sacred-text-detail', arguments: 'bhagavad_gita'),
                ),
                const SizedBox(height: 12),
                _ScriptureCard(
                  title: 'Ramayana',
                  subtitle: 'The Epic of Duty',
                  color: const Color(0xFF2C1810),
                  imagePath: 'assets/images/ramayana.png',
                  onTap: () => Navigator.of(context).pushNamed('/sacred-text-detail', arguments: 'ramayana'),
                ),
                const SizedBox(height: 12),
                _ScriptureCard(
                  title: 'Upanishads',
                  subtitle: 'Wisdom of the Self',
                  color: const Color(0xFF1A2E1A),
                  imagePath: 'assets/images/upanishads.png',
                  onTap: () => Navigator.of(context).pushNamed('/sacred-text-detail', arguments: 'upanishads'),
                ),
                const SizedBox(height: 12),
                _ScriptureCard(
                  title: 'Mahabharata',
                  subtitle: 'The Great Epic',
                  color: const Color(0xFF3D1F00),
                  imagePath: 'assets/images/mahabharat_page.png',
                  onTap: () => Navigator.of(context).pushNamed('/sacred-text-detail', arguments: 'mahabharata'),
                ),
                const SizedBox(height: 28),
              ],
            ),
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
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
