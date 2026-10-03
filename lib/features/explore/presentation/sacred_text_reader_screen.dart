import 'dart:async';
import 'package:flutter/foundation.dart';
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
import '../../../../providers/streak_provider.dart';
import 'widgets/reading_context_card.dart';
import 'widgets/reading_reflection_card.dart';
import 'widgets/reading_wisdom_card.dart';

import '../../../../data/upanishads_data.dart';

class SargaScrollPhysics extends ScrollPhysics {
  final bool allowUp;
  final bool allowDown;

  const SargaScrollPhysics({
    super.parent,
    this.allowUp = false,
    this.allowDown = false,
  });

  @override
  SargaScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SargaScrollPhysics(
      parent: buildParent(ancestor),
      allowUp: allowUp,
      allowDown: allowDown,
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // offset < 0 means dragging finger UP (scrolling DOWN to next vertical page)
    if (offset < 0 && !allowUp) {
      return 0.0;
    }
    // offset > 0 means dragging finger DOWN (scrolling UP to previous vertical page)
    if (offset > 0 && !allowDown) {
      return 0.0;
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }
}

class SacredTextReaderScreen extends StatefulWidget {
  const SacredTextReaderScreen({
    super.key,
    required this.textId,
    this.initialChapterNumber = 1,
    this.initialKandaNumber,
    this.initialSargaNumber,
    this.initialVerseNumber,
    this.initialMantraNumber,
    this.initialVerseId,
    this.initialPassageId,
    this.initialPageIndex,
  });

  final String textId;
  final int initialChapterNumber;
  final int? initialKandaNumber;
  final int? initialSargaNumber;
  final int? initialVerseNumber;
  final int? initialMantraNumber;
  final String? initialVerseId;
  final String? initialPassageId;
  final int? initialPageIndex;

  @override
  State<SacredTextReaderScreen> createState() => _SacredTextReaderScreenState();
}

class _SacredTextReaderScreenState extends State<SacredTextReaderScreen> {
  late final PageController _pageController;
  late final FlutterTts _tts;
  bool _isSpeaking = false;
  String? _lastAudioLangCode;
  bool _hasJumpedToInitialPosition = false;
  bool _isInitialLoadCompleted = false;
  Timer? _dwellTimer;

  late int currentChapter;

