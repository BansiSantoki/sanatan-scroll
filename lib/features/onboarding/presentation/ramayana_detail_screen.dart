import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/routes/app_routes.dart';

class RamayanaDetailScreen extends StatelessWidget {
  const RamayanaDetailScreen({super.key});

  // ============================================================
  // COLORS
  // ============================================================

  static const Color pageBackground =
      Color(0xFFFBF7EE);

  static const Color heroBackground =
      Color(0xFFDADBBA);

  static const Color statBackground =
      Color(0xFFFFFBF5);

  static const Color olive =
      Color(0xFF68763F);

  static const Color primaryText =
      Color(0xFF18200F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,

      bottomNavigationBar:
          _buildBottomNavigation(),

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
                    const _RamayanaHero(),
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
          'The Ramayana is an ancient Sanskrit epic that narrates '
          'the life of Lord Rama, his unwavering commitment to '
          'dharma, his exile, the battle against Ravana, and his '
          'return to Ayodhya. It is a timeless guide to righteous '
          'living, ideal leadership, loyalty, love and devotion.',

          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight:
                FontWeight.w400,
            height: 1.72,
            color:
                const Color(0xFF252525),
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
                  const Color(0xFFD3D5B0),
            ),

            _TeachingChip(
              text: 'Devotion',
              color:
                  const Color(0xFFF0AC76),
            ),

            _TeachingChip(
              text: 'Relationships',
              color:
                  const Color(0xFFEAC985),
            ),

            _TeachingChip(
              text: 'Duty & Sacrifice',
              color:
                  const Color(0xFFD3D5B0),
            ),

            _TeachingChip(
              text: 'Righteous Leadership',
              color:
                  const Color(0xFFEAC985),
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
        color: olive,

        borderRadius:
            BorderRadius.circular(44),

        child: InkWell(
          borderRadius:
              BorderRadius.circular(44),

          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.sacredTextReading,
              arguments: 'ramayana',
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
                  color: Colors.white,
                ),
              ),

              const SizedBox(
                width: 27,
              ),

              const Icon(
                Icons.arrow_forward_rounded,
                size: 38,
                color: Colors.white,
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
// RAMAYANA HERO
// =================================================================

class _RamayanaHero extends StatelessWidget {
  const _RamayanaHero();

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      // IMPORTANT:
      // Total hero + overlapping statistics height.
      height: 685,

      child: Stack(
        clipBehavior: Clip.none,

        children: [
          // ======================================================
          // MAIN HERO
          // ======================================================

          Positioned(
            left: 0,
            right: 0,
            top: 0,

            child: Container(
              height: 490,

              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFDADBBA,
                ),

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

                        style:
                            GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w400,
                          letterSpacing:
                              0.25,
                          color:
                              const Color(
                            0xFF18200F,
                          ),
                        ),
                      ),
                    ),

                    // ============================================
                    // RAMAYANA
                    // ============================================

                    Positioned(
                      left: 39,
                      top: 121,
                      right: 20,

                      child: Text(
                        'Ramayana',

                        maxLines: 1,

                        style:
                            GoogleFonts.cormorantGaramond(
                          fontSize: 57,
                          fontWeight:
                              FontWeight.w700,
                          height: 0.95,
                          color:
                              const Color(
                            0xFF18200F,
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
                        'The Epic of Duty',

                        style:
                            GoogleFonts.inter(
                          fontSize: 21,
                          fontWeight:
                              FontWeight.w400,
                          color:
                              const Color(
                            0xFF18200F,
                          ),
                        ),
                      ),
                    ),

                    // ============================================
                    // RAMAYANA IMAGE
                    // ============================================

                    Positioned(
                      right: -8,
                      bottom: 0,

                      child: SizedBox(
                        width: 310,
                        height: 305,

                        child: Image.asset(
                          'assets/images/ramayana_lineart.png',

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
          // STATISTICS
          // ======================================================

          Positioned(
            left: 26,
            right: 26,
            top: 455,

            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    number: '7',
                    label: 'Kandas\n(Books)',
                  ),
                ),

                const SizedBox(
                  width: 3,
                ),

                Expanded(
                  child: _StatCard(
                    number: '24,000',
                    label: 'Verses',
                  ),
                ),

                const SizedBox(
                  width: 3,
                ),

                Expanded(
                  child: _StatCard(
                    number: '~500',
                    label: 'Pages',
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
        horizontal: 24,
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
// LOTUS
// =================================================================

class _LotusIcon extends StatelessWidget {
  const _LotusIcon({
    required this.color,
  });

  final Color color;

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width: 94,
      height: 94,

      child: CustomPaint(
        painter:
            _LotusPainter(
          color: color,
        ),
      ),
    );
  }
}

class _LotusPainter
    extends CustomPainter {
  const _LotusPainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final Paint paint =
        Paint()
          ..color = color
          ..style =
              PaintingStyle.fill;

    final Paint outline =
        Paint()
          ..color = color
          ..style =
              PaintingStyle.stroke
          ..strokeWidth = 1.2;

    final double cx =
        size.width / 2;

    final Path center =
        Path();

    center.moveTo(
      cx,
      8,
    );

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
      paint,
    );

    canvas.drawPath(
      center,
      outline,
    );

    final Path left =
        Path();

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
      paint,
    );

    canvas.drawPath(
      left,
      outline,
    );

    final Path right =
        Path();

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
      paint,
    );

    canvas.drawPath(
      right,
      outline,
    );

    final Path outerLeft =
        Path();

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
      paint,
    );

    canvas.drawPath(
      outerLeft,
      outline,
    );

    final Path outerRight =
        Path();

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
      paint,
    );

    canvas.drawPath(
      outerRight,
      outline,
    );

    canvas.drawLine(
      Offset(
        cx,
        68,
      ),
      Offset(
        cx,
        88,
      ),
      outline,
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
// TOP BUTTON
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
                0xFFBFCF7A,
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