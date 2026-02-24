import 'package:isar/isar.dart';

part 'rsa_keys.g.dart';

/// Almacena las claves RSA del administrador
@collection
class RsaKeys {
  Id id = Isar.autoIncrement;

  /// Clave privada en formato PEM
  late String privateKeyPem;

  /// Clave pública en formato PEM
  late String publicKeyPem;

  /// Fecha de creación
  DateTime createdAt = DateTime.now();

  /// Notas o identificador
  String? label;
}
