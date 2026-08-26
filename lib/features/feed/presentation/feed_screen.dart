import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../data/mock_wisdom_data.dart';
import '../../../../data/sacred_books_data.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/chapter_completion_provider.dart';
import '../../../../providers/reading_progress_provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Timer? _completionTimer;
  bool _isShowingCompletion = false;

  @override
  void dispose() {
    _completionTimer?.cancel();
    super.dispose();
  }

  Future<void> _showPendingCompletion(BuildContext context) async {
    if (!mounted || _isShowingCompletion) {
      return;
    }

    final completion =
        context.read<ChapterCompletionProvider>().takePending();

    if (completion == null) {
      return;
    }

    _isShowingCompletion = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return _CompletionDialog(
          bookTitle: completion.bookTitle,
          chapterTitle: completion.chapterTitle,
        );
      },
    );

    _isShowingCompletion = false;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final horizontalPadding = width >= 900
        ? 40.0
        : width >= 600
            ? 28.0
            : 20.0;

    final maxContentWidth = width >= 900 ? 900.0 : double.infinity;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPendingCompletion(context);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFAF0E4),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxContentWidth,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                top: 12,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // HEADER
                  _HomeHeaderRow(),

                  SizedBox(height: 28),

                  // DAILY WISDOM
                  _DailyWisdomCard(),

                  SizedBox(height: 28),

                  // CONTINUE
                  _ContinueJourneyCard(),

                  SizedBox(height: 30),

                  // EXPLORE
                  _ExploreScripturesSection(),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class _HomeHeaderRow extends StatelessWidget {
  const _HomeHeaderRow();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final rawName = auth.firstName;
    final userName = rawName.isNotEmpty ? rawName : 'Bansi';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            'Namaste, $userName',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 31,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF141814),
              height: 1,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFBC07E),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🔥',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 7),
              Text(
                '7 Days',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF141814),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// DAILY WISDOM
// ============================================================
//
// IMPORTANT:
// bg_bg.png       = green background
// chariot_lineart.png = chariot line art
//
// બંને Stack માં છે.
// Text left side માં fixed area માં છે.
// એટલે text image ઉપર નહીં જાય.
// ============================================================

class _DailyWisdomCard extends StatelessWidget {
  const _DailyWisdomCard();

