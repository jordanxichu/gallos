import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/models.dart';

/// Servicio singleton para manejar la base de datos Isar.
class DatabaseService {
  static Isar? _isar;

  /// Obtiene la instancia de Isar, inicializando si es necesario.
  static Future<Isar> get instance async {
    if (_isar != null) return _isar!;

    // Usar Application Support en macOS (siempre permitido en sandbox)
    // En otras plataformas usar Documents
    final Directory dir;
    if (Platform.isMacOS) {
      dir = await getApplicationSupportDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    // Asegurar que el directorio existe
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    print('📁 Isar directory: ${dir.path}');

    _isar = await Isar.open(
      [
        ParticipanteDbSchema,
        GalloDbSchema,
        DerbyDbSchema,
        RondaDbSchema,
        PeleaDbSchema,
      ],
      directory: dir.path,
      name: 'derby_manager',
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
