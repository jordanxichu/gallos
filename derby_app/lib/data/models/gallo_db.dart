import 'package:isar/isar.dart';

part 'gallo_db.g.dart';

/// Modelo Isar para persistir Gallo.
@collection
class GalloDb {
  Id id = Isar.autoIncrement;

  /// ID único del engine
  @Index(unique: true)
  late String uid;

  /// ID del participante dueño
  @Index()
  late String participanteId;

  late double peso;
  String? anillo;

  /// activo, retirado, eliminado
  String estado = 'activo';

  DateTime createdAt = DateTime.now();
}
