import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class BackupService {
  Future<String> exportarJson(Map<String, dynamic> payload) async {
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/derby_backup_$timestamp.json');

    final pretty = const JsonEncoder.withIndent('  ').convert(payload);
    await file.writeAsString(pretty);
    await _abrirArchivo(file.path);

    return file.path;
  }

  Future<void> _abrirArchivo(String filePath) async {
    try {
      if (Platform.isMacOS) {
        await Process.run('open', [filePath]);
        return;
      }

      if (Platform.isWindows) {
        await Process.run(
          'cmd',
          ['/c', 'start', '', filePath],
          runInShell: true,
        );
        return;
      }

      if (Platform.isLinux) {
        await Process.run('xdg-open', [filePath]);
      }
    } catch (_) {
      // no-op
    }
  }
}
