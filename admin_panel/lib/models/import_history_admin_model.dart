import 'package:cloud_firestore/cloud_firestore.dart';

class ImportHistoryAdminModel {
  final String id;
  final String fileName;
  final String bookId;
  final String bookName;
  final int totalRows;
  final int successCount;
  final int errorCount;
  final String status;
  final List<String> errors;
  final DateTime timestamp;
  final String importedBy;

  ImportHistoryAdminModel({
    required this.id,
    required this.fileName,
    required this.bookId,
    required this.bookName,
    required this.totalRows,
    required this.successCount,
    required this.errorCount,
    required this.status,
    required this.errors,
    required this.timestamp,
    required this.importedBy,
  });

  factory ImportHistoryAdminModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ImportHistoryAdminModel(
      id: doc.id,
      fileName: data['fileName'] ?? 'unknown.csv',
      bookId: data['bookId'] ?? '',
      bookName: data['bookName'] ?? '',
      totalRows: (data['totalRows'] as num?)?.toInt() ?? 0,
      successCount: (data['successCount'] as num?)?.toInt() ?? 0,
      errorCount: (data['errorCount'] as num?)?.toInt() ?? 0,
      status: data['status'] ?? 'completed',
      errors: List<String>.from(data['errors'] ?? []),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      importedBy: data['importedBy'] ?? 'Admin',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'bookId': bookId,
      'bookName': bookName,
      'totalRows': totalRows,
      'successCount': successCount,
      'errorCount': errorCount,
      'status': status,
      'errors': errors,
      'timestamp': FieldValue.serverTimestamp(),
      'importedBy': importedBy,
    };
  }
}
