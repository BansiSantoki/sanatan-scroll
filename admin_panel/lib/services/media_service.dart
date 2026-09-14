import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class MediaItemAdminModel {
  final String name;
  final String path;
  final String downloadUrl;
  final int size;
  final DateTime? timeCreated;

  const MediaItemAdminModel({
    required this.name,
    required this.path,
    required this.downloadUrl,
    required this.size,
    this.timeCreated,
  });
}

class MediaService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadBytes({
    required Uint8List bytes,
    required String path,
    required String contentType,
  }) async {
    try {
      final ref = _storage.ref().child(path);
      final metadata = SettableMetadata(contentType: contentType);
      final uploadTask = await ref.putData(bytes, metadata);
      final url = await uploadTask.ref.getDownloadURL();
      return url;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading bytes to Firebase Storage: $e');
      }
      return null;
    }
  }

  Future<List<MediaItemAdminModel>> listMedia({String folder = 'media'}) async {
    try {
      final ListResult result = await _storage.ref().child(folder).listAll();
      final List<MediaItemAdminModel> items = [];

      for (final ref in result.items) {
        try {
          final url = await ref.getDownloadURL();
          final meta = await ref.getMetadata();
          items.add(
            MediaItemAdminModel(
              name: ref.name,
              path: ref.fullPath,
              downloadUrl: url,
              size: meta.size ?? 0,
              timeCreated: meta.timeCreated,
            ),
          );
        } catch (_) {}
      }

      items.sort((a, b) => (b.timeCreated ?? DateTime(1970)).compareTo(a.timeCreated ?? DateTime(1970)));
      return items;
    } catch (e) {
      if (kDebugMode) {
        print('Error listing media from Storage: $e');
      }
      return [];
    }
  }

  Future<bool> deleteMedia(String path) async {
    try {
      await _storage.ref().child(path).delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting media from Storage: $e');
      }
      return false;
    }
  }
}
