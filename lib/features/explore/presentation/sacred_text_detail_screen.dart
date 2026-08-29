import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/services/share_service.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../providers/navigation_provider.dart';

class SacredTextDetailScreen extends StatefulWidget {
  final String bookId;

  const SacredTextDetailScreen({
    super.key,
    required this.bookId,
  });

  @override
  State<SacredTextDetailScreen> createState() => _SacredTextDetailScreenState();
}

class _SacredTextDetailScreenState extends State<SacredTextDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  // ============================================================
  // COLORS
  // ============================================================

  static const Color pageBgColor = Color(0xFFFAF7F2);
  static const Color darkTextColor = Color(0xFF1B1B1B);
  static const Color cardCreamColor = Color(0xFFFFFDF9);
  static const Color navBarColor = Color(0xFF1B1C1B);

  // ============================================================
  // BOOK INFORMATION
  // ============================================================

  String get _title {
    switch (widget.bookId) {
      case 'ramayana':
        return 'Ramayana';
      case 'upanishads':
        return 'Upanishads';
      case 'mahabharata':
        return 'Mahabharata';
      case 'bhagavad_gita':
      default:
        return 'Bhagavad Gita';
    }
  }

  String get _subtitle {
    switch (widget.bookId) {
      case 'ramayana':
        return 'The Epic of Duty';
      case 'upanishads':
        return 'Wisdom of the Self';
      case 'mahabharata':
        return 'The Greatest Epic';
      case 'bhagavad_gita':
      default:
        return 'The Song of the Divine';
    }
  }

  String? get _extraBadge {
    switch (widget.bookId) {
      case 'ramayana':
        return '24,000 Verses';
      default:
        return null;
    }
  }

  String get _about {
    switch (widget.bookId) {
      case 'ramayana':
        return 'The Ramayana is an ancient Sanskrit epic that narrates the life of Lord Rama, his unwavering commitment to dharma, his exile, the battle against Ravana, and his return to Ayodhya. It is a timeless guide to righteous living, ideal leadership, loyalty, love and devotion.';
      case 'upanishads':
        return 'The Upanishads are a collection of ancient Hindu scriptures that explore the nature of reality, the self (Atman), and the ultimate truth (Brahman). They are the philosophical foundation of Hinduism, offering timeless insights into consciousness, wisdom, and liberation.';
      case 'mahabharata':
        return 'The Mahabharata is one of the world’s longest epic poems, narrating the story of the Bharata dynasty. It is a timeless treasure trove of wisdom on dharma, politics, morality, spirituality, and the human condition.';
      case 'bhagavad_gita':
      default:
        return 'The Bhagavad Gita is a 700-verse Hindu scripture that is part of the epic Mahabharata. It is a conversation between Lord Krishna and Arjuna on the battlefield, covering dharma, devotion, knowledge and selfless action.';
    }
  }

  List<_TeachingChipData> get _teachings {
    switch (widget.bookId) {
      case 'ramayana':
        return const [
          _TeachingChipData('Dharma', icon: Icons.shield_outlined, color: Color(0xFFE4E7CD)),
          _TeachingChipData('Devotion', icon: Icons.favorite_border_rounded, color: Color(0xFFE4E7CD)),
          _TeachingChipData('Relationships', icon: Icons.people_outline_rounded, color: Color(0xFFE4E7CD)),
          _TeachingChipData('Duty & Sacrifice', icon: Icons.spa_outlined, color: Color(0xFFE4E7CD)),
          _TeachingChipData('Righteous Leadership', icon: Icons.auto_awesome_outlined, color: Color(0xFFE4E7CD)),
        ];

      case 'upanishads':
        return const [
          _TeachingChipData('Wisdom of the Self', color: Color(0xFFCCD5B8)),
          _TeachingChipData('Consciousness', color: Color(0xFFECA780)),
          _TeachingChipData('Brahman', color: Color(0xFFEBD09C)),
          _TeachingChipData('Liberation (Moksha)', color: Color(0xFFCCD5B8)),
        ];

      case 'mahabharata':
        return const [
          _TeachingChipData('Dharma', color: Color(0xFFCCD5B8)),
          _TeachingChipData('Karma', color: Color(0xFFECA780)),
          _TeachingChipData('Bhakti', color: Color(0xFFEBD09C)),
          _TeachingChipData('Life Lessons', color: Color(0xFFCCD5B8)),
        ];

      case 'bhagavad_gita':
      default:
        return const [
          _TeachingChipData('Dharma', color: Color(0xFFCBD5AE)),
          _TeachingChipData('Karma', color: Color(0xFFF2B07C)),
          _TeachingChipData('Bhakti', color: Color(0xFFF5CF8E)),
          _TeachingChipData('Selfless Action', color: Color(0xFFCBD5AE)),
        ];
    }
  }

  // ============================================================
  // HERO CARD THEME COLORS
  // ============================================================

  Color get _cardBgColor {
    switch (widget.bookId) {
      case 'ramayana':
        return const Color(0xFFCBD1AE);
      case 'upanishads':
        return const Color(0xFFA5B288);
      case 'mahabharata':
        return const Color(0xFFDFB874);
      case 'bhagavad_gita':
      default:
        return const Color(0xFFE48D53);
    }
  }

  Color get _cardHeaderTextColor {
    switch (widget.bookId) {
      case 'ramayana':
        return const Color(0xFF384628);
      case 'upanishads':
        return const Color(0xFF283618);
      case 'mahabharata':
        return const Color(0xFF423314);
      case 'bhagavad_gita':
      default:
        return const Color(0xFF4A2C18);
    }
  }

  Color get _cardTitleColor {
    switch (widget.bookId) {
      case 'ramayana':
        return const Color(0xFF1B2A10);
      case 'upanishads':
        return const Color(0xFF15240B);
      case 'mahabharata':
        return const Color(0xFF1E1506);
      case 'bhagavad_gita':
      default:
        return const Color(0xFF1F1208);
    }
  }

  Color get _cardSubtitleColor {
    switch (widget.bookId) {
      case 'ramayana':
        return const Color(0xFF2E3D1E);
      case 'upanishads':
        return const Color(0xFF283618);
      case 'mahabharata':
        return const Color(0xFF423314);
      case 'bhagavad_gita':
      default:
        return const Color(0xFF3D2515);
    }
  }

  Color get _buttonColor {
    switch (widget.bookId) {
      case 'ramayana':
        return const Color(0xFF58623A);
      case 'upanishads':
        return const Color(0xFFA5B288);
      case 'mahabharata':
        return const Color(0xFFDCB779);
      case 'bhagavad_gita':
      default:
        return const Color(0xFFE48643);
    }
  }

  Color get _buttonTextColor {
    switch (widget.bookId) {
      case 'ramayana':
        return Colors.white;
      case 'upanishads':
        return const Color(0xFF1C2812);
      case 'mahabharata':
        return const Color(0xFF231A0B);
      case 'bhagavad_gita':
      default:
        return const Color(0xFF1F1208);
    }
  }



  // ============================================================
  // STATS
  // ============================================================

  List<_StatItem> get _stats {
    switch (widget.bookId) {
      case 'ramayana':
        return const [
          _StatItem(
            value: '7',
            label: 'Kandas\n(Books)',
            icon: Icons.menu_book_outlined,
          ),
          _StatItem(
            value: '24,000',
            label: 'Verses',
            icon: Icons.eco_outlined,
          ),
          _StatItem(
            value: '~500',
            label: 'Pages',
            icon: Icons.description_outlined,
          ),
        ];

      case 'upanishads':
        return const [
          _StatItem(
            value: '108',
            label: 'Upanishads',
          ),
          _StatItem(
            value: '2000+',
            label: 'Teachings',
          ),
          _StatItem(
            value: '500+',
            label: 'Verses',
          ),
        ];

      case 'mahabharata':
        return const [
          _StatItem(
            value: '18',
            label: 'Parvas (Books)',
          ),
          _StatItem(
            value: '100,000+',
            label: 'Verses',
          ),
          _StatItem(
            value: '1',
            label: 'Great Epic',
          ),
        ];

      case 'bhagavad_gita':
      default:
        return const [
          _StatItem(
            value: '18',
            label: 'Chapters',
          ),
          _StatItem(
            value: '700',
            label: 'Verses',
          ),
          _StatItem(
            value: '350',
            label: 'Pages',
          ),
        ];
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: navBarColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: pageBgColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Top Action Bar
              _buildTopBar(),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),

                      // Hero Card
                      _buildHeroCard(),

                      // Floating 3-Stat Cards
                      _buildStatsRow(),

                      const SizedBox(height: 4),

                      // About this text
                      _buildAboutSection(),

                      const SizedBox(height: 28),

                      // Key Teachings
                      _buildTeachingsSection(),

                      const SizedBox(height: 32),

                      // Start Reading Button
                      _buildStartReadingButton(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Dock Navigation
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back,
              size: 26,
              color: darkTextColor,
            ),
            splashRadius: 24,
          ),
          IconButton(
            onPressed: _shareBook,
            icon: const Icon(
              Icons.share_outlined,
              size: 24,
              color: darkTextColor,
            ),
            splashRadius: 24,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HERO CARD
  // ============================================================

  // ============================================================
  // HERO CARD
  // ============================================================

  Widget _buildHeroCard() {
    final bool isRamayanaOrUpanishads =
        widget.bookId == 'ramayana' || widget.bookId == 'upanishads';

    return Container(
      width: double.infinity,
      height: 360,
      decoration: BoxDecoration(
        color: _cardBgColor,
        borderRadius: BorderRadius.circular(26),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // Top Right Corner Art (Lotus / Leaves)
            Positioned(
              top: 16,
              right: 18,
              child: widget.bookId == 'ramayana'
                  ? _buildRamayanaTopLeaves()
                  : _buildLotusArt(),
            ),

            // Main Side Illustration Image - BIG size for Ramayana and Upanishads
            Positioned(
              left: isRamayanaOrUpanishads ? 10 : null,
              right: isRamayanaOrUpanishads ? 10 : 14,
              bottom: isRamayanaOrUpanishads ? 4 : 12,
              top: isRamayanaOrUpanishads ? 35 : 65,
              width: isRamayanaOrUpanishads ? null : 210,
              child: Align(
                alignment: isRamayanaOrUpanishads
                    ? Alignment.bottomCenter
                    : Alignment.bottomRight,
                child: _buildBookIllustration(),
              ),
            ),

            // Text info on top left
            Positioned(
              left: 22,
              top: 24,
              right: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SACRED SCRIPTURE',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: _cardHeaderTextColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _title,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        height: 1.05,
                        color: _cardTitleColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _subtitle,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: _cardSubtitleColor,
                    ),
                  ),
                  if (_extraBadge != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _extraBadge!,
                      style: GoogleFonts.manrope(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: _cardHeaderTextColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOTUS ART
  // ============================================================

  Widget _buildLotusArt() {
    return CustomPaint(
      size: const Size(60, 48),
      painter: _LotusPainter(),
    );
  }

  Widget _buildRamayanaTopLeaves() {
    return CustomPaint(
      size: const Size(75, 60),
      painter: _RamayanaLeavesPainter(),
    );
  }

  // ============================================================
  // BOOK ILLUSTRATION SWITCHER
  // ============================================================

  Widget _buildBookIllustration() {
    final String imagePath = switch (widget.bookId) {
      'ramayana' => 'assets/images/trishual.png',
      'upanishads' => 'assets/images/upnishad_page.png',
      'mahabharata' => 'assets/images/mahabharat_page.png',
      'bhagavad_gita' => 'assets/images/chariot_lineart.png',
      _ => 'assets/images/chariot_lineart.png',
    };

    final bool isRamayanaOrUpanishads =
        widget.bookId == 'ramayana' || widget.bookId == 'upanishads';

    return Image.asset(
      imagePath,
      width: isRamayanaOrUpanishads ? 310 : null,
      height: isRamayanaOrUpanishads ? 310 : null,
      fit: BoxFit.contain,
      alignment: isRamayanaOrUpanishads
          ? Alignment.bottomCenter
          : Alignment.bottomRight,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox.shrink();
      },
    );
  }

  // ============================================================
  // 3 STATS ROW
  // ============================================================

  Widget _buildStatsRow() {
    return Transform.translate(
      offset: const Offset(0, -38),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: _stats.map((stat) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: cardCreamColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        stat.value,
                        style: GoogleFonts.manrope(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: darkTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stat.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF555555),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ============================================================
  // ABOUT SECTION
  // ============================================================

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this text',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: darkTextColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _about,
            style: GoogleFonts.manrope(
              fontSize: 14.5,
              height: 1.55,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KEY TEACHINGS SECTION
  // ============================================================

  Widget _buildTeachingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Teachings',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: darkTextColor,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _teachings.map((chip) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: chip.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (chip.icon != null) ...[
                      Icon(
                        chip.icon,
                        size: 16,
                        color: darkTextColor,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      chip.text,
                      style: GoogleFonts.manrope(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: darkTextColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // START READING BUTTON
  // ============================================================

  Widget _buildStartReadingButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _openChapterList,
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonColor,
          foregroundColor: _buttonTextColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start Reading',
              style: GoogleFonts.manrope(
                fontSize: 16.5,
                fontWeight: FontWeight.w600,
                color: _buttonTextColor,
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward,
              size: 20,
              color: _buttonTextColor,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION BAR
  // ============================================================

  Widget _buildBottomNavigation() {
    return CustomBottomNavigation(
      currentIndex: 3,
      onTap: (index) {
        context.read<NavigationProvider>().setIndex(index);
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }

  // ============================================================
  // ACTIONS
  // ============================================================

  void _openChapterList() {
    Navigator.of(context).pushNamed(
      AppRoutes.sacredChapterList,
      arguments: widget.bookId,
    );
  }

  void _shareBook() {
    ShareService.showOptions(
      context: context,
      title: _title,
      text: '$_title — $_subtitle\n\n$_about\n\nSanatan Scroll',
    );
  }
}

// ============================================================
// HELPER MODELS
// ============================================================

class _StatItem {
  final String value;
  final String label;
  final IconData? icon;

  const _StatItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

class _TeachingChipData {
  final String text;
  final IconData? icon;
  final Color color;

  const _TeachingChipData(
    this.text, {
    this.icon,
    required this.color,
  });
}



// ============================================================
// LOTUS PAINTER (Top-right corner icon)
// ============================================================

class _LotusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Center petal
    final centerPetal = Path();
    centerPetal.moveTo(w * 0.5, h * 0.1);
    centerPetal.cubicTo(w * 0.62, h * 0.35, w * 0.6, h * 0.7, w * 0.5, h * 0.85);
    centerPetal.cubicTo(w * 0.4, h * 0.7, w * 0.38, h * 0.35, w * 0.5, h * 0.1);
    canvas.drawPath(centerPetal, fillPaint);

    // Left petal
    final leftPetal = Path();
    leftPetal.moveTo(w * 0.28, h * 0.25);
    leftPetal.cubicTo(w * 0.45, h * 0.35, w * 0.5, h * 0.7, w * 0.45, h * 0.85);
    leftPetal.cubicTo(w * 0.28, h * 0.75, w * 0.18, h * 0.5, w * 0.28, h * 0.25);
    canvas.drawPath(leftPetal, fillPaint);

    // Right petal
    final rightPetal = Path();
    rightPetal.moveTo(w * 0.72, h * 0.25);
    rightPetal.cubicTo(w * 0.55, h * 0.35, w * 0.5, h * 0.7, w * 0.55, h * 0.85);
    rightPetal.cubicTo(w * 0.72, h * 0.75, w * 0.82, h * 0.5, w * 0.72, h * 0.25);
    canvas.drawPath(rightPetal, fillPaint);

    // Outer Left Petal
    final outerLeft = Path();
    outerLeft.moveTo(w * 0.1, h * 0.5);
    outerLeft.cubicTo(w * 0.28, h * 0.55, w * 0.4, h * 0.78, w * 0.4, h * 0.88);
    outerLeft.cubicTo(w * 0.2, h * 0.85, w * 0.05, h * 0.72, w * 0.1, h * 0.5);
    canvas.drawPath(outerLeft, fillPaint);

    // Outer Right Petal
    final outerRight = Path();
    outerRight.moveTo(w * 0.9, h * 0.5);
    outerRight.cubicTo(w * 0.72, h * 0.55, w * 0.6, h * 0.78, w * 0.6, h * 0.88);
    outerRight.cubicTo(w * 0.8, h * 0.85, w * 0.95, h * 0.72, w * 0.9, h * 0.5);
    canvas.drawPath(outerRight, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// RAMAYANA TOP LEAVES PAINTER
// ============================================================

class _RamayanaLeavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final leafPaint = Paint()
      ..color = const Color(0xFF495736).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final sunPaint = Paint()
      ..color = const Color(0xFFF7F3E2).withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    // Gentle sun circle
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.6), 13, sunPaint);

    // Branch stem
    final branch = Path();
    branch.moveTo(size.width * 0.95, size.height * 0.05);
    branch.cubicTo(
      size.width * 0.65,
      size.height * 0.15,
      size.width * 0.45,
      size.height * 0.35,
      size.width * 0.15,
      size.height * 0.55,
    );
    canvas.drawPath(branch, leafPaint);

    // Leaves along the branch
    _drawLeaf(canvas, Offset(size.width * 0.75, size.height * 0.12), -0.4, leafPaint);
    _drawLeaf(canvas, Offset(size.width * 0.60, size.height * 0.22), 0.3, leafPaint);
    _drawLeaf(canvas, Offset(size.width * 0.42, size.height * 0.38), -0.5, leafPaint);
    _drawLeaf(canvas, Offset(size.width * 0.25, size.height * 0.48), 0.4, leafPaint);
    _drawLeaf(canvas, Offset(size.width * 0.15, size.height * 0.55), -0.2, leafPaint);
  }

  void _drawLeaf(Canvas canvas, Offset center, double angle, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(8, -10, 18, -12);
    path.quadraticBezierTo(10, 0, 0, 0);
    canvas.drawPath(path, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}