  @override
  void initState() {
    super.initState();
    if (widget.textId == 'ramayana' && widget.initialKandaNumber != null && widget.initialSargaNumber != null) {
      currentChapter = (widget.initialKandaNumber! * 1000) + widget.initialSargaNumber!;
    } else if (widget.textId == 'upanishads' && widget.initialMantraNumber != null) {
      currentChapter = widget.initialMantraNumber!;
    } else {
      currentChapter = widget.initialChapterNumber;
    }

    final initialPage = (widget.textId == 'upanishads' && currentChapter > 0)
        ? (currentChapter - 1)
        : ((widget.initialVerseNumber != null && widget.initialVerseNumber! > 0) ? widget.initialVerseNumber! - 1 : 0);

    _pageController = PageController(initialPage: initialPage);
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
    _dwellTimer?.cancel();
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
      // Use Hindi/Sanskrit TTS engine for Sanskrit shlokas
      try {
        await _tts.setLanguage('hi-IN');
      } catch (_) {
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
    // Only read the Sanskrit shloka as requested
    if (verse.sanskrit.trim().isNotEmpty) {
      return verse.sanskrit.trim();
    }
    return verse.getQuoteText(langCode).trim();
  }

  void _shareVerse({
    required SacredBookModel book,
    required SacredChapterModel chapter,
    required SacredVerseModel verse,
    required String langCode,
  }) {
    if (book.id == 'upanishads') {
      final passageRef = chapter.title;
      final sanskritText = verse.sanskrit.trim();
      final translationText = verse.getLocalizedTranslation(langCode).trim();

      final buffer = StringBuffer();
      buffer.writeln('Book:');
      buffer.writeln('Isha Upanishad');
      buffer.writeln();
      buffer.writeln('Reference:');
      buffer.writeln(passageRef);
      buffer.writeln();
      if (sanskritText.isNotEmpty) {
        buffer.writeln('Sanskrit:');
        buffer.writeln(sanskritText);
        buffer.writeln();
      }
      buffer.writeln('Translation:');
      buffer.writeln(translationText);

      ShareService.share(
        title: 'Isha Upanishad · $passageRef',
        text: buffer.toString(),
      );
      return;
    }

    final l10n = AppLocalizations.of(context);
    final chapterWord = l10n.chapter;
    final verseWord = l10n.verse;
    final bookTitle = book.getLocalizedTitle(langCode);

    String topHeader;
    if (book.id == 'ramayana' || verse.kandaNumber != null || verse.sargaNumber != null || chapter.chapterNumber >= 1000) {
      final kanda = verse.kandaNumber ?? (chapter.chapterNumber >= 1000 ? chapter.chapterNumber ~/ 1000 : chapter.chapterNumber);
      final sarga = verse.sargaNumber ?? (chapter.chapterNumber >= 1000 ? chapter.chapterNumber % 1000 : 1);
      final isBalaKanda = kanda == 1;
      final kandaName = isBalaKanda ? 'Bala Kanda' : 'Kanda $kanda';
      topHeader = '$bookTitle · $kandaName (Sarga $sarga) · $verseWord ${verse.verseNumber}';
    } else {
      topHeader = '$bookTitle · $chapterWord ${chapter.chapterNumber} · $verseWord ${verse.verseNumber}';
    }

    final sanskritText = verse.sanskrit.trim();
    final translationText = verse.getLocalizedTranslation(langCode).trim();

    String translationLabel;
    if (langCode == 'hi') {
      translationLabel = 'अनुवाद:';
    } else if (langCode == 'gu') {
      translationLabel = 'અનુવાદ:';
    } else {
      translationLabel = 'Translation:';
    }

    final buffer = StringBuffer();
    buffer.writeln(topHeader);
    buffer.writeln();
    if (sanskritText.isNotEmpty) {
      buffer.writeln(sanskritText);
      buffer.writeln();
    }
    buffer.writeln(translationLabel);
    buffer.writeln(translationText);
    buffer.writeln();
    buffer.write('— Sanatan Scroll');

    ShareService.share(
      title: topHeader,
      text: buffer.toString(),
    );
  }

  void _saveProgress({
    required int chapterNumber,
    required int verseNumber,
    String? chapterName,
    int? kandaNumber,
    int? sargaNumber,
    int? mantraNumber,
    String? verseId,
    String? passageId,
    int pageIndex = 0,
    String reason = 'Actual reading activity',
  }) {
    context.read<ReadingProgressProvider>().savePosition(
          bookId: widget.textId,
          chapterNumber: chapterNumber,
          chapterName: chapterName,
          kandaNumber: kandaNumber,
          sargaNumber: sargaNumber,
          verseNumber: verseNumber,
          mantraNumber: mantraNumber,
          verseId: verseId,
          passageId: passageId,
          pageIndex: pageIndex,
          reason: reason,
        );
    context.read<StreakProvider>().markCompleted(DateTime.now());
  }

  void _scheduleDwellSave({
    required int chapterNumber,
    required int verseNumber,
    String? chapterName,
    int? kandaNumber,
    int? sargaNumber,
    int? mantraNumber,
    String? verseId,
    String? passageId,
    int pageIndex = 0,
    required String reason,
  }) {
    _dwellTimer?.cancel();
    _dwellTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isInitialLoadCompleted) {
        _saveProgress(
          chapterNumber: chapterNumber,
          verseNumber: verseNumber,
          chapterName: chapterName,
          kandaNumber: kandaNumber,
          sargaNumber: sargaNumber,
          mantraNumber: mantraNumber,
          verseId: verseId,
          passageId: passageId,
          pageIndex: pageIndex,
          reason: reason,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final langCode = localeProvider.languageCode;
    final l10n = AppLocalizations.of(context);
    final isBhagavadGita = (widget.textId == 'bhagavad_gita' || widget.textId == 'gita');
    final isRamayana = (widget.textId == 'ramayana');
    final isUpanishad = (widget.textId == 'upanishads');
    final cardsPerVerse = isBhagavadGita ? 3 : 1;

    return StreamBuilder<SacredBookModel?>(
      stream: SacredBooksRepository.streamBookWithChapterVerses(
        bookId: widget.textId,
        chapterNumber: currentChapter,
      ),
      builder: (context, snapshot) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bgColor = isDark ? const Color(0xFF141714) : const Color(0xFFFAF7F2);

        final book = snapshot.data ?? SacredBooksRepository.getCachedOrFallbackBook(widget.textId);

        if (snapshot.connectionState == ConnectionState.waiting && book == null) {
          return Scaffold(
            backgroundColor: bgColor,
            body: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFC85A32),
              ),
            ),
          );
        }
        if (book == null) {
          return Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B)),
            ),
            body: Center(
              child: Text(
                l10n.scriptureNotFound,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        }

        // ============================================================
        // RAMAYANA: VERTICAL SWIPE = SARGA, HORIZONTAL SWIPE = SHLOKA
        // ============================================================
        if (isRamayana) {
          final sargas = book.chapters;
          if (sargas.isEmpty) {
            return Scaffold(
              backgroundColor: bgColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B)),
              ),
              body: Center(
                child: Text(l10n.noVersesAvailable),
              ),
            );
          }

          return _RamayanaReaderView(
            book: book,
            sargas: sargas,
            initialChapterNumber: widget.initialChapterNumber,
            initialKandaNumber: widget.initialKandaNumber,
            initialSargaNumber: widget.initialSargaNumber,
            initialVerseNumber: widget.initialVerseNumber,
            initialVerseId: widget.initialVerseId,
            initialPassageId: widget.initialPassageId,
            langCode: langCode,
            isSpeaking: _isSpeaking,
            onToggleAudio: (text, lang) => _toggleAudio(text, lang),
            onShareVerse: (b, c, v) => _shareVerse(book: b, chapter: c, verse: v, langCode: langCode),
            onSaveProgress: _saveProgress,
            onSargaChanged: (newChapterNumber) {
              if (currentChapter != newChapterNumber) {
                setState(() {
                  currentChapter = newChapterNumber;
                });
              }
            },
            buildFullPageAudioContent: _buildFullPageAudioContent,
          );
        }

        final chapter = book.getChapter(currentChapter);
        final itemCount = isUpanishad ? book.chapters.length : (chapter?.verses.length ?? 0);

        if (itemCount == 0) {
          return Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: isDark ? const Color(0xFFF0F2F0) : const Color(0xFF1B1B1B)),
            ),
            body: Center(
              child: Text(l10n.noVersesAvailable),
            ),
          );
        }

        // Check if we need to jump to initial verse/mantra position on first load
        if (!_hasJumpedToInitialPosition) {
          int targetIdx = 0;
          if (isUpanishad) {
            final targetMantra = widget.initialMantraNumber ?? widget.initialVerseNumber ?? currentChapter;
            targetIdx = (targetMantra - 1).clamp(0, itemCount - 1);
            if (targetIdx > 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_pageController.hasClients) {
                  _pageController.jumpToPage(targetIdx);
                }
              });
            }
          } else if (chapter != null && chapter.verses.isNotEmpty) {
            int matchIdx = -1;
            if (widget.initialVerseNumber != null && widget.initialVerseNumber! > 0) {
              matchIdx = chapter.verses.indexWhere((v) => v.verseNumber == widget.initialVerseNumber);
            }
            if (matchIdx == -1 && widget.initialVerseId != null) {
              matchIdx = chapter.verses.indexWhere((v) => v.transliteration == widget.initialVerseId);
            }
            if (matchIdx == -1 && widget.initialVerseNumber != null && widget.initialVerseNumber! > 0) {
              matchIdx = (widget.initialVerseNumber! - 1).clamp(0, chapter.verses.length - 1);
            }

            if (matchIdx > 0) {
              targetIdx = matchIdx;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_pageController.hasClients) {
                  _pageController.jumpToPage(targetIdx);
                }
              });
            }
          }

          _hasJumpedToInitialPosition = true;

          if (kDebugMode) {
            debugPrint('==================================================');
            debugPrint('[CONTINUE_DEBUG] READER OPENED / INITIALIZED');
            debugPrint('bookId: ${widget.textId}');
            debugPrint('chapterNumber: $currentChapter');
            debugPrint('initialVerseNumber: ${widget.initialVerseNumber}');
            debugPrint('initialVerseId: ${widget.initialVerseId}');
            debugPrint('initialPageIndex: ${widget.initialPageIndex}');
            debugPrint('resolvedTargetIndex: $targetIdx');
            debugPrint('==================================================');
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isInitialLoadCompleted = true;
              });
              if (isUpanishad) {
                final activeChap = book.chapters[targetIdx.clamp(0, book.chapters.length - 1)];
                _scheduleDwellSave(
                  chapterNumber: activeChap.chapterNumber,
                  verseNumber: 1,
                  chapterName: activeChap.title,
                  mantraNumber: activeChap.chapterNumber,
                  pageIndex: targetIdx,
                  reason: 'User stayed on initial Upanishads mantra page for 3+ seconds',
                );
              } else if (chapter != null && chapter.verses.isNotEmpty) {
                final activeVerse = chapter.verses[targetIdx.clamp(0, chapter.verses.length - 1)];
                _scheduleDwellSave(
                  chapterNumber: currentChapter,
                  verseNumber: activeVerse.verseNumber,
                  chapterName: chapter.title,
                  verseId: activeVerse.transliteration,
                  pageIndex: targetIdx,
                  reason: 'User stayed on initial verse page for 3+ seconds',
                );
              }
            }
          });
        }

        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: itemCount,
          onPageChanged: (pageIndex) {
            if (!_isInitialLoadCompleted) return;

            if (isUpanishad) {
              final activeChap = book.chapters[pageIndex];
              _saveProgress(
                chapterNumber: activeChap.chapterNumber,
                verseNumber: 1,
                chapterName: activeChap.title,
                mantraNumber: activeChap.chapterNumber,
                pageIndex: pageIndex,
                reason: 'User swiped Upanishads page $pageIndex',
              );
              _scheduleDwellSave(
                chapterNumber: activeChap.chapterNumber,
                verseNumber: 1,
                chapterName: activeChap.title,
                mantraNumber: activeChap.chapterNumber,
                pageIndex: pageIndex,
                reason: 'User stayed on Upanishads page $pageIndex for 3+ seconds',
              );
              context.read<ChapterCompletionProvider>().markCompleted(
                    bookTitle: book.title,
                    chapterTitle: activeChap.title,
                    bookId: book.id,
                    chapterNumber: activeChap.chapterNumber,
                  );
            } else if (chapter != null) {
              final activeVerse = (pageIndex >= 0 && pageIndex < chapter.verses.length)
                  ? chapter.verses[pageIndex]
                  : null;
              final actualVerseNum = activeVerse?.verseNumber ?? (pageIndex + 1);

              _saveProgress(
                chapterNumber: currentChapter,
                verseNumber: actualVerseNum,
                chapterName: chapter.title,
                verseId: activeVerse?.transliteration,
                pageIndex: pageIndex,
                reason: 'User swiped verse page $pageIndex (Verse $actualVerseNum)',
              );
              _scheduleDwellSave(
                chapterNumber: currentChapter,
                verseNumber: actualVerseNum,
                chapterName: chapter.title,
                verseId: activeVerse?.transliteration,
                pageIndex: pageIndex,
                reason: 'User stayed on verse page $pageIndex (Verse $actualVerseNum) for 3+ seconds',
              );
              if (pageIndex == chapter.verses.length - 1) {
                context.read<ChapterCompletionProvider>().markCompleted(
                      bookTitle: book.title,
                      chapterTitle: chapter.title,
                      bookId: book.id,
                      chapterNumber: chapter.chapterNumber,
                    );
              }
            }
          },
          itemBuilder: (context, pageIndex) {
            final SacredChapterModel activeChapter;
            final SacredVerseModel activeVerse;

            if (isUpanishad) {
              activeChapter = book.chapters[pageIndex];
              if (activeChapter.verses.isNotEmpty) {
                activeVerse = activeChapter.verses.first;
              } else {
                final fallbackChap = UpanishadsData.buildUpanishadsBook().getChapter(activeChapter.chapterNumber);
                if (fallbackChap != null && fallbackChap.verses.isNotEmpty) {
                  activeVerse = fallbackChap.verses.first;
                } else {
                  activeVerse = SacredVerseModel(
                    verseNumber: activeChapter.chapterNumber,
                    sanskrit: activeChapter.descriptionEnglish,
                    english: activeChapter.descriptionEnglish,
                    gujarati: activeChapter.descriptionGujarati,
                    hindi: activeChapter.descriptionHindi,
                    meaningEnglish: activeChapter.descriptionEnglish,
                    meaningGujarati: activeChapter.descriptionGujarati,
                  );
                }
              }
            } else {
              activeChapter = chapter!;
              activeVerse = chapter.verses[pageIndex];
            }

            void handleNextVerse() {
              if (pageIndex < itemCount - 1) {
                _pageController.animateToPage(
                  pageIndex + 1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                );
              }
            }

            void handleBack() {
              Navigator.of(context).maybePop();
            }

            final fullAudioContent = _buildFullPageAudioContent(
              book: book,
              chapter: activeChapter,
              verse: activeVerse,
              langCode: langCode,
            );

            return _VerseView(
              key: ValueKey('${book.id}_c${activeChapter.chapterNumber}_v${activeVerse.verseNumber}'),
              book: book,
              chapter: activeChapter,
              verse: activeVerse,
              langCode: langCode,
              isBhagavadGita: isBhagavadGita,
              cardsPerVerse: cardsPerVerse,
              isSpeaking: _isSpeaking,
              onToggleAudio: () => _toggleAudio(fullAudioContent, langCode),
              onShareVerse: () => _shareVerse(
                book: book,
                chapter: activeChapter,
                verse: activeVerse,
                langCode: langCode,
              ),
              onBack: handleBack,
              onNextVerse: handleNextVerse,
              initialCardIndex: widget.initialPageIndex ?? 0,
            );
          },
        );
      },
    );
  }
}

