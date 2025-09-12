import 'package:ankoot_new/theme/storage_helper_io.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SecureLogger {
  static final _key = encrypt.Key.fromBase64('Qr8N7YXVoJHkRFiQXAG9bg==');
  static final _iv = encrypt.IV.fromBase64('8Kqzl+SIdlv2iDx97mdYOg==');
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  static Future<void> write(String log) async {
    final path = await PlatformStorage.getLogFilePath();
    final timestamp = DateTime.now().toIso8601String();
    final encrypted = _encrypter.encrypt('[$timestamp] $log', iv: _iv);
    await PlatformStorage.writeLogs(path, '${encrypted.base64}\n');
  }

  static Future<String> readLogs() async {
    final path = await PlatformStorage.getLogFilePath();
    final data = await PlatformStorage.readLogs(path);
    if (data.isEmpty) return 'No logs found.';
    final lines = data.split('\n');
    return lines
        .map((line) {
          try {
            return _encrypter.decrypt64(line, iv: _iv);
          } catch (_) {
            return '⚠️ Failed to decrypt a log entry.';
          }
        })
        .join('\n');
  }

  static Future<void> clearLogs() async {
    final path = await PlatformStorage.getLogFilePath();
    await PlatformStorage.clearLogs(path);
  }
}