  @override
  Widget build(BuildContext context) {
    final wisdom = MockWisdomData.dailyWisdom;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isSmallPhone = width < 370;
        final isTablet = width >= 600;

        final titleSize = isTablet
            ? 29.0
            : isSmallPhone
                ? 23.0
                : 25.0;

        final sanskritSize = isTablet
            ? 19.0
            : isSmallPhone
                ? 15.5
                : 17.0;

        final quoteSize = isTablet
            ? 14.5
            : isSmallPhone
                ? 12.5
                : 13.5;

        final cardHeight = isTablet
            ? 350.0
            : isSmallPhone
                ? 330.0
                : 350.0;

        return SizedBox(
          width: double.infinity,
          height: cardHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ------------------------------------------------
              // GREEN BACKGROUND
              // ------------------------------------------------

              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: isTablet
                    ? width * 0.50
                    : width * 0.53,
                child: Image.asset(
                  'assets/images/bg_bg.png',
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFB5BD8E),
                        borderRadius: BorderRadius.circular(45),
                      ),
                    );
                  },
                ),
              ),

              // ------------------------------------------------
              // TEXT AREA
              // ------------------------------------------------

              Positioned(
                left: 0,
                top: 8,
                width: width * 0.59,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DAILY WISDOM
                    Text(
                      'DAILY WISDOM',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF858D5C),
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // BOOK TITLE
                    Text(
                      wisdom.source,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF141814),
                        height: 1.05,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // CHAPTER + VERSE
                    Text(
                      'Chapter ${wisdom.chapter}.Verse ${wisdom.verse}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF141814),
                        height: 1.05,
                      ),
                    ),

                    const SizedBox(height: 13),

                    // SANSKRIT
                    if (wisdom.sanskrit != null &&
                        wisdom.sanskrit!.isNotEmpty)
                      Text(
                        wisdom.sanskrit!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: sanskritSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF141814),
                          height: 1.35,
                        ),
                      ),

                    const SizedBox(height: 12),

                    // ENGLISH TRANSLATION
                    Text(
                      wisdom.quote,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: quoteSize,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF30352F),
                        height: 1.48,
                      ),
                    ),
                  ],
                ),
              ),

              // ------------------------------------------------
              // CHARIOT
              // ------------------------------------------------

              Positioned(
                right: isTablet ? -2 : -4,
                bottom: isTablet ? 15 : 13,
                width: isTablet
                    ? width * 0.49
                    : width * 0.50,
                child: Image.asset(
                  'assets/images/chariot_lineart.png',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// CONTINUE YOUR JOURNEY
// ============================================================

class _ContinueJourneyCard extends StatelessWidget {
  const _ContinueJourneyCard();

  @override
  Widget build(BuildContext context) {
    final readingProvider = context.watch<ReadingProgressProvider>();
    final savedPos = readingProvider.positionFor('bhagavad_gita');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFBC07E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            if (savedPos != null) {
              Navigator.of(context).pushNamed(
                AppRoutes.sacredTextReading,
                arguments: {
                  'textId': 'bhagavad_gita',
                  'chapterNumber': savedPos.chapterNumber,
                },
              );
            } else {
              Navigator.of(context).pushNamed(
                AppRoutes.sacredTextReading,
                arguments: 'bhagavad_gita',
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              25,
              20,
              25,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Continue Your Journey',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF141814),
                          height: 1.05,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Pick up where you left off',
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF30352F),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 34,
                  color: Color(0xFF141814),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EXPLORE SCRIPTURES
// ============================================================

class _ExploreScripturesSection extends StatelessWidget {
  const _ExploreScripturesSection();

  static const List<Map<String, dynamic>> _fourBooks = [
    {
      'id': 'bhagavad_gita',
      'title': 'Gita',
      'subtitle': 'The Song of\nthe Divine',
      'color': Color(0xFFFBC07E),
      'iconType': 0,
    },
    {
      'id': 'ramayana',
      'title': 'Ramayana',
      'subtitle': 'The Epic of\nDuty',
      'color': Color(0xFFF7B185),
      'iconType': 1,
    },
    {
      'id': 'upanishads',
      'title': 'Upanishads',
      'subtitle': 'Wisdom of\nthe Self',
      'color': Color(0xFFB5BD8E),
      'iconType': 2,
    },
    {
      'id': 'mahabharata',
      'title': 'Mahabharata',
      'subtitle': 'The Great\nEpic',
      'color': Color(0xFFEBD49A),
      'iconType': 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXPLORE SCRIPTURES',
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF858D5C),
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Dive into timeless wisdom',
          style: GoogleFonts.inter(
            fontSize: 15.5,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF141814),
          ),
        ),

        const SizedBox(height: 18),

        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _fourBooks.length,
            separatorBuilder: (context, index) {
              return const SizedBox(width: 12);
            },
            itemBuilder: (context, index) {
              final info = _fourBooks[index];

              final bookId = info['id'] as String;
              final title = info['title'] as String;
              final subtitle = info['subtitle'] as String;
              final bgColor = info['color'] as Color;
              final iconType = info['iconType'] as int;

              final book = SacredBooksData.findById(bookId);

              return _HorizontalBookCard(
                bookId: bookId,
                title: title,
                subtitle: subtitle,
                bgColor: bgColor,
                iconType: iconType,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.sacredTextDetail,
                    arguments: book?.id ?? bookId,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================
// BOOK CARD
// ============================================================

class _HorizontalBookCard extends StatelessWidget {
  final String bookId;
  final String title;
  final String subtitle;
  final Color bgColor;
  final int iconType;
  final VoidCallback onTap;

  const _HorizontalBookCard({
    required this.bookId,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.iconType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 116,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 46,
                  height: 46,
                  child: CustomPaint(
                    painter: _getIconPainter(iconType),
                  ),
                ),

                const SizedBox(height: 11),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF141814),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF30352F),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomPainter _getIconPainter(int type) {
    const iconColor = Color(0xFF141814);

    switch (type) {
      case 0:
        return const _LotusIconPainter(color: iconColor);

      case 1:
        return const _BowArrowIconPainter(color: iconColor);

      case 2:
        return const _LeavesIconPainter(color: iconColor);

      case 3:
        return const _WheelIconPainter(color: iconColor);

      default:
        return const _LotusIconPainter(color: iconColor);
    }
  }
}

// ============================================================
// LOTUS
// ============================================================

class _LotusIconPainter extends CustomPainter {
  final Color color;

  const _LotusIconPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2 + 2;

    final center = Path();

    center.moveTo(cx, cy + 12);
    center.quadraticBezierTo(
      cx - 9,
      cy - 3,
      cx,
      cy - 15,
    );
    center.quadraticBezierTo(
      cx + 9,
      cy - 3,
      cx,
      cy + 12,
    );

    canvas.drawPath(center, paint);

    final left = Path();

    left.moveTo(cx - 2, cy + 12);
    left.quadraticBezierTo(
      cx - 18,
      cy + 3,
      cx - 15,
      cy - 8,
    );
    left.quadraticBezierTo(
      cx - 6,
      cy - 5,
      cx - 2,
      cy + 6,
    );

    canvas.drawPath(left, paint);

    final right = Path();

    right.moveTo(cx + 2, cy + 12);
    right.quadraticBezierTo(
      cx + 18,
      cy + 3,
      cx + 15,
      cy - 8,
    );
    right.quadraticBezierTo(
      cx + 6,
      cy - 5,
      cx + 2,
      cy + 6,
    );

    canvas.drawPath(right, paint);

    final outerLeft = Path();

    outerLeft.moveTo(cx - 4, cy + 12);
    outerLeft.quadraticBezierTo(
      cx - 22,
      cy + 11,
      cx - 19,
      cy + 1,
    );
    outerLeft.quadraticBezierTo(
      cx - 10,
      cy + 2,
      cx - 4,
      cy + 9,
    );

    canvas.drawPath(outerLeft, paint);

    final outerRight = Path();

    outerRight.moveTo(cx + 4, cy + 12);
    outerRight.quadraticBezierTo(
      cx + 22,
      cy + 11,
      cx + 19,
      cy + 1,
    );
    outerRight.quadraticBezierTo(
      cx + 10,
      cy + 2,
      cx + 4,
      cy + 9,
    );

    canvas.drawPath(outerRight, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// BOW & ARROW
// ============================================================

class _BowArrowIconPainter extends CustomPainter {
  final Color color;

  const _BowArrowIconPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    final bow = Path();

    bow.moveTo(cx - 13, cy + 13);
    bow.quadraticBezierTo(
      cx + 5,
      cy + 5,
      cx + 13,
      cy - 13,
    );

    canvas.drawPath(bow, paint);

    final stringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(cx - 13, cy + 13),
      Offset(cx + 13, cy - 13),
      stringPaint,
    );

    canvas.drawLine(
      Offset(cx - 11, cy + 11),
      Offset(cx + 12, cy - 12),
      paint,
    );

    final head = Path();

    head.moveTo(cx + 5, cy - 12);
    head.lineTo(cx + 12, cy - 12);
    head.lineTo(cx + 12, cy - 5);

    canvas.drawPath(head, paint);

    final nock = Path();

    nock.moveTo(cx - 13, cy + 9);
    nock.lineTo(cx - 9, cy + 13);

    canvas.drawPath(nock, stringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// LEAVES
// ============================================================

class _LeavesIconPainter extends CustomPainter {
  final Color color;

  const _LeavesIconPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    canvas.drawLine(
      Offset(cx, cy + 16),
      Offset(cx, cy - 14),
      paint,
    );

    final top = Path();

    top.moveTo(cx, cy - 14);
    top.quadraticBezierTo(
      cx - 8,
      cy - 7,
      cx,
      cy + 1,
    );
    top.quadraticBezierTo(
      cx + 8,
      cy - 7,
      cx,
      cy - 14,
    );

    canvas.drawPath(top, paint);

    final left = Path();

    left.moveTo(cx, cy + 1);
    left.quadraticBezierTo(
      cx - 15,
      cy - 5,
      cx - 15,
      cy + 5,
    );
    left.quadraticBezierTo(
      cx - 5,
      cy + 10,
      cx,
      cy + 1,
    );

    canvas.drawPath(left, paint);

    final right = Path();

    right.moveTo(cx, cy + 1);
    right.quadraticBezierTo(
      cx + 15,
      cy - 5,
      cx + 14,
      cy + 5,
    );
    right.quadraticBezierTo(
      cx + 5,
      cy + 10,
      cx,
      cy + 1,
    );

    canvas.drawPath(right, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// WHEEL
// ============================================================

class _WheelIconPainter extends CustomPainter {
  final Color color;

  const _WheelIconPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    const rOuter = 16.0;
    const rInner = 5.0;

    canvas.drawCircle(
      center,
      rOuter,
      paint,
    );

    canvas.drawCircle(
      center,
      rInner,
      paint,
    );

    for (int i = 0; i < 8; i++) {
      final angle = i * (math.pi / 4);

      final p1 = Offset(
        center.dx + rInner * math.cos(angle),
        center.dy + rInner * math.sin(angle),
      );

      final p2 = Offset(
        center.dx + rOuter * math.cos(angle),
        center.dy + rOuter * math.sin(angle),
      );

      canvas.drawLine(
        p1,
        p2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// COMPLETION DIALOG
// ============================================================

class _CompletionDialog extends StatelessWidget {
  const _CompletionDialog({
    required this.bookTitle,
    required this.chapterTitle,
  });

  final String bookTitle;
  final String chapterTitle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 700),
        curve: Curves.elasticOut,
        tween: Tween(
          begin: 0.65,
          end: 1,
        ),
        builder: (
          context,
          scale,
          child,
        ) {
          return Transform.scale(
            scale: scale,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                24,
                22,
                24,
                18,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF0E4),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFFBC07E),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Color(0xFFE88242),
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.auto_awesome,
                        color: Color(0xFFE88242),
                        size: 28,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    'You completed $chapterTitle',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF141814),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    bookTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF2D352E),
                    ),
                  ),

                  const SizedBox(height: 18),

                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF212121),
                    ),
                    child: const Text(
                      'Continue journey',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}