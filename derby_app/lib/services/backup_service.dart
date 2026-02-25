import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

/// Resultado de la importación de backup.
class ImportResult {
  final bool success;
  final String? error;
  final Map<String, dynamic>? data;

  const ImportResult.success(this.data) : success = true, error = null;
  const ImportResult.failure(this.error) : success = false, data = null;
}

class BackupService {
  /// Obtiene el directorio para exportar archivos (Escritorio o Documentos).
  /// En Windows, crea una carpeta "DerbyManager" en C:\ProgramData para datos,
  /// pero exporta a Documentos/DerbyManager para exportaciones visibles al usuario.
  Future<Directory> _getExportDir() async {
    final Directory dir;

    if (Platform.isWindows) {
      // En Windows, crear carpeta en Documentos/DerbyManager
      final docs = await getApplicationDocumentsDirectory();
      dir = Directory('${docs.path}${Platform.pathSeparator}DerbyManager');
    } else if (Platform.isMacOS || Platform.isLinux) {
      // En macOS/Linux, usar la carpeta de Application Support
      final support = await getApplicationSupportDirectory();
      dir = Directory('${support.path}${Platform.pathSeparator}exports');
    } else {
      // Móvil: usar Documents
      final docs = await getApplicationDocumentsDirectory();
      dir = Directory('${docs.path}${Platform.pathSeparator}DerbyManager');
    }

    // Crear si no existe
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    return dir;
  }

  /// Exporta contenido CSV a un archivo y lo abre.
  /// Retorna la ruta del archivo creado.
  Future<String> exportarCsv(String content, String filename) async {
    final dir = await _getExportDir();
    final file = File('${dir.path}${Platform.pathSeparator}$filename');
    await file.writeAsString(content, flush: true);
    await _abrirArchivo(file.path);
    return file.path;
  }

  Future<String> exportarJson(Map<String, dynamic> payload) async {
    final dir = await _getExportDir();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File(
      '${dir.path}${Platform.pathSeparator}derby_backup_$timestamp.json',
    );

    final pretty = const JsonEncoder.withIndent('  ').convert(payload);
    await file.writeAsString(pretty);
    await _abrirArchivo(file.path);

    return file.path;
  }

  /// Importa un archivo JSON de backup.
  /// Retorna [ImportResult] con los datos o un error.
  Future<ImportResult> importarJson() async {
    try {
      // Abrir selector de archivos
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return const ImportResult.failure('No se seleccionó ningún archivo');
      }

      final file = File(result.files.first.path!);
      if (!await file.exists()) {
        return const ImportResult.failure('El archivo no existe');
      }

      final content = await file.readAsString();
      final data = json.decode(content) as Map<String, dynamic>;

      // Validar estructura básica
      if (!data.containsKey('meta') || !data.containsKey('derby')) {
        return const ImportResult.failure(
          'Formato de backup inválido: faltan campos requeridos (meta, derby)',
        );
      }

      final meta = data['meta'] as Map<String, dynamic>;
      if (meta['app'] != 'Derby Manager') {
        return const ImportResult.failure(
          'Este archivo no es un backup de Derby Manager',
        );
      }

      return ImportResult.success(data);
    } on FormatException catch (e) {
      return ImportResult.failure('Error de formato JSON: ${e.message}');
    } catch (e) {
      return ImportResult.failure('Error al importar: $e');
    }
  }

  Future<void> _abrirArchivo(String filePath) async {
    try {
      if (Platform.isMacOS) {
        await Process.run('open', [filePath]);
        return;
      }

      if (Platform.isWindows) {
        await Process.run('cmd', [
          '/c',
          'start',
          '',
          filePath,
        ], runInShell: true);
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
