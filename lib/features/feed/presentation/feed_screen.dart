import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/language_selector_button.dart';
import '../../../../data/daily_readings_repository.dart';
import '../../../../data/sacred_books_repository.dart';
import '../../../../models/sacred_book_model.dart';
import '../../../../models/wisdom_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/chapter_completion_provider.dart';
import '../../../../providers/navigation_provider.dart';
import '../../../../providers/reading_progress_provider.dart';
import '../../../../providers/streak_provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCompletionDialog();
    });
  }

  void _checkCompletionDialog() {
    final completionProvider = context.read<ChapterCompletionProvider>();
    final pending = completionProvider.takePending();
    if (pending != null) {
      showDialog(
        context: context,
        builder: (_) => _CompletionDialog(
          bookTitle: pending.bookTitle,
          chapterTitle: pending.chapterTitle,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 600 ? 32.0 : 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 12),
              _HomeHeaderRow(),
              SizedBox(height: 20),
              _DailyWisdomCard(),
              SizedBox(height: 24),
              _ContinueJourneyCard(),
              SizedBox(height: 28),
              _ExploreScripturesSection(),
              SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 1. HEADER ROW (Namaste, User Name & Streak Pill)
// ============================================================

class _HomeHeaderRow extends StatelessWidget {
  const _HomeHeaderRow();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final streakProvider = context.watch<StreakProvider>();
    final currentStreak = streakProvider.streak.currentStreak;
    final l10n = context.l10n;

    final rawName = auth.userName.trim();
    final String greetingText;
    if (rawName.isEmpty || rawName == 'Seeker') {
      greetingText = l10n.namaste;
    } else {
      greetingText = '${l10n.namaste}, $rawName';
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final greetingFontSize = screenWidth < 360 ? 20.0 : (screenWidth > 600 ? 26.0 : 22.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                greetingText,
                style: AppTextStyles.getFont(
                  context,
                  fontSize: greetingFontSize,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1B1B1B),
                  height: 1.15,
                  isSerif: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => context.read<NavigationProvider>().setIndex(1),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
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
                      l10n.daysStreak(currentStreak),
                      style: AppTextStyles.getFont(
                        context,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF23180C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Align(
          alignment: Alignment.centerRight,
          child: LanguageSelectorButton(),
        ),
      ],
    );
  }
}

// ============================================================
// 2. DAILY WISDOM CARD
// ============================================================

class _DailyWisdomCard extends StatelessWidget {
  const _DailyWisdomCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WisdomModel>(
      stream: DailyReadingsRepository.streamDailyWisdom(),
      builder: (context, snapshot) {
        final wisdom = snapshot.data;
        final title = wisdom?.reflection ?? '${context.l10n.bhagavadGita} 2.47';
        final sanskrit = wisdom?.sanskrit ?? 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।';
        final quote = wisdom?.getLocalizedQuote(context.l10n.locale.languageCode) ??
            (context.l10n.locale.languageCode == 'gu'
                ? 'તમને તમારું કર્તવ્ય કરવાનો અધિકાર છે, પરંતુ તેના ફળ પર નહીં.'
                : context.l10n.locale.languageCode == 'hi'
                    ? 'आपको अपने कर्तव्य का पालन करने का अधिकार है, लेकिन उसके फलों पर नहीं।'
                    : 'You have the right to perform your duty, but not to the fruits of your actions.');

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final cardHeight = width >= 600 ? 320.0 : 290.0;

            return SizedBox(
              width: double.infinity,
              height: cardHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background Blob Graphic & Golden Star
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _DailyWisdomBackgroundPainter(),
                    ),
                  ),

                  // Enlarged Chariot Line-Art Image inside Green Blob
                  Positioned(
                    right: 0,
                    bottom: 0,
                    width: width * 0.52,
                    height: cardHeight * 0.88,
                    child: Image.asset(
                      'assets/images/chariot_lineart.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomRight,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),

                  // Left side Text Content
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: width * 0.52,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.l10n.dailyWisdom,
                            style: AppTextStyles.getFont(
                              context,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF7A7E5A),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.getFont(
                              context,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1B1B1B),
                              height: 1.05,
                              isSerif: true,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            sanskrit,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.getFontForLocale(
                              const Locale('hi'),
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF222222),
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            quote,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.getFont(
                              context,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF383838),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _DailyWisdomBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final blobPaint = Paint()
      ..color = const Color(0xFFB8C296)
      ..style = PaintingStyle.fill;

    final blob = Path();
    final bx = w * 0.48;

    blob.moveTo(bx + w * 0.12, 0);
    blob.cubicTo(w, 0, w, h * 0.20, w, h * 0.45);
    blob.cubicTo(w, h * 0.85, w * 0.95, h, w * 0.58, h);
    blob.cubicTo(w * 0.44, h, w * 0.48, h * 0.70, w * 0.50, h * 0.48);
    blob.cubicTo(w * 0.52, h * 0.25, bx + w * 0.05, 0, bx + w * 0.12, 0);
    blob.close();

    canvas.drawPath(blob, blobPaint);

    final starPaint = Paint()
      ..color = const Color(0xFFF8C87A)
      ..style = PaintingStyle.fill;

    _drawStar(canvas, Offset(w * 0.86, h * 0.18), 22, starPaint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    final innerRadius = radius * 0.42;

    for (int i = 0; i < 16; i++) {
      final r = (i % 2 == 0) ? radius : innerRadius;
      final angle = i * (math.pi / 8);
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// 3. CONTINUE YOUR JOURNEY CARD
// ============================================================

class _ContinueJourneyCard extends StatelessWidget {
  const _ContinueJourneyCard();

  @override
  Widget build(BuildContext context) {
    final readingProvider = context.watch<ReadingProgressProvider>();
    final savedPos = readingProvider.positionFor('bhagavad_gita');
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7BD77),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            context.read<NavigationProvider>().setIndex(3);
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
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.continueYourJourney,
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E1208),
                          height: 1.05,
                          isSerif: true,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.pickUpWhereYouLeftOff,
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF3D2614),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 26,
                  color: Color(0xFF1E1208),
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
// 4. EXPLORE SCRIPTURES SECTION (4 Cards side-by-side)
// ============================================================

class _ExploreScripturesSection extends StatelessWidget {
  const _ExploreScripturesSection();

  static const List<Color> _cardColors = [
    Color(0xFFF7BD77),
    Color(0xFFF0A77E),
    Color(0xFFB8C296),
    Color(0xFFEBC78C),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final langCode = l10n.locale.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.exploreScriptures,
          style: AppTextStyles.getFont(
            context,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF7A7E5A),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.diveIntoTimelessWisdom,
          style: AppTextStyles.getFont(
            context,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1B1B1B),
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<SacredBookModel>>(
          stream: SacredBooksRepository.streamAllBooks(),
          builder: (context, snapshot) {
            final books = snapshot.data ?? [];
            if (books.isEmpty) {
              return const SizedBox(
                height: 195,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFF7BD77)),
                ),
              );
            }

            return SizedBox(
              height: 195,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: books.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final book = books[index];
                  final title = book.getLocalizedTitle(langCode);
                  final subtitle = book.getLocalizedSubtitle(langCode);
                  final bgColor = _cardColors[index % _cardColors.length];

                  return SizedBox(
                    width: 132,
                    child: _BookCard(
                      bookId: book.id,
                      title: title,
                      subtitle: subtitle,
                      bgColor: bgColor,
                      iconType: index % 4,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

// ============================================================
// SINGLE BOOK CARD
// ============================================================

class _BookCard extends StatelessWidget {
  final String bookId;
  final String title;
  final String subtitle;
  final Color bgColor;
  final int iconType;

  const _BookCard({
    required this.bookId,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.iconType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            context.read<NavigationProvider>().setIndex(3);
            Navigator.of(context).pushNamed(
              AppRoutes.sacredTextDetail,
              arguments: bookId,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 14,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: CustomPaint(
                    painter: _getIconPainter(iconType),
                  ),
                ),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B1B1B),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.getFont(
                    context,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF3B3B3B),
                    height: 1.2,
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
    const iconColor = Color(0xFF1B1B1B);

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

class _LotusIconPainter extends CustomPainter {
  final Color color;

  const _LotusIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2 + 2;

    final center = Path();
    center.moveTo(cx, cy + 12);
    center.quadraticBezierTo(cx - 9, cy - 3, cx, cy - 15);
    center.quadraticBezierTo(cx + 9, cy - 3, cx, cy + 12);
    canvas.drawPath(center, paint);

    final left = Path();
    left.moveTo(cx - 2, cy + 12);
    left.quadraticBezierTo(cx - 18, cy + 3, cx - 15, cy - 8);
    left.quadraticBezierTo(cx - 6, cy - 5, cx - 2, cy + 6);
    canvas.drawPath(left, paint);

    final right = Path();
    right.moveTo(cx + 2, cy + 12);
    right.quadraticBezierTo(cx + 18, cy + 3, cx + 15, cy - 8);
    right.quadraticBezierTo(cx + 6, cy - 5, cx + 2, cy + 6);
    canvas.drawPath(right, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BowArrowIconPainter extends CustomPainter {
  final Color color;

  const _BowArrowIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    final bow = Path();
    bow.moveTo(cx - 13, cy + 13);
    bow.quadraticBezierTo(cx + 5, cy + 5, cx + 13, cy - 13);
    canvas.drawPath(bow, paint);

    canvas.drawLine(Offset(cx - 13, cy + 13), Offset(cx + 13, cy - 13), paint);
    canvas.drawLine(Offset(cx - 11, cy + 11), Offset(cx + 12, cy - 12), paint);

    final head = Path();
    head.moveTo(cx + 5, cy - 12);
    head.lineTo(cx + 12, cy - 12);
    head.lineTo(cx + 12, cy - 5);
    canvas.drawPath(head, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LeavesIconPainter extends CustomPainter {
  final Color color;

  const _LeavesIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    canvas.drawLine(Offset(cx, cy + 16), Offset(cx, cy - 14), paint);

    final top = Path();
    top.moveTo(cx, cy - 14);
    top.quadraticBezierTo(cx - 8, cy - 7, cx, cy + 1);
    top.quadraticBezierTo(cx + 8, cy - 7, cx, cy - 14);
    canvas.drawPath(top, paint);

    final left = Path();
    left.moveTo(cx, cy + 1);
    left.quadraticBezierTo(cx - 15, cy - 5, cx - 15, cy + 5);
    left.quadraticBezierTo(cx - 5, cy + 10, cx, cy + 1);
    canvas.drawPath(left, paint);

    final right = Path();
    right.moveTo(cx, cy + 1);
    right.quadraticBezierTo(cx + 15, cy - 5, cx + 14, cy + 5);
    right.quadraticBezierTo(cx + 5, cy + 10, cx, cy + 1);
    canvas.drawPath(right, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WheelIconPainter extends CustomPainter {
  final Color color;

  const _WheelIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    const rOuter = 16.0;
    const rInner = 5.0;

    canvas.drawCircle(center, rOuter, paint);
    canvas.drawCircle(center, rInner, paint);

    for (int i = 0; i < 8; i++) {
      final angle = i * (math.pi / 4);
      canvas.drawLine(
        Offset(
          center.dx + rInner * math.cos(angle),
          center.dy + rInner * math.sin(angle),
        ),
        Offset(
          center.dx + rOuter * math.cos(angle),
          center.dy + rOuter * math.sin(angle),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        tween: Tween(begin: 0.7, end: 1),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F2),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFF7BD77),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFFE46D24),
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You completed $chapterTitle',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B1B1B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bookTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.getFont(
                      context,
                      fontSize: 13,
                      color: const Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1B1B1B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Continue journey',
                      style: AppTextStyles.getFont(
                        context,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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