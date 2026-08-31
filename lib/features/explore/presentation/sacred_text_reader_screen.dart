import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/share_service.dart';
import '../../../../data/sacred_books_repository.dart';
import '../../../../models/sacred_book_model.dart';
import '../../../../models/sacred_chapter_model.dart';
import '../../../../models/sacred_verse_model.dart';
import '../../../../models/saved_item_model.dart';
import '../../../../providers/chapter_completion_provider.dart';
import '../../../../providers/locale_provider.dart';
import '../../../../providers/reading_progress_provider.dart';
import '../../../../providers/saved_provider.dart';
import 'widgets/reading_context_card.dart';
import 'widgets/reading_reflection_card.dart';
import 'widgets/reading_wisdom_card.dart';

class SacredTextReaderScreen extends StatefulWidget {
  const SacredTextReaderScreen({
    super.key,
    required this.textId,
    this.initialChapterNumber = 1,
  });

  final String textId;
  final int initialChapterNumber;

  @override
  State<SacredTextReaderScreen> createState() => _SacredTextReaderScreenState();
}

class _SacredTextReaderScreenState extends State<SacredTextReaderScreen> {
  late final Future<SacredBookModel?> _bookFuture;
  late final PageController _pageController;
  late final FlutterTts _tts;
  bool _isSpeaking = false;
  String? _lastAudioLangCode;

  late int currentChapter;

