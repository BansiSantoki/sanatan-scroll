import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/routes/app_routes.dart';

class GitaDetailScreen extends StatelessWidget {
  const GitaDetailScreen({super.key});

  // ============================================================
  // COLORS
  // ============================================================

  static const Color pageBackground = Color(0xFFFBF1E5);
  static const Color heroOrange = Color(0xFFF28A4B);
  static const Color cardBackground = Color(0xFFFFF9F0);
  static const Color black = Color(0xFF111111);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,

      // ========================================================
      // FIXED BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar: _buildBottomNavigation(),

      // ========================================================
      // SCROLLABLE CONTENT
      // ========================================================

      body: SafeArea(
        bottom: false,

        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // TOP BAR
              // ==================================================

              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 4,
                ),

                child: SizedBox(
                  height: 64,

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [
                      _TopIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),

                      _TopIconButton(
                        icon: Icons.share_outlined,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Share feature coming soon',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // ==================================================
              // HERO
              // ==================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),

                child: _buildHero(),
              ),

              const SizedBox(height: 42),

              // ==================================================
              // ABOUT
              // ==================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                ),

                child: _buildAbout(),
              ),

              const SizedBox(height: 38),

              // ==================================================
              // KEY TEACHINGS
              // ==================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                ),

                child: _buildTeachings(),
              ),

              const SizedBox(height: 38),

              // ==================================================
              // START READING
              // ==================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),

                child: _buildStartReading(context),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _buildHero() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Reference card is approximately 475-485px tall
        // on a normal phone.
        final heroHeight = width * 1.38;

        return ClipRRect(
          borderRadius: BorderRadius.circular(32),

          child: Container(
            width: double.infinity,
            height: heroHeight,
            color: heroOrange,

            child: Stack(
              clipBehavior: Clip.hardEdge,

              children: [
                // ==================================================
                // SACRED SCRIPTURE
                // ==================================================

                Positioned(
                  left: 38,
                  top: 42,

                  child: Text(
                    'SACRED SCRIPTURE',

                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      color: black,
                    ),
                  ),
                ),

                // ==================================================
                // TITLE
                // ==================================================

                Positioned(
                  left: 38,
                  right: 25,
                  top: 102,

                  child: Text(
                    'Bhagavad Gita',

                    maxLines: 1,
                    overflow: TextOverflow.visible,

                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 51,
                      fontWeight: FontWeight.w700,
                      height: 0.95,
                      color: black,
                    ),
                  ),
                ),

                // ==================================================
                // SUBTITLE
                // ==================================================

                Positioned(
                  left: 38,
                  top: 190,

                  child: Text(
                    'The Song of the Divine',

                    style: GoogleFonts.inter(
                      fontSize: 21,
                      fontWeight: FontWeight.w400,
                      color: black,
                    ),
                  ),
                ),

                // ==================================================
                // LOTUS
                // ==================================================

                Positioned(
                  right: 28,
                  top: 32,

                  child: SizedBox(
                    width: 100,
                    height: 100,

                    child: CustomPaint(
                      painter: _LotusPainter(),
                    ),
                  ),
                ),

                // ==================================================
                // CHARIOT
                // ==================================================

                Positioned(
                  right: -8,
                  bottom: 122,

                  child: SizedBox(
                    width: width * 0.62,
                    height: 230,

                    child: Image.asset(
                      'assets/images/chariot_lineart.png',

                      fit: BoxFit.contain,
                      alignment: Alignment.bottomRight,

                      filterQuality: FilterQuality.high,

                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const SizedBox();
                      },
                    ),
                  ),
                ),

                // ==================================================
                // STATISTICS
                // ==================================================

                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 16,

                  child: _buildStatistics(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStatistics() {
    return SizedBox(
      height: 150,

      child: Row(
        children: [
          Expanded(
            child: _GitaStatBox(
              number: '18',
              label: 'Chapters',
            ),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: _GitaStatBox(
              number: '700',
              label: 'Verses',
            ),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: _GitaStatBox(
              number: '350',
              label: 'Pages',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ABOUT
  // ============================================================

  Widget _buildAbout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'About this text',

          style: GoogleFonts.cormorantGaramond(
            fontSize: 37,
            fontWeight: FontWeight.w700,
            height: 1.0,
            color: black,
          ),
        ),

        const SizedBox(height: 19),

        Text(
          'The Bhagavad Gita is a 700-verse Hindu scripture that is '
          'part of the epic Mahabharata. It is a conversation between '
          'Lord Krishna and Arjuna on the battlefield, covering '
          'dharma, devotion, knowledge and selfless action.',

          style: GoogleFonts.inter(
            fontSize: 16.5,
            fontWeight: FontWeight.w400,
            height: 1.65,
            color: const Color(0xFF252525),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // KEY TEACHINGS
  // ============================================================

  Widget _buildTeachings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Key Teachings',

          style: GoogleFonts.cormorantGaramond(
            fontSize: 37,
            fontWeight: FontWeight.w700,
            height: 1.0,
            color: black,
          ),
        ),

        const SizedBox(height: 20),

        Wrap(
          spacing: 12,
          runSpacing: 12,

          children: const [
            _GitaTeachingChip(
              text: 'Dharma',
              color: Color(0xFFD9DFB8),
            ),

            _GitaTeachingChip(
              text: 'Karma',
              color: Color(0xFFF9BE7B),
            ),

            _GitaTeachingChip(
              text: 'Bhakti',
              color: Color(0xFFF6D99D),
            ),

            _GitaTeachingChip(
              text: 'Selfless Action',
              color: Color(0xFFD9DFB8),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // START READING
  // ============================================================

  Widget _buildStartReading(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 72,

      child: Material(
        color: heroOrange,

        borderRadius: BorderRadius.circular(27),

        child: InkWell(
          borderRadius: BorderRadius.circular(27),

          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.sacredTextReading,
              arguments: 'bhagavad_gita',
            );
          },

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(
                'Start Reading',

                style: GoogleFonts.inter(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),

              const SizedBox(width: 16),

              const Icon(
                Icons.arrow_forward_rounded,
                size: 29,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FIXED BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF151515),

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),

      child: SafeArea(
        top: false,

        child: SizedBox(
          height: 78,

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,

            children: const [
              _BottomNavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                selected: true,
              ),

              _BottomNavItem(
                icon: Icons.local_fire_department_outlined,
                label: 'Streak',
              ),

              _BottomNavItem(
                icon: Icons.bookmark_border_rounded,
                label: 'Saved',
              ),

              _BottomNavItem(
                icon: Icons.article_outlined,
                label: 'Feed',
              ),

              _BottomNavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// GITA STAT BOX
// ================================================================

class _GitaStatBox extends StatelessWidget {
  const _GitaStatBox({
    required this.number,
    required this.label,
  });

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,

      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            number,

            style: GoogleFonts.inter(
              fontSize: 34,
              fontWeight: FontWeight.w500,
              height: 1,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            label,

            textAlign: TextAlign.center,

            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// GITA TEACHING CHIP
// ================================================================

class _GitaTeachingChip extends StatelessWidget {
  const _GitaTeachingChip({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Text(
        text,

        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}

// ================================================================
// TOP ICON
// ================================================================

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(30),

        child: SizedBox(
          width: 52,
          height: 52,

          child: Center(
            child: Icon(
              icon,
              size: 30,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// BOTTOM NAV ITEM
// ================================================================

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final Color color = selected
        ? const Color(0xFFF3A04E)
        : Colors.white;

    return SizedBox(
      width: 62,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(
            icon,
            size: 27,
            color: color,
          ),

          const SizedBox(height: 5),

          Text(
            label,

            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// LOTUS
// ================================================================

class _LotusPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = const Color(0xFFFFE6D0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double cx = size.width / 2;

    // Center petal
    final Path center = Path();

    center.moveTo(
      cx,
      size.height * 0.88,
    );

    center.cubicTo(
      cx - 19,
      size.height * 0.62,
      cx - 15,
      size.height * 0.28,
      cx,
      size.height * 0.06,
    );

    center.cubicTo(
      cx + 15,
      size.height * 0.28,
      cx + 19,
      size.height * 0.62,
      cx,
      size.height * 0.88,
    );

    canvas.drawPath(center, paint);

    // Left
    final Path left = Path();

    left.moveTo(
      cx,
      size.height * 0.88,
    );

    left.cubicTo(
      cx - 30,
      size.height * 0.78,
      cx - 43,
      size.height * 0.52,
      cx - 40,
      size.height * 0.28,
    );

    left.cubicTo(
      cx - 18,
      size.height * 0.37,
      cx - 7,
      size.height * 0.61,
      cx,
      size.height * 0.88,
    );

    canvas.drawPath(left, paint);

    // Right
    final Path right = Path();

    right.moveTo(
      cx,
      size.height * 0.88,
    );

    right.cubicTo(
      cx + 30,
      size.height * 0.78,
      cx + 43,
      size.height * 0.52,
      cx + 40,
      size.height * 0.28,
    );

    right.cubicTo(
      cx + 18,
      size.height * 0.37,
      cx + 7,
      size.height * 0.61,
      cx,
      size.height * 0.88,
    );

    canvas.drawPath(right, paint);

    // Outer left
    final Path outerLeft = Path();

    outerLeft.moveTo(
      cx,
      size.height * 0.88,
    );

    outerLeft.cubicTo(
      cx - 43,
      size.height * 0.86,
      cx - 57,
      size.height * 0.65,
      cx - 56,
      size.height * 0.47,
    );

    outerLeft.cubicTo(
      cx - 30,
      size.height * 0.50,
      cx - 12,
      size.height * 0.69,
      cx,
      size.height * 0.88,
    );

    canvas.drawPath(outerLeft, paint);

    // Outer right
    final Path outerRight = Path();

    outerRight.moveTo(
      cx,
      size.height * 0.88,
    );

    outerRight.cubicTo(
      cx + 43,
      size.height * 0.86,
      cx + 57,
      size.height * 0.65,
      cx + 56,
      size.height * 0.47,
    );

    outerRight.cubicTo(
      cx + 30,
      size.height * 0.50,
      cx + 12,
      size.height * 0.69,
      cx,
      size.height * 0.88,
    );

    canvas.drawPath(outerRight, paint);

    // Base
    canvas.drawLine(
      Offset(
        cx - 30,
        size.height * 0.88,
      ),
      Offset(
        cx + 30,
        size.height * 0.88,
      ),
      paint,
    );

    // Stem
    canvas.drawLine(
      Offset(
        cx,
        size.height * 0.88,
      ),
      Offset(
        cx,
        size.height,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}