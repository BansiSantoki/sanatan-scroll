import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/language_selector_button.dart';
import '../../../../data/sacred_books_repository.dart';
import '../../../../models/sacred_book_model.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF141714) : const Color(0xFFFAF7F2),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B),
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
                  color: isDark ? const Color(0xFF2C241B) : const Color(0xFFF7BE78),
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
                        color: isDark ? const Color(0xFFF7BE78) : const Color(0xFF23180C),
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

// ============================================================
// 2. DYNAMIC LAST READ / DAILY WISDOM CARD
// ============================================================

class _DailyWisdomBookData {
  final String bookId;
  final String title;
  final String sanskrit;
  final String quoteEn;
  final String quoteGu;
  final String quoteHi;
  final String imagePath;
  final Color cardBgColor;
  final Color blobColor;

  const _DailyWisdomBookData({
    required this.bookId,
    required this.title,
    required this.sanskrit,
    required this.quoteEn,
    required this.quoteGu,
    required this.quoteHi,
    required this.imagePath,
    required this.cardBgColor,
    required this.blobColor,
  });

  String getLocalizedQuote(String langCode) {
    if (langCode == 'gu') return quoteGu;
    if (langCode == 'hi') return quoteHi;
    return quoteEn;
  }
}

_DailyWisdomBookData _getBookWisdomData(String bookId) {
  switch (bookId) {
    case 'ramayana':
      return const _DailyWisdomBookData(
        bookId: 'ramayana',
        title: 'Ramayana · Bala Kanda · Sarga 1',
        sanskrit: 'ततो गृध्रस्य वचनात्सम्पातेर्हनुमान्बली। शतयोजनविस्तीर्णं पुप्लुवे लवणार्णवम्॥',
        quoteEn: 'Following the words of Sampati, the mighty Hanuman leapt across the vast salt ocean stretching for a hundred yojanas.',
        quoteGu: 'સંપાતિના વચનોનું પાલન કરી શક્તિશાળી હનુમાનજીએ સો યોજન વિસ્તીર્ણ સમુદ્રને પાર કર્યો.',
        quoteHi: 'संपाती के वचनों का पालन करते हुए महाबली हनुमान जी ने सौ योजन फैले हुए समुद्र को लांघा।',
        imagePath: 'assets/images/trishual.png',
        cardBgColor: Color(0xFFCBD1AE),
        blobColor: Color(0xFF8A9A65),
      );
    case 'upanishads':
      return const _DailyWisdomBookData(
        bookId: 'upanishads',
        title: 'Upanishads · Isha Upanishad',
        sanskrit: 'ईशा वास्यमिदं सर्वं यत्किञ्च जगत्यां जगत्। तेन त्यक्तेन भुञ्जीथा मा गृधः कस्यस्विद्धनम्॥',
        quoteEn: 'All this, whatever moves in this moving world, is enveloped by the Supreme. Enjoy through renunciation; do not covet.',
        quoteGu: 'આ જગતમાં જે કંઈ પણ ગતિશીલ છે તે ઈશ્વરથી વ્યાપ્ત છે. ત્યાગભાવથી ભોગવો, કોઈના ધનની લાલચ ન કરો.',
        quoteHi: 'इस जगत् में जो कुछ भी गतिमान है, वह सब ईश्वर से व्याप्त है। त्यागपूर्वक उपभोग करो, किसी के धन का लोभ मत करो।',
        imagePath: 'assets/images/upnishad_page.png',
        cardBgColor: Color(0xFFA5B288),
        blobColor: Color(0xFF6B7B4F),
      );
    case 'mahabharata':
      return const _DailyWisdomBookData(
        bookId: 'mahabharata',
        title: 'Mahabharata · Adi Parva',
        sanskrit: 'धर्मे च अर्थे च कामे च मोक्षे च भरतर्षभ। यदिहास्ति तदन्यत्र यन्नेहास्ति न तत्क्वचित्॥',
        quoteEn: 'What is found here regarding Duty, Wealth, Desire, and Liberation may be found elsewhere; what is not here is nowhere else.',
        quoteGu: 'ધર્મ, અર્થ, કામ અને મોક્ષ વિશે જે અહીં છે તે જ અન્યત્ર છે; જે અહીં નથી તે ક્યાંય નથી.',
        quoteHi: 'धर्म, अर्थ, काम और मोक्ष के विषय में जो यहाँ है वही अन्यत्र है; जो यहाँ नहीं है वह कहीं नहीं है।',
        imagePath: 'assets/images/mahabharat_page.png',
        cardBgColor: Color(0xFFDFB874),
        blobColor: Color(0xFFC4984F),
      );
    case 'bhagavad_gita':
    case 'gita':
    default:
      return const _DailyWisdomBookData(
        bookId: 'bhagavad_gita',
        title: 'Bhagavad Gita 2.47',
        sanskrit: 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।',
        quoteEn: 'You have the right to perform your duty, but not to the fruits of your actions.',
        quoteGu: 'તમને તમારું કર્તવ્ય કરવાનો અધિકાર છે, પરંતુ તેના ફળ પર નહીં.',
        quoteHi: 'आपको अपने कर्तव्य का पालन करने का अधिकार है, लेकिन उसके फलों पर नहीं।',
        imagePath: 'assets/images/chariot_lineart.png',
        cardBgColor: Color(0xFFF7BD77),
        blobColor: Color(0xFFE48D53),
      );
  }
}

class _DailyWisdomCard extends StatelessWidget {
  const _DailyWisdomCard();

  @override
  Widget build(BuildContext context) {
    final readingProvider = context.watch<ReadingProgressProvider>();
    final activeBookId = readingProvider.lastReadBookId;
    final data = _getBookWisdomData(activeBookId);
    final langCode = context.l10n.locale.languageCode;
    final quote = data.getLocalizedQuote(langCode);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cardHeight = width >= 600 ? 320.0 : 290.0;

        return SizedBox(
          width: double.infinity,
          height: cardHeight,
          child: Container(
            decoration: BoxDecoration(
              color: data.cardBgColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Right side Enlarged Line-Art Image for Active Book
                  Positioned(
                    right: 8,
                    bottom: 8,
                    top: 8,
                    width: width * 0.46,
                    child: Image.asset(
                      data.imagePath,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerRight,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),

                  // Left side Text Content
                  Positioned(
                    left: 20,
                    top: 16,
                    bottom: 16,
                    width: width * 0.52,
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
                            color: const Color(0xFF525738),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.getFont(
                            context,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B1B1B),
                            height: 1.05,
                            isSerif: true,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data.sanskrit,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.getFontForLocale(
                            const Locale('hi'),
                            fontSize: 15.0,
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
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF383838),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// 3. CONTINUE YOUR JOURNEY CARD
// ============================================================

class _ContinueJourneyCard extends StatelessWidget {
  const _ContinueJourneyCard();

  @override
  Widget build(BuildContext context) {
    final readingProvider = context.watch<ReadingProgressProvider>();
    final activeBookId = readingProvider.lastReadBookId;
    final savedPos = readingProvider.positionFor(activeBookId);
    final bookData = _getBookWisdomData(activeBookId);
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bookData.cardBgColor,
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
                  'textId': activeBookId,
                  'chapterNumber': savedPos.chapterNumber,
                },
              );
            } else {
              Navigator.of(context).pushNamed(
                AppRoutes.sacredTextDetail,
                arguments: activeBookId,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.exploreScriptures,
          style: AppTextStyles.getFont(
            context,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: isDark ? const Color(0xFFE88B60) : const Color(0xFF7A7E5A),
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
            color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B),
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

  Color _getCardBgColor(String bookId, bool isDark) {
    if (isDark) return const Color(0xFF222722);
    switch (bookId) {
      case 'ramayana':
        return const Color(0xFFB4C5A1); // Sage green
      case 'upanishads':
        return const Color(0xFFE5B869); // Warm Golden Ochre
      case 'mahabharata':
        return const Color(0xFFD6A350); // Golden brown
      case 'bhagavad_gita':
      default:
        return const Color(0xFFF49C6B); // Orange
    }
  }

  String _getCardArtwork(String bookId) {
    switch (bookId) {
      case 'ramayana':
        return 'assets/images/trishual.png';
      case 'upanishads':
        return 'assets/images/upnishad_page.png';
      case 'mahabharata':
        return 'assets/images/mahabharat_page.png';
      case 'bhagavad_gita':
      default:
        return 'assets/images/chariot_lineart.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = _getCardBgColor(bookId, isDark);
    final artwork = _getCardArtwork(bookId);

    return Container(
      height: 185,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            context.read<ReadingProgressProvider>().setLastReadBookId(bookId);
            context.read<NavigationProvider>().setIndex(3);
            Navigator.of(context).pushNamed(
              AppRoutes.sacredTextDetail,
              arguments: bookId,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 14,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Image.asset(
                    artwork,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => CustomPaint(
                      painter: _getIconPainter(iconType, isDark),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
                      color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B),
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
                    color: isDark ? const Color(0xFFA0A6A0) : const Color(0xFF3B3B3B),
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

  CustomPainter _getIconPainter(int type, bool isDark) {
    final iconColor = isDark ? const Color(0xFFE88B60) : const Color(0xFF1B1B1B);

    switch (type) {
      case 0:
        return _LotusIconPainter(color: iconColor);
      case 1:
        return _BowArrowIconPainter(color: iconColor);
      case 2:
        return _LeavesIconPainter(color: iconColor);
      case 3:
        return _WheelIconPainter(color: iconColor);
      default:
        return _LotusIconPainter(color: iconColor);
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