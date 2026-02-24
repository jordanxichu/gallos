import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/license_record.dart';
import 'models/rsa_keys.dart';

/// Servicio de base de datos Isar
class DatabaseService {
  static Isar? _isar;

  static Future<Isar> get instance async {
    if (_isar != null) {
      print('💾 DatabaseService: Returning existing Isar instance');
      return _isar!;
    }

    print('💾 DatabaseService: Getting documents directory...');
    final dir = await getApplicationDocumentsDirectory();
    print('💾 DatabaseService: Opening Isar at ${dir.path}...');

    _isar = await Isar.open(
      [
        LicenseRecordSchema,
        RsaKeysSchema,
      ],
      directory: dir.path,
      name: 'license_admin',
      inspector: true,
    );

    print('💾 DatabaseService: Isar opened successfully');
    return _isar!;
  }

  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
