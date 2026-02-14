import 'package:isar/isar.dart';
import 'package:derby_engine/derby_engine.dart';
import 'package:flutter/foundation.dart';
import 'database_service.dart';
import 'models/models.dart';

/// Repositorio para persistir y recuperar datos del derby.
class DerbyRepository {
  late Isar _isar;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    debugPrint('🔄 Inicializando repositorio...');
    _isar = await DatabaseService.instance;
    _initialized = true;
    debugPrint('✅ Repositorio inicializado');
  }

  // ==================== PARTICIPANTES ====================

  /// Guarda un participante en la BD.
  Future<void> guardarParticipante(Participante p) async {
    await init();
    debugPrint('💾 Guardando participante: ${p.nombre} (${p.id})');

    // Buscar si ya existe
    final existing = await _isar.participanteDbs
        .filter()
        .uidEqualTo(p.id)
        .findFirst();

    final db = existing ?? ParticipanteDb();
    db.uid = p.id;
    db.nombre = p.nombre;
    db.equipo = p.equipo;
    db.telefono = p.telefono;
    db.puntosTotales = p.puntosTotales;
    db.peleasGanadas = p.peleasGanadas;
    db.peleasPerdidas = p.peleasPerdidas;
    db.peleasEmpatadas = p.peleasEmpatadas;

    await _isar.writeTxn(() async {
      await _isar.participanteDbs.put(db);
    });
    debugPrint('✅ Participante guardado');
  }

  /// Carga todos los participantes de la BD.
  Future<List<Participante>> cargarParticipantes() async {
    await init();

    final dbs = await _isar.participanteDbs.where().findAll();
    debugPrint('📂 Participantes cargados: ${dbs.length}');
    return dbs
        .map(
          (db) => Participante(
            id: db.uid,
            nombre: db.nombre,
            equipo: db.equipo,
            telefono: db.telefono,
            puntosTotales: db.puntosTotales,
            peleasGanadas: db.peleasGanadas,
            peleasPerdidas: db.peleasPerdidas,
            peleasEmpatadas: db.peleasEmpatadas,
          ),
        )
        .toList();
  }

  /// Elimina un participante de la BD.
  Future<void> eliminarParticipante(String uid) async {
    await init();

    await _isar.writeTxn(() async {
      await _isar.participanteDbs.filter().uidEqualTo(uid).deleteAll();
    });
  }

  // ==================== GALLOS ====================

  /// Guarda un gallo en la BD.
  Future<void> guardarGallo(Gallo g) async {
    await init();
    debugPrint('💾 Guardando gallo: ${g.anillo} (${g.id})');

    final existing = await _isar.galloDbs.filter().uidEqualTo(g.id).findFirst();

    final db = existing ?? GalloDb();
    db.uid = g.id;
    db.participanteId = g.participanteId;
    db.peso = g.peso;
    db.anillo = g.anillo;
    db.estado = g.estado.name;

    await _isar.writeTxn(() async {
      await _isar.galloDbs.put(db);
    });
    debugPrint('✅ Gallo guardado');
  }

  /// Carga todos los gallos de la BD.
  Future<List<Gallo>> cargarGallos() async {
    await init();

    final dbs = await _isar.galloDbs.where().findAll();
    debugPrint('📂 Gallos cargados: ${dbs.length}');
    return dbs
        .map(
          (db) => Gallo(
            id: db.uid,
            participanteId: db.participanteId,
            peso: db.peso,
            anillo: db.anillo ?? db.uid, // Usar uid como fallback
            estado: EstadoGallo.values.firstWhere(
              (e) => e.name == db.estado,
              orElse: () => EstadoGallo.activo,
            ),
          ),
        )
        .toList();
  }

  /// Elimina un gallo de la BD.
  Future<void> eliminarGallo(String uid) async {
    await init();

    await _isar.writeTxn(() async {
      await _isar.galloDbs.filter().uidEqualTo(uid).deleteAll();
    });
  }

  // ==================== DERBY CONFIG ====================

  /// Guarda la configuración del derby actual.
  Future<void> guardarDerby({
    required String uid,
    required String nombre,
    String? lugar,
    required ConfiguracionDerby config,
  }) async {
    await init();

    final existing = await _isar.derbyDbs.filter().uidEqualTo(uid).findFirst();

    final db = existing ?? DerbyDb();
    db.uid = uid;
    db.nombre = nombre;
    db.lugar = lugar;
    db.numeroRondas = config.numeroRondas;
    db.toleranciaPeso = config.toleranciaPeso;
    db.puntosVictoria = config.puntosVictoria;
    db.puntosDerrota = config.puntosDerrota;
    db.puntosEmpate = config.puntosEmpate;

    await _isar.writeTxn(() async {
      await _isar.derbyDbs.put(db);
    });
  }

  /// Carga el derby activo (el más reciente).
  Future<DerbyDb?> cargarDerbyActivo() async {
    await init();

    return await _isar.derbyDbs.where().sortByCreatedAtDesc().findFirst();
  }

  // ==================== RONDAS Y PELEAS ====================

  /// Guarda todas las rondas de un derby.
  Future<void> guardarRondas(String derbyId, List<Ronda> rondas) async {
    await init();

    await _isar.writeTxn(() async {
      // Eliminar rondas y peleas anteriores
      await _isar.rondaDbs.filter().derbyIdEqualTo(derbyId).deleteAll();

      for (final ronda in rondas) {
        // Guardar ronda
        final rondaDb = RondaDb()
          ..uid = ronda.id
          ..derbyId = derbyId
          ..numero = ronda.numero
          ..estado = ronda.estado.name
          ..bloqueada = ronda.bloqueada
          ..fechaGeneracion = ronda.fechaGeneracion;

        await _isar.rondaDbs.put(rondaDb);

        // Guardar peleas de la ronda
        for (final pelea in ronda.peleas) {
          final peleaDb = PeleaDb()
            ..uid = pelea.id
            ..rondaId = ronda.id
            ..numero = pelea.numero
            ..galloRojoId = pelea.galloRojoId
            ..galloVerdeId = pelea.galloVerdeId
            ..ganadorId = pelea.ganadorId
            ..empate = pelea.empate
            ..duracionSegundos = pelea.duracionSegundos
            ..notas = pelea.notas
            ..estado = pelea.estado.name;

          await _isar.peleaDbs.put(peleaDb);
        }
      }
    });
  }

  /// Carga las rondas de un derby.
  Future<List<Ronda>> cargarRondas(String derbyId) async {
    await init();

    final rondasDb = await _isar.rondaDbs
        .filter()
        .derbyIdEqualTo(derbyId)
        .sortByNumero()
        .findAll();

    final rondas = <Ronda>[];

    for (final rondaDb in rondasDb) {
      // Cargar peleas de esta ronda
      final peleasDb = await _isar.peleaDbs
          .filter()
          .rondaIdEqualTo(rondaDb.uid)
          .sortByNumero()
          .findAll();

      final peleas = peleasDb
          .map(
            (pDb) => Pelea(
              id: pDb.uid,
              numero: pDb.numero,
              galloRojoId: pDb.galloRojoId,
              galloVerdeId: pDb.galloVerdeId,
              ganadorId: pDb.ganadorId,
              empate: pDb.empate,
              duracionSegundos: pDb.duracionSegundos,
              notas: pDb.notas,
            ),
          )
          .toList();

      rondas.add(
        Ronda(
          id: rondaDb.uid,
          numero: rondaDb.numero,
          peleas: peleas,
          bloqueada: rondaDb.bloqueada,
          fechaGeneracion: rondaDb.fechaGeneracion,
        ),
      );
    }

    return rondas;
  }

  /// Actualiza el resultado de una pelea.
  Future<void> actualizarPelea(Pelea pelea) async {
    await init();

    final existing = await _isar.peleaDbs
        .filter()
        .uidEqualTo(pelea.id)
        .findFirst();

    if (existing != null) {
      existing.ganadorId = pelea.ganadorId;
      existing.empate = pelea.empate;
      existing.duracionSegundos = pelea.duracionSegundos;
      existing.notas = pelea.notas;
      existing.estado = pelea.estado.name;

      await _isar.writeTxn(() async {
        await _isar.peleaDbs.put(existing);
      });
    }
  }

  // ==================== RESET ====================

  /// Elimina todos los datos.
  Future<void> limpiarTodo() async {
    await init();

    await _isar.writeTxn(() async {
      await _isar.clear();
    });
  }
}
