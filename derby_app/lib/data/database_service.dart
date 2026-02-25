import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/models.dart';

/// Servicio singleton para manejar la base de datos Isar.
class DatabaseService {
  static Isar? _isar;

  /// Nombre de la base de datos según el modo de compilación.
  /// Esto evita que datos de desarrollo aparezcan en releases.
  static String get _databaseName =>
      kDebugMode ? 'derby_manager_dev' : 'derby_manager';

  /// Obtiene la instancia de Isar, inicializando si es necesario.
  static Future<Isar> get instance async {
    if (_isar != null) return _isar!;

    // En desktop usar Application Support (evita Documents en Windows).
    // En móvil/web se mantiene Documents.
    final Directory dir;
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      dir = await getApplicationSupportDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    // Asegurar que el directorio existe
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    print('📁 Isar directory: ${dir.path}');
    print('📦 Database name: $_databaseName (${kDebugMode ? "DEBUG" : "RELEASE"})');

    _isar = await Isar.open(
      [
        ParticipanteDbSchema,
        GalloDbSchema,
        DerbyDbSchema,
        RondaDbSchema,
        PeleaDbSchema,
        LicenseDbSchema,
        AuditLogDbSchema,
      ],
      directory: dir.path,
      name: _databaseName,
    );

    print('✅ Isar initialized successfully');

    return _isar!;
  }

  /// Cierra la base de datos.
  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
