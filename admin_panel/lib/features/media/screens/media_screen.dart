import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/loading_state_widget.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../providers/media_provider.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  void _handleUpload(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'mp3', 'wav', 'aac'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final bytes = file.bytes;
        if (bytes != null) {
          final ext = file.extension?.toLowerCase() ?? 'png';
          final contentType = ['mp3', 'wav', 'aac'].contains(ext) ? 'audio/$ext' : 'image/$ext';
          final filename = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';

          final url = await context.read<MediaProvider>().uploadMedia(
                bytes: bytes,
                filename: filename,
                contentType: contentType,
              );

          if (context.mounted && url != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Media asset uploaded successfully.')),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload media: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaProvider = context.watch<MediaProvider>();

    if (mediaProvider.isLoading) {
      return const LoadingStateWidget(message: 'Loading Firebase Storage assets...');
    }

    final mediaItems = mediaProvider.mediaItems;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Firebase Storage Media Manager',
                    style: GoogleFonts.cinzel(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AdminColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bucket: sanatan-scroll-19b25.firebasestorage.app',
                    style: GoogleFonts.inter(fontSize: 12, color: AdminColors.textMuted),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => mediaProvider.loadMedia(),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _handleUpload(context),
                    icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                    label: const Text('Upload Media File'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          Expanded(
            child: mediaItems.isEmpty
                ? EmptyStateWidget(
                    title: 'No Media Assets Uploaded',
                    message: 'Upload book cover images or audio clips to Firebase Storage.',
                    actionLabel: 'Upload Media',
                    onAction: () => _handleUpload(context),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 280,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: mediaItems.length,
                    itemBuilder: (context, index) {
                      final item = mediaItems[index];
                      final isImage = item.name.toLowerCase().endsWith('.png') ||
                          item.name.toLowerCase().endsWith('.jpg') ||
                          item.name.toLowerCase().endsWith('.jpeg') ||
                          item.name.toLowerCase().endsWith('.webp');

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail Preview
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                color: AdminColors.bgSubtle,
                                child: isImage
                                    ? Image.network(
                                        item.downloadUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Center(
                                          child: Icon(Icons.broken_image, size: 40, color: AdminColors.textMuted),
                                        ),
                                      )
                                    : const Center(
                                        child: Icon(Icons.audiotrack, size: 48, color: AdminColors.primary),
                                      ),
                              ),
                            ),

                            // Details & Copy
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AdminColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${(item.size / 1024).toStringAsFixed(1)} KB',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AdminColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                          ),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: item.downloadUrl));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Storage URL copied to clipboard.')),
                                            );
                                          },
                                          icon: const Icon(Icons.copy, size: 14),
                                          label: const Text('Copy URL', style: TextStyle(fontSize: 12)),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 18, color: AdminColors.error),
                                        onPressed: () async {
                                          final confirm = await ConfirmationDialog.show(
                                            context,
                                            title: 'Delete Storage Asset',
                                            content: 'Are you sure you want to delete "${item.name}" from Storage?',
                                            confirmLabel: 'Delete File',
                                            isDestructive: true,
                                          );
                                          if (confirm == true) {
                                            mediaProvider.deleteMedia(item.path, item.name);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
