import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_typography.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/share_service.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../providers/locale_provider.dart';
import '../../../../providers/navigation_provider.dart';
import '../../../../providers/reading_progress_provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ReadingProgressProvider>().setLastReadBookId(widget.bookId);
      }
    });
  }

  // ============================================================
  // BOOK INFORMATION
  // ============================================================

  String _getLocalizedTitle(BuildContext context) {
    final langCode = context.watch<LocaleProvider>().languageCode;
    switch (widget.bookId) {
      case 'ramayana':
        return context.l10n.ramayana;
      case 'upanishads':
        if (langCode == 'gu') return 'ઇશોપનિષદ';
        if (langCode == 'hi') return 'ईशोपनिषद्';
        return 'Isha Upanishad';
      case 'mahabharata':
        return context.l10n.mahabharata;
      case 'bhagavad_gita':
      default:
        return context.l10n.bhagavadGita;
    }
  }

  String _getHeroArtwork(String bookId) {
    switch (bookId) {
      case 'ramayana':
        return 'assets/images/ramayana_bow_art.png';
      case 'upanishads':
        return 'assets/images/upanishad_leaf_art.png';
      case 'mahabharata':
        return 'assets/images/mahabharat_page.png';
      case 'bhagavad_gita':
      default:
        return 'assets/images/bhagavat_gita_big.png';
    }
  }

  String _getLocalizedSubtitle(BuildContext context) {
    final l10n = context.l10n;
    switch (widget.bookId) {
      case 'ramayana':
        return l10n.ramayanaSubtitle;
      case 'upanishads':
        return l10n.upanishadsSubtitle;
      case 'mahabharata':
        return l10n.mahabharataSubtitle;
      case 'bhagavad_gita':
      default:
        return l10n.gitaSubtitle;
    }
  }

  String _getLocalizedAbout(BuildContext context) {
    final langCode = context.watch<LocaleProvider>().languageCode;
    switch (widget.bookId) {
      case 'ramayana':
        if (langCode == 'gu') {
          return 'રામાયણ એ એક પ્રાચીન સંસ્કૃત મહાકાવ્ય છે જે ભગવાન શ્રી રામના જીવન, ધર્મ પ્રત્યેની તેમની અટલ નિષ્ઠા, વનવાસ, રાવણ સામેના યુદ્ધ અને અયોધ્યા પાછા ફરવાની કથા વર્ણવે છે. આ ધર્મનિષ્ઠ જીવન, આદર્શ નેતૃત્વ, વફાદારી, પ્રેમ અને ભક્તિનું સદાબહાર માર્ગદર્શક છે.';
        } else if (langCode == 'hi') {
          return 'रामायण एक प्राचीन संस्कृत महाकाव्य है जो भगवान श्री राम के जीवन, धर्म के प्रति उनकी अटूट निष्ठा, वनवास, रावण के विरुद्ध युद्ध और अयोध्या वापसी की कथा का वर्णन करता है। यह धर्मपरायण जीवन, आदर्श नेतृत्व, निष्ठा, प्रेम और भक्ति का शाश्वत मार्गदर्शक है।';
        }
        return 'The Ramayana is an ancient Sanskrit epic that narrates the life of Lord Rama, his unwavering commitment to dharma, his exile, the battle against Ravana, and his return to Ayodhya. It is a timeless guide to righteous living, ideal leadership, loyalty, love and devotion.';
      case 'upanishads':
        if (langCode == 'gu') {
          return 'ઈશાવાસ્યોપનિષદ એ એક અત્યંત ગૂઢ અને સંક્ષિપ્ત સંસ્કૃત ગ્રંથ છે જે સમસ્ત અસ્તિત્વની મૂળભૂત એકતા, આત્માનું સ્વરૂપ, અને વિવેક, અનાસક્તિ તથા સદ્ભાવ સાથે જગતમાં જીવવાનો માર્ગ પ્રગટ કરે છે.';
        } else if (langCode == 'hi') {
          return 'ईशावास्योपनिषद् एक अत्यंत गूढ़ और संक्षिप्त संस्कृत ग्रन्थ है जो समस्त अस्तित्व की मूलभूत एकता, आत्मा के स्वरूप, और विवेक, अनासक्ति तथा सद्भाव के साथ जगत् में जीने का मार्ग प्रकट करता है।';
        }
        return 'The Isha Upanishad is a profound and concise Sanskrit text that reveals the essential unity of all existence, the nature of the Self, and the path to live in the world with wisdom, detachment and harmony.';
      case 'mahabharata':
        if (langCode == 'gu') {
          return 'મહાભારત વિશ્વના સૌથી લાંબા મહાકાવ્યોમાંનું એક છે, જે ભારત વંશની કથા વર્ણવે છે. તે ધર્મ, રાજનીતિ, નૈતિકતા, અધ્યાત્મ અને માનવ જીવન વિશે જ્ઞાનનો મહાન ખજાનો છે.';
        } else if (langCode == 'hi') {
          return 'महाभारत विश्व के सबसे लंबे महाकाव्यों में से एक है, जो भारत वंश की गाथा का वर्णन करता है। यह धर्म, राजनीति, नैतिकता, अध्यात्म और मानव जीवन के ज्ञान का शाश्वत खजाना है।';
        }
        return 'The Mahabharata is one of the world’s longest epic poems, narrating the story of the Bharata dynasty. It is a timeless treasure trove of wisdom on dharma, politics, morality, spirituality, and the human condition.';
      case 'bhagavad_gita':
      default:
        if (langCode == 'gu') {
          return 'ભગવદ્ ગીતા એ ૭૦૦ શ્લોકોનું હિન્દુ શાસ્ત્ર છે જે મહાભારત મહાકાવ્યનો એક ભાગ છે. તે રણભૂમિમાં કુરુક્ષેત્ર ખાતે ભગવાન શ્રીકૃષ્ણ અને અર્જુન વચ્ચેનો સંવાદ છે, જેમાં ધર્મ, ભક્તિ, જ્ઞાન અને નિષ્કામ કરમનો ઉપદેશ આપ્યો છે.';
        } else if (langCode == 'hi') {
          return 'भगवद् गीता ७०० श्लोकों का हिंदू शास्त्र है जो महाभारत महाकाव्य का एक भाग है। यह कुरुक्षेत्र के युद्धक्षेत्र में भगवान श्रीकृष्ण और अर्जुन के बीच का संवाद है, जिसमें धर्म, भक्ति, ज्ञान और निष्काम कर्म का उपदेश दिया गया है।';
        }
        return 'The Bhagavad Gita is a 700-verse Hindu scripture that is part of the epic Mahabharata. It is a conversation between Lord Krishna and Arjuna on the battlefield, covering dharma, devotion, knowledge and selfless action.';
    }
  }

  List<_TeachingChipData> _getLocalizedTeachings(BuildContext context) {
    final langCode = context.watch<LocaleProvider>().languageCode;
    switch (widget.bookId) {
      case 'ramayana':
        return [
          _TeachingChipData(langCode == 'gu' ? 'ધર્મ' : (langCode == 'hi' ? 'धर्म' : 'Dharma'), color: const Color(0xFFE4E8D5)),
          _TeachingChipData(langCode == 'gu' ? 'ભક્તિ' : (langCode == 'hi' ? 'भक्ति' : 'Devotion'), color: const Color(0xFFE4E8D5)),
          _TeachingChipData(langCode == 'gu' ? 'સંબંધો' : (langCode == 'hi' ? 'संबंध' : 'Relationships'), color: const Color(0xFFE4E8D5)),
          _TeachingChipData(langCode == 'gu' ? 'કર્તવ્ય અને ત્યાગ' : (langCode == 'hi' ? 'कर्तव्य एवं त्याग' : 'Duty & Sacrifice'), color: const Color(0xFFE4E8D5)),
          _TeachingChipData(langCode == 'gu' ? 'આદર્શ નેતૃત્વ' : (langCode == 'hi' ? 'आदर्श नेतृत्व' : 'Righteous Leadership'), color: const Color(0xFFE4E8D5)),
        ];

      case 'upanishads':
        return [
          _TeachingChipData(langCode == 'gu' ? 'આત્મા (Self)' : (langCode == 'hi' ? 'आत्मा (Self)' : 'Self'), color: const Color(0xFFE4E8D5)),
          _TeachingChipData(langCode == 'gu' ? 'કર્મ (Action)' : (langCode == 'hi' ? 'कर्म (Action)' : 'Action'), color: const Color(0xFFFDECDA)),
          _TeachingChipData(langCode == 'gu' ? 'સન્યાસ (Renunciation)' : (langCode == 'hi' ? 'संन्यास (Renunciation)' : 'Renunciation'), color: const Color(0xFFFDF4DA)),
          _TeachingChipData(langCode == 'gu' ? 'જ્ઞાન (Knowledge)' : (langCode == 'hi' ? 'ज्ञान (Knowledge)' : 'Knowledge'), color: const Color(0xFFE4E8D5)),
          _TeachingChipData(langCode == 'gu' ? 'ઈશ્વર (The Divine)' : (langCode == 'hi' ? 'ईश्वर (The Divine)' : 'The Divine'), color: const Color(0xFFFDECDA)),
        ];

      case 'mahabharata':
        return [
          _TeachingChipData(langCode == 'gu' ? 'ધર્મ' : (langCode == 'hi' ? 'धर्म' : 'Dharma'), color: const Color(0xFFE4E8D5)),
          _TeachingChipData(langCode == 'gu' ? 'કર્મ' : (langCode == 'hi' ? 'कर्म' : 'Karma'), color: const Color(0xFFFDECDA)),
          _TeachingChipData(langCode == 'gu' ? 'ભક્તિ' : (langCode == 'hi' ? 'भक्ति' : 'Bhakti'), color: const Color(0xFFFDF4DA)),
          _TeachingChipData(langCode == 'gu' ? 'જીવનનો ઉપદેશ' : (langCode == 'hi' ? 'जीवन का उपदेश' : 'Life Lessons'), color: const Color(0xFFE4E8D5)),
        ];

      case 'bhagavad_gita':
      default:
        return [
          _TeachingChipData(langCode == 'gu' ? 'ધર્મ' : (langCode == 'hi' ? 'धर्म' : 'Dharma'), color: const Color(0xFFE4E8D5)),
          _TeachingChipData(langCode == 'gu' ? 'કર્મ' : (langCode == 'hi' ? 'कर्म' : 'Karma'), color: const Color(0xFFFDECDA)),
          _TeachingChipData(langCode == 'gu' ? 'ભક્તિ' : (langCode == 'hi' ? 'भक्ति' : 'Bhakti'), color: const Color(0xFFFDF4DA)),
          _TeachingChipData(langCode == 'gu' ? 'નિષ્કામ કર્મ' : (langCode == 'hi' ? 'निष्काम कर्म' : 'Selfless Action'), color: const Color(0xFFE4E8D5)),
        ];
    }
  }

  // ============================================================
  // HERO CARD THEME COLORS
  // ============================================================

  Color get _cardBgColor {
    switch (widget.bookId) {
      case 'ramayana':
        return const Color(0xFF8A9A78);
      case 'upanishads':
        return const Color(0xFFE5B869);
      case 'mahabharata':
        return const Color(0xFFD6A350);
      case 'bhagavad_gita':
      default:
        return const Color(0xFFE47A46);
    }
  }

  Color get _cardHeaderTextColor {
    switch (widget.bookId) {
      case 'ramayana':
        return const Color(0xFF2E3D1E);
      case 'upanishads':
        return const Color(0xFF5D4219);
      case 'mahabharata':
        return const Color(0xFF3D2E14);
      case 'bhagavad_gita':
      default:
        return const Color(0xFF3D1F14);
    }
  }

  Color get _cardTitleColor {
    return const Color(0xFF1B1B1B);
  }

  Color get _cardSubtitleColor {
    return const Color(0xFF2D2D2D);
  }

  Color get _buttonColor {
    switch (widget.bookId) {
      case 'ramayana':
        return const Color(0xFF495736);
      case 'upanishads':
        return const Color(0xFFB87635);
      case 'mahabharata':
        return const Color(0xFFC8932A);
      case 'bhagavad_gita':
      default:
        return const Color(0xFFE47A46);
    }
  }

  // ============================================================
  // STATS
  // ============================================================

  List<_StatItem> get _stats {
    switch (widget.bookId) {
      case 'ramayana':
        return const [
          _StatItem(value: '7', label: 'Kandas'),
          _StatItem(value: '24,000', label: 'Verses'),
        ];
      case 'upanishads':
        return const [
          _StatItem(value: '18', label: 'Mantras'),
        ];
      case 'mahabharata':
        return const [
          _StatItem(value: '18', label: 'Parvas'),
          _StatItem(value: '100,000+', label: 'Verses'),
        ];
      case 'bhagavad_gita':
      default:
        return const [
          _StatItem(value: '18', label: 'Chapters'),
          _StatItem(value: '700', label: 'Verses'),
        ];
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF141714) : const Color(0xFFFAF7F2),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Action Bar
            _buildTopBar(isDark),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),

                    // Combined Hero Header & Stats Card
                    _buildHeroCard(context, isDark),

                    const SizedBox(height: 24),

                    // About this text
                    _buildAboutSection(context, isDark),

                    const SizedBox(height: 24),

                    // Key Teachings
                    _buildTeachingsSection(context, isDark),

                    const SizedBox(height: 32),

                    // Start Reading Button
                    _buildStartReadingButton(context),

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
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar(bool isDark) {
    final iconColor = isDark ? const Color(0xFFE6E8E6) : const Color(0xFF1B1B1B);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
            splashRadius: 24,
          ),
          IconButton(
            onPressed: _shareBook,
            icon: Icon(
              Icons.share_outlined,
              size: 24,
              color: iconColor,
            ),
            splashRadius: 24,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HERO CARD WITH EMBEDDED STATS
  // ============================================================

  Widget _buildHeroCard(BuildContext context, bool isDark) {
    final labelText = AppLocalizations.of(context).sacredScripture;

    final stats = _stats;
    final title = _getLocalizedTitle(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Colored Top Hero Banner
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 40),
          decoration: BoxDecoration(
            color: _cardBgColor,
            borderRadius: BorderRadius.circular(26),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Stack(
              children: [
                // Text Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 126, 55),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        labelText,
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 11,
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
                          title,
                          maxLines: 1,
                          softWrap: false,
                          style: AppTextStyles.getFont(
                            context,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                            color: _cardTitleColor,
                            isSerif: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getLocalizedSubtitle(context),
                        style: AppTextStyles.getFont(
                          context,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: _cardSubtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Illustration: replaced white badge with supplied asset
                Positioned(
                  right: 4,
                  bottom: 4,
                  top: 4,
                  width: 145,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      _getHeroArtwork(widget.bookId),
                      fit: BoxFit.contain,
                      alignment: Alignment.centerRight,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Overlapping White/Cream Stats Box Container
        Positioned(
          left: 14,
          right: 14,
          bottom: 0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF222722) : const Color(0xFFFFFDF9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: List.generate(stats.length, (index) {
                final stat = stats[index];
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              stat.value,
                              style: AppTextStyles.getFont(
                                context,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B),
                                isSerif: true,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              stat.label,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.getFont(
                                context,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: isDark ? Colors.white60 : const Color(0xFF555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index < stats.length - 1)
                        Container(
                          width: 1,
                          height: 34,
                          color: isDark ? Colors.white24 : const Color(0xFFEAE2D2),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ABOUT SECTION
  // ============================================================

  Widget _buildAboutSection(BuildContext context, bool isDark) {
    final langCode = context.watch<LocaleProvider>().languageCode;
    final headingTitle = langCode == 'gu'
        ? 'આ ગ્રંથ વિશે'
        : (langCode == 'hi' ? 'इस ग्रंथ के बारे में' : 'About this text');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headingTitle,
            style: AppTypography.sectionHeading(
              langCode,
              color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF18392C),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _getLocalizedAbout(context),
            style: AppTypography.body(
              langCode,
              color: isDark ? const Color(0xFFD0D4D0) : const Color(0xFF18392C),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KEY TEACHINGS SECTION
  // ============================================================

  Widget _buildTeachingsSection(BuildContext context, bool isDark) {
    final langCode = context.watch<LocaleProvider>().languageCode;
    final teachingsTitle = langCode == 'gu'
        ? 'મુખ્ય ઉપદેશો'
        : (langCode == 'hi' ? 'मुख्य उपदेश' : 'Key Teachings');
    final teachingsList = _getLocalizedTeachings(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            teachingsTitle,
            style: AppTypography.sectionHeading(
              langCode,
              color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF18392C),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: teachingsList.map((chip) {
              final chipBg = isDark ? const Color(0xFF2A322A) : chip.color;
              final textColor = isDark ? const Color(0xFFE6E8E6) : const Color(0xFF1B1B1B);

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  chip.text,
                  style: AppTextStyles.getFont(
                    context,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
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

  Widget _buildStartReadingButton(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _openChapterList,
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.startReading,
              style: AppTextStyles.getFont(
                context,
                fontSize: 16.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward,
              size: 20,
              color: Colors.white,
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
      activeColor: _buttonColor,
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
    final title = _getLocalizedTitle(context);
    final subtitle = _getLocalizedSubtitle(context);
    final aboutText = _getLocalizedAbout(context);
    ShareService.showOptions(
      context: context,
      title: title,
      text: '$title — $subtitle\n\n$aboutText\n\nSanatan Scroll',
    );
  }
}

// ============================================================
// HELPER MODELS
// ============================================================

class _StatItem {
  final String value;
  final String label;

  const _StatItem({
    required this.value,
    required this.label,
  });
}

class _TeachingChipData {
  final String text;
  final Color color;

  const _TeachingChipData(
    this.text, {
    required this.color,
  });
}

