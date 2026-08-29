import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/routes/app_routes.dart';

class MahabharataDetailScreen extends StatelessWidget {
  const MahabharataDetailScreen({super.key});

  // ============================================================
  // COLORS
  // ============================================================

  static const Color pageBackground =
      Color(0xFFFBF4EA);

  static const Color heroBackground =
      Color(0xFFE7C48A);

  static const Color statBackground =
      Color(0xFFFFFBF5);

  static const Color primaryText =
      Color(0xFF17140F);

  static const Color buttonColor =
      Color(0xFFE4BE7E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,

      // ========================================================
      // FIXED BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar:
          _buildBottomNavigation(),

      // ========================================================
      // SCROLL VIEW
      // ========================================================

      body: SafeArea(
        bottom: false,

        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // ==================================================
              // TOP BAR
              // ==================================================

              Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  22,
                  8,
                  22,
                  12,
                ),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  children: [
                    _TopIconButton(
                      icon:
                          Icons.arrow_back_rounded,

                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    _TopIconButton(
                      icon:
                          Icons.share_outlined,

                      onPressed: () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
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
              // HERO
              // ==================================================

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 30,
                ),

                child:
                    const _MahabharataHero(),
              ),

              const SizedBox(
                height: 36,
              ),

              // ==================================================
              // ABOUT
              // ==================================================

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 59,
                ),

                child:
                    _buildAbout(),
              ),

              const SizedBox(
                height: 65,
              ),

              // ==================================================
              // KEY TEACHINGS
              // ==================================================

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 59,
                ),

                child:
                    _buildKeyTeachings(),
              ),

              const SizedBox(
                height: 42,
              ),

              // ==================================================
              // START READING
              // ==================================================

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 30,
                ),

                child:
                    _buildStartReading(context),
              ),

              const SizedBox(
                height: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ABOUT
  // ============================================================

  Widget _buildAbout() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          'About this text',

          style:
              GoogleFonts.cormorantGaramond(
            fontSize: 39,
            fontWeight:
                FontWeight.w700,
            height: 1.0,
            color: primaryText,
          ),
        ),

        const SizedBox(
          height: 24,
        ),

        Text(
          'The Mahabharata is one of the world’s longest epic poems, '
          'narrating the story of the Bharata dynasty. It is a timeless '
          'treasure trove of wisdom on dharma, politics, morality, '
          'spirituality, and the human condition.',

          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight:
                FontWeight.w400,
            height: 1.72,
            color:
                const Color(0xFF25221E),
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
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          'Key Teachings',

          style:
              GoogleFonts.cormorantGaramond(
            fontSize: 39,
            fontWeight:
                FontWeight.w700,
            height: 1.0,
            color: primaryText,
          ),
        ),

        const SizedBox(
          height: 28,
        ),

        Wrap(
          spacing: 13,
          runSpacing: 14,

          children: [
            _TeachingChip(
              text: 'Dharma',
              color:
                  const Color(0xFFD6D7B3),
            ),

            _TeachingChip(
              text: 'Karma',
              color:
                  const Color(0xFFF0AB75),
            ),

            _TeachingChip(
              text: 'Bhakti',
              color:
                  const Color(0xFFECC77F),
            ),

            _TeachingChip(
              text: 'Life Lessons',
              color:
                  const Color(0xFFD6D7B3),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // START READING
  // ============================================================

  Widget _buildStartReading(
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 88,

      child: Material(
        color: buttonColor,

        borderRadius:
            BorderRadius.circular(44),

        child: InkWell(
          borderRadius:
              BorderRadius.circular(44),

          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.sacredTextReading,
              arguments: 'mahabharata',
            );
          },

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Text(
                'Start Reading',

                style:
                    GoogleFonts.inter(
                  fontSize: 21,
                  fontWeight:
                      FontWeight.w400,
                  color: primaryText,
                ),
              ),

              const SizedBox(
                width: 27,
              ),

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

      decoration:
          const BoxDecoration(
        color: Color(0xFF202020),

        borderRadius:
            BorderRadius.only(
          topLeft:
              Radius.circular(36),
          topRight:
              Radius.circular(36),
        ),
      ),

      child: SafeArea(
        top: false,

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,

          children: const [
            _BottomNavItem(
              icon:
                  Icons.home_outlined,
              label: 'Home',
              selected: true,
            ),

            _BottomNavItem(
              icon:
                  Icons.local_fire_department_outlined,
              label: 'Streak',
            ),

            _BottomNavItem(
              icon:
                  Icons.bookmark_border_rounded,
              label: 'Saved',
            ),

            _BottomNavItem(
              icon:
                  Icons.article_outlined,
              label: 'Feed',
            ),

            _BottomNavItem(
              icon:
                  Icons.person_outline_rounded,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// MAHABHARATA HERO
// =================================================================

class _MahabharataHero extends StatelessWidget {
  const _MahabharataHero();

  static const Color heroBackground =
      Color(0xFFE7C48A);

  static const Color textColor =
      Color(0xFF17140F);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // IMPORTANT:
      // This is the total hero + statistics height.
      height: 685,

      child: Stack(
        clipBehavior: Clip.none,

        children: [
          // ======================================================
          // MAIN HERO CARD
          // ======================================================

          Positioned(
            left: 0,
            right: 0,
            top: 0,

            child: Container(
              height: 490,

              decoration:
                  BoxDecoration(
                color: heroBackground,

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

                      child:
                          _LotusIcon(),
                    ),

                    // ============================================
                    // SACRED SCRIPTURE
                    // ============================================

                    Positioned(
                      left: 40,
                      top: 61,

                      child: Text(
                        'SACRED SCRIPTURE',

                        style:
                            GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w400,
                          letterSpacing:
                              0.25,
                          color: textColor,
                        ),
                      ),
                    ),

                    // ============================================
                    // TITLE
                    // ============================================

                    Positioned(
                      left: 39,
                      top: 121,
                      right: 25,

                      child: Text(
                        'Mahabharata',

                        maxLines: 1,

                        style:
                            GoogleFonts.cormorantGaramond(
                          fontSize: 57,
                          fontWeight:
                              FontWeight.w700,
                          height: 0.95,
                          color: textColor,
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
                        'The Greatest Epic',

                        style:
                            GoogleFonts.inter(
                          fontSize: 21,
                          fontWeight:
                              FontWeight.w400,
                          color: textColor,
                        ),
                      ),
                    ),

                    // ============================================
                    // CHARIOT IMAGE
                    // ============================================

                    Positioned(
                      right: -10,
                      bottom: 0,

                      child: SizedBox(
                        width: 435,
                        height: 310,

                        child: Image.asset(
                          'assets/images/mahabharata_lineart.png',

                          fit:
                              BoxFit.contain,

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
          // STAT CARDS
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
                    number: '18',
                    label: 'Parvas (Books)',
                  ),
                ),

                const SizedBox(
                  width: 3,
                ),

                Expanded(
                  child: _StatCard(
                    number: '100,000+',
                    label: 'Verses',
                  ),
                ),

                const SizedBox(
                  width: 3,
                ),

                Expanded(
                  child: _StatCard(
                    number: '1',
                    label: 'Great Epic',
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
// STAT CARD
// =================================================================

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.number,
    required this.label,
  });

  final String number;
  final String label;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      height: 198,

      decoration:
          BoxDecoration(
        color:
            const Color(0xFFFFFBF5),

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

            textAlign:
                TextAlign.center,

            style:
                GoogleFonts.inter(
              fontSize:
                  number.length > 6
                      ? 23
                      : 29,
              fontWeight:
                  FontWeight.w400,
              color:
                  const Color(
                0xFF151515,
              ),
            ),
          ),

          const SizedBox(
            height: 17,
          ),

          Text(
            label,

            textAlign:
                TextAlign.center,

            style:
                GoogleFonts.inter(
              fontSize: 15.5,
              fontWeight:
                  FontWeight.w400,
              height: 1.25,
              color:
                  const Color(
                0xFF151515,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// LOTUS
// =================================================================

class _LotusIcon extends StatelessWidget {
  const _LotusIcon();

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width: 94,
      height: 94,

      child: CustomPaint(
        painter:
            _LotusPainter(),
      ),
    );
  }
}

class _LotusPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final Paint paint =
        Paint()
          ..color = Colors.white.withValues(
            alpha: 0.72,
          )
          ..style = PaintingStyle.fill;

    final Paint outline =
        Paint()
          ..color = Colors.white.withValues(
            alpha: 0.78,
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;

    final double centerX =
        size.width / 2;

    // Center petal
    final Path center =
        Path();

    center.moveTo(
      centerX,
      8,
    );

    center.cubicTo(
      centerX - 21,
      31,
      centerX - 20,
      54,
      centerX,
      67,
    );

    center.cubicTo(
      centerX + 20,
      54,
      centerX + 21,
      31,
      centerX,
      8,
    );

    canvas.drawPath(
      center,
      paint,
    );

    canvas.drawPath(
      center,
      outline,
    );

    // Left petal
    final Path left =
        Path();

    left.moveTo(
      centerX,
      67,
    );

    left.cubicTo(
      centerX - 31,
      64,
      centerX - 49,
      45,
      centerX - 46,
      28,
    );

    left.cubicTo(
      centerX - 24,
      30,
      centerX - 8,
      47,
      centerX,
      67,
    );

    canvas.drawPath(
      left,
      paint,
    );

    canvas.drawPath(
      left,
      outline,
    );

    // Right petal
    final Path right =
        Path();

    right.moveTo(
      centerX,
      67,
    );

    right.cubicTo(
      centerX + 31,
      64,
      centerX + 49,
      45,
      centerX + 46,
      28,
    );

    right.cubicTo(
      centerX + 24,
      30,
      centerX + 8,
      47,
      centerX,
      67,
    );

    canvas.drawPath(
      right,
      paint,
    );

    canvas.drawPath(
      right,
      outline,
    );

    // Outer left
    final Path outerLeft =
        Path();

    outerLeft.moveTo(
      centerX - 2,
      69,
    );

    outerLeft.cubicTo(
      centerX - 32,
      70,
      centerX - 60,
      55,
      centerX - 66,
      42,
    );

    outerLeft.cubicTo(
      centerX - 39,
      39,
      centerX - 16,
      50,
      centerX - 2,
      69,
    );

    canvas.drawPath(
      outerLeft,
      paint,
    );

    canvas.drawPath(
      outerLeft,
      outline,
    );

    // Outer right
    final Path outerRight =
        Path();

    outerRight.moveTo(
      centerX + 2,
      69,
    );

    outerRight.cubicTo(
      centerX + 32,
      70,
      centerX + 60,
      55,
      centerX + 66,
      42,
    );

    outerRight.cubicTo(
      centerX + 39,
      39,
      centerX + 16,
      50,
      centerX + 2,
      69,
    );

    canvas.drawPath(
      outerRight,
      paint,
    );

    canvas.drawPath(
      outerRight,
      outline,
    );

    // Stem
    canvas.drawLine(
      Offset(
        centerX,
        68,
      ),
      Offset(
        centerX,
        88,
      ),
      outline,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

// =================================================================
// TEACHING CHIP
// =================================================================

class _TeachingChip
    extends StatelessWidget {
  const _TeachingChip({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 13,
      ),

      decoration:
          BoxDecoration(
        color: color,

        borderRadius:
            BorderRadius.circular(30),
      ),

      child: Text(
        text,

        style:
            GoogleFonts.inter(
          fontSize: 17,
          fontWeight:
              FontWeight.w400,
          color:
              const Color(
            0xFF181818,
          ),
        ),
      ),
    );
  }
}

// =================================================================
// TOP ICON
// =================================================================

class _TopIconButton
    extends StatelessWidget {
  const _TopIconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Material(
      color:
          Colors.transparent,

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
              color:
                  Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

// =================================================================
// BOTTOM NAV ITEM
// =================================================================

class _BottomNavItem
    extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(
    BuildContext context,
  ) {
    final Color color =
        selected
            ? const Color(
                0xFFFFD778,
              )
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

          const SizedBox(
            height: 7,
          ),

          Text(
            label,

            style:
                GoogleFonts.inter(
              fontSize: 14,
              fontWeight:
                  FontWeight.w400,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}