  @override
  void initState() {
    super.initState();
    currentChapter = widget.initialChapterNumber;
    _bookFuture = SacredBooksRepository.fetchBookById(widget.textId);
    _pageController = PageController();
    _tts = FlutterTts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLang = context.read<LocaleProvider>().languageCode;
    if (_lastAudioLangCode != null && _lastAudioLangCode != currentLang) {
      if (_isSpeaking) {
        _tts.stop();
        _isSpeaking = false;
      }
    }
    _lastAudioLangCode = currentLang;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _toggleAudio(String text, String langCode) async {
    if (_isSpeaking) {
      await _tts.stop();
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    } else {
      if (langCode == 'hi') {
        await _tts.setLanguage('hi-IN');
      } else if (langCode == 'gu') {
        await _tts.setLanguage('gu-IN');
      } else {
        await _tts.setLanguage('en-US');
      }
      await _tts.speak(text);
      if (mounted) {
        setState(() {
          _isSpeaking = true;
        });
      }

      _tts.setCompletionHandler(() {
        if (mounted) {
          setState(() {
            _isSpeaking = false;
          });
        }
      });
    }
  }

  String _buildFullPageAudioContent({
    required SacredBookModel book,
    required SacredChapterModel chapter,
    required SacredVerseModel verse,
    required String langCode,
  }) {
    final bookTitle = book.getLocalizedTitle(langCode);
    final intro = '$bookTitle, Chapter ${chapter.chapterNumber}, Verse ${verse.verseNumber}.';
    final quote = verse.getQuoteText(langCode);
    final sanskrit = verse.sanskrit.isNotEmpty ? 'Sanskrit verse: ${verse.sanskrit}.' : '';
    final translation = 'Translation: ${verse.getLocalizedTranslation(langCode)}.';
    final contextText = verse.getContextText(langCode).isNotEmpty
        ? 'Context: ${verse.getContextText(langCode)}.'
        : '';

    return '$intro $quote $sanskrit $translation $contextText';
  }

  void _shareVerse({
    required SacredBookModel book,
    required SacredChapterModel chapter,
    required SacredVerseModel verse,
    required String langCode,
  }) {
    final title = '${book.getLocalizedTitle(langCode)} - Chapter ${chapter.chapterNumber}, Verse ${verse.verseNumber}';
    final content = '${verse.getQuoteText(langCode)}\n\n${verse.getLocalizedTranslation(langCode)}';

    ShareService.showOptions(
      context: context,
      title: title,
      text: '$title\n\n$content',
    );
  }

  void _saveProgress(int chapterNumber, int verseNumber) {
    context.read<ReadingProgressProvider>().savePosition(
          bookId: widget.textId,
          chapterNumber: chapterNumber,
          verseNumber: verseNumber,
        );
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final langCode = localeProvider.languageCode;
    final savedProvider = context.watch<SavedProvider>();
    final isBhagavadGita = (widget.textId == 'bhagavad_gita');
    final cardsPerVerse = isBhagavadGita ? 3 : 2;

    return FutureBuilder<SacredBookModel?>(
      future: _bookFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFFAF7F2),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFC85A32),
              ),
            ),
          );
        }

        final book = snapshot.data;
        if (book == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFFAF7F2),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFF1B1B1B)),
            ),
            body: Center(
              child: Text(
                'Scripture not found',
                style: AppLocalizations.of(context).appName.isNotEmpty
                    ? Theme.of(context).textTheme.titleMedium
                    : null,
              ),
            ),
          );
        }

        final chapter = book.getChapter(currentChapter);
        if (chapter == null || chapter.verses.isEmpty) {
          return Scaffold(
            backgroundColor: const Color(0xFFFAF7F2),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFF1B1B1B)),
            ),
            body: const Center(
              child: Text('No verses available for this chapter.'),
            ),
          );
        }

        final totalPages = chapter.verses.length * cardsPerVerse;

        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: totalPages,
          onPageChanged: (pageIndex) {
            final verseIndex = pageIndex ~/ cardsPerVerse;
            _saveProgress(currentChapter, verseIndex + 1);

            if (verseIndex == chapter.verses.length - 1) {
              context.read<ChapterCompletionProvider>().markCompleted(
                    bookTitle: book.title,
                    chapterTitle: chapter.title,
                    bookId: book.id,
                    chapterNumber: chapter.chapterNumber,
                  );
            }
          },
          itemBuilder: (context, pageIndex) {
            final verseIndex = pageIndex ~/ cardsPerVerse;
            final cardTypeIndex = pageIndex % cardsPerVerse;
            final verse = chapter.verses[verseIndex];

            final savedItem = SavedItemModel(
              id: '${book.id}_c${chapter.chapterNumber}_v${verse.verseNumber}',
              type: SavedItemType.verse,
              title: '${book.getLocalizedTitle(langCode)} ${chapter.chapterNumber}.${verse.verseNumber}',
              content: verse.getQuoteText(langCode),
              source: book.getLocalizedTitle(langCode),
              savedAt: DateTime.now(),
            );

            final isSaved = savedProvider.isSaved(savedItem.id);

            void toggleSave() {
              savedProvider.toggleItem(savedItem);
            }

            // Card 1: Orange Wisdom Card
            if (cardTypeIndex == 0) {
              final fullAudioContent = _buildFullPageAudioContent(
                book: book,
                chapter: chapter,
                verse: verse,
                langCode: langCode,
              );

              return ReadingWisdomCard(
                book: book,
                chapter: chapter,
                verse: verse,
                languageCode: langCode,
                isSaved: isSaved,
                onToggleSave: toggleSave,
                isPlayingAudio: _isSpeaking,
                onToggleAudio: () => _toggleAudio(
                  fullAudioContent,
                  langCode,
                ),
              );
            }

            // Card 2: Off-White Context Card
            if (cardTypeIndex == 1) {
              return ReadingContextCard(
                book: book,
                chapter: chapter,
                verse: verse,
                languageCode: langCode,
                isSaved: isSaved,
                onToggleSave: toggleSave,
                onBack: () => Navigator.of(context).maybePop(),
                isBhagavadGita: isBhagavadGita,
                onTapReflection: () {
                  if (isBhagavadGita) {
                    _pageController.animateToPage(
                      pageIndex + 1,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                    );
                  }
                },
              );
            }

            // Card 3: Off-White Reflection Card (Bhagavad Gita only)
            return ReadingReflectionCard(
              book: book,
              chapter: chapter,
              verse: verse,
              languageCode: langCode,
              isSaved: isSaved,
              onToggleSave: toggleSave,
              onBack: () => Navigator.of(context).maybePop(),
              onShare: () => _shareVerse(
                book: book,
                chapter: chapter,
                verse: verse,
                langCode: langCode,
              ),
            );
          },
        );
      },
    );
  }
}
