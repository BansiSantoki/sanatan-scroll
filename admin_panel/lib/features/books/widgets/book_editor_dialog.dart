import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../models/sacred_book_admin_model.dart';
import '../../../providers/books_provider.dart';
import '../../../providers/media_provider.dart';

class BookEditorDialog extends StatefulWidget {
  final SacredBookAdminModel? book;

  const BookEditorDialog({super.key, this.book});

  static Future<void> show(BuildContext context, {SacredBookAdminModel? book}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => BookEditorDialog(book: book),
    );
  }

  @override
  State<BookEditorDialog> createState() => _BookEditorDialogState();
}

class _BookEditorDialogState extends State<BookEditorDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _idController;
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _titleEnController;
  late TextEditingController _titleGuController;
  late TextEditingController _titleHiController;
  late TextEditingController _subtitleEnController;
  late TextEditingController _subtitleGuController;
  late TextEditingController _subtitleHiController;
  late TextEditingController _emojiController;
  late TextEditingController _coverUrlController;
  late TextEditingController _chaptersController;
  late TextEditingController _orderController;

  bool _published = true;
  bool _isUploadingCover = false;

  @override
  void initState() {
    super.initState();
    final b = widget.book;
    _idController = TextEditingController(text: b?.id ?? '');
    _titleController = TextEditingController(text: b?.title ?? '');
    _subtitleController = TextEditingController(text: b?.subtitle ?? '');
    _titleEnController = TextEditingController(text: b?.titleEn ?? '');
    _titleGuController = TextEditingController(text: b?.titleGu ?? '');
    _titleHiController = TextEditingController(text: b?.titleHi ?? '');
    _subtitleEnController = TextEditingController(text: b?.subtitleEn ?? '');
    _subtitleGuController = TextEditingController(text: b?.subtitleGu ?? '');
    _subtitleHiController = TextEditingController(text: b?.subtitleHi ?? '');
    _emojiController = TextEditingController(text: b?.iconEmoji ?? '📜');
    _coverUrlController = TextEditingController(text: b?.coverUrl ?? '');
    _chaptersController = TextEditingController(text: (b?.totalChapters ?? 18).toString());
    _orderController = TextEditingController(text: (b?.order ?? 1).toString());
    _published = b?.published ?? true;
  }

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    _titleEnController.dispose();
    _titleGuController.dispose();
    _titleHiController.dispose();
    _subtitleEnController.dispose();
    _subtitleGuController.dispose();
    _subtitleHiController.dispose();
    _emojiController.dispose();
    _coverUrlController.dispose();
    _chaptersController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _handlePickAndUploadCover() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final bytes = file.bytes;
        if (bytes != null) {
          setState(() {
            _isUploadingCover = true;
          });
          final filename = 'cover_${DateTime.now().millisecondsSinceEpoch}_${file.name}';
          final url = await context.read<MediaProvider>().uploadMedia(
                bytes: bytes,
                filename: filename,
                contentType: 'image/jpeg',
              );
          if (url != null) {
            setState(() {
              _coverUrlController.text = url;
            });
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload cover image: $e')),
      );
    } finally {
      setState(() {
        _isUploadingCover = false;
      });
    }
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final id = _idController.text.trim().toLowerCase().replaceAll(' ', '_');
    final model = SacredBookAdminModel(
      id: id,
      title: _titleController.text.trim(),
      subtitle: _subtitleController.text.trim(),
      titleEn: _titleEnController.text.trim().isNotEmpty ? _titleEnController.text.trim() : null,
      titleGu: _titleGuController.text.trim().isNotEmpty ? _titleGuController.text.trim() : null,
      titleHi: _titleHiController.text.trim().isNotEmpty ? _titleHiController.text.trim() : null,
      subtitleEn: _subtitleEnController.text.trim().isNotEmpty ? _subtitleEnController.text.trim() : null,
      subtitleGu: _subtitleGuController.text.trim().isNotEmpty ? _subtitleGuController.text.trim() : null,
      subtitleHi: _subtitleHiController.text.trim().isNotEmpty ? _subtitleHiController.text.trim() : null,
      iconEmoji: _emojiController.text.trim().isNotEmpty ? _emojiController.text.trim() : '📜',
      coverUrl: _coverUrlController.text.trim().isNotEmpty ? _coverUrlController.text.trim() : null,
      totalChapters: int.tryParse(_chaptersController.text) ?? 1,
      order: int.tryParse(_orderController.text) ?? 1,
      published: _published,
      createdAt: widget.book?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await context.read<BooksProvider>().saveBook(model);
    if (mounted && success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book "${model.title}" saved successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;

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
                  const Icon(Icons.menu_book, color: AdminColors.saffron, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? 'Edit Sacred Book' : 'Add New Sacred Book',
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
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Book ID (Unique Slug)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _idController,
                                  enabled: !isEditing,
                                  decoration: const InputDecoration(hintText: 'bhagavad_gita'),
                                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Emoji Icon', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _emojiController,
                                  decoration: const InputDecoration(hintText: '📜'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Order Index', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _orderController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(hintText: '1'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Primary Title', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _titleController,
                                  decoration: const InputDecoration(hintText: 'Bhagavad Gita'),
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
                                  decoration: const InputDecoration(hintText: 'The Song of God'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Chapters', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _chaptersController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(hintText: '18'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Text('Multilingual Titles & Subtitles', style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold)),
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
                              decoration: const InputDecoration(labelText: 'Title Gujarati (શ્રીમદ્ ભગવદ્ ગીતા)'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _titleHiController,
                              decoration: const InputDecoration(labelText: 'Title Hindi (श्रीमद्भगवद्गीता)'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _subtitleEnController,
                              decoration: const InputDecoration(labelText: 'Subtitle English'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _subtitleGuController,
                              decoration: const InputDecoration(labelText: 'Subtitle Gujarati'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _subtitleHiController,
                              decoration: const InputDecoration(labelText: 'Subtitle Hindi'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Text('Cover Image & Storage Reference', style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Divider(),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _coverUrlController,
                              decoration: const InputDecoration(
                                hintText: 'https://firebasestorage.googleapis.com/...',
                                labelText: 'Cover Image URL',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _isUploadingCover ? null : _handlePickAndUploadCover,
                            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.saffron),
                            icon: _isUploadingCover
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Icon(Icons.cloud_upload_outlined, size: 18),
                            label: const Text('Upload Cover'),
                          ),
                        ],
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
                            _published ? 'Published (Visible to Seekers)' : 'Draft (Admin Only)',
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
                    child: const Text('Save Sacred Book'),
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
