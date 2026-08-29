import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/services/share_service.dart';
import '../../../../core/widgets/tts_audio_button.dart';
import '../../../../data/sacred_books_repository.dart';
import '../../../../data/sacred_books_data.dart';
import '../../../../models/sacred_book_model.dart';
import '../../../../models/sacred_chapter_model.dart';
import '../../../../models/sacred_verse_model.dart';
import '../../../../models/saved_item_model.dart';
import '../../../../providers/saved_provider.dart';
import '../../../../providers/reading_progress_provider.dart';
import '../../../../providers/chapter_rating_provider.dart';
import '../../../../providers/chapter_completion_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/guest_access_provider.dart';
import '../../../../providers/streak_provider.dart';

class SacredTextReaderScreen extends StatefulWidget {
  const SacredTextReaderScreen({  
    super.key  ,
    required this.textId,
    this.initialChapterNumber = 1,
  });

  final String textId;
  final int initialChapterNumber;

  @override
  State<SacredTextReaderScreen> createState() => _SacredTextReaderScreenState();
}

class _SacredTextReaderScreenState extends State<SacredTextReaderScreen> {
  String selectedLanguage = 'English';
  late final Future<SacredBookModel?> _bookFuture;
  late final FlutterTts _tts;
  bool _isSpeaking = false;

  late int currentChapter;
  int currentVerseIndex = 0;
  String? _completedChapterKey;
  String? _ratingLoadKey;
  bool _guestChapterMarked = false;

