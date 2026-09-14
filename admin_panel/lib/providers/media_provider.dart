import 'package:flutter/foundation.dart';
import '../services/media_service.dart';
import '../services/activity_logs_service.dart';

class MediaProvider extends ChangeNotifier {
  final MediaService _mediaService = MediaService();
  final ActivityLogsService _logsService = ActivityLogsService();

  List<MediaItemAdminModel> _mediaItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MediaItemAdminModel> get mediaItems => _mediaItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  MediaProvider() {
    loadMedia();
  }

  Future<void> loadMedia() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _mediaItems = await _mediaService.listMedia();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch media assets: $e';
      notifyListeners();
    }
  }

  Future<String?> uploadMedia({
    required Uint8List bytes,
    required String filename,
    required String contentType,
  }) async {
    _isLoading = true;
    notifyListeners();

    final path = 'media/$filename';
    final url = await _mediaService.uploadBytes(
      bytes: bytes,
      path: path,
      contentType: contentType,
    );

    if (url != null) {
      await _logsService.logAction(
        action: 'Uploaded Media Asset',
        target: filename,
        details: 'Path: $path',
      );
      await loadMedia();
    } else {
      _isLoading = false;
      _errorMessage = 'Failed to upload media.';
      notifyListeners();
    }
    return url;
  }

  Future<bool> deleteMedia(String path, String name) async {
    _isLoading = true;
    notifyListeners();

    final success = await _mediaService.deleteMedia(path);
    if (success) {
      await _logsService.logAction(
        action: 'Deleted Media Asset',
        target: name,
        details: 'Path: $path',
      );
      await loadMedia();
      return true;
    } else {
      _isLoading = false;
      _errorMessage = 'Failed to delete media asset.';
      notifyListeners();
      return false;
    }
  }
}
