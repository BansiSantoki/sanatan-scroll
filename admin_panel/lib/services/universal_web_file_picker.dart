import 'dart:async';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

/// Production Universal Web File Picker for Chrome, Edge, Firefox, and Safari
class UniversalWebFilePicker {
  static Future<PlatformFile?> pickCsvFile() async {
    if (kIsWeb) {
      try {
        final completer = Completer<PlatformFile?>();
        final uploadInput = html.FileUploadInputElement();
        uploadInput.accept = '.xlsx,.xls,.csv,.txt,text/csv,text/plain,application/vnd.ms-excel,application/csv,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        uploadInput.multiple = false;
        uploadInput.click();

        uploadInput.onChange.listen((event) {
          final files = uploadInput.files;
          if (files == null || files.isEmpty) {
            if (!completer.isCompleted) completer.complete(null);
            return;
          }
          final file = files.first;
          final reader = html.FileReader();

          reader.onLoadEnd.listen((e) {
            final result = reader.result;
            Uint8List bytes;
            if (result is Uint8List) {
              bytes = result;
            } else if (result is List<int>) {
              bytes = Uint8List.fromList(result);
            } else if (result is ByteBuffer) {
              bytes = Uint8List.view(result);
            } else {
              bytes = Uint8List(0);
            }

            if (!completer.isCompleted) {
              completer.complete(PlatformFile(
                name: file.name,
                size: file.size,
                bytes: bytes,
              ));
            }
          });

          reader.onError.listen((e) {
            if (!completer.isCompleted) {
              completer.completeError('Failed to read file in Chrome: ${reader.error}');
            }
          });

          reader.readAsArrayBuffer(file);
        });

        return await completer.future.timeout(
          const Duration(minutes: 5),
          onTimeout: () => null,
        );
      } catch (e) {
        print('[UNIVERSAL WEB FILE PICKER FALLBACK]: $e');
      }
    }

    // Standard Fallback for non-web or fallback environments
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv', 'txt'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files.first;
    }
    return null;
  }
}
