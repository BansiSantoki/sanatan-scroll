import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareService {
  ShareService._();

  static Future<void> share({
    required String title,
    required String text,
  }) {
    return Share.share(text, subject: title);
  }

  static Future<bool> shareToWhatsApp(String text) async {
    final uri = Uri.https('wa.me', '/', {'text': text});
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> showOptions({
    required BuildContext context,
    required String title,
    required String text,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.ios_share_outlined),
                title: const Text('Share with other apps'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  share(title: title, text: text);
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat_outlined),
                title: const Text('Share to WhatsApp'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await shareToWhatsApp(text);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
