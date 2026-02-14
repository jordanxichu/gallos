import 'package:isar/isar.dart';

part 'derby_db.g.dart';

/// Modelo Isar para persistir un Derby completo.
@collection
class DerbyDb {
  Id id = Isar.autoIncrement;

  /// ID único del derby
  @Index(unique: true)
  late String uid;

  late String nombre;
  String? lugar;

  // Configuración
  int numeroRondas = 5;
  double toleranciaPeso = 50.0;
  int puntosVictoria = 3;
  int puntosDerrota = 0;
  int puntosEmpate = 1;

  /// generado, enProgreso, finalizado
  String estado = 'generado';

  DateTime createdAt = DateTime.now();
  DateTime? fechaSorteo;
  DateTime? fechaFin;
}

/// Modelo Isar para persistir Ronda.
@collection
class RondaDb {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  @Index()
  late String derbyId;

  late int numero;

  /// generada, enProgreso, finalizada
  String estado = 'generada';

  bool bloqueada = false;
  DateTime? fechaGeneracion;
}

/// Modelo Isar para persistir Pelea.
@collection
class PeleaDb {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  @Index()
  late String rondaId;

  late int numero;
  late String galloRojoId;
  late String galloVerdeId;

  String? ganadorId;
  bool empate = false;
  int? duracionSegundos;
  String? notas;

  /// pendiente, enCurso, finalizada, cancelada
  String estado = 'pendiente';
}