class _VerseView extends StatefulWidget {
  const _VerseView({
    super.key,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.langCode,
    required this.isBhagavadGita,
    required this.cardsPerVerse,
    required this.isSpeaking,
    required this.onToggleAudio,
    required this.onShareVerse,
    required this.onBack,
    required this.onNextVerse,
    this.initialCardIndex = 0,
  });

  final SacredBookModel book;
  final SacredChapterModel chapter;
  final SacredVerseModel verse;
  final String langCode;
  final bool isBhagavadGita;
  final int cardsPerVerse;
  final bool isSpeaking;
  final VoidCallback onToggleAudio;
  final VoidCallback onShareVerse;
  final VoidCallback onBack;
  final VoidCallback onNextVerse;
  final int initialCardIndex;

  @override
  State<_VerseView> createState() => _VerseViewState();
}

class _VerseViewState extends State<_VerseView> {
  late final PageController _horizontalController;

  @override
  void initState() {
    super.initState();
    _horizontalController = PageController(
      initialPage: widget.initialCardIndex.clamp(0, widget.cardsPerVerse - 1),
    );
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  void _goToNextCard() {
    if (_horizontalController.hasClients) {
      _horizontalController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode && (widget.book.id.contains('gita') || widget.isBhagavadGita)) {
      final verse = widget.verse;
      final lang = widget.langCode.toLowerCase().split('-').first.trim();
      final enAvail = verse.english.trim().isNotEmpty || verse.meaningEnglish.trim().isNotEmpty;
      final hiAvail = (verse.hindi != null && verse.hindi!.trim().isNotEmpty) || (verse.meaningHindi != null && verse.meaningHindi!.trim().isNotEmpty);
      final guAvail = verse.gujarati.trim().isNotEmpty || verse.meaningGujarati.trim().isNotEmpty;
      final displayedField = lang == 'hi' ? 'hindi' : (lang == 'gu' ? 'gujarati' : 'english');

      debugPrint('==================================================');
      debugPrint('[GITA VERSE READER DEBUG LOG]');
      debugPrint('Book: ${widget.book.title}');
      debugPrint('Verse ID: ${widget.book.id}_c${widget.chapter.chapterNumber}_v${verse.verseNumber}');
      debugPrint('Selected language: $lang');
      debugPrint('English available: $enAvail');
      debugPrint('Hindi available: $hiAvail');
      debugPrint('Gujarati available: $guAvail');
      debugPrint('Displayed translation field: $displayedField');
      debugPrint('==================================================');
    }

    final savedProvider = context.watch<SavedProvider>();
    final isUpanishad = widget.book.id == 'upanishads';

    final savedItem = SavedItemModel(
      id: '${widget.book.id}_c${widget.chapter.chapterNumber}_v${widget.verse.verseNumber}',
      type: SavedItemType.verse,
      title: isUpanishad
          ? 'Isha Upanishad Mantra ${widget.chapter.chapterNumber}'
          : '${widget.book.getLocalizedTitle(widget.langCode)} ${widget.chapter.chapterNumber}.${widget.verse.verseNumber}',
      content: widget.verse.getQuoteText(widget.langCode),
      source: widget.book.getLocalizedTitle(widget.langCode),
      savedAt: DateTime.now(),
      bookId: widget.book.id,
      bookName: widget.book.getLocalizedTitle(widget.langCode),
      chapterId: widget.chapter.chapterNumber.toString(),
      chapterNumber: widget.chapter.chapterNumber,
      chapterName: widget.chapter.title,
      kandaNumber: widget.verse.kandaNumber ?? (widget.chapter.chapterNumber >= 1000 ? widget.chapter.chapterNumber ~/ 1000 : null),
      sargaNumber: widget.verse.sargaNumber ?? (widget.chapter.chapterNumber >= 1000 ? widget.chapter.chapterNumber % 1000 : null),
      mantraNumber: isUpanishad ? widget.chapter.chapterNumber : widget.verse.verseNumber,
      verseId: widget.verse.transliteration,
      verseNumber: widget.verse.verseNumber,
    );
    final isSaved = savedProvider.isSaved(savedItem.id);
    void toggleSave() => savedProvider.toggleItem(savedItem);

    return PageView.builder(
      controller: _horizontalController,
      scrollDirection: Axis.horizontal,
      itemCount: widget.cardsPerVerse,
      itemBuilder: (context, cardIndex) {
        if (cardIndex == 0) {
          return ReadingWisdomCard(
            book: widget.book,
            chapter: widget.chapter,
            verse: widget.verse,
            languageCode: widget.langCode,
            isSaved: isSaved,
            onToggleSave: toggleSave,
            onShare: widget.onShareVerse,
            isPlayingAudio: widget.isSpeaking,
            onToggleAudio: widget.onToggleAudio,
            onBack: widget.onBack,
            onNextCard: widget.cardsPerVerse > 1 ? _goToNextCard : widget.onNextVerse,
            totalCards: widget.cardsPerVerse,
          );
        }

        if (cardIndex == 1 && widget.isBhagavadGita) {
          return ReadingReflectionCard(
            book: widget.book,
            chapter: widget.chapter,
            verse: widget.verse,
            languageCode: widget.langCode,
            isSaved: isSaved,
            onToggleSave: toggleSave,
            onShare: widget.onShareVerse,
            onBack: widget.onBack,
            onNextCard: _goToNextCard,
            totalCards: widget.cardsPerVerse,
          );
        }

        return ReadingContextCard(
          book: widget.book,
          chapter: widget.chapter,
          verse: widget.verse,
          languageCode: widget.langCode,
          isSaved: isSaved,
          onToggleSave: toggleSave,
          onShare: widget.onShareVerse,
          onBack: widget.onBack,
          onNextVerse: widget.onNextVerse,
          totalCards: widget.cardsPerVerse,
        );
      },
    );
  }
}

class _RamayanaReaderView extends StatefulWidget {
  const _RamayanaReaderView({
    required this.book,
    required this.sargas,
    required this.initialChapterNumber,
    this.initialKandaNumber,
    this.initialSargaNumber,
    this.initialVerseNumber,
    this.initialVerseId,
    this.initialPassageId,
    required this.langCode,
    required this.isSpeaking,
    required this.onToggleAudio,
    required this.onShareVerse,
    required this.onSaveProgress,
    this.onSargaChanged,
    required this.buildFullPageAudioContent,
  });

