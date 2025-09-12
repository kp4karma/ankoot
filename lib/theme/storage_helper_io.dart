import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PlatformStorage {
  static Future<String> readLogs(String path) async {
    final file = File(path);
    if (!await file.exists()) return '';
    return await file.readAsString();
  }

  static Future<void> writeLogs(String path, String content) async {
    final file = File(path);
    await file.writeAsString(content, mode: FileMode.append);
  }

  static Future<void> clearLogs(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.writeAsString('');
    }
  }

  static Future<String> getLogFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/secure_error_logs.txt';
  }
}
