import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Saves generated PDF progress reports to the device (offline).
///
/// Replaces the previous Supabase Storage upload + `notify_report` edge
/// function. Sharing/sending is handled by the caller via `share_plus`.
class ReportService {
  /// Write [bytes] to a PDF file in the app documents directory and return it.
  Future<File> saveReport(
    Uint8List bytes, {
    String? suggestedName,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    final name = suggestedName ?? 'StoryTots_Report_$y-$m-$d.pdf';
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
