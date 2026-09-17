import 'package:http/http.dart' as http;
import 'ramayana_parser_service.dart';

class SourceFetchResult {
  final String sourceUrl;
  final String sourceName;
  final List<RamayanaParsedRow> parsedRows;
  final bool success;
  final String? errorMessage;

  const SourceFetchResult({
    required this.sourceUrl,
    required this.sourceName,
    required this.parsedRows,
    required this.success,
    this.errorMessage,
  });
}

class SourceFetcherService {
  /// Fetch accessible source content from given URL
  Future<SourceFetchResult> fetchFromUrl(String rawUrl) async {
    String url = rawUrl.trim();
    if (url.isEmpty) {
      return const SourceFetchResult(
        sourceUrl: '',
        sourceName: 'Unknown',
        parsedRows: [],
        success: false,
        errorMessage: 'Source URL cannot be empty.',
      );
    }

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception("Connection timed out while fetching from $url");
        },
      );

      if (response.statusCode != 200) {
        return SourceFetchResult(
          sourceUrl: url,
          sourceName: uri.host,
          parsedRows: [],
          success: false,
          errorMessage: 'Failed to fetch source (HTTP Status ${response.statusCode}).',
        );
      }

      final bodyText = response.body;
      if (bodyText.trim().isEmpty) {
        return SourceFetchResult(
          sourceUrl: url,
          sourceName: uri.host,
          parsedRows: [],
          success: false,
          errorMessage: 'Source response was empty.',
        );
      }

      // Parse accessible structure
      final parsedRows = _extractVersesFromHtmlOrText(bodyText, url, uri.host);

      if (parsedRows.isEmpty) {
        return SourceFetchResult(
          sourceUrl: url,
          sourceName: uri.host,
          parsedRows: [],
          success: true,
          errorMessage: 'Fetched page successfully, but no structured Ramayana verses were automatically detected. You can upload the Master Sheet CSV/XLSX instead.',
        );
      }

      return SourceFetchResult(
        sourceUrl: url,
        sourceName: uri.host,
        parsedRows: parsedRows,
        success: true,
      );
    } catch (e) {
      return SourceFetchResult(
        sourceUrl: url,
        sourceName: 'External Source',
        parsedRows: [],
        success: false,
        errorMessage: 'Error fetching source content: $e',
      );
    }
  }

  /// Extractor algorithm to detect Ramayana structure (Kanda, Sarga, Shlok, Sanskrit text)
  List<RamayanaParsedRow> _extractVersesFromHtmlOrText(String text, String sourceUrl, String sourceName) {
    final rows = <RamayanaParsedRow>[];
    
    // Pattern to look for Shloks or verse markers in HTML text
    final verseRegex = RegExp(
      r'(?:Kanda\s*(\d+))?[\s\S]*?(?:Sarga\s*(\d+))?[\s\S]*?(?:Shlok|Verse)\s*(\d+)[\s\S]*?(?:Sanskrit:?\s*)?([॥\u0900-\u097F\s\n,.-]+(?:॥|\d+)?)+',
      caseSensitive: false,
    );

    final matches = verseRegex.allMatches(text);
    int count = 1;

    for (final m in matches) {
      final kanda = int.tryParse(m.group(1) ?? '1') ?? 1;
      final sarga = int.tryParse(m.group(2) ?? '1') ?? 1;
      final verse = int.tryParse(m.group(3) ?? count.toString()) ?? count;
      final sanskritText = m.group(4)?.trim() ?? '';

      if (sanskritText.length > 5) {
        final kandaPad = kanda.toString().padLeft(2, '0');
        final sargaPad = sarga.toString().padLeft(3, '0');
        final versePad = verse.toString().padLeft(3, '0');
        final verseId = 'RAM-$kandaPad-$sargaPad-$versePad';

        rows.add(
          RamayanaParsedRow(
            fileRowNumber: count,
            rawId: verseId,
            verseId: verseId,
            bookId: 'ramayana',
            bookName: 'Ramayana',
            kandaNumber: kanda,
            sargaNumber: sarga,
            verseNumber: verse,
            sanskrit: sanskritText,
            english: '',
            hindi: '',
            gujarati: '',
            explanation: '',
            sourceUrl: sourceUrl,
            sourceName: sourceName,
            qaStatus: 'Draft',
            notes: 'Extracted from Source URL: $sourceUrl',
            action: 'new',
          ),
        );
        count++;
      }
    }

    return rows;
  }
}
