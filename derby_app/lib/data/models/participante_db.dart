import 'package:isar/isar.dart';

part 'participante_db.g.dart';

/// Modelo Isar para persistir Participante.
@collection
class ParticipanteDb {
  Id id = Isar.autoIncrement;

  /// ID único del engine
  @Index()
  late String uid;

  late String nombre;
  String? equipo;
  String? telefono;

  int puntosTotales = 0;
  int peleasGanadas = 0;
  int peleasPerdidas = 0;
  int peleasEmpatadas = 0;

  /// IDs de participantes compadres (no pueden enfrentarse nunca)
  List<String> compadres = [];

  DateTime createdAt = DateTime.now();
}
