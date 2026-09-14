import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../models/sacred_chapter_admin_model.dart';
import '../../../providers/chapters_provider.dart';

class ChapterEditorDialog extends StatefulWidget {
  final SacredChapterAdminModel? chapter;
  final String bookId;

  const ChapterEditorDialog({
    super.key,
    this.chapter,
    required this.bookId,
  });

  static Future<void> show(
    BuildContext context, {
    required String bookId,
    SacredChapterAdminModel? chapter,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ChapterEditorDialog(bookId: bookId, chapter: chapter),
    );
  }

  @override
  State<ChapterEditorDialog> createState() => _ChapterEditorDialogState();
}

class _ChapterEditorDialogState extends State<ChapterEditorDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _numberController;
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _titleEnController;
  late TextEditingController _titleGuController;
  late TextEditingController _titleHiController;
  late TextEditingController _subtitleEnController;
  late TextEditingController _subtitleGuController;
  late TextEditingController _subtitleHiController;
  late TextEditingController _descEnController;
  late TextEditingController _descGuController;
  late TextEditingController _descHiController;
  late TextEditingController _orderController;

  bool _published = true;

  @override
  void initState() {
    super.initState();
    final c = widget.chapter;
    _numberController = TextEditingController(text: (c?.chapterNumber ?? 1).toString());
    _titleController = TextEditingController(text: c?.title ?? '');
    _subtitleController = TextEditingController(text: c?.subtitle ?? '');
    _titleEnController = TextEditingController(text: c?.titleEn ?? '');
    _titleGuController = TextEditingController(text: c?.titleGu ?? '');
    _titleHiController = TextEditingController(text: c?.titleHi ?? '');
    _subtitleEnController = TextEditingController(text: c?.subtitleEn ?? '');
    _subtitleGuController = TextEditingController(text: c?.subtitleGu ?? '');
    _subtitleHiController = TextEditingController(text: c?.subtitleHi ?? '');
    _descEnController = TextEditingController(text: c?.descriptionEnglish ?? '');
    _descGuController = TextEditingController(text: c?.descriptionGujarati ?? '');
    _descHiController = TextEditingController(text: c?.descriptionHindi ?? '');
    _orderController = TextEditingController(text: (c?.order ?? c?.chapterNumber ?? 1).toString());
    _published = c?.published ?? true;
  }

  @override
  void dispose() {
    _numberController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    _titleEnController.dispose();
    _titleGuController.dispose();
    _titleHiController.dispose();
    _subtitleEnController.dispose();
    _subtitleGuController.dispose();
    _subtitleHiController.dispose();
    _descEnController.dispose();
    _descGuController.dispose();
    _descHiController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final chNum = int.tryParse(_numberController.text) ?? 1;
    final model = SacredChapterAdminModel(
      chapterNumber: chNum,
      title: _titleController.text.trim(),
      subtitle: _subtitleController.text.trim(),
      titleEn: _titleEnController.text.trim().isNotEmpty ? _titleEnController.text.trim() : null,
      titleGu: _titleGuController.text.trim().isNotEmpty ? _titleGuController.text.trim() : null,
      titleHi: _titleHiController.text.trim().isNotEmpty ? _titleHiController.text.trim() : null,
      subtitleEn: _subtitleEnController.text.trim().isNotEmpty ? _subtitleEnController.text.trim() : null,
      subtitleGu: _subtitleGuController.text.trim().isNotEmpty ? _subtitleGuController.text.trim() : null,
      subtitleHi: _subtitleHiController.text.trim().isNotEmpty ? _subtitleHiController.text.trim() : null,
      descriptionEnglish: _descEnController.text.trim(),
      descriptionGujarati: _descGuController.text.trim(),
      descriptionHindi: _descHiController.text.trim().isNotEmpty ? _descHiController.text.trim() : null,
      order: int.tryParse(_orderController.text) ?? chNum,
      published: _published,
      createdAt: widget.chapter?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await context.read<ChaptersProvider>().saveChapter(model);
    if (mounted && success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chapter #$chNum "${model.title}" saved successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.chapter != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 750,
        constraints: const BoxConstraints(maxHeight: 850),
        child: Column(
          children: [
            // Modal Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: const BoxDecoration(
                color: AdminColors.primaryDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.collections_bookmark, color: AdminColors.saffron, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? 'Edit Chapter #${widget.chapter!.chapterNumber}' : 'Add New Chapter',
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

            // Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Chapter Number', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
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
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Primary Title', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _titleController,
                                  decoration: const InputDecoration(hintText: 'Arjuna Visada Yoga'),
                                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Primary Subtitle', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _subtitleController,
                                  decoration: const InputDecoration(hintText: 'Observing the Armies'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Text('Multilingual Chapter Titles', style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Divider(),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _titleEnController,
                              decoration: const InputDecoration(labelText: 'Title English'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _titleGuController,
                              decoration: const InputDecoration(labelText: 'Title Gujarati (અર્જુનવિષાદયોગ)'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _titleHiController,
                              decoration: const InputDecoration(labelText: 'Title Hindi (कुरुक्षेत्र के युद्धस्थल में सैन्यनिरीक्षण)'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Text('Chapter Summary & Multilingual Descriptions', style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Divider(),
                      const SizedBox(height: 8),

                      Text('Description (English)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descEnController,
                        maxLines: 3,
                        decoration: const InputDecoration(hintText: 'Summary of chapter themes in English...'),
                      ),
                      const SizedBox(height: 12),

                      Text('Description (Gujarati)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descGuController,
                        maxLines: 3,
                        decoration: const InputDecoration(hintText: 'અધ્યાયનો ટૂંકમાં ગુજરાતી વિવરણ...'),
                      ),
                      const SizedBox(height: 12),

                      Text('Description (Hindi)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descHiController,
                        maxLines: 3,
                        decoration: const InputDecoration(hintText: 'अध्याय का संक्षिप्त हिंदी विवरण...'),
                      ),
                      const SizedBox(height: 20),

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
                            _published ? 'Published (Visible in App)' : 'Draft',
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
                    child: const Text('Save Chapter'),
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