  final SacredBookModel book;
  final List<SacredChapterModel> sargas;
  final int initialChapterNumber;
  final int? initialKandaNumber;
  final int? initialSargaNumber;
  final int? initialVerseNumber;
  final String? initialVerseId;
  final String? initialPassageId;
  final String langCode;
  final bool isSpeaking;
  final void Function(String text, String lang) onToggleAudio;
  final void Function(SacredBookModel book, SacredChapterModel sarga, SacredVerseModel verse) onShareVerse;
  final void Function({
    required int chapterNumber,
    required int verseNumber,
    String? chapterName,
    int? kandaNumber,
    int? sargaNumber,
    int? mantraNumber,
    String? verseId,
    String? passageId,
    int pageIndex,
    String reason,
  }) onSaveProgress;
  final ValueChanged<int>? onSargaChanged;
  final String Function({
    required SacredBookModel book,
    required SacredChapterModel chapter,
    required SacredVerseModel verse,
    required String langCode,
  }) buildFullPageAudioContent;

  @override
  State<_RamayanaReaderView> createState() => _RamayanaReaderViewState();
}

class _RamayanaReaderViewState extends State<_RamayanaReaderView> {
  late PageController _shlokaPageController;

  late int _currentKandaNumber;
  late int _currentSargaNumber;
  int _currentShlokaIndex = 0;

