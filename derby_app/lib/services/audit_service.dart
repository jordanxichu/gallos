import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';
import '../data/database_service.dart';
import '../data/models/audit_log_db.dart';

/// Servicio de auditoría inmutable basado en Isar.
///
/// Cada evento se almacena con un hash que depende del evento anterior,
/// creando una cadena de integridad que permite detectar manipulaciones.
class AuditService {
  Isar? _isar;
  int _contador = 0; // Contador para garantizar unicidad en mismo microsegundo

  Future<Isar> get _db async {
    _isar ??= await DatabaseService.instance;
    return _isar!;
  }

  /// Genera un hash SHA256 para un evento.
  String _generateHash({
    required String tipo,
    required String descripcion,
    required DateTime timestamp,
    int nonce = 0,
    String? hashAnterior,
  }) {
    // Incluir microsegundos y nonce para garantizar unicidad
    final data =
        '$tipo|$descripcion|${timestamp.microsecondsSinceEpoch}|$nonce|${hashAnterior ?? ''}';
    return sha256.convert(utf8.encode(data)).toString();
  }

  /// Registra un evento de auditoría.
  ///
  /// El evento es inmutable una vez creado.
  Future<void> registrarEvento({
    required String tipo,
    required String descripcion,
    Map<String, dynamic>? payload,
    String? actor,
  }) async {
    final isar = await _db;

    // Obtener el hash del último evento
    final ultimoEvento = await isar.auditLogDbs
        .where()
        .sortByTimestampDesc()
        .findFirst();

    final timestamp = DateTime.now();
    _contador++; // Incrementar contador para garantizar unicidad
    final hash = _generateHash(
      tipo: tipo,
      descripcion: descripcion,
      timestamp: timestamp,
      nonce: _contador,
      hashAnterior: ultimoEvento?.hash,
    );

    final evento = AuditLogDb()
      ..tipo = tipo
      ..descripcion = descripcion
      ..payload = payload != null ? jsonEncode(payload) : null
      ..actor = actor
      ..timestamp = timestamp
      ..hashAnterior = ultimoEvento?.hash
      ..hash = hash;

    await isar.writeTxn(() async {
      await isar.auditLogDbs.put(evento);
    });
  }

  /// Obtiene los últimos N eventos de auditoría.
  Future<List<AuditLogDb>> obtenerUltimos({int limite = 50}) async {
    final isar = await _db;
    return isar.auditLogDbs
        .where()
        .sortByTimestampDesc()
        .limit(limite)
        .findAll();
  }

  /// Obtiene eventos por tipo.
  Future<List<AuditLogDb>> obtenerPorTipo(
    String tipo, {
    int limite = 50,
  }) async {
    final isar = await _db;
    return isar.auditLogDbs
        .where()
        .tipoEqualTo(tipo)
        .sortByTimestampDesc()
        .limit(limite)
        .findAll();
  }

  /// Obtiene eventos en un rango de fechas.
  Future<List<AuditLogDb>> obtenerPorRango({
    required DateTime desde,
    required DateTime hasta,
  }) async {
    final isar = await _db;
    return isar.auditLogDbs
        .where()
        .timestampBetween(desde, hasta)
        .sortByTimestampDesc()
        .findAll();
  }

  /// Verifica la integridad de la cadena de auditoría.
  ///
  /// Retorna lista de IDs de eventos con integridad comprometida.
  Future<List<int>> verificarIntegridad() async {
    final isar = await _db;
    final eventos = await isar.auditLogDbs.where().sortByTimestamp().findAll();

    final eventosCorruptos = <int>[];
    String? hashAnterior;

    for (final evento in eventos) {
      final hashCalculado = _generateHash(
        tipo: evento.tipo,
        descripcion: evento.descripcion,
        timestamp: evento.timestamp,
        hashAnterior: hashAnterior,
      );

      if (hashCalculado != evento.hash) {
        eventosCorruptos.add(evento.id);
      }

      // Verificar cadena
      if (evento.hashAnterior != hashAnterior) {
        eventosCorruptos.add(evento.id);
      }

      hashAnterior = evento.hash;
    }

    return eventosCorruptos.toSet().toList();
  }

  /// Obtiene el conteo total de eventos.
  Future<int> contarEventos() async {
    final isar = await _db;
    return isar.auditLogDbs.count();
  }
}
