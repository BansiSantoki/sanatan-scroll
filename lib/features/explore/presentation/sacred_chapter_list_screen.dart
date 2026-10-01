import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_typography.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/share_service.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../data/sacred_books_data.dart';
import '../../../../data/sacred_books_repository.dart';
import '../../../../models/sacred_book_model.dart';
import '../../../../models/sacred_chapter_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/guest_access_provider.dart';
import '../../../../providers/locale_provider.dart';
import '../../../../providers/navigation_provider.dart';

class SacredChapterListScreen extends StatefulWidget {
  const SacredChapterListScreen({
    super.key,
    required this.textId,
    this.initialKandaNumber,
  });

  final String textId;
  final int? initialKandaNumber;

  @override
  State<SacredChapterListScreen> createState() => _SacredChapterListScreenState();
}

class _SacredChapterListScreenState extends State<SacredChapterListScreen> {
  int? _selectedKandaNumber;

  @override
  void initState() {
    super.initState();
    _selectedKandaNumber = widget.initialKandaNumber;
  }

  static const List<Map<String, String>> _ramayanaKandas = [
    {
      'number': '1',
      'titleEn': 'Bala Kanda',
      'subtitleEn': 'The Book of Childhood',
      'titleHi': 'बाल काण्ड',
      'subtitleHi': 'बाल्यकाल की कथा',
      'titleGu': 'બાળ કાંડ',
      'subtitleGu': 'બાળપણની કથા',
    },
    {
      'number': '2',
      'titleEn': 'Ayodhya Kanda',
      'subtitleEn': 'The Book of Ayodhya',
      'titleHi': 'अयोध्या काण्ड',
      'subtitleHi': 'अयोध्या की कथा',
      'titleGu': 'અયોધ્યા કાંડ',
      'subtitleGu': 'અયોધ્યાની કથા',
    },
    {
      'number': '3',
      'titleEn': 'Aranya Kanda',
      'subtitleEn': 'The Book of the Forest',
      'titleHi': 'अरण्य काण्ड',
      'subtitleHi': 'वनवास की कथा',
      'titleGu': 'અરણ્ય કાંડ',
      'subtitleGu': 'વનવાસની કથા',
    },
    {
      'number': '4',
      'titleEn': 'Kishkindha Kanda',
      'subtitleEn': 'The Book of Kishkindha',
      'titleHi': 'किष्किन्धा काण्ड',
      'subtitleHi': 'सुग्रीव और हनुमान मिलन',
      'titleGu': 'કિષ્કિંધા કાંડ',
      'subtitleGu': 'સુગ્રીવ અને હનુમાન મિલન',
    },
    {
      'number': '5',
      'titleEn': 'Sundara Kanda',
      'subtitleEn': 'The Book of Beauty',
      'titleHi': 'सुन्दर काण्ड',
      'subtitleHi': 'हनुमान जी की लंका यात्रा',
      'titleGu': 'સુંદર કાંડ',
      'subtitleGu': 'હનુમાનજીની લંકા યાત્રા',
    },
    {
      'number': '6',
      'titleEn': 'Yuddha Kanda',
      'subtitleEn': 'The Book of War',
      'titleHi': 'युद्ध काण्ड',
      'subtitleHi': 'लंका युद्ध और विजय',
      'titleGu': 'યુદ્ધ કાંડ',
      'subtitleGu': 'લંકા યુદ્ધ અને વિજય',
    },
    {
      'number': '7',
      'titleEn': 'Uttara Kanda',
      'subtitleEn': 'The Final Book',
      'titleHi': 'उत्तर काण्ड',
      'subtitleHi': 'उत्तर गाथा और राम राज्य',
      'titleGu': 'ઉત્તર કાંડ',
      'subtitleGu': 'ઉત્તર ગાથા અને રામ રાજ્ય',
    },
  ];

  static const Map<int, int> _kandaSargaCounts = {
    1: 77,  // Bala Kanda
    2: 119, // Ayodhya Kanda
    3: 75,  // Aranya Kanda
    4: 67,  // Kishkindha Kanda
    5: 68,  // Sundara Kanda
    6: 128, // Yuddha Kanda
    7: 111, // Uttara Kanda
  };

  String _getKandaTitle(Map<String, String> kanda, String langCode) {
    if (langCode == 'gu') return kanda['titleGu']!;
    if (langCode == 'hi') return kanda['titleHi']!;
    return kanda['titleEn']!;
  }

