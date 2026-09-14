import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../models/sacred_verse_admin_model.dart';
import '../../../providers/verses_provider.dart';

class VerseEditorDialog extends StatefulWidget {
  final SacredVerseAdminModel? verse;
  final String bookId;
  final int chapterNumber;

  const VerseEditorDialog({
    super.key,
    this.verse,
    required this.bookId,
    required this.chapterNumber,
  });

  static Future<void> show(
    BuildContext context, {
    required String bookId,
    required int chapterNumber,
    SacredVerseAdminModel? verse,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => VerseEditorDialog(
        bookId: bookId,
        chapterNumber: chapterNumber,
        verse: verse,
      ),
    );
  }

  @override
  State<VerseEditorDialog> createState() => _VerseEditorDialogState();
}

class _VerseEditorDialogState extends State<VerseEditorDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  late TextEditingController _numberController;
  late TextEditingController _sanskritController;
  late TextEditingController _transliterationController;

  // Multilingual translations
  late TextEditingController _englishController;
  late TextEditingController _gujaratiController;
  late TextEditingController _hindiController;

  // Multilingual meanings
  late TextEditingController _meaningEnController;
  late TextEditingController _meaningGuController;
  late TextEditingController _meaningHiController;

  // Additional rich text fields
  late TextEditingController _quoteEnController;
  late TextEditingController _quoteGuController;
  late TextEditingController _quoteHiController;

  late TextEditingController _contextEnController;
  late TextEditingController _contextGuController;
  late TextEditingController _contextHiController;

  late TextEditingController _whyMattersEnController;
  late TextEditingController _whyMattersGuController;
  late TextEditingController _whyMattersHiController;

  late TextEditingController _reflPrevEnController;
  late TextEditingController _reflPrevGuController;
  late TextEditingController _reflPrevHiController;

  late TextEditingController _reflFullEnController;
  late TextEditingController _reflFullGuController;
  late TextEditingController _reflFullHiController;

  late TextEditingController _oneThingEnController;
  late TextEditingController _oneThingGuController;
  late TextEditingController _oneThingHiController;

  late TextEditingController _tryThisEnController;
  late TextEditingController _tryThisGuController;
  late TextEditingController _tryThisHiController;

  late TextEditingController _carryEnController;
  late TextEditingController _carryGuController;
  late TextEditingController _carryHiController;

  late TextEditingController _audioEnController;
  late TextEditingController _audioGuController;
  late TextEditingController _audioHiController;

  bool _published = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    final v = widget.verse;

    _numberController = TextEditingController(text: (v?.verseNumber ?? 1).toString());
    _sanskritController = TextEditingController(text: v?.sanskrit ?? '');
    _transliterationController = TextEditingController(text: v?.transliteration ?? '');

    _englishController = TextEditingController(text: v?.english ?? '');
    _gujaratiController = TextEditingController(text: v?.gujarati ?? '');
    _hindiController = TextEditingController(text: v?.hindi ?? '');

    _meaningEnController = TextEditingController(text: v?.meaningEnglish ?? '');
    _meaningGuController = TextEditingController(text: v?.meaningGujarati ?? '');
    _meaningHiController = TextEditingController(text: v?.meaningHindi ?? '');

    _quoteEnController = TextEditingController(text: v?.quote ?? '');
    _quoteGuController = TextEditingController(text: v?.quoteGu ?? '');
    _quoteHiController = TextEditingController(text: v?.quoteHi ?? '');

    _contextEnController = TextEditingController(text: v?.contextText ?? '');
    _contextGuController = TextEditingController(text: v?.contextTextGu ?? '');
    _contextHiController = TextEditingController(text: v?.contextTextHi ?? '');

    _whyMattersEnController = TextEditingController(text: v?.whyItMatters ?? '');
    _whyMattersGuController = TextEditingController(text: v?.whyItMattersGu ?? '');
    _whyMattersHiController = TextEditingController(text: v?.whyItMattersHi ?? '');

    _reflPrevEnController = TextEditingController(text: v?.reflectionPreview ?? '');
    _reflPrevGuController = TextEditingController(text: v?.reflectionPreviewGu ?? '');
    _reflPrevHiController = TextEditingController(text: v?.reflectionPreviewHi ?? '');

    _reflFullEnController = TextEditingController(text: v?.reflectionFull ?? '');
    _reflFullGuController = TextEditingController(text: v?.reflectionFullGu ?? '');
    _reflFullHiController = TextEditingController(text: v?.reflectionFullHi ?? '');

    _oneThingEnController = TextEditingController(text: v?.oneThingToNotice ?? '');
    _oneThingGuController = TextEditingController(text: v?.oneThingToNoticeGu ?? '');
    _oneThingHiController = TextEditingController(text: v?.oneThingToNoticeHi ?? '');

    _tryThisEnController = TextEditingController(text: v?.tryThis ?? '');
    _tryThisGuController = TextEditingController(text: v?.tryThisGu ?? '');
    _tryThisHiController = TextEditingController(text: v?.tryThisHi ?? '');

    _carryEnController = TextEditingController(text: v?.carryThisWithYou ?? '');
    _carryGuController = TextEditingController(text: v?.carryThisWithYouGu ?? '');
    _carryHiController = TextEditingController(text: v?.carryThisWithYouHi ?? '');

    _audioEnController = TextEditingController(text: v?.audioUrl ?? '');
    _audioGuController = TextEditingController(text: v?.audioUrlGu ?? '');
    _audioHiController = TextEditingController(text: v?.audioUrlHi ?? '');

    _published = v?.published ?? true;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _numberController.dispose();
    _sanskritController.dispose();
    _transliterationController.dispose();

    _englishController.dispose();
    _gujaratiController.dispose();
    _hindiController.dispose();

    _meaningEnController.dispose();
    _meaningGuController.dispose();
    _meaningHiController.dispose();

    _quoteEnController.dispose();
    _quoteGuController.dispose();
    _quoteHiController.dispose();

    _contextEnController.dispose();
    _contextGuController.dispose();
    _contextHiController.dispose();

    _whyMattersEnController.dispose();
    _whyMattersGuController.dispose();
    _whyMattersHiController.dispose();

    _reflPrevEnController.dispose();
    _reflPrevGuController.dispose();
    _reflPrevHiController.dispose();

    _reflFullEnController.dispose();
    _reflFullGuController.dispose();
    _reflFullHiController.dispose();

    _oneThingEnController.dispose();
    _oneThingGuController.dispose();
    _oneThingHiController.dispose();

    _tryThisEnController.dispose();
    _tryThisGuController.dispose();
    _tryThisHiController.dispose();

    _carryEnController.dispose();
    _carryGuController.dispose();
    _carryHiController.dispose();

    _audioEnController.dispose();
    _audioGuController.dispose();
    _audioHiController.dispose();

    super.dispose();
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final verseNum = int.tryParse(_numberController.text) ?? 1;
    final model = SacredVerseAdminModel(
      verseNumber: verseNum,
      sanskrit: _sanskritController.text.trim(),
      english: _englishController.text.trim(),
      gujarati: _gujaratiController.text.trim(),
      hindi: _hindiController.text.trim().isNotEmpty ? _hindiController.text.trim() : null,
      meaningEnglish: _meaningEnController.text.trim(),
      meaningGujarati: _meaningGuController.text.trim(),
      meaningHindi: _meaningHiController.text.trim().isNotEmpty ? _meaningHiController.text.trim() : null,
      transliteration: _transliterationController.text.trim().isNotEmpty ? _transliterationController.text.trim() : null,
      quote: _quoteEnController.text.trim().isNotEmpty ? _quoteEnController.text.trim() : null,
      quoteGu: _quoteGuController.text.trim().isNotEmpty ? _quoteGuController.text.trim() : null,
      quoteHi: _quoteHiController.text.trim().isNotEmpty ? _quoteHiController.text.trim() : null,
      contextText: _contextEnController.text.trim().isNotEmpty ? _contextEnController.text.trim() : null,
      contextTextGu: _contextGuController.text.trim().isNotEmpty ? _contextGuController.text.trim() : null,
      contextTextHi: _contextHiController.text.trim().isNotEmpty ? _contextHiController.text.trim() : null,
      whyItMatters: _whyMattersEnController.text.trim().isNotEmpty ? _whyMattersEnController.text.trim() : null,
      whyItMattersGu: _whyMattersGuController.text.trim().isNotEmpty ? _whyMattersGuController.text.trim() : null,
      whyItMattersHi: _whyMattersHiController.text.trim().isNotEmpty ? _whyMattersHiController.text.trim() : null,
      reflectionPreview: _reflPrevEnController.text.trim().isNotEmpty ? _reflPrevEnController.text.trim() : null,
      reflectionPreviewGu: _reflPrevGuController.text.trim().isNotEmpty ? _reflPrevGuController.text.trim() : null,
      reflectionPreviewHi: _reflPrevHiController.text.trim().isNotEmpty ? _reflPrevHiController.text.trim() : null,
      reflectionFull: _reflFullEnController.text.trim().isNotEmpty ? _reflFullEnController.text.trim() : null,
      reflectionFullGu: _reflFullGuController.text.trim().isNotEmpty ? _reflFullGuController.text.trim() : null,
      reflectionFullHi: _reflFullHiController.text.trim().isNotEmpty ? _reflFullHiController.text.trim() : null,
      oneThingToNotice: _oneThingEnController.text.trim().isNotEmpty ? _oneThingEnController.text.trim() : null,
      oneThingToNoticeGu: _oneThingGuController.text.trim().isNotEmpty ? _oneThingGuController.text.trim() : null,
      oneThingToNoticeHi: _oneThingHiController.text.trim().isNotEmpty ? _oneThingHiController.text.trim() : null,
      tryThis: _tryThisEnController.text.trim().isNotEmpty ? _tryThisEnController.text.trim() : null,
      tryThisGu: _tryThisGuController.text.trim().isNotEmpty ? _tryThisGuController.text.trim() : null,
      tryThisHi: _tryThisHiController.text.trim().isNotEmpty ? _tryThisHiController.text.trim() : null,
      carryThisWithYou: _carryEnController.text.trim().isNotEmpty ? _carryEnController.text.trim() : null,
      carryThisWithYouGu: _carryGuController.text.trim().isNotEmpty ? _carryGuController.text.trim() : null,
      carryThisWithYouHi: _carryHiController.text.trim().isNotEmpty ? _carryHiController.text.trim() : null,
      audioUrl: _audioEnController.text.trim().isNotEmpty ? _audioEnController.text.trim() : null,
      audioUrlGu: _audioGuController.text.trim().isNotEmpty ? _audioGuController.text.trim() : null,
      audioUrlHi: _audioHiController.text.trim().isNotEmpty ? _audioHiController.text.trim() : null,
      published: _published,
      createdAt: widget.verse?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await context.read<VersesProvider>().saveVerse(model);
    if (mounted && success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verse #$verseNum saved successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.verse != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 900,
        constraints: const BoxConstraints(maxHeight: 900),
        child: Column(
          children: [
            // Modal Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: AdminColors.primaryDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.format_quote, color: AdminColors.saffron, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    isEditing
                        ? 'Edit Verse #${widget.verse!.verseNumber} (${widget.bookId} Ch ${widget.chapterNumber})'
                        : 'Add New Verse (${widget.bookId} Ch ${widget.chapterNumber})',
                    style: GoogleFonts.cinzel(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              color: AdminColors.bgSubtle,
              child: TabBar(
                controller: _tabController,
                labelColor: AdminColors.primaryDark,
                unselectedLabelColor: AdminColors.textSecondary,
                indicatorColor: AdminColors.saffron,
                tabs: const [
                  Tab(text: 'Sanskrit & Translation'),
                  Tab(text: 'Explanations & Meaning'),
                  Tab(text: 'Reflections & Prompts'),
                  Tab(text: 'Audio & Media'),
                ],
              ),
            ),

            // Form Body
            Expanded(
              child: Form(
                key: _formKey,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Sanskrit & Translations
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Verse Number', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _numberController,
                                      keyboardType: TextInputType.number,
                                      enabled: !isEditing,
                                      decoration: const InputDecoration(hintText: '1'),
                                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Roman Transliteration', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _transliterationController,
                                      decoration: const InputDecoration(hintText: 'dhṛtarāṣṭra uvāca...'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Text('Original Sanskrit Shloka (Devanagari)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _sanskritController,
                            maxLines: 4,
                            decoration: const InputDecoration(hintText: 'धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः।\nमामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय॥'),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Sanskrit text is required' : null,
                          ),
                          const SizedBox(height: 20),

                          Text('English Translation', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _englishController,
                            maxLines: 3,
                            decoration: const InputDecoration(hintText: 'Dhritarashtra said: O Sanjaya, assembled on the sacred plain of Kurukshetra...'),
                            validator: (v) => v == null || v.trim().isEmpty ? 'English translation required' : null,
                          ),
                          const SizedBox(height: 16),

                          Text('Gujarati Translation (ગુજરાતી અનુવાદ)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _gujaratiController,
                            maxLines: 3,
                            decoration: const InputDecoration(hintText: 'ધૃતરાષ્ટ્ર કહ્યું: હે સંજય, કુરુક્ષેત્રના પવિત્ર મેદાનમાં એકઠા થયેલા...'),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Gujarati translation required' : null,
                          ),
                          const SizedBox(height: 16),

                          Text('Hindi Translation (हिंदी अनुवाद)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _hindiController,
                            maxLines: 3,
                            decoration: const InputDecoration(hintText: 'धृतराष्ट्र ने कहा: हे संजय! धर्मभूमि कुरुक्षेत्र में एकत्र हुए...'),
                          ),
                        ],
                      ),
                    ),

                    // Tab 2: Explanations & Meanings
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Meaning / Explanation (English)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _meaningEnController,
                            maxLines: 4,
                            decoration: const InputDecoration(hintText: 'Deep spiritual explanation of this shloka...'),
                          ),
                          const SizedBox(height: 16),

                          Text('Meaning / Explanation (Gujarati)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _meaningGuController,
                            maxLines: 4,
                            decoration: const InputDecoration(hintText: 'આ શ્લોકનો ગહન આધ્યાત્મિક અર્થ...'),
                          ),
                          const SizedBox(height: 16),

                          Text('Meaning / Explanation (Hindi)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _meaningHiController,
                            maxLines: 4,
                            decoration: const InputDecoration(hintText: 'इस श्लोक का गूढ़ आध्यात्मिक अर्थ...'),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _quoteEnController,
                                  decoration: const InputDecoration(labelText: 'Key Quote (English)'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _quoteGuController,
                                  decoration: const InputDecoration(labelText: 'Key Quote (Gujarati)'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _quoteHiController,
                                  decoration: const InputDecoration(labelText: 'Key Quote (Hindi)'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Tab 3: Reflections & Actionable Prompts
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Why It Matters (English)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _whyMattersEnController,
                            maxLines: 2,
                            decoration: const InputDecoration(hintText: 'Why this verse is relevant for daily life...'),
                          ),
                          const SizedBox(height: 16),

                          Text('Why It Matters (Gujarati)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _whyMattersGuController,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),

                          Text('Full Reflection (English)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _reflFullEnController,
                            maxLines: 4,
                            decoration: const InputDecoration(hintText: 'Detailed reflective commentary...'),
                          ),
                          const SizedBox(height: 16),

                          Text('One Thing to Notice (English)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _oneThingEnController,
                            decoration: const InputDecoration(hintText: 'Notice the next time your mood changes...'),
                          ),
                          const SizedBox(height: 16),

                          Text('Try This (English Actionable)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _tryThisEnController,
                            decoration: const InputDecoration(hintText: 'Before checking the result, ask...'),
                          ),
                        ],
                      ),
                    ),

                    // Tab 4: Audio URLs & Media
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Chanting / Audio Recitation URLs', style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold)),
                          const Divider(),
                          const SizedBox(height: 12),

                          Text('Audio URL (Default / English)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _audioEnController,
                            decoration: const InputDecoration(hintText: 'https://firebasestorage.googleapis.com/.../verse_1_en.mp3'),
                          ),
                          const SizedBox(height: 16),

                          Text('Audio URL (Gujarati)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _audioGuController,
                            decoration: const InputDecoration(hintText: 'https://firebasestorage.googleapis.com/.../verse_1_gu.mp3'),
                          ),
                          const SizedBox(height: 16),

                          Text('Audio URL (Hindi)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _audioHiController,
                            decoration: const InputDecoration(hintText: 'https://firebasestorage.googleapis.com/.../verse_1_hi.mp3'),
                          ),
                          const SizedBox(height: 24),

                          Row(
                            children: [
                              Switch(
                                value: _published,
                                activeColor: AdminColors.success,
                                onChanged: (v) {
                                  setState(() {
                                    _published = v;
                                  });
                                },
                              ),
                              Text(
                                _published ? 'Published (Visible to Mobile App)' : 'Draft',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  color: _published ? AdminColors.success : AdminColors.warning,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Modal Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: AdminColors.bgSubtle,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _handleSave,
                    child: const Text('Save Verse'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
