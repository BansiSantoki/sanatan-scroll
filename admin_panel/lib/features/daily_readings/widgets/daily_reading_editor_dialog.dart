import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../models/daily_reading_admin_model.dart';
import '../../../providers/daily_readings_provider.dart';
import '../../../providers/books_provider.dart';

class DailyReadingEditorDialog extends StatefulWidget {
  final DailyReadingAdminModel? reading;

  const DailyReadingEditorDialog({super.key, this.reading});

  static Future<void> show(BuildContext context, {DailyReadingAdminModel? reading}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => DailyReadingEditorDialog(reading: reading),
    );
  }

  @override
  State<DailyReadingEditorDialog> createState() => _DailyReadingEditorDialogState();
}

class _DailyReadingEditorDialogState extends State<DailyReadingEditorDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _dateController;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _chapterController;
  late TextEditingController _verseController;
  String _selectedBookId = 'bhagavad_gita';
  bool _published = true;

  @override
  void initState() {
    super.initState();
    final r = widget.reading;
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);

    _dateController = TextEditingController(text: r?.dateString ?? todayStr);
    _titleController = TextEditingController(text: r?.title ?? '');
    _descController = TextEditingController(text: r?.description ?? '');
    _chapterController = TextEditingController(text: (r?.chapterNumber ?? 1).toString());
    _verseController = TextEditingController(text: (r?.verseNumber ?? 1).toString());
    _selectedBookId = r?.bookId ?? 'bhagavad_gita';
    _published = r?.published ?? true;
  }

  @override
  void dispose() {
    _dateController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _chapterController.dispose();
    _verseController.dispose();
    super.dispose();
  }

  void _handlePickDate() async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(_dateController.text) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toIso8601String().substring(0, 10);
      });
    }
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final dateStr = _dateController.text.trim();
    final model = DailyReadingAdminModel(
      id: widget.reading?.id ?? dateStr,
      dateString: dateStr,
      bookId: _selectedBookId,
      chapterNumber: int.tryParse(_chapterController.text) ?? 1,
      verseNumber: int.tryParse(_verseController.text) ?? 1,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      published: _published,
      createdAt: widget.reading?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await context.read<DailyReadingsProvider>().saveDailyReading(model);
    if (mounted && success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Daily Reading for $dateStr saved.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.reading != null;
    final books = context.watch<BooksProvider>().rawBooks;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 650,
        constraints: const BoxConstraints(maxHeight: 750),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: const BoxDecoration(
                color: AdminColors.primaryDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.today, color: AdminColors.saffron, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? 'Edit Daily Reading' : 'Schedule Daily Reading',
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

            // Form
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
                                Text('Date (YYYY-MM-DD)', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _dateController,
                                  readOnly: true,
                                  onTap: _handlePickDate,
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.calendar_today, size: 18),
                                  ),
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
                                Text('Book Reference', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: books.any((b) => b.id == _selectedBookId)
                                      ? _selectedBookId
                                      : (books.isNotEmpty ? books.first.id : 'bhagavad_gita'),
                                  decoration: const InputDecoration(),
                                  items: books.map((b) {
                                    return DropdownMenuItem<String>(
                                      value: b.id,
                                      child: Text('${b.iconEmoji} ${b.title}'),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        _selectedBookId = val;
                                      });
                                    }
                                  },
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Chapter Number', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _chapterController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(hintText: '2'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Verse Number', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _verseController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(hintText: '47'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Text('Title of the Day', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(hintText: 'Karmanye Vadhikaraste — Focus on Action'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Title is required' : null,
                      ),
                      const SizedBox(height: 16),

                      Text('Daily Reflection Message / Description', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descController,
                        maxLines: 4,
                        decoration: const InputDecoration(hintText: 'Today\'s wisdom scroll message for seekers...'),
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
                            _published ? 'Published (Active for this Date)' : 'Draft',
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
                    child: const Text('Save Daily Reading'),
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
