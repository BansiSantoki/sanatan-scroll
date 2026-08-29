import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/routes/app_routes.dart';

class UpanishadsDetailScreen extends StatelessWidget {
  const UpanishadsDetailScreen({super.key});

  // ============================================================
  // COLORS
  // ============================================================

  static const Color pageBackground = Color(0xFFFBF6EE);

  static const Color heroColor = Color(0xFFD9DBB7);

  static const Color cardColor = Color(0xFFFFFBF5);

  static const Color primaryText = Color(0xFF17200F);

  static const Color oliveButton = Color(0xFFBFC59A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar: _buildBottomNavigation(),

      // ========================================================
      // BODY
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
                padding: const EdgeInsets.fromLTRB(
                  22,
                  8,
                  22,
                  12,
                ),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    // BACK
                    _TopIconButton(
                      icon: Icons.arrow_back_rounded,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    // SHARE
                    _TopIconButton(
                      icon: Icons.share_outlined,
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
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

              // ==================================================
              // HERO CARD
              // ==================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),

                child: const _UpanishadsHero(),
              ),

              const SizedBox(height: 34),

              // ==================================================
              // ABOUT
              // ==================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 59,
                ),

                child: _buildAbout(),
              ),

              const SizedBox(height: 62),

              // ==================================================
              // KEY TEACHINGS
              // ==================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 59,
                ),

                child: _buildKeyTeachings(),
              ),

              const SizedBox(height: 40),

              // ==================================================
              // START READING
              // ==================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),

                child: _buildStartReading(context),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ABOUT SECTION
  // ============================================================

  Widget _buildAbout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Text(
          'About this text',

          style: GoogleFonts.cormorantGaramond(
            fontSize: 39,
            fontWeight: FontWeight.w700,
            height: 1.0,
            color: primaryText,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          'The Upanishads are a collection of ancient Hindu scriptures '
          'that explore the nature of reality, the self (Atman), and the '
          'ultimate truth (Brahman). They are the philosophical '
          'foundation of Hinduism, offering timeless insights into '
          'consciousness, wisdom, and liberation.',

          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            height: 1.72,
            color: const Color(0xFF252525),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // KEY TEACHINGS
  // ============================================================

  Widget _buildKeyTeachings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Text(
          'Key Teachings',

          style: GoogleFonts.cormorantGaramond(
            fontSize: 39,
            fontWeight: FontWeight.w700,
            height: 1.0,
            color: primaryText,
          ),
        ),

        const SizedBox(height: 28),

        Wrap(
          spacing: 13,
          runSpacing: 14,

          children: [

            _TeachingChip(
              text: 'Wisdom of the Self',
              color: const Color(0xFFD2D5B0),
            ),

            _TeachingChip(
              text: 'Consciousness',
              color: const Color(0xFFF0AC76),
            ),

            _TeachingChip(
              text: 'Brahman',
              color: const Color(0xFFEBC982),
            ),

            _TeachingChip(
              text: 'Liberation (Moksha)',
              color: const Color(0xFFD2D5B0),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // START READING BUTTON
  // ============================================================

  Widget _buildStartReading(
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 88,

      child: Material(
        color: oliveButton,

        borderRadius: BorderRadius.circular(44),

        child: InkWell(
          borderRadius: BorderRadius.circular(44),

          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.sacredTextReading,
              arguments: 'upanishads',
            );
          },

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Text(
                'Start Reading',

                style: GoogleFonts.inter(
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                  color: primaryText,
                ),
              ),

              const SizedBox(width: 27),

              const Icon(
                Icons.arrow_forward_rounded,
                size: 38,
                color: primaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      height: 118,

      decoration: const BoxDecoration(
        color: Color(0xFF202020),

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),

      child: SafeArea(
        top: false,

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,

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
    );
  }
}

// =================================================================
// UPANISHADS HERO
// =================================================================

class _UpanishadsHero extends StatelessWidget {
  const _UpanishadsHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // IMPORTANT:
      // Total area of hero + overlapping cards.
      height: 680,

      child: Stack(
        clipBehavior: Clip.none,

        children: [

          // ======================================================
          // MAIN GREEN HERO
          // ======================================================

          Positioned(
            left: 0,
            right: 0,
            top: 0,

            child: Container(
              height: 490,

              decoration: BoxDecoration(
                color: const Color(0xFFD9DBB7),

                borderRadius:
                    BorderRadius.circular(30),
              ),

              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(30),

                child: Stack(
                  children: [

                    // ============================================
                    // LOTUS
                    // ============================================

                    Positioned(
                      top: 40,
                      right: 34,

                      child: _LotusIcon(
                        color: Colors.white.withValues(
                          alpha: 0.75,
                        ),
                      ),
                    ),

                    // ============================================
                    // SACRED SCRIPTURE
                    // ============================================

                    Positioned(
                      left: 40,
                      top: 61,

                      child: Text(
                        'SACRED SCRIPTURE',

                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w400,
                          letterSpacing: 0.25,
                          color: const Color(
                            0xFF17200F,
                          ),
                        ),
                      ),
                    ),

                    // ============================================
                    // UPANISHADS TITLE
                    // ============================================

                    Positioned(
                      left: 39,
                      top: 121,
                      right: 15,

                      child: Text(
                        'Upanishads',

                        maxLines: 1,

                        style:
                            GoogleFonts.cormorantGaramond(
                          fontSize: 57,
                          fontWeight:
                              FontWeight.w700,
                          height: 0.95,
                          color: const Color(
                            0xFF17200F,
                          ),
                        ),
                      ),
                    ),

                    // ============================================
                    // SUBTITLE
                    // ============================================

                    Positioned(
                      left: 40,
                      top: 235,

                      child: Text(
                        'Wisdom of the Self',

                        style: GoogleFonts.inter(
                          fontSize: 21,
                          fontWeight:
                              FontWeight.w400,
                          color: const Color(
                            0xFF17200F,
                          ),
                        ),
                      ),
                    ),

                    // ============================================
                    // UPANISHADS ILLUSTRATION
                    // ============================================

                    Positioned(
                      right: -8,
                      bottom: 0,

                      child: SizedBox(
                        width: 350,
                        height: 305,

                        child: Image.asset(
                          'assets/images/upanishads_lineart.png',

                          fit: BoxFit.contain,

                          alignment:
                              Alignment.bottomRight,

                          filterQuality:
                              FilterQuality.high,

                          errorBuilder:
                              (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ======================================================
          // STATISTICS
          // ======================================================

          Positioned(
            left: 26,
            right: 26,
            top: 455,

            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Expanded(
                  child: _StatCard(
                    number: '108',
                    label: 'Upanishads',
                  ),
                ),

                const SizedBox(width: 3),

                Expanded(
                  child: _StatCard(
                    number: '2000+',
                    label: 'Teachings',
                  ),
                ),

                const SizedBox(width: 3),

                Expanded(
                  child: _StatCard(
                    number: '500+',
                    label: 'Verses',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// STATISTICS CARD
// =================================================================

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.number,
    required this.label,
  });

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 198,

      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),

        borderRadius:
            BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.025,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Text(
            number,

            textAlign: TextAlign.center,

            style: GoogleFonts.inter(
              fontSize: 29,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF151515),
            ),
          ),

          const SizedBox(height: 17),

          Text(
            label,

            textAlign: TextAlign.center,

            style: GoogleFonts.inter(
              fontSize: 15.5,
              fontWeight: FontWeight.w400,
              height: 1.25,
              color: const Color(0xFF151515),
            ),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// TEACHING CHIP
// =================================================================

class _TeachingChip extends StatelessWidget {
  const _TeachingChip({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 13,
      ),

      decoration: BoxDecoration(
        color: color,

        borderRadius:
            BorderRadius.circular(30),
      ),

      child: Text(
        text,

        style: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF181818),
        ),
      ),
    );
  }
}

// =================================================================
// TOP ICON BUTTON
// =================================================================

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onPressed,

        borderRadius:
            BorderRadius.circular(30),

        child: SizedBox(
          width: 52,
          height: 52,

          child: Center(
            child: Icon(
              icon,
              size: 35,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

// =================================================================
// LOTUS ICON
// =================================================================

class _LotusIcon extends StatelessWidget {
  const _LotusIcon({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 94,
      height: 94,

      child: CustomPaint(
        painter: _LotusPainter(
          color: color,
        ),
      ),
    );
  }
}

class _LotusPainter extends CustomPainter {
  const _LotusPainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final double cx = size.width / 2;

    // ----------------------------------------------------------
    // CENTER PETAL
    // ----------------------------------------------------------

    final Path center = Path();

    center.moveTo(cx, 8);

    center.cubicTo(
      cx - 21,
      31,
      cx - 20,
      54,
      cx,
      67,
    );

    center.cubicTo(
      cx + 20,
      54,
      cx + 21,
      31,
      cx,
      8,
    );

    canvas.drawPath(
      center,
      fillPaint,
    );

    canvas.drawPath(
      center,
      strokePaint,
    );

    // ----------------------------------------------------------
    // LEFT PETAL
    // ----------------------------------------------------------

    final Path left = Path();

    left.moveTo(
      cx,
      67,
    );

    left.cubicTo(
      cx - 31,
      64,
      cx - 49,
      45,
      cx - 46,
      28,
    );

    left.cubicTo(
      cx - 24,
      30,
      cx - 8,
      47,
      cx,
      67,
    );

    canvas.drawPath(
      left,
      fillPaint,
    );

    canvas.drawPath(
      left,
      strokePaint,
    );

    // ----------------------------------------------------------
    // RIGHT PETAL
    // ----------------------------------------------------------

    final Path right = Path();

    right.moveTo(
      cx,
      67,
    );

    right.cubicTo(
      cx + 31,
      64,
      cx + 49,
      45,
      cx + 46,
      28,
    );

    right.cubicTo(
      cx + 24,
      30,
      cx + 8,
      47,
      cx,
      67,
    );

    canvas.drawPath(
      right,
      fillPaint,
    );

    canvas.drawPath(
      right,
      strokePaint,
    );

    // ----------------------------------------------------------
    // OUTER LEFT
    // ----------------------------------------------------------

    final Path outerLeft = Path();

    outerLeft.moveTo(
      cx - 2,
      69,
    );

    outerLeft.cubicTo(
      cx - 32,
      70,
      cx - 60,
      55,
      cx - 66,
      42,
    );

    outerLeft.cubicTo(
      cx - 39,
      39,
      cx - 16,
      50,
      cx - 2,
      69,
    );

    canvas.drawPath(
      outerLeft,
      fillPaint,
    );

    canvas.drawPath(
      outerLeft,
      strokePaint,
    );

    // ----------------------------------------------------------
    // OUTER RIGHT
    // ----------------------------------------------------------

    final Path outerRight = Path();

    outerRight.moveTo(
      cx + 2,
      69,
    );

    outerRight.cubicTo(
      cx + 32,
      70,
      cx + 60,
      55,
      cx + 66,
      42,
    );

    outerRight.cubicTo(
      cx + 39,
      39,
      cx + 16,
      50,
      cx + 2,
      69,
    );

    canvas.drawPath(
      outerRight,
      fillPaint,
    );

    canvas.drawPath(
      outerRight,
      strokePaint,
    );

    // ----------------------------------------------------------
    // STEM
    // ----------------------------------------------------------

    canvas.drawLine(
      Offset(cx, 68),
      Offset(cx, 88),
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _LotusPainter oldDelegate,
  ) {
    return oldDelegate.color != color;
  }
}

// =================================================================
// BOTTOM NAVIGATION ITEM
// =================================================================

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
        ? const Color(0xFFCFD78D)
        : Colors.white;

    return SizedBox(
      width: 65,

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            size: 32,
            color: color,
          ),

          const SizedBox(height: 7),

          Text(
            label,

            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}