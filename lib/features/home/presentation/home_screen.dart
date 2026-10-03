import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/services/daily_wisdom_service.dart';
import '../../../providers/locale_provider.dart';
import '../../../providers/reading_progress_provider.dart';
import '../../../providers/streak_provider.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  DailyWisdomVerse _todayWisdom = DailyWisdomService.getFallbackWisdomForBook(DateTime.now(), 'bhagavad_gita');
  String? _lastLoadedBookId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final readingProgress = Provider.of<ReadingProgressProvider>(context);
    final activeBookId = readingProgress.lastReadBookId;
    if (_lastLoadedBookId != activeBookId) {
      _lastLoadedBookId = activeBookId;
      _loadDailyWisdom(activeBookId);
    }
  }

  Future<void> _loadDailyWisdom(String activeBookId) async {
    final wisdom = await DailyWisdomService.getTodayWisdom(activeBookId: activeBookId);
    if (mounted) {
      setState(() {
        _todayWisdom = wisdom;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = (user?.displayName != null && user!.displayName!.trim().isNotEmpty)
        ? user.displayName!.trim().split(' ').first
        : (user?.email != null && user!.email!.trim().isNotEmpty)
            ? user.email!.trim().split('@').first
            : 'Bansi';

    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 600 ? 28.0 : 20.0;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final langCode = localeProvider.languageCode;
    final l10n = context.l10n;

    final readingProgress = Provider.of<ReadingProgressProvider>(context);
    final lastReadBookId = readingProgress.lastReadBookId;

    final List<Map<String, dynamic>> scriptureBooks = [
      {
        'id': 'bhagavad_gita',
        'title': l10n.bhagavadGita,
        'subtitle': l10n.gitaSubtitle,
        'bgColor': const Color(0xFFE47A46),
        'imagePath': 'assets/images/bhagavat_gita_big.png',
      },
      {
        'id': 'ramayana',
        'title': l10n.ramayana,
        'subtitle': l10n.ramayanaSubtitle,
        'bgColor': const Color(0xFF94AA84),
        'imagePath': 'assets/images/ramayana_bow_art.png',
      },
      {
        'id': 'upanishads',
        'title': l10n.upanishads,
        'subtitle': l10n.upanishadsSubtitle,
        'bgColor': const Color(0xFFF2B75B),
        'imagePath': 'assets/images/upanishad_leaf_art.png',
      },
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF141714) : const Color(0xFFFAF6F0);
    final headerTextColor = isDark ? const Color(0xFFF0F2F0) : const Color(0xFF141814);
    final subLabelColor = isDark ? const Color(0xFFA0A6A0) : const Color(0xFF736D66);
    final bodyLabelColor = isDark ? const Color(0xFFE0E4E0) : const Color(0xFF382F24);
    final popupBgColor = isDark ? const Color(0xFF222622) : const Color(0xFFFFFDF9);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. HEADER ROW (Namaste, User Name & Streak + Language Pill)
              // ==========================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${l10n.namaste}, $userName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: headerTextColor,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Streak Pill Widget
                      Consumer<StreakProvider>(
                        builder: (context, streakProvider, _) {
                          final streakCount = streakProvider.streak.currentStreak;

                          return InkWell(
                            onTap: () => Navigator.of(context).pushNamed('/streak'),
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7BE78),
                                borderRadius: BorderRadius.circular(18),
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
                                    l10n.daysStreak(streakCount),
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
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

                      const SizedBox(height: 6),

                      // Language Dropdown Pill Widget
                      PopupMenuButton<String>(
                        onSelected: (selectedLang) {
                          localeProvider.setLocale(Locale(selectedLang));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: popupBgColor,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7BE78),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.language,
                                style: GoogleFonts.inter(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF23180C),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: Color(0xFF23180C),
                              ),
                            ],
                          ),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'en',
                            child: Text('English', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                          ),
                          PopupMenuItem(
                            value: 'gu',
                            child: Text('ગુજરાતી', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                          ),
                          PopupMenuItem(
                            value: 'hi',
                            child: Text('हिंदी', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ==========================================
              // 2. DYNAMIC DAILY WISDOM HERO CARD
              // ==========================================
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.sacredTextReading,
                    arguments: _todayWisdom.toRouteArguments(),
                  );
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
                  decoration: BoxDecoration(
                    color: _todayWisdom.bgColor,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: _todayWisdom.bgColor.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Text content on Left (52% width)
                      Expanded(
                        flex: 52,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.dailyWisdom,
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF332014),
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _todayWisdom.getLocalizedTitle(langCode),
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF141814),
                                height: 1.05,
                              ),
                            ),
                            Text(
                              _todayWisdom.verseRef,
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF141814),
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _todayWisdom.sanskrit,
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF141814),
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _todayWisdom.getLocalizedTranslation(langCode),
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF28201A),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Illustration on Right (50% width)
                      Expanded(
                        flex: 50,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            _todayWisdom.imagePath,
                            height: 225,
                            fit: BoxFit.contain,
                            alignment: Alignment.centerRight,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (_, __, ___) => Image.asset(
                              'assets/images/bhagavat_gita_big.png',
                              height: 225,
                              fit: BoxFit.contain,
                              alignment: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ==========================================
              // 3. CONTINUE YOUR JOURNEY CARD
              // ==========================================
              Builder(
                builder: (context) {
                  final lastPos = readingProgress.latestPosition ?? readingProgress.positionFor(lastReadBookId);
                  final String targetBook = lastPos?.bookId ?? (lastReadBookId.isNotEmpty ? lastReadBookId : 'bhagavad_gita');

                  final subtitleText = lastPos != null
                      ? _getLocalizedPositionText(context, lastPos)
                      : l10n.pickUpWhereYouLeftOff;

                  return InkWell(
                    onTap: () {
                      final routeArgs = lastPos != null
                          ? lastPos.toRouteArguments()
                          : {'textId': targetBook, 'chapterNumber': 1, 'verseNumber': 1};

                      if (kDebugMode) {
                        debugPrint('==================================================');
                        debugPrint('[CONTINUE_DEBUG] TAPPED CONTINUE YOUR JOURNEY');
                        debugPrint('targetBookId: $targetBook');
                        debugPrint('loadedProgress: ${lastPos?.toMap()}');
                        debugPrint('routeArgs: $routeArgs');
                        debugPrint('==================================================');
                      }

                      Navigator.of(context).pushNamed(
                        AppRoutes.sacredTextReading,
                        arguments: routeArgs,
                      );
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7BE78),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF7BE78).withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.continueYourJourney,
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF141814),
                                    height: 1.08,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  subtitleText,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF2C2218),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 28,
                              color: Color(0xFF141814),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // ==========================================
              // 4. EXPLORE SCRIPTURES HORIZONTAL SCROLLABLE LIST
              // ==========================================
              Text(
                l10n.exploreScriptures,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: subLabelColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                l10n.diveIntoTimelessWisdom,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: bodyLabelColor,
                ),
              ),
              const SizedBox(height: 16),

              // Horizontal Left-Right Scrollable List for Sacred Books
              SizedBox(
                height: 215,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: scriptureBooks.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final item = scriptureBooks[index];
                    return _ScriptureHorizontalBookCard(
                      title: item['title']!,
                      subtitle: item['subtitle']!,
                      bgColor: item['bgColor'] as Color,
                      imagePath: item['imagePath']!,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.sacredTextDetail,
                          arguments: item['id'],
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedPositionText(
    BuildContext context,
    ReadingPosition pos,
  ) {
    final langCode = Provider.of<LocaleProvider>(context, listen: false).languageCode;
    final bookId = pos.bookId;
    final chapNum = pos.chapterNumber;
    final verseNum = pos.verseNumber;
    final kandaNum = pos.kandaNumber ?? (chapNum >= 1000 ? chapNum ~/ 1000 : null);
    final sargaNum = pos.sargaNumber ?? (chapNum >= 1000 ? chapNum % 1000 : null);
    final mantraNum = pos.mantraNumber ?? (bookId == 'upanishads' ? chapNum : verseNum);

    if (bookId == 'upanishads') {
      if (langCode == 'gu') return 'ઇશોપનિષદ · મંત્ર $mantraNum';
      if (langCode == 'hi') return 'ईशोपनिषद् · मन्त्र $mantraNum';
      return 'Isha Upanishad · Mantra $mantraNum';
    } else if (bookId == 'ramayana') {
      final k = kandaNum ?? 1;
      final s = sargaNum ?? 1;
      if (langCode == 'gu') return 'રામાયણ · કાંડ $k, સર્ગ $s, શ્લોક $verseNum';
      if (langCode == 'hi') return 'रामायण · काण्ड $k, सर्ग $s, श्लोक $verseNum';
      return 'Ramayana · Kanda $k, Sarga $s, Verse $verseNum';
    } else {
      if (langCode == 'gu') return 'ભગવદ્ ગીતા · અધ્યાય $chapNum, શ્લોક $verseNum';
      if (langCode == 'hi') return 'भगवद् गीता · अध्याय $chapNum, श्लोक $verseNum';
      return 'Bhagavad Gita · Chapter $chapNum, Verse $verseNum';
    }
  }
}

class _ScriptureHorizontalBookCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color bgColor;
  final String imagePath;
  final VoidCallback onTap;

  const _ScriptureHorizontalBookCard({
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: bgColor.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
        child: Column(
          children: [
            // Top Line-Art Image
            Expanded(
              child: Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  height: 115,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Book Title
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF141814),
                height: 1.1,
              ),
            ),

            const SizedBox(height: 3),

            // Book Subtitle
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF2C251F),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
