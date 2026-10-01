import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../providers/locale_provider.dart';
import '../../../providers/reading_progress_provider.dart';
import '../../../providers/streak_provider.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
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

    // Daily Wisdom dynamic content based on lastReadBookId
    final Map<String, dynamic> dailyWisdomData = _getDailyWisdomData(lastReadBookId, langCode, l10n);

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
                  final String bookId = dailyWisdomData['bookId'] as String;
                  if (bookId == 'bhagavad_gita') {
                    Navigator.of(context).pushNamed(AppRoutes.dailyReading);
                  } else {
                    Navigator.of(context).pushNamed(
                      AppRoutes.sacredTextReading,
                      arguments: {'textId': bookId, 'chapterNumber': 1},
                    );
                  }
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
                  decoration: BoxDecoration(
                    color: dailyWisdomData['bgColor'] as Color,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: (dailyWisdomData['bgColor'] as Color).withValues(alpha: 0.25),
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
                              dailyWisdomData['title'] as String,
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF141814),
                                height: 1.05,
                              ),
                            ),
                            Text(
                              dailyWisdomData['verseRef'] as String,
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF141814),
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              dailyWisdomData['shloka'] as String,
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF141814),
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              dailyWisdomData['translation'] as String,
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

                      // Illustration on Right (50% width, large Bhagavad Gita chariot image)
                      Expanded(
                        flex: 50,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            dailyWisdomData['imagePath'] as String,
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
                  final String targetBook = lastReadBookId.isNotEmpty ? lastReadBookId : 'bhagavad_gita';
                  final lastPos = readingProgress.positionFor(targetBook);
                  final targetChapter = lastPos?.chapterNumber ?? 1;

                  final subtitleText = lastPos != null
                      ? _getLocalizedPositionText(context, targetBook, lastPos.chapterNumber, lastPos.verseNumber)
                      : l10n.pickUpWhereYouLeftOff;

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.sacredTextReading,
                        arguments: {'textId': targetBook, 'chapterNumber': targetChapter},
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
                        context.read<ReadingProgressProvider>().setLastReadBookId(item['id'] as String);
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

  Map<String, dynamic> _getDailyWisdomData(String bookId, String langCode, AppLocalizations l10n) {
    if (bookId == 'ramayana') {
      final translation = langCode == 'gu'
          ? 'શ્રી રામ એ ધર્મની સાક્ષાત મૂર્તિ, સજ્જન અને સત્ય પરાક્રમી છે.'
          : (langCode == 'hi'
              ? 'श्री राम धर्म के साक्षात स्वरूप, सज्जन और सत्य पराक्रमी हैं।'
              : 'Rama is the embodiment of Dharma, righteous and truthful in valor.');
      return {
        'bookId': 'ramayana',
        'title': l10n.ramayana,
        'verseRef': '1.1',
        'shloka': 'रामो विग्रहवान् धर्मः साधुः सत्यपराक्रमः।',
        'translation': translation,
        'bgColor': const Color(0xFF94AA84),
        'imagePath': 'assets/images/ramayana_bow_art.png',
      };
    } else if (bookId == 'upanishads' || bookId == 'isha_upanishad') {
      final translation = langCode == 'gu'
          ? 'આ સમગ્ર જગતમાં જે કંઈ પણ ચરાચર છે, તે બધું ઈશ્વરથી વ્યાપ્ત છે.'
          : (langCode == 'hi'
              ? 'इस सम्पूर्ण जगत् में जो कुछ भी स्थावर-जंगम है, वह सब ईश्वर से आच्छादित है।'
              : 'All this, whatever moves in this moving world, is enveloped by God.');
      return {
        'bookId': 'upanishads',
        'title': l10n.upanishads,
        'verseRef': 'Mantra 1',
        'shloka': 'ईशा वास्यमिदं सर्वं यत्किञ्च जगत्यां जगत्।',
        'translation': translation,
        'bgColor': const Color(0xFFF2B75B),
        'imagePath': 'assets/images/upanishad_leaf_art.png',
      };
    } else {
      // Bhagavad Gita default
      final translation = langCode == 'gu'
          ? 'તમને કર્મ કરવાનો જ અધિકાર છે, પરંતુ તેના ફળ ઉપર ક્યારેય નહીં.'
          : (langCode == 'hi'
              ? 'कर्म करने में ही तुम्हारा अधिकार है, उसके फलों में कभी नहीं।'
              : 'You have the right to perform your duty, but not to the fruits of your actions.');
      return {
        'bookId': 'bhagavad_gita',
        'title': l10n.bhagavadGita,
        'verseRef': '2.47',
        'shloka': 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।',
        'translation': translation,
        'bgColor': const Color(0xFFE47A46),
        'imagePath': 'assets/images/bhagavat_gita_big.png',
      };
    }
  }

  String _getLocalizedPositionText(
    BuildContext context,
    String bookId,
    int chapterNum,
    int verseNum,
  ) {
    final langCode = Provider.of<LocaleProvider>(context, listen: false).languageCode;
    if (bookId == 'upanishads') {
      if (langCode == 'gu') return 'ઇશોપનિષદ · મંત્ર $verseNum';
      if (langCode == 'hi') return 'ईशोपनिषद् · मन्त्र $verseNum';
      return 'Isha Upanishad · Mantra $verseNum';
    } else if (bookId == 'ramayana') {
      if (langCode == 'gu') return 'રામાયણ · કાંડ $chapterNum';
      if (langCode == 'hi') return 'रामायण · काण्ड $chapterNum';
      return 'Ramayana · Kanda $chapterNum';
    } else {
      if (langCode == 'gu') return 'ભગવદ્ ગીતા · અધ્યાય $chapterNum, શ્લોક $verseNum';
      if (langCode == 'hi') return 'भगवद् गीता · अध्याय $chapterNum, श्लोक $verseNum';
      return 'Bhagavad Gita · Chapter $chapterNum, Verse $verseNum';
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