  bool _isNavigatingSarga = false;
  bool _isInitialLoadCompleted = false;
  Timer? _dwellTimer;

  static const Map<int, int> _kandaSargaCounts = {
    1: 77,  // Bala Kanda
    2: 119, // Ayodhya Kanda
    3: 75,  // Aranya Kanda
    4: 67,  // Kishkindha Kanda
    5: 68,  // Sundara Kanda
    6: 128, // Yuddha Kanda
    7: 111, // Uttara Kanda
  };

  static const List<Map<String, String>> _ramayanaKandaNames = [
    {'en': 'Bala Kanda', 'hi': 'बाल काण्ड', 'gu': 'બાળ કાંડ'},
    {'en': 'Ayodhya Kanda', 'hi': 'अयोध्या काण्ड', 'gu': 'અયોધ્યા કાંડ'},
    {'en': 'Aranya Kanda', 'hi': 'अरण्य काण्ड', 'gu': 'અરણ્ય કાંડ'},
    {'en': 'Kishkindha Kanda', 'hi': 'किष्किन्धा काण्ड', 'gu': 'કિષ્કિંધા કાંડ'},
    {'en': 'Sundara Kanda', 'hi': 'सुन्दर काण्ड', 'gu': 'સુંદર કાંડ'},
    {'en': 'Yuddha Kanda', 'hi': 'युद्ध काण्ड', 'gu': 'યુદ્ધ કાંડ'},
    {'en': 'Uttara Kanda', 'hi': 'उत्तर काण्ड', 'gu': 'ઉત્તર કાંડ'},
  ];