  @override
  void initState() {
    super.initState();
    currentChapter = widget.initialChapterNumber;
    _bookFuture = SacredBooksRepository.fetchBookById(widget.textId);
    _tts = FlutterTts();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      context.read<GuestAccessProvider>().markFreeChapterUsed(
            isAuthenticated: auth.isAuthenticated,
          );
      context.read<StreakProvider>().markCompleted(DateTime.now());
      _guestChapterMarked = true;
      final position =
          context.read<ReadingProgressProvider>().positionFor(widget.textId);
      if (position != null) {
        setState(() {
          currentChapter = position.chapterNumber;
          currentVerseIndex = position.verseNumber - 1;
        });
      }
    });

    _tts.setCompletionHandler(() {
      if (!mounted) return;
      setState(() {
        _isSpeaking = false;
      });
    });

    _tts.setErrorHandler((_) {
      if (!mounted) return;
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: FutureBuilder<SacredBookModel?>(
          future: _bookFuture,
          builder: (context, snapshot) {
            final SacredBookModel? book = snapshot.data ?? SacredBooksData.findById(widget.textId);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book?.title ?? '', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.darkText)),
                const SizedBox(height: 2),
                Text(
                  book != null ? 'Chapter $currentChapter of ${book.totalChapters}' : '',
                  style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.secondaryText),
                ),
              ],
            );
          },
        ),
        actions: [
          // placeholders — actual buttons rendered later in body for accessibility
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.screenBackground,
        ),
        child: FutureBuilder<SacredBookModel?>(
          future: _bookFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final SacredBookModel? book =
                snapshot.data ?? SacredBooksData.findById(widget.textId);

            if (book == null) {
              return const Center(
                child: Text('Book not found'),
              );
            }

            final SacredChapterModel? chapter = book.getChapter(currentChapter);

            if (chapter == null) {
              return Center(
                child: Text('Chapter not found in ${book.title}'),
              );
            }

            if (chapter.verses.isEmpty) {
              return const Center(
                child: Text('No verses available for this chapter'),
              );
            }

            if (currentVerseIndex >= chapter.verses.length) {
              currentVerseIndex = 0;
            }

            final SacredVerseModel verse = chapter.verses[currentVerseIndex];

            if (currentVerseIndex == chapter.verses.length - 1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _markChapterCompleted(book, chapter);
              });
            }

            final auth = context.watch<AuthProvider>();
            final guestAccess = context.watch<GuestAccessProvider>();

            final ratingKey = '${book.id}_${chapter.chapterNumber}';
            if (_ratingLoadKey != ratingKey) {
              _ratingLoadKey = ratingKey;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!mounted) return;
                final ratingProvider = context.read<ChapterRatingProvider>();
                await ratingProvider.loadRating(
                  bookId: book.id,
                  chapterNumber: chapter.chapterNumber,
                );
              });
            }

            const languages = [
              'English',
              'Sanskrit',
              'Gujarati',
            ];

            return SafeArea(
              child: Column(
                children: [
                  // top actions (save/share/audio)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
                    child: Row(
                      children: [
                        const SizedBox(width: 48), // left space for back button in AppBar
                        const Spacer(),
                        _buildSaveVerseButton(
                          context: context,
                          book: book,
                          chapter: chapter,
                          verse: verse,
                        ),
                        IconButton(
                          tooltip: 'Share chapter',
                          icon: const Icon(Icons.share_outlined),
                          color: AppColors.darkText,
                          onPressed: () => ShareService.showOptions(
                            context: context,
                            title: '${book.title} - ${chapter.title}',
                            text: _chapterShareText(book, chapter),
                          ),
                        ),
                        _buildAudioButton(
                          chapter: chapter,
                          verse: verse,
                        ),
                      ],
                    ),
                  ),
                  _buildProgress(
                    totalChapters: book.totalChapters,
                  ),
                  const SizedBox(height: 16),
                  _buildLanguageSelector(languages),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        8,
                        20,
                        24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chapter.title,
                            style: AppTextStyles.pageHeading.copyWith(
                              color: AppColors.darkText,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            chapter.subtitle,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.secondaryText,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                'Verse ${verse.verseNumber}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.primaryBurgundy,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${currentVerseIndex + 1} / ${chapter.totalVerses}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildVerseCard(verse),
                          const SizedBox(height: 20),
                          _buildMeaningSection(verse),
                          const SizedBox(height: 24),
                          _buildChapterRating(book, chapter),
                          const SizedBox(height: 24),
                          _buildVerseNavigation(book: book, chapter: chapter),
                          if (!auth.isAuthenticated &&
                              _guestChapterMarked &&
                              guestAccess.hasUsedFreeChapter &&
                              currentVerseIndex ==
                                  chapter.verses.length - 1) ...[
                            const SizedBox(height: 18),
                            _buildGuestSignInBanner(context),
                          ],
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGuestSignInBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: AppColors.peachHighlight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warmOrange),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Enjoyed this chapter? Sign in to continue reading.',
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.auth),
            child: const Text('Sign in now'),
          ),
        ],
      ),
    );
  }

  String _chapterShareText(
    SacredBookModel book,
    SacredChapterModel chapter,
  ) {
    final firstVerse = chapter.verses.isEmpty ? null : chapter.verses.first;
    return [
      '${book.title} - ${chapter.title}',
      'Chapter ${chapter.chapterNumber}',
      if (firstVerse != null) firstVerse.sanskrit,
      if (firstVerse != null) firstVerse.english,
      'Read more on Sanatan Scroll',
    ].join('\n\n');
  }

  Widget _buildSaveVerseButton({
    required BuildContext context,
    required SacredBookModel book,
    required SacredChapterModel chapter,
    required SacredVerseModel verse,
  }) {
    final savedProvider = context.watch<SavedProvider>();
    final itemId = '${book.id}_c${chapter.chapterNumber}_v${verse.verseNumber}';
    final isSaved = savedProvider.isSaved(itemId);

    return IconButton(
      icon: Icon(
        isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        color: isSaved ? AppColors.primaryBurgundy : AppColors.darkText,
      ),
      onPressed: () async {
        final item = SavedItemModel(
          id: itemId,
          type: SavedItemType.verse,
          title: '${book.title} ${chapter.chapterNumber}:${verse.verseNumber}',
          content: verse.english,
          source:
              '${book.title} - Chapter ${chapter.chapterNumber}, Verse ${verse.verseNumber}',
          savedAt: DateTime.now(),
        );

        await savedProvider.toggleItem(item);

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                isSaved ? 'Removed from saved' : 'Saved to your collection'),
            duration: const Duration(milliseconds: 1400),
          ),
        );
      },
    );
  }

  Widget _buildAudioButton({
    required SacredChapterModel chapter,
    required SacredVerseModel verse,
  }) {
    return IconButton(
      tooltip: _isSpeaking ? 'Stop audio' : 'Play audio',
      icon: Icon(
        _isSpeaking ? Icons.stop_circle_outlined : Icons.volume_up_outlined,
        color: AppColors.darkText,
      ),
      onPressed: () async {
        if (_isSpeaking) {
          await _stopSpeaking();
          return;
        }

        await _speakVerse(chapter: chapter, verse: verse);
      },
    );
  }

  Future<void> _speakVerse({
    required SacredChapterModel chapter,
    required SacredVerseModel verse,
  }) async {
    final meaning = selectedLanguage == 'Gujarati'
        ? verse.meaningGujarati
        : verse.meaningEnglish;
    final text = [
      chapter.title,
      chapter.subtitle,
      'Verse ${verse.verseNumber}',
      _getDisplayVerseText(verse),
      'Meaning',
      meaning,
    ].join('. ').trim();
    if (text.isEmpty) return;

    final languageCode = switch (selectedLanguage) {
      'Gujarati' => 'gu-IN',
      'Sanskrit' => 'hi-IN',
      _ => 'en-IN',
    };

    await _tts.stop();
    await _tts.setLanguage(languageCode);
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.43);
    await _tts.speak(text);

    if (!mounted) return;
    setState(() {
      _isSpeaking = true;
    });
  }

  Future<void> _stopSpeaking() async {
    await _tts.stop();
    if (!mounted) return;
    setState(() {
      _isSpeaking = false;
    });
  }

  String _getDisplayVerseText(SacredVerseModel verse) {
    if (selectedLanguage == 'Sanskrit') {
      return verse.sanskrit;
    }

    if (selectedLanguage == 'Gujarati') {
      return verse.gujarati;
    }

    return verse.english;
  }

  // =====================================================
  // READING PROGRESS
  // =====================================================

  Widget _buildProgress({
    required int totalChapters,
  }) {
    final double progress = currentChapter / totalChapters;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Reading Progress',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$currentChapter / $totalChapters Chapters',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBurgundy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // LANGUAGE SELECTOR
  // =====================================================

  Widget _buildLanguageSelector(
    List<String> languages,
  ) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: languages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final language = languages[index];
          final isSelected = selectedLanguage == language;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedLanguage = language;
              });
              _stopSpeaking();
            },
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 200,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryBurgundy
                    : AppColors.softBeige,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryBurgundy
                      : AppColors.divider,
                ),
              ),
              child: Center(
                child: Text(
                  language,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.darkText,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChapterRating(
    SacredBookModel book,
    SacredChapterModel chapter,
  ) {
    final ratings = context.watch<ChapterRatingProvider>();
    final selectedRating = ratings.ratingFor(book.id, chapter.chapterNumber);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  selectedRating == 0
                      ? 'Rate this chapter'
                      : 'Your chapter rating',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.darkText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...List.generate(5, (index) {
                final star = index + 1;
                return IconButton(
                  tooltip: '$star star${star == 1 ? '' : 's'}',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 30),
                  icon: Icon(
                    star <= selectedRating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: AppColors.warmOrange,
                    size: 25,
                  ),
                  onPressed: () async {
                    final error = await ratings.setRating(
                      bookId: book.id,
                      chapterNumber: chapter.chapterNumber,
                      rating: star,
                    );
                    if (error == null || !mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error)),
                    );
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  // VERSE CARD
  // =====================================================

  Widget _buildVerseCard(
    SacredVerseModel verse,
  ) {
    final displayText = _getDisplayVerseText(verse);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.softBeige,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.divider,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 30),
              const Icon(
                Icons.auto_stories_rounded,
                color: AppColors.primaryBurgundy,
                size: 30,
              ),
              TtsAudioButton(
                text: displayText,
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            displayText,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              fontSize: selectedLanguage == 'Sanskrit' ? 22 : 18,
              height: 1.8,
              color: AppColors.darkText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // MEANING
  // =====================================================

  Widget _buildMeaningSection(
    SacredVerseModel verse,
  ) {
    final String meaning = selectedLanguage == 'Gujarati'
        ? verse.meaningGujarati
        : verse.meaningEnglish;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedLanguage == 'Gujarati' ? 'અર્થ' : 'Meaning',
                style: AppTextStyles.sectionHeading.copyWith(
                  color: AppColors.darkText,
                  fontSize: 22,
                ),
              ),
              TtsAudioButton(
                text: meaning,
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            meaning,
            style: AppTextStyles.body.copyWith(
              color: AppColors.secondaryText,
              height: 1.7,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // VERSE PREVIOUS / NEXT
  // =====================================================

  Widget _buildVerseNavigation({
    required SacredBookModel book,
    required SacredChapterModel chapter,
  }) {
    final bool hasPreviousVerse = currentVerseIndex > 0;

    final bool hasNextVerse = currentVerseIndex < chapter.verses.length - 1;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: hasPreviousVerse
                ? () {
                    _stopSpeaking();
                    setState(() {
                      currentVerseIndex--;
                    });
                    _saveProgress();
                  }
                : null,
            icon: const Icon(
              Icons.arrow_back_rounded,
            ),
            label: const Text(
              'Previous Verse',
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primaryBurgundy,
              side: const BorderSide(
                color: AppColors.primaryBurgundy,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: hasNextVerse
                ? () {
                    _stopSpeaking();
                    setState(() {
                      currentVerseIndex++;
                    });
                    _saveProgress();
                    if (currentVerseIndex == chapter.verses.length - 1) {
                      _markChapterCompleted(book, chapter);
                    }
                  }
                : null,
            icon: const Icon(
              Icons.arrow_forward_rounded,
            ),
            label: const Text(
              'Next Verse',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBurgundy,
              foregroundColor: AppColors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _saveProgress() {
    context.read<ReadingProgressProvider>().savePosition(
          bookId: widget.textId,
          chapterNumber: currentChapter,
          verseNumber: currentVerseIndex + 1,
        );
  }

  Future<void> _markChapterCompleted(
    SacredBookModel book,
    SacredChapterModel chapter,
  ) {
    final key = '${widget.textId}_${chapter.chapterNumber}';
    if (_completedChapterKey == key) return Future.value();
    _completedChapterKey = key;
    return context
        .read<ChapterCompletionProvider>()
        .markCompleted(
          bookTitle: book.title,
          chapterTitle: chapter.title,
          bookId: book.id,
          chapterNumber: chapter.chapterNumber,
        )
        .then((error) {
      if (error == null || !mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    });
  }
}
