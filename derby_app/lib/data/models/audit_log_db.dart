import 'package:isar/isar.dart';

part 'audit_log_db.g.dart';

/// Modelo Isar para registro de auditoría inmutable.
///
/// Cada entrada es un registro permanente de una acción en el sistema.
/// No se permiten actualizaciones ni eliminaciones.
@collection
class AuditLogDb {
  Id id = Isar.autoIncrement;

  /// Tipo de evento: 'resultado', 'deshacer', 'bloqueo', 'gallo', 'participante', etc.
  @Index()
  late String tipo;

  /// Descripción detallada del evento
  late String descripcion;

  /// Datos adicionales en formato JSON (para reconstrucción forense)
  String? payload;

  /// Usuario o contexto que generó el evento (futuro: autenticación)
  String? actor;

  /// Timestamp inmutable del evento
  @Index()
  DateTime timestamp = DateTime.now();

  /// Hash del evento anterior (cadena de integridad)
  String? hashAnterior;

  /// Hash de este evento (SHA256 de tipo+descripcion+timestamp+nonce+hashAnterior)
  @Index()
  late String hash;
}