  @override
  void initState() {
    super.initState();
    _initFromChapterNumber(widget.initialChapterNumber);

    final activeSarga = _findOrCreateActiveSarga();
    final verses = _getEffectiveVerses(activeSarga);

    int targetShlokaIndex = 0;
    if (widget.initialVerseNumber != null && widget.initialVerseNumber! > 0) {
      final matchIdx = verses.indexWhere((v) => v.verseNumber == widget.initialVerseNumber);
      targetShlokaIndex = matchIdx != -1 ? matchIdx : (widget.initialVerseNumber! - 1).clamp(0, verses.isNotEmpty ? verses.length - 1 : 0);
    }

    _currentShlokaIndex = targetShlokaIndex;
    _shlokaPageController = PageController(initialPage: targetShlokaIndex);

    if (kDebugMode) {
      debugPrint('==================================================');
      debugPrint('[CONTINUE_DEBUG] RAMAYANA READER OPENED / INITIALIZED');
      debugPrint('bookId: ramayana');
      debugPrint('kandaNumber: $_currentKandaNumber');
      debugPrint('sargaNumber: $_currentSargaNumber');
      debugPrint('initialVerseNumber: ${widget.initialVerseNumber}');
      debugPrint('resolvedShlokaIndex: $targetShlokaIndex');
      debugPrint('==================================================');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isInitialLoadCompleted = true;
        });
        _scheduleDwellSave('User stayed on initial Ramayana shloka for 3+ seconds');
      }
    });
  }

  void _initFromChapterNumber(int chapNum) {
    if (widget.initialKandaNumber != null && widget.initialKandaNumber! > 0) {
      _currentKandaNumber = widget.initialKandaNumber!;
      _currentSargaNumber = widget.initialSargaNumber ?? 1;
    } else if (chapNum >= 1000) {
      _currentKandaNumber = chapNum ~/ 1000;
      _currentSargaNumber = chapNum % 1000;
    } else {
      _currentKandaNumber = (chapNum > 0 && chapNum <= 7) ? chapNum : 1;
      _currentSargaNumber = widget.initialSargaNumber ?? 1;
    }
  }

  @override
  void didUpdateWidget(covariant _RamayanaReaderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialChapterNumber != widget.initialChapterNumber) {
      _initFromChapterNumber(widget.initialChapterNumber);
      if (_shlokaPageController.hasClients) {
        _shlokaPageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _dwellTimer?.cancel();
    _shlokaPageController.dispose();
    super.dispose();
  }

  int _getSargaCountForKanda(int kandaNum) {
    return _kandaSargaCounts[kandaNum] ?? 77;
  }

  String _getKandaName(int kandaNum, String langCode) {
    if (kandaNum < 1 || kandaNum > 7) return 'Kanda $kandaNum';
    final map = _ramayanaKandaNames[kandaNum - 1];
    if (langCode == 'hi') return map['hi']!;
    if (langCode == 'gu') return map['gu']!;
    return map['en']!;
  }

  SacredChapterModel _findOrCreateActiveSarga() {
    final compositeNum = (_currentKandaNumber * 1000) + _currentSargaNumber;

    final matchInSargas = widget.sargas.cast<SacredChapterModel?>().firstWhere(
      (c) => c != null && (c.chapterNumber == compositeNum || (c.chapterNumber == _currentKandaNumber && c.verses.any((v) => (v.sargaNumber ?? 1) == _currentSargaNumber))),
      orElse: () => null,
    );

    if (matchInSargas != null) {
      final filteredVerses = matchInSargas.verses.where((v) {
        final vKanda = v.kandaNumber ?? _currentKandaNumber;
        final vSarga = v.sargaNumber ?? _currentSargaNumber;
        return vKanda == _currentKandaNumber && vSarga == _currentSargaNumber;
      }).toList();

      filteredVerses.sort((a, b) => a.verseNumber.compareTo(b.verseNumber));

      return matchInSargas.copyWith(
        chapterNumber: compositeNum,
        title: 'Sarga $_currentSargaNumber',
        subtitle: '${_getKandaName(_currentKandaNumber, widget.langCode)} • Sarga $_currentSargaNumber',
        verses: filteredVerses,
      );
    }

    final kandaNameEn = _getKandaName(_currentKandaNumber, 'en');
    final kandaNameHi = _getKandaName(_currentKandaNumber, 'hi');
    final kandaNameGu = _getKandaName(_currentKandaNumber, 'gu');

    return SacredChapterModel(
      chapterNumber: compositeNum,
      title: 'Sarga $_currentSargaNumber',
      subtitle: '$kandaNameEn • Sarga $_currentSargaNumber',
      titleEn: 'Sarga $_currentSargaNumber',
      titleHi: 'सर्ग $_currentSargaNumber',
      titleGu: 'સર્ગ $_currentSargaNumber',
      subtitleEn: '$kandaNameEn • Sarga $_currentSargaNumber',
      subtitleHi: '$kandaNameHi • सर्ग $_currentSargaNumber',
      subtitleGu: '$kandaNameGu • સર્ગ $_currentSargaNumber',
      descriptionEnglish: 'Sarga $_currentSargaNumber of $kandaNameEn',
      descriptionHindi: '$kandaNameHi का सर्ग $_currentSargaNumber',
      descriptionGujarati: '$kandaNameGu નો સર્ગ $_currentSargaNumber',
      verses: const [],
    );
  }

  void _saveProgress({String reason = 'Actual reading activity'}) {
    if (!_isInitialLoadCompleted) return;

    final activeSarga = _findOrCreateActiveSarga();
    final verses = _getEffectiveVerses(activeSarga);
    final composite = (_currentKandaNumber * 1000) + _currentSargaNumber;
    final verse = (_currentShlokaIndex >= 0 && _currentShlokaIndex < verses.length)
        ? verses[_currentShlokaIndex]
        : null;

    final actualVerseNum = verse?.verseNumber ?? (_currentShlokaIndex + 1);

    widget.onSaveProgress(
      chapterNumber: composite,
      verseNumber: actualVerseNum,
      chapterName: activeSarga.title,
      kandaNumber: _currentKandaNumber,
      sargaNumber: _currentSargaNumber,
      verseId: verse?.transliteration,
      pageIndex: _currentShlokaIndex,
      reason: reason,
    );
  }

  void _scheduleDwellSave(String reason) {
    _dwellTimer?.cancel();
    _dwellTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isInitialLoadCompleted) {
        _saveProgress(reason: reason);
      }
    });
  }

  void _goToNextShloka(int totalShlokas) {
    if (_currentShlokaIndex < totalShlokas - 1) {
      _currentShlokaIndex++;
      if (_shlokaPageController.hasClients) {
        _shlokaPageController.animateToPage(
          _currentShlokaIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
      _saveProgress();
    } else {
      _goToNextSarga();
    }
  }

  void _goToNextSarga() {
    if (_isNavigatingSarga) return;
    _isNavigatingSarga = true;
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _isNavigatingSarga = false;
    });

    final maxSargas = _getSargaCountForKanda(_currentKandaNumber);
    if (_currentSargaNumber < maxSargas) {
      setState(() {
        _currentSargaNumber++;
        _currentShlokaIndex = 0;
      });
      _resetControllerAndNotify();
    } else if (_currentKandaNumber < 7) {
      setState(() {
        _currentKandaNumber++;
        _currentSargaNumber = 1;
        _currentShlokaIndex = 0;
      });
      _resetControllerAndNotify();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have reached the end of Ramayana.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _goToPreviousSarga() {
    if (_isNavigatingSarga) return;
    _isNavigatingSarga = true;
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _isNavigatingSarga = false;
    });

    if (_currentSargaNumber > 1) {
      setState(() {
        _currentSargaNumber--;
        _currentShlokaIndex = 0;
      });
      _resetControllerAndNotify();
    } else if (_currentKandaNumber > 1) {
      final prevKanda = _currentKandaNumber - 1;
      final prevSargaCount = _getSargaCountForKanda(prevKanda);
      setState(() {
        _currentKandaNumber = prevKanda;
        _currentSargaNumber = prevSargaCount;
        _currentShlokaIndex = 0;
      });
      _resetControllerAndNotify();
    }
  }

  void _resetControllerAndNotify() {
    if (_shlokaPageController.hasClients) {
      _shlokaPageController.jumpToPage(0);
    }
    final newComposite = (_currentKandaNumber * 1000) + _currentSargaNumber;
    widget.onSargaChanged?.call(newComposite);
    _saveProgress();
  }

  List<SacredVerseModel> _getEffectiveVerses(SacredChapterModel activeSarga) {
    if (activeSarga.verses.isNotEmpty) {
      return activeSarga.verses;
    }
    final kandaNameEn = _getKandaName(_currentKandaNumber, 'en');
    final kandaNameHi = _getKandaName(_currentKandaNumber, 'hi');
    final kandaNameGu = _getKandaName(_currentKandaNumber, 'gu');

    return [
      SacredVerseModel(
        verseNumber: 1,
        kandaNumber: _currentKandaNumber,
        sargaNumber: _currentSargaNumber,
        sanskrit: 'ॐ श्री रामचन्द्राय नमः ॥',
        english: 'Sarga $_currentSargaNumber of $kandaNameEn',
        hindi: '$kandaNameHi - सर्ग $_currentSargaNumber',
        gujarati: '$kandaNameGu - સર્ગ $_currentSargaNumber',
        meaningEnglish: 'Sarga $_currentSargaNumber of $kandaNameEn.',
        meaningHindi: '$kandaNameHi का सर्ग $_currentSargaNumber।',
        meaningGujarati: '$kandaNameGu નો સર્ગ $_currentSargaNumber.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final activeSarga = _findOrCreateActiveSarga();
    final verses = _getEffectiveVerses(activeSarga);
    final totalVerses = verses.length;
    final savedProvider = context.watch<SavedProvider>();

    if (_currentShlokaIndex >= totalVerses) {
      _currentShlokaIndex = 0;
    }

    final isLastShlokaOfSarga = _currentShlokaIndex == totalVerses - 1;
    final maxSargasInKanda = _getSargaCountForKanda(_currentKandaNumber);
    final isLastSargaOfKanda = _currentSargaNumber == maxSargasInKanda;

    String nextBtnLabel;
    IconData nextBtnIcon;

    if (!isLastShlokaOfSarga) {
      nextBtnLabel = (widget.langCode == 'gu') ? 'આગળ' : (widget.langCode == 'hi' ? 'आगे' : 'Next');
      nextBtnIcon = Icons.arrow_forward_rounded;
    } else if (!isLastSargaOfKanda) {
      final sargaPrefix = (widget.langCode == 'gu') ? 'સર્ગ' : (widget.langCode == 'hi' ? 'सर्ग' : 'Sarga');
      nextBtnLabel = '$sargaPrefix ${_currentSargaNumber + 1}';
      nextBtnIcon = Icons.arrow_upward_rounded;
    } else if (_currentKandaNumber < 7) {
      nextBtnLabel = _getKandaName(_currentKandaNumber + 1, widget.langCode);
      nextBtnIcon = Icons.arrow_upward_rounded;
    } else {
      nextBtnLabel = (widget.langCode == 'gu') ? 'સંપૂર્ણ' : (widget.langCode == 'hi' ? 'समाप्त' : 'End');
      nextBtnIcon = Icons.check_circle_outline_rounded;
    }

    return GestureDetector(
      onVerticalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity < -200) {
          // BOTTOM -> TOP swipe (drag up) - Transition to next Sarga from ANY shloka
          _goToNextSarga();
        } else if (velocity > 200) {
          // TOP -> BOTTOM swipe (drag down) - Transition to previous Sarga from ANY shloka
          _goToPreviousSarga();
        }
      },
      child: PageView.builder(
        controller: _shlokaPageController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: totalVerses,
        onPageChanged: (index) {
          if (_currentShlokaIndex != index) {
            setState(() {
              _currentShlokaIndex = index;
            });
            if (_isInitialLoadCompleted) {
              _saveProgress(reason: 'User swiped Ramayana shloka $index');
              _scheduleDwellSave('User stayed on Ramayana shloka $index for 3+ seconds');
            }
          }
        },
        itemBuilder: (context, index) {
          final verse = verses[index];
          final composite = (_currentKandaNumber * 1000) + _currentSargaNumber;

          final savedItem = SavedItemModel(
            id: '${widget.book.id}_c${composite}_v${verse.verseNumber}',
            type: SavedItemType.verse,
            title: '${_getKandaName(_currentKandaNumber, widget.langCode)} Sarga $_currentSargaNumber Verse ${verse.verseNumber}',
            content: verse.getQuoteText(widget.langCode),
            source: widget.book.getLocalizedTitle(widget.langCode),
            savedAt: DateTime.now(),
            bookId: widget.book.id,
            bookName: widget.book.getLocalizedTitle(widget.langCode),
            chapterId: activeSarga.chapterNumber.toString(),
            chapterNumber: composite,
            chapterName: activeSarga.title,
            kandaNumber: _currentKandaNumber,
            sargaNumber: _currentSargaNumber,
            verseId: verse.transliteration,
            verseNumber: verse.verseNumber,
          );
          final isSaved = savedProvider.isSaved(savedItem.id);
          void toggleSave() => savedProvider.toggleItem(savedItem);

          final fullAudioContent = widget.buildFullPageAudioContent(
            book: widget.book,
            chapter: activeSarga,
            verse: verse,
            langCode: widget.langCode,
          );

          final shlokaNumStr = (index + 1).toString().padLeft(2, '0');
          final totalShlokasStr = totalVerses.toString().padLeft(2, '0');
          final cardLabel = '$shlokaNumStr / $totalShlokasStr';

          return ReadingWisdomCard(
            key: ValueKey('ramayana_k${_currentKandaNumber}_s${_currentSargaNumber}_v${verse.verseNumber}_$index'),
            book: widget.book,
            chapter: activeSarga,
            verse: verse,
            languageCode: widget.langCode,
            isSaved: isSaved,
            onToggleSave: toggleSave,
            onShare: () => widget.onShareVerse(widget.book, activeSarga, verse),
            isPlayingAudio: widget.isSpeaking,
            onToggleAudio: () => widget.onToggleAudio(fullAudioContent, widget.langCode),
            onBack: () => Navigator.of(context).maybePop(),
            onNextCard: () => _goToNextShloka(totalVerses),
            totalCards: 1,
            customCardLabel: cardLabel,
            customTotalProgress: totalVerses <= 20 ? totalVerses : 0,
            customActiveProgressIndex: totalVerses <= 20 ? index : 0,
            customNextButtonLabel: nextBtnLabel,
            customNextButtonIcon: nextBtnIcon,
          );
        },
      ),
    );
  }
}