  String _getKandaSubtitle(Map<String, String> kanda, String langCode) {
    if (langCode == 'gu') return kanda['subtitleGu']!;
    if (langCode == 'hi') return kanda['subtitleHi']!;
    return kanda['subtitleEn']!;
  }

  String _formatNumber(int number, String langCode) {
    return number.toString();
  }

  List<SacredChapterModel> _getSargasForKanda(List<SacredChapterModel> allChapters, int kandaNumber) {
    final filtered = allChapters.where((chap) {
      if (chap.chapterNumber >= 1000) {
        return (chap.chapterNumber ~/ 1000) == kandaNumber;
      }
      final title = chap.title.toLowerCase();
      final sub = chap.subtitle.toLowerCase();
      switch (kandaNumber) {
        case 1: return title.contains('bala') || sub.contains('bala');
        case 2: return title.contains('ayodhya') || sub.contains('ayodhya');
        case 3: return title.contains('aranya') || sub.contains('aranya');
        case 4: return title.contains('kishkindha') || sub.contains('kishkindha');
        case 5: return title.contains('sundara') || sub.contains('sundara');
        case 6: return title.contains('yuddha') || sub.contains('yuddha');
        case 7: return title.contains('uttara') || sub.contains('uttara');
        default: return false;
      }
    }).toList();

    if (filtered.isNotEmpty) return filtered;

    final sargaCount = _kandaSargaCounts[kandaNumber] ?? 77;
    final kandaMap = _ramayanaKandas[kandaNumber - 1];
    final kandaNameEn = kandaMap['titleEn'] ?? 'Kanda $kandaNumber';
    final kandaNameHi = kandaMap['titleHi'] ?? kandaNameEn;
    final kandaNameGu = kandaMap['titleGu'] ?? kandaNameEn;

    return List.generate(sargaCount, (idx) {
      final sargaNum = idx + 1;
      final compositeChapterNumber = (kandaNumber * 1000) + sargaNum;
      return SacredChapterModel(
        chapterNumber: compositeChapterNumber,
        title: 'Sarga $sargaNum',
        subtitle: '$kandaNameEn • Sarga $sargaNum',
        titleEn: 'Sarga $sargaNum',
        titleHi: 'सर्ग $sargaNum',
        titleGu: 'સર્ગ $sargaNum',
        subtitleEn: '$kandaNameEn • Sarga $sargaNum',
        subtitleHi: '$kandaNameHi • सर्ग $sargaNum',
        subtitleGu: '$kandaNameGu • સર્ગ $sargaNum',
        descriptionEnglish: 'Sarga $sargaNum of $kandaNameEn',
        descriptionHindi: '$kandaNameHi का सर्ग $sargaNum',
        descriptionGujarati: '$kandaNameGu નો સર્ગ $sargaNum',
        verses: const [],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<SacredBookModel?>(
      stream: SacredBooksRepository.streamBookById(widget.textId),
      builder: (context, snapshot) {
        final book = snapshot.data ?? SacredBooksData.findById(widget.textId);

        if (book == null) {
          return _bookNotFound(context, isDark);
        }

        final config = _BookUiConfig.fromBookId(book.id);
        final width = MediaQuery.sizeOf(context).width;

        final horizontalPadding = width >= 900
            ? 40.0
            : width >= 600
                ? 28.0
                : 20.0;

        final maxContentWidth = width >= 900 ? 900.0 : double.infinity;
        final langCode = context.watch<LocaleProvider>().languageCode;

        final isRamayana = book.id == 'ramayana';
        final isKandaSelected = isRamayana && _selectedKandaNumber != null;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF141714) : const Color(0xFFFAF7F2),
          bottomNavigationBar: CustomBottomNavigation(
            currentIndex: 0,
            onTap: (index) {
              context.read<NavigationProvider>().setIndex(index);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          body: SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: isRamayana && isKandaSelected
                    ? _buildDedicatedKandaView(
                        context: context,
                        book: book,
                        kandaNumber: _selectedKandaNumber!,
                        horizontalPadding: horizontalPadding,
                        maxContentWidth: maxContentWidth,
                        langCode: langCode,
                        isDark: isDark,
                      )
                    : _buildMainBookView(
                        context: context,
                        book: book,
                        config: config,
                        horizontalPadding: horizontalPadding,
                        maxContentWidth: maxContentWidth,
                        langCode: langCode,
                        isDark: isDark,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // DEDICATED KANDA SCREEN (MATCHES REFERENCE DESIGN EXACTLY)
  // ============================================================

  Widget _buildDedicatedKandaView({
    required BuildContext context,
    required SacredBookModel book,
    required int kandaNumber,
    required double horizontalPadding,
    required double maxContentWidth,
    required String langCode,
    required bool isDark,
  }) {
    final kandaMap = _ramayanaKandas[kandaNumber - 1];
    final kandaTitle = _getKandaTitle(kandaMap, langCode);
    final parentTitle = (langCode == 'gu')
        ? 'રામાયણ'
        : (langCode == 'hi' ? 'रामायण' : 'Ramayana');
    final sargasSectionTitle = (langCode == 'gu')
        ? 'સર્ગ પસંદ કરો'
        : (langCode == 'hi' ? 'सर्ग चुनें' : 'Select a Sarga');

    final sargas = _getSargasForKanda(book.chapters, kandaNumber);
    final iconColor = isDark ? const Color(0xFFE6E8E6) : const Color(0xFF1B1B1B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),

        // Top Action Bar with Back Arrow and Share Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding - 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (widget.initialKandaNumber != null) {
                    Navigator.of(context).maybePop();
                  } else {
                    setState(() {
                      _selectedKandaNumber = null;
                    });
                  }
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 26,
                  color: iconColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  final textToShare = '$kandaTitle — $parentTitle\n\nSanatan Scroll';
                  ShareService.showOptions(
                    context: context,
                    title: kandaTitle,
                    text: textToShare,
                  );
                },
                icon: Icon(
                  Icons.share_outlined,
                  size: 24,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Muted Parent Category Subtitle ("Ramayana")
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            parentTitle,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white60 : const Color(0xFF86867B),
            ),
          ),
        ),

        const SizedBox(height: 4),

        // Dedicated Kanda Name ("Bala Kanda", "Ayodhya Kanda", etc.)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            kandaTitle,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              height: 1.05,
              color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF18200F),
            ),
          ),
        ),

        const SizedBox(height: 28),

        // Section Heading ("Select a Sarga")
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            sargasSectionTitle,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF18200F),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Sarga List Cards
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              left: horizontalPadding,
              right: horizontalPadding,
              top: 4,
              bottom: 24,
            ),
            itemCount: sargas.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final sarga = sargas[index];
              return _buildSargaCard(
                context,
                book,
                sarga,
                index,
                kandaMap,
                _BookUiConfig.fromBookId('ramayana'),
                langCode,
                isDark,
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MAIN BOOK VIEW (LEVEL 1 / OTHER BOOKS)
  // ============================================================

  Widget _buildMainBookView({
    required BuildContext context,
    required SacredBookModel book,
    required _BookUiConfig config,
    required double horizontalPadding,
    required double maxContentWidth,
    required String langCode,
    required bool isDark,
  }) {
    final isRamayana = book.id == 'ramayana';

    String localizedTitle;
    String localizedSubtitle;
    String countText;

    if (isRamayana) {
      localizedTitle = (langCode == 'gu') ? 'રામાયણ' : (langCode == 'hi' ? 'रामायण' : 'Ramayana');
      localizedSubtitle = (langCode == 'gu') ? 'કર્તવ્યની મહાગાથા' : (langCode == 'hi' ? 'कर्तव्य की महागाथा' : 'The Epic of Duty');
      countText = (langCode == 'gu') ? '7 કાંડ' : (langCode == 'hi' ? '7 काण्ड' : '7 Kandas');
    } else if (book.id == 'upanishads') {
      localizedTitle = (langCode == 'gu') ? 'ઈશા ઉપનિષદ' : (langCode == 'hi' ? 'ईशावास्योपनिषद्' : 'Isha Upanishad');
      localizedSubtitle = (langCode == 'gu') ? 'આત્મજ્ઞાનનું ઉપદેશ' : (langCode == 'hi' ? 'आत्मज्ञान का उपदेश' : 'The Inner Teaching');
      countText = (langCode == 'gu') ? '18 મંત્ર' : (langCode == 'hi' ? '18 मंत्र' : '18 Mantras');
    } else if (book.id == 'bhagavad_gita' || book.id == 'gita') {
      localizedTitle = (langCode == 'gu') ? 'ભગવદ્ ગીતા' : (langCode == 'hi' ? 'भगवद् गीता' : 'Bhagavad Gita');
      localizedSubtitle = (langCode == 'gu') ? 'ભગવાન શ્રી કૃષ્ણનું દિવ્ય સંગીત' : (langCode == 'hi' ? 'भगवान श्री कृष्ण का दिव्य गीत' : 'The Divine Song of Lord Krishna');
      countText = (langCode == 'gu') ? '18 અધ્યાય' : (langCode == 'hi' ? '18 अध्याय' : '18 Chapters');
    } else {
      localizedTitle = book.getLocalizedTitle(langCode);
      final rawSubtitle = book.getLocalizedSubtitle(langCode);
      localizedSubtitle = rawSubtitle.isNotEmpty ? rawSubtitle : config.defaultSubtitle;
      final chapUnit = (langCode == 'gu') ? 'અધ્યાય' : (langCode == 'hi' ? 'अध्याय' : 'Chapters');
      countText = '${book.totalChapters} $chapUnit';
    }

    final iconColor = isDark ? const Color(0xFFE6E8E6) : const Color(0xFF1B1B1B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),

        // Top Action Bar with Back Arrow and Share Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding - 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: Icon(
                  Icons.arrow_back,
                  size: 26,
                  color: iconColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  final textToShare = '$localizedTitle — $localizedSubtitle\n\nSanatan Scroll';
                  ShareService.showOptions(
                    context: context,
                    title: localizedTitle,
                    text: textToShare,
                  );
                },
                icon: Icon(
                  Icons.share_outlined,
                  size: 24,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Book Header Artwork Card
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
            decoration: BoxDecoration(
              color: config.headerBgColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                // Text details on left
                Expanded(
                  flex: 58,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context).sacredScripture.toUpperCase(),
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2C1810),
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          localizedTitle,
                          maxLines: 1,
                          softWrap: false,
                          style: AppTextStyles.getFont(
                            context,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B1B1B),
                            height: 1.1,
                            isSerif: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        localizedSubtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF2E2218),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        countText,
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2C1810),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Artwork on right
                Expanded(
                  flex: 42,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      config.artworkAsset,
                      height: 140,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerRight,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Section Heading (Select a Kanda / Chapter / Mantra)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            isRamayana
                ? context.l10n.selectKanda
                : (book.id == 'upanishads' ? context.l10n.selectMantra : context.l10n.selectChapter),
            style: AppTypography.sectionHeading(
              langCode,
              color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF18392C),
            ).copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Cards List
        Expanded(
          child: isRamayana
              ? ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: 4,
                    bottom: 24,
                  ),
                  itemCount: 7,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final kandaMap = _ramayanaKandas[index];
                    return _buildKandaCard(
                      context,
                      kandaMap,
                      index,
                      config,
                      langCode,
                      isDark,
                    );
                  },
                )
              : Builder(
                  builder: (context) {
                    final List<SacredChapterModel> chaptersList = book.chapters;

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: horizontalPadding,
                        right: horizontalPadding,
                        top: 4,
                        bottom: 24,
                      ),
                      itemCount: chaptersList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final chapter = chaptersList[index];
                        return _buildChapterCard(
                          context,
                          book,
                          chapter,
                          index,
                          config,
                          langCode,
                          isDark,
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ============================================================
  // KANDA CARD (LEVEL 1: MAIN RAMAYANA PAGE - 7 KANDAS)
  // ============================================================

  Widget _buildKandaCard(
    BuildContext context,
    Map<String, String> kandaMap,
    int index,
    _BookUiConfig config,
    String langCode,
    bool isDark,
  ) {
    final title = _getKandaTitle(kandaMap, langCode);
    final subtitle = _getKandaSubtitle(kandaMap, langCode);
    final kandaNum = index + 1;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedKandaNumber = kandaNum;
          });
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF222722) : const Color(0xFFFFF9F0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? Colors.white12 : const Color(0xFFF0E6D8),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Kanda Number Badge
              Container(
                width: 58,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2E3824) : config.badgeBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  _formatNumber(kandaNum, langCode),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.getFont(
                    context,
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFFA5B888) : config.badgeTextColor,
                    height: 1,
                    isSerif: true,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Center Kanda Title & Subtitle
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.cardTitle(
                        langCode,
                        color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF141814),
                      ).copyWith(
                        fontSize: 20,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.compact(
                        langCode,
                        color: isDark ? Colors.white60 : const Color(0xFF666666),
                      ).copyWith(
                        fontSize: 13.5,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Right Arrow Chevron
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.white60 : const Color(0xFF23180C),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SARGA CARD (DEDICATED KANDA SCREEN)
  // ============================================================

  Widget _buildSargaCard(
    BuildContext context,
    SacredBookModel book,
    SacredChapterModel sarga,
    int index,
    Map<String, String> kandaMap,
    _BookUiConfig config,
    String langCode,
    bool isDark,
  ) {
    final sargaNumber = index + 1;
    final kandaTitle = _getKandaTitle(kandaMap, langCode);
    final sargaPrefix = (langCode == 'gu') ? 'સર્ગ' : (langCode == 'hi' ? 'सर्ग' : 'Sarga');
    final sargaNumStr = _formatNumber(sargaNumber, langCode);
    final sargaTitle = '$kandaTitle - $sargaPrefix $sargaNumStr';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final auth = context.read<AuthProvider>();
          final guestAccess = context.read<GuestAccessProvider>();

          if (!guestAccess.canOpenChapter(
            isAuthenticated: auth.isAuthenticated,
          )) {
            _showSignInPrompt(context, isDark);
            return;
          }

          Navigator.of(context).pushNamed(
            AppRoutes.sacredTextReading,
            arguments: {
              'textId': book.id,
              'chapterNumber': sarga.chapterNumber,
            },
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF222722) : const Color(0xFFFFFDF8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white12 : const Color(0xFFE8E4D8),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.015),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Sarga Number Badge (Sage green rounded box matching reference)
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2E3824) : const Color(0xFFE1E5D3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  sargaNumStr,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFA5B888) : const Color(0xFF2F401E),
                    height: 1,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Center Sarga Title
              Expanded(
                child: Text(
                  sargaTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF18200F),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Right Arrow Chevron
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.white54 : const Color(0xFF666666),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChapterCard(
    BuildContext context,
    SacredBookModel book,
    SacredChapterModel chapter,
    int index,
    _BookUiConfig config,
    String langCode,
    bool isDark,
  ) {
    final bool isUpanishad = book.id == 'upanishads';
    final String numStr = _formatNumber(chapter.chapterNumber, langCode);

    String chapterTitle;
    String chapterSubtitle;

    if (isUpanishad) {
      final mantraPrefix = (langCode == 'gu') ? 'મંત્ર' : (langCode == 'hi' ? 'मंत्र' : 'Mantra');
      chapterTitle = '$mantraPrefix $numStr';
      chapterSubtitle = '';
    } else if (book.id == 'bhagavad_gita' || book.id == 'gita') {
      chapterTitle = chapter.getLocalizedTitle(langCode);
      final code = langCode.toLowerCase().split('-').first.split('_').first.trim();
      if (code == 'gu') {
        chapterSubtitle = 'ભગવદ્ ગીતા અધ્યાય $numStr';
      } else if (code == 'hi') {
        chapterSubtitle = 'भगवद् गीता अध्याय $numStr';
      } else {
        chapterSubtitle = 'Bhagavad Gita Chapter ${chapter.chapterNumber}';
      }
    } else {
      chapterTitle = chapter.getLocalizedTitle(langCode);
      chapterSubtitle = chapter.getLocalizedSubtitle(langCode);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final auth = context.read<AuthProvider>();
          final guestAccess = context.read<GuestAccessProvider>();

          if (!guestAccess.canOpenChapter(
            isAuthenticated: auth.isAuthenticated,
          )) {
            _showSignInPrompt(context, isDark);
            return;
          }

          Navigator.of(context).pushNamed(
            AppRoutes.sacredTextReading,
            arguments: {
              'textId': book.id,
              'chapterNumber': chapter.chapterNumber,
            },
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF222722) : const Color(0xFFFFF9F0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? Colors.white12 : const Color(0xFFF0E6D8),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Chapter Number Badge
              Container(
                width: 58,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2E3824) : config.badgeBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  numStr,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.getFont(
                    context,
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFFA5B888) : config.badgeTextColor,
                    height: 1,
                    isSerif: true,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Center Chapter Title & Subtitle
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapterTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.cardTitle(
                        langCode,
                        color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF141814),
                      ).copyWith(
                        fontSize: 20,
                        height: 1.1,
                      ),
                    ),
                    if (chapterSubtitle.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        chapterSubtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.compact(
                          langCode,
                          color: isDark ? Colors.white60 : const Color(0xFF666666),
                        ).copyWith(
                          fontSize: 13.5,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Right Arrow Chevron
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.white60 : const Color(0xFF23180C),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookNotFound(BuildContext context, bool isDark) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF141714) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? const Color(0xFFE6E8E6) : const Color(0xFF1B1B1B),
          ),
        ),
      ),
      body: Center(
        child: Text(
          AppLocalizations.of(context).scriptureNotFound,
          style: TextStyle(
            color: isDark ? const Color(0xFFE6E8E6) : const Color(0xFF1B1B1B),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showSignInPrompt(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);
    final langCode = context.read<LocaleProvider>().languageCode;

    final titleText = (langCode == 'gu')
        ? 'સાઇન ઇન કરવું જરૂરી છે'
        : (langCode == 'hi' ? 'साइन इन आवश्यक है' : 'Sign In Required');

    final messageText = (langCode == 'gu')
        ? 'વધુ પ્રકરણો વાંચવા અને તમારી પ્રગતિ ટ્રેક કરવા માટે સાઇન ઇન કરો.'
        : (langCode == 'hi'
            ? 'अधिक अध्याय पढ़ने और अपनी प्रगति ट्रैक करने के लिए साइन इन करें।'
            : 'Please sign in to access more chapters and track your reading progress.');

    final maybeLaterText = (langCode == 'gu')
        ? 'પછીથી'
        : (langCode == 'hi' ? 'बाद में' : 'Maybe Later');

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? const Color(0xFF202020) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                titleText,
                style: AppTextStyles.getFont(
                  context,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                  isSerif: true,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                messageText,
                textAlign: TextAlign.center,
                style: AppTextStyles.getFont(
                  context,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(maybeLaterText),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pushNamed(AppRoutes.auth);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC85A32),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.signIn,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BookUiConfig {
  final Color headerBgColor;
  final Color badgeBgColor;
  final Color badgeTextColor;
  final String artworkAsset;
  final String defaultSubtitle;
  final String sectionTitle;
  final String Function(int count) unitName;

  const _BookUiConfig({
    required this.headerBgColor,
    required this.badgeBgColor,
    required this.badgeTextColor,
    required this.artworkAsset,
    required this.defaultSubtitle,
    required this.sectionTitle,
    required this.unitName,
  });

  factory _BookUiConfig.fromBookId(String bookId) {
    switch (bookId) {
      case 'ramayana':
        return _BookUiConfig(
          headerBgColor: const Color(0xFF94AA84),
          badgeBgColor: const Color(0xFFE2ECCB),
          badgeTextColor: const Color(0xFF2F401E),
          artworkAsset: 'assets/images/ramayana_bow_art.png',
          defaultSubtitle: 'The Epic of Duty',
          sectionTitle: 'Select a Kanda',
          unitName: (c) => c == 1 ? 'Kanda' : 'Kandas',
        );

      case 'mahabharata':
        return _BookUiConfig(
          headerBgColor: const Color(0xFFE5A855),
          badgeBgColor: const Color(0xFFFBE5C5),
          badgeTextColor: const Color(0xFF4A3210),
          artworkAsset: 'assets/images/mahabharat_page.png',
          defaultSubtitle: 'The Epic of Dharma & Duty',
          sectionTitle: 'Select a Chapter',
          unitName: (c) => c == 1 ? 'Chapter' : 'Chapters',
        );

      case 'upanishads':
        return _BookUiConfig(
          headerBgColor: const Color(0xFFF2B75B),
          badgeBgColor: const Color(0xFFFDECDA),
          badgeTextColor: const Color(0xFF4A2C10),
          artworkAsset: 'assets/images/upanishad_leaf_art.png',
          defaultSubtitle: 'The Inner Teaching',
          sectionTitle: 'Select a Mantra',
          unitName: (c) => c == 1 ? 'Mantra' : 'Mantras',
        );

      case 'bhagavad_gita':
      default:
        return _BookUiConfig(
          headerBgColor: const Color(0xFFE47A46),
          badgeBgColor: const Color(0xFFFDECDA),
          badgeTextColor: const Color(0xFF5A2A10),
          artworkAsset: 'assets/images/bhagavat_gita_big.png',
          defaultSubtitle: 'The Divine Song of Lord Krishna',
          sectionTitle: 'Select a Chapter',
          unitName: (c) => c == 1 ? 'Chapter' : 'Chapters',
        );
    }
  }
}