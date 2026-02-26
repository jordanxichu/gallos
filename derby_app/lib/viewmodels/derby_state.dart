import 'package:flutter/foundation.dart';
import 'package:derby_engine/derby_engine.dart';
import '../data/derby_repository.dart';
import '../data/database_service.dart';
import '../services/backup_service.dart';
import '../services/history_service.dart';
import '../services/license_manager.dart';
import '../services/audit_service.dart';
import '../services/retiro_backup_utils.dart';
import 'gallo_vm.dart';
import 'info_retiro.dart';
import 'participante_vm.dart';
import 'ronda_vm.dart';

/// Estado global del derby para la aplicación.
///
/// Centraliza todos los datos y proporciona ViewModels para las pantallas.
/// Usa ChangeNotifier para notificar cambios a la UI.
class DerbyState extends ChangeNotifier {
  // === Repositorio para persistencia ===
  final DerbyRepository _repo = DerbyRepository();
  final BackupService _backupService = BackupService();
  final HistoryService _historyService = HistoryService();
  final AuditService _auditService = AuditService();
  LicenseManager? _licenseManager;
  String _derbyId = 'derby_default';
  String _derbyNombre = 'Derby Actual';

  // === Datos del modelo ===
  Derby? _derby;
  final List<Participante> _participantes = [];
  final List<Gallo> _gallos = [];
  List<Ronda> _rondas = [];
  List<Ronda> _rondasPreview = [];
  ConfiguracionDerby _config = ConfiguracionDerby.standard();

  // === Estado de la UI ===
  bool _cargando = false;
  String? _error;
  int _rondaSeleccionada = 0;
  DateTime? _previewGeneradoEn;
  List<HistorialEvento> _historial = [];

  /// Mapa de galloId → info de retiro (motivo + ronda donde se retiró).
  /// Se persiste en JSON export/import.
  final Map<String, InfoRetiro> _infoRetiros = {};

  // === Getters de estado ===
  bool get cargando => _cargando;
  String? get error => _error;
  int get rondaSeleccionada => _rondaSeleccionada;
  String get derbyNombre => _derbyNombre;
  String get derbyId => _derbyId;
  bool get tienePreview => _rondasPreview.isNotEmpty;
  DateTime? get previewGeneradoEn => _previewGeneradoEn;
  List<HistorialEvento> get historialEventos => List.unmodifiable(_historial);

  /// Info de retiros/descalificaciones por gallo
  Map<String, InfoRetiro> get infoRetiros => Map.unmodifiable(_infoRetiros);

  // === Getters de auditoría ===
  AuditService get auditService => _auditService;

  // === Getters de licencia ===
  LicenseStatus get licencia => _licenseManager?.status ?? LicenseStatus.demo;
  bool get licenciaActiva => _licenseManager?.status.isActive ?? true;
  bool get licenciaPro => _licenseManager?.isPro ?? false;
  bool get licenciaDemo => _licenseManager?.isDemo ?? true;
  int get diasLicenciaRestantes => _licenseManager?.status.daysRemaining ?? 0;
  String get huellaDispositivo => _licenseManager?.deviceFingerprint ?? '';

  // Limitaciones del modo demo
  bool get permitePdf => _licenseManager?.allowPdfExport ?? false;
  bool get permiteBackup => _licenseManager?.allowBackup ?? false;
  int get maxParticipantesDemo => _licenseManager?.maxParticipantesDemo ?? 2;
  int get maxRondasDemo => _licenseManager?.maxRondasDemo ?? 1;
  bool get puedeAgregarParticipante =>
      _licenseManager?.canAddParticipante(_participantes.length) ?? true;

  /// Verifica si la licencia permite generar más rondas.
  /// En modo demo, se limita a maxRondasDemo rondas.
  bool get puedeGenerarSorteo =>
      _licenseManager?.canCreateRonda(_config.numeroRondas) ?? true;

  // === Getters de datos crudos (para el engine) ===
  Derby? get derby => _derby;
  List<Participante> get participantes => List.unmodifiable(_participantes);
  List<Gallo> get gallos => List.unmodifiable(_gallos);
  List<Ronda> get rondas => List.unmodifiable(_rondas);
  ConfiguracionDerby get config => _config;

  // === ViewModels calculados ===

  /// Lista de participantes como ViewModels ordenados por puntos
  List<ParticipanteVM> get participantesVM {
    return ParticipanteVM.fromListOrdenada(_participantes, gallos: _gallos);
  }

  /// Lista de gallos como ViewModels
  List<GalloVM> get gallosVM {
    return GalloVM.fromList(
      _gallos,
      participantes: _participantes,
      rondas: _rondas,
      infoRetiros: _infoRetiros,
    );
  }

  /// Lista de rondas como ViewModels
  List<RondaVM> get rondasVM {
    return RondaVM.fromList(
      _rondas,
      gallos: _gallos,
      participantes: _participantes,
    );
  }

  List<RondaVM> get rondasPreviewVM {
    return RondaVM.fromList(
      _rondasPreview,
      gallos: _gallos,
      participantes: _participantes,
    );
  }

  List<RondaVM> get rondasMostradasVM {
    return sorteoRealizado ? rondasVM : rondasPreviewVM;
  }

  /// Ronda actual seleccionada como ViewModel
  RondaVM? get rondaActualVM {
    if (_rondas.isEmpty || _rondaSeleccionada >= _rondas.length) return null;
    return RondaVM.fromRonda(
      _rondas[_rondaSeleccionada],
      gallos: _gallos,
      participantes: _participantes,
    );
  }

  RondaVM? get rondaPreviewActualVM {
    if (_rondasPreview.isEmpty || _rondaSeleccionada >= _rondasPreview.length) {
      return null;
    }

    return RondaVM.fromRonda(
      _rondasPreview[_rondaSeleccionada],
      gallos: _gallos,
      participantes: _participantes,
    );
  }

  RondaVM? get rondaMostradaVM {
    return sorteoRealizado ? rondaActualVM : rondaPreviewActualVM;
  }

  // === Estadísticas globales ===
  int get totalParticipantes => _participantes.length;
  int get totalGallos => _gallos.length;
  int get totalRondas => _rondas.length;
  int get totalPeleas => _rondas.fold(0, (sum, r) => sum + r.totalPeleas);

  /// Gallos retirados (incluye muertes)
  int get gallosRetirados =>
      _gallos.where((g) => g.estado == EstadoGallo.retirado).length;

  /// Gallos descalificados
  int get gallosDescalificados =>
      _gallos.where((g) => g.estado == EstadoGallo.descalificado).length;

  /// Gallos fuera del torneo (retirados + descalificados)
  int get gallosFueraTorneo => gallosRetirados + gallosDescalificados;

  /// Gallos muertos (retiro cuyo motivo contiene "muert")
  int get gallosMuertos =>
      _infoRetiros.values.where((info) => info.esMuerte).length;

  /// Peleas completadas (terminadas = finalizadas + canceladas)
  int get peleasCompletadas =>
      _rondas.fold(0, (sum, r) => sum + r.peleasTerminadas);

  int get porcentajeProgreso =>
      totalPeleas > 0 ? (peleasCompletadas * 100 ~/ totalPeleas) : 0;

  bool get sorteoRealizado => _rondas.isNotEmpty;
  int get totalRondasMostradas =>
      sorteoRealizado ? _rondas.length : _rondasPreview.length;

  // === Inicialización y Carga ===

  /// Carga todos los datos persistidos.
  Future<void> cargarDatos() async {
    _cargando = true;
    notifyListeners();

    try {
      // Cargar derby activo
      final derbyDb = await _repo.cargarDerbyActivo();
      if (derbyDb != null) {
        _derbyId = derbyDb.uid;
        _derbyNombre = derbyDb.nombre;
        _config = ConfiguracionDerby(
          numeroRondas: derbyDb.numeroRondas,
          toleranciaPeso: derbyDb.toleranciaPeso,
          puntosVictoria: derbyDb.puntosVictoria,
          puntosDerrota: derbyDb.puntosDerrota,
          puntosEmpate: derbyDb.puntosEmpate,
        );
      }

      // Cargar participantes
      final participantes = await _repo.cargarParticipantes();
      _participantes.clear();
      _participantes.addAll(participantes);

      // Cargar gallos
      final gallos = await _repo.cargarGallos();
      _gallos.clear();
      _gallos.addAll(gallos);
      _infoRetiros.clear();

      // Cargar rondas
      _rondas = await _repo.cargarRondas(_derbyId);
      _historial = await _historyService.loadHistory();

      // Validar integridad de datos cargados
      final erroresIntegridad = _validarIntegridad();
      if (erroresIntegridad.isNotEmpty) {
        _error = 'Datos corruptos detectados:\n${erroresIntegridad.join('\n')}';
        _cargando = false;
        notifyListeners();
        return;
      }

      // Inicializar sistema de licencias
      final isar = await DatabaseService.instance;
      _licenseManager = LicenseManager(isar);
      await _licenseManager!.initialize();

      // Posicionar en la ronda activa (primera no-bloqueada)
      _rondaSeleccionada = _calcularRondaActiva();

      _cargando = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Error cargando datos: $e';
      _cargando = false;
      notifyListeners();
    }
  }

  /// Valida la integridad de los datos cargados.
  /// Retorna lista de errores encontrados (vacía si todo está bien).
  List<String> _validarIntegridad() {
    final errores = <String>[];

    // Set de IDs válidos para búsqueda rápida
    final participanteIds = _participantes.map((p) => p.id).toSet();
    final galloIds = _gallos.map((g) => g.id).toSet();

    // 1. Verificar gallos huérfanos (participanteId no existe)
    for (final gallo in _gallos) {
      if (!participanteIds.contains(gallo.participanteId)) {
        errores.add(
          'Gallo "${gallo.anillo}" (${gallo.id}) tiene participanteId inválido: ${gallo.participanteId}',
        );
      }
    }

    // 2. Verificar peleas con gallos inexistentes
    for (int i = 0; i < _rondas.length; i++) {
      final ronda = _rondas[i];
      for (int j = 0; j < ronda.peleas.length; j++) {
        final pelea = ronda.peleas[j];

        if (!galloIds.contains(pelea.galloRojoId)) {
          errores.add(
            'Ronda ${i + 1}, Pelea ${j + 1}: galloRojoId inválido (${pelea.galloRojoId})',
          );
        }

        if (!galloIds.contains(pelea.galloVerdeId)) {
          errores.add(
            'Ronda ${i + 1}, Pelea ${j + 1}: galloVerdeId inválido (${pelea.galloVerdeId})',
          );
        }

        // Verificar que ganadorId (si existe) sea uno de los dos gallos
        if (pelea.ganadorId != null && !pelea.empate) {
          if (pelea.ganadorId != pelea.galloRojoId &&
              pelea.ganadorId != pelea.galloVerdeId) {
            errores.add(
              'Ronda ${i + 1}, Pelea ${j + 1}: ganadorId (${pelea.ganadorId}) no corresponde a ningún gallo de la pelea',
            );
          }
        }
      }
    }

    // 3. Verificar que puntos de participantes sean consistentes
    for (final participante in _participantes) {
      // Recalcular puntos esperados desde peleas
      var puntosCalculados = 0;
      var victoriasCalculadas = 0;

      // Obtener gallos de este participante
      final gallosParticipante = _gallos
          .where((g) => g.participanteId == participante.id)
          .map((g) => g.id)
          .toSet();

      for (final ronda in _rondas) {
        for (final pelea in ronda.peleas) {
          if (!pelea.tieneResultado) continue;

          // Solo contar si algún gallo del participante está en la pelea
          final galloEnPelea = gallosParticipante.contains(pelea.galloRojoId)
              ? pelea.galloRojoId
              : gallosParticipante.contains(pelea.galloVerdeId)
              ? pelea.galloVerdeId
              : null;

          if (galloEnPelea == null) continue;

          if (pelea.empate) {
            puntosCalculados += _config.puntosEmpate;
          } else if (pelea.ganadorId == galloEnPelea) {
            puntosCalculados += _config.puntosVictoria;
            victoriasCalculadas++;
          } else {
            puntosCalculados += _config.puntosDerrota;
          }
        }
      }

      // Comparar con valores almacenados
      if (participante.puntosTotales != puntosCalculados) {
        errores.add(
          'Participante "${participante.nombre}": puntosTotales=${participante.puntosTotales} pero calculados=$puntosCalculados',
        );
      }
      if (participante.peleasGanadas != victoriasCalculadas) {
        errores.add(
          'Participante "${participante.nombre}": peleasGanadas=${participante.peleasGanadas} pero calculadas=$victoriasCalculadas',
        );
      }
    }

    return errores;
  }

  // === Acciones de Participantes ===

  Future<void> agregarParticipante(Participante participante) async {
    if (!puedeAgregarParticipante) {
      throw StateError(
        'Modo demo: máximo $maxParticipantesDemo participantes. Activa licencia Pro.',
      );
    }

    _participantes.add(participante);
    notifyListeners();
    await _repo.guardarParticipante(participante);
    await _registrarEvento(
      tipo: 'participante',
      descripcion: 'Participante agregado: ${participante.nombre}',
    );
  }

  Future<void> actualizarParticipante(Participante participante) async {
    final index = _participantes.indexWhere((p) => p.id == participante.id);
    if (index != -1) {
      _participantes[index] = participante;
      notifyListeners();
      await _repo.guardarParticipante(participante);
      await _registrarEvento(
        tipo: 'participante',
        descripcion: 'Participante actualizado: ${participante.nombre}',
      );
    }
  }

  /// Actualiza solo la lista de compadres de un participante.
  /// Los compadres son bidireccionales: si A es compadre de B, B es compadre de A.
  Future<void> actualizarCompadres(
    String participanteId,
    List<String> nuevosCompadresIds,
  ) async {
    // Obtener compadres anteriores para sincronizar bidireccionalidad
    final indexActual = _participantes.indexWhere(
      (p) => p.id == participanteId,
    );
    if (indexActual == -1) return;

    final compadresAnteriores = List<String>.from(
      _participantes[indexActual].compadres,
    );

    // --- Actualizar el participante principal ---
    _participantes[indexActual] = _participantes[indexActual].copyWith(
      compadres: nuevosCompadresIds,
    );
    await _repo.guardarParticipante(_participantes[indexActual]);

    // --- Sincronización bidireccional ---
    // 1. Quitar de los que ya no son compadres
    final quitados = compadresAnteriores
        .where((id) => !nuevosCompadresIds.contains(id))
        .toList();
    for (final id in quitados) {
      final idx = _participantes.indexWhere((p) => p.id == id);
      if (idx == -1) continue;
      final p = _participantes[idx];
      final nuevaLista = p.compadres.where((c) => c != participanteId).toList();
      _participantes[idx] = p.copyWith(compadres: nuevaLista);
      await _repo.guardarParticipante(_participantes[idx]);
    }

    // 2. Agregar a los nuevos compadres
    final agregados = nuevosCompadresIds
        .where((id) => !compadresAnteriores.contains(id))
        .toList();
    for (final id in agregados) {
      final idx = _participantes.indexWhere((p) => p.id == id);
      if (idx == -1) continue;
      final p = _participantes[idx];
      if (!p.compadres.contains(participanteId)) {
        _participantes[idx] = p.copyWith(
          compadres: [...p.compadres, participanteId],
        );
        await _repo.guardarParticipante(_participantes[idx]);
      }
    }

    notifyListeners();
    await _registrarEvento(
      tipo: 'participante',
      descripcion:
          'Compadres actualizados para ${_participantes[indexActual].nombre} '
          '(${nuevosCompadresIds.length} compadres)',
    );
  }

  Future<void> eliminarParticipante(String id) async {
    _participantes.removeWhere((p) => p.id == id);
    // También eliminar gallos del participante
    final gallosAEliminar = _gallos
        .where((g) => g.participanteId == id)
        .toList();
    _gallos.removeWhere((g) => g.participanteId == id);
    notifyListeners();

    await _repo.eliminarParticipante(id);
    for (final g in gallosAEliminar) {
      await _repo.eliminarGallo(g.id);
    }
    await _registrarEvento(
      tipo: 'participante',
      descripcion: 'Participante eliminado (id: $id)',
    );
  }

  // === Acciones de Gallos ===

  Future<void> agregarGallo(Gallo gallo) async {
    _gallos.add(gallo);
    notifyListeners();
    await _repo.guardarGallo(gallo);
    await _registrarEvento(
      tipo: 'gallo',
      descripcion: 'Gallo agregado: ${gallo.anillo}',
    );
  }

  Future<void> actualizarGallo(Gallo gallo) async {
    final index = _gallos.indexWhere((g) => g.id == gallo.id);
    if (index != -1) {
      _gallos[index] = gallo;
      notifyListeners();
      await _repo.guardarGallo(gallo);
      await _registrarEvento(
        tipo: 'gallo',
        descripcion: 'Gallo actualizado: ${gallo.anillo}',
      );
    }
  }

  /// Elimina un gallo del torneo.
  ///
  /// Lanza [StateError] si ya hay sorteo realizado.
  /// En ese caso, usar [retirarGallo] o [descalificarGallo] en su lugar.
  Future<void> eliminarGallo(String id) async {
    // No permitir eliminar gallos si ya hay sorteo
    if (sorteoRealizado) {
      final gallo = _gallos.where((g) => g.id == id).firstOrNull;
      final anillo = gallo?.anillo ?? id;
      throw StateError(
        'No se puede eliminar el gallo "$anillo" porque ya hay sorteo realizado.\n'
        'Usa "Retirar" o "Descalificar" en su lugar para mantener la integridad de los datos.',
      );
    }

    _gallos.removeWhere((g) => g.id == id);
    notifyListeners();
    await _repo.eliminarGallo(id);
    await _registrarEvento(
      tipo: 'gallo',
      descripcion: 'Gallo eliminado (id: $id)',
    );
  }

  // === P1-4: Retiro/Descalificación de Gallos Mid-Torneo ===

  /// Cambia el estado de un gallo (retirar, descalificar, etc.)
  ///
  /// Cuando un gallo es retirado o descalificado:
  /// - Sus peleas PENDIENTES se cancelan automáticamente
  /// - NO se modifican peleas ya finalizadas
  /// - NO se regeneran rondas
  Future<void> cambiarEstadoGallo(
    String galloId,
    EstadoGallo nuevoEstado, {
    String? motivo,
  }) async {
    final index = _gallos.indexWhere((g) => g.id == galloId);
    if (index == -1) return;

    final gallo = _gallos[index];
    final estadoAnterior = gallo.estado;

    // No permitir cambiar a activo si ya estaba inactivo
    if (estadoAnterior != EstadoGallo.activo &&
        nuevoEstado == EstadoGallo.activo) {
      throw StateError(
        'No se puede reactivar un gallo que ya fue retirado o descalificado',
      );
    }

    // Actualizar el gallo
    _gallos[index] = gallo.copyWith(estado: nuevoEstado);

    // Si el gallo fue retirado/descalificado, cancelar sus peleas pendientes
    if (nuevoEstado != EstadoGallo.activo &&
        nuevoEstado != EstadoGallo.finalizado) {
      // Determinar ronda actual (primera no-bloqueada, o última bloqueada + 1)
      final rondaRetiro = _calcularRondaActiva() + 1; // 1-based

      // Guardar info de retiro
      _infoRetiros[galloId] = InfoRetiro(
        ronda: rondaRetiro,
        motivo: motivo,
        anillo: gallo.anillo,
        timestamp: DateTime.now(),
      );

      await _cancelarPeleasPendientesDeGallo(
        galloId,
        anillo: gallo.anillo,
        motivo: motivo,
        estado: nuevoEstado,
      );
    }

    notifyListeners();
    await _repo.guardarGallo(_gallos[index]);

    final motivoTexto = motivo != null ? ' - Motivo: $motivo' : '';
    await _registrarEvento(
      tipo: 'gallo',
      descripcion:
          'Estado de gallo ${gallo.anillo} cambiado a ${nuevoEstado.name}$motivoTexto',
    );

    // Auditoría inmutable - CRÍTICO para retirados/descalificados
    if (nuevoEstado != EstadoGallo.activo) {
      await _auditService.registrarEvento(
        tipo: 'gallo',
        descripcion: 'Gallo ${gallo.anillo} ${nuevoEstado.name}',
        payload: {
          'galloId': galloId,
          'anillo': gallo.anillo,
          'estadoAnterior': estadoAnterior.name,
          'nuevoEstado': nuevoEstado.name,
          'motivo': motivo,
        },
      );
    }
  }

  /// Retira un gallo del torneo (por lesión, muerte, decisión del dueño, etc.)
  Future<void> retirarGallo(String galloId, {String? motivo}) async {
    await cambiarEstadoGallo(galloId, EstadoGallo.retirado, motivo: motivo);
  }

  /// Descalifica un gallo del torneo
  Future<void> descalificarGallo(String galloId, {String? motivo}) async {
    await cambiarEstadoGallo(
      galloId,
      EstadoGallo.descalificado,
      motivo: motivo,
    );
  }

  /// Cancela todas las peleas pendientes de un gallo.
  /// Las peleas finalizadas NO se modifican.
  Future<void> _cancelarPeleasPendientesDeGallo(
    String galloId, {
    required String anillo,
    String? motivo,
    required EstadoGallo estado,
  }) async {
    var peleasCanceladas = 0;

    // Texto descriptivo para la nota de cancelación
    final estadoTexto = estado == EstadoGallo.descalificado
        ? 'descalificado'
        : (motivo != null && motivo.toLowerCase().contains('muert')
              ? 'muerto'
              : 'retirado');
    final notaCancelacion =
        'Sin cotejo \u2013 gallo $anillo $estadoTexto${motivo != null ? " ($motivo)" : ""}';

    for (var rondaIndex = 0; rondaIndex < _rondas.length; rondaIndex++) {
      final ronda = _rondas[rondaIndex];

      // No modificar rondas bloqueadas
      if (ronda.bloqueada) continue;

      final nuevasPeleas = <Pelea>[];
      var rondaModificada = false;

      for (final pelea in ronda.peleas) {
        if (!pelea.tieneResultado && pelea.participoGallo(galloId)) {
          // Cancelar esta pelea con nota detallada
          nuevasPeleas.add(
            pelea.copyWith(
              estado: EstadoPelea.cancelada,
              notas: notaCancelacion,
            ),
          );
          rondaModificada = true;
          peleasCanceladas++;
        } else {
          nuevasPeleas.add(pelea);
        }
      }

      if (rondaModificada) {
        _rondas[rondaIndex] = ronda.conPeleasActualizadas(nuevasPeleas);
        await _repo.guardarRondas(_derbyId, _rondas);

        // Auto-bloquear si al cancelar peleas, la ronda quedó completa
        final rondaActualizada = _rondas[rondaIndex];
        if (rondaActualizada.todasFinalizadas && !rondaActualizada.bloqueada) {
          await bloquearRonda(rondaIndex, autoBloqueo: true);
        }
      }
    }

    if (peleasCanceladas > 0) {
      await _registrarEvento(
        tipo: 'pelea',
        descripcion:
            '$peleasCanceladas peleas canceladas por retiro/descalificación de gallo',
      );
    }
  }

  // === Acciones de Configuración ===

  Future<void> actualizarConfiguracion(ConfiguracionDerby config) async {
    _config = config;
    notifyListeners();
    await _repo.guardarDerby(
      uid: _derbyId,
      nombre: _derbyNombre,
      config: _config,
    );
    await _registrarEvento(
      tipo: 'configuracion',
      descripcion: 'Configuración actualizada',
    );
  }

  // === Acciones de Sorteo ===

  /// Ejecuta el sorteo generando todas las rondas.
  ///
  /// Lanza [StateError] en modo demo si se excede el límite de rondas.
  Future<void> ejecutarSorteo() async {
    await generarPreviewSorteo();
  }

  Future<void> generarPreviewSorteo() async {
    if (_gallos.length < 2) {
      _error = 'Se necesitan al menos 2 gallos';
      notifyListeners();
      return;
    }

    // P0-LICENCIA: Verificar límite de rondas en modo demo
    if (!puedeGenerarSorteo) {
      throw StateError(
        'Modo demo: máximo $maxRondasDemo ronda(s). '
        'La configuración actual tiene ${_config.numeroRondas} rondas. '
        'Reduce el número de rondas o activa licencia Pro.',
      );
    }

    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      // Pequeño delay para mostrar loading
      await Future.delayed(const Duration(milliseconds: 300));

      final generator = RoundGenerator(
        configuracion: _config,
        participantes: _participantes,
      );

      final resultado = generator.generarRondas(
        gallos: _gallos,
        optimizar: true,
      );

      _rondasPreview = resultado.rondas;
      _previewGeneradoEn = DateTime.now();
      _rondaSeleccionada = 0;
      _cargando = false;
      notifyListeners();
      await _registrarEvento(
        tipo: 'sorteo',
        descripcion:
            'Preview de sorteo generado (${_rondasPreview.length} rondas)',
      );
    } catch (e) {
      _error = 'Error en sorteo: $e';
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> aprobarPreviewSorteo() async {
    if (_rondasPreview.isEmpty) return;

    _rondas = List<Ronda>.from(_rondasPreview);
    _rondasPreview = [];
    _previewGeneradoEn = null;
    _rondaSeleccionada = 0;
    notifyListeners();

    await _repo.guardarRondas(_derbyId, _rondas);
    await _registrarEvento(
      tipo: 'sorteo',
      descripcion: 'Sorteo aprobado y confirmado (${_rondas.length} rondas)',
    );
  }

  Future<void> descartarPreviewSorteo() async {
    if (_rondasPreview.isEmpty) return;
    _rondasPreview = [];
    _previewGeneradoEn = null;
    _rondaSeleccionada = 0;
    notifyListeners();
    await _registrarEvento(
      tipo: 'sorteo',
      descripcion: 'Preview de sorteo descartado',
    );
  }

  /// Limpia el sorteo actual.
  Future<void> limpiarSorteo() async {
    _rondas = [];
    _rondasPreview = [];
    _previewGeneradoEn = null;
    _rondaSeleccionada = 0;
    notifyListeners();
    await _repo.guardarRondas(_derbyId, []);
    await _registrarEvento(tipo: 'sorteo', descripcion: 'Sorteo eliminado');
  }

  // === Acciones de Navegación de Rondas ===

  /// Seleccionar una ronda específica.
  /// Solo permite navegar a una ronda si todas las anteriores están bloqueadas,
  /// o si se navega hacia atrás (para consultar rondas ya jugadas).
  void seleccionarRonda(int index) {
    if (index < 0 || index >= totalRondasMostradas) return;

    // Navegar hacia atrás siempre está permitido
    if (index <= _rondaSeleccionada) {
      _rondaSeleccionada = index;
      notifyListeners();
      return;
    }

    // Navegar hacia adelante: verificar que todas las rondas anteriores estén bloqueadas
    for (var i = 0; i < index; i++) {
      if (i < _rondas.length && !_rondas[i].bloqueada) return;
    }

    _rondaSeleccionada = index;
    notifyListeners();
  }

  /// Avanza a la siguiente ronda SOLO si la actual está bloqueada.
  void siguienteRonda() {
    if (_rondaSeleccionada >= totalRondasMostradas - 1) return;

    // La ronda actual debe estar bloqueada para poder avanzar
    if (_rondaSeleccionada < _rondas.length &&
        !_rondas[_rondaSeleccionada].bloqueada) {
      return;
    }

    _rondaSeleccionada++;
    notifyListeners();
  }

  void rondaAnterior() {
    if (_rondaSeleccionada > 0) {
      _rondaSeleccionada--;
      notifyListeners();
    }
  }

  /// Calcula la ronda activa: la primera ronda que NO está bloqueada.
  /// Si todas están bloqueadas, devuelve la última.
  int _calcularRondaActiva() {
    if (_rondas.isEmpty) return 0;
    for (var i = 0; i < _rondas.length; i++) {
      if (!_rondas[i].bloqueada) return i;
    }
    return _rondas.length - 1; // Todas bloqueadas → mostrar la última
  }

  // === Acciones de Peleas ===

  /// Registra el resultado de una pelea.
  ///
  /// Lanza [StateError] si la ronda está bloqueada.
  Future<void> registrarResultado({
    required int indexRonda,
    required String peleaId,
    String? ganadorId,
    bool empate = false,
    int? duracionSegundos,
    String? notas,
  }) async {
    if (indexRonda >= _rondas.length) return;

    final ronda = _rondas[indexRonda];

    // P0-2: Verificar bloqueo de ronda
    if (ronda.bloqueada) {
      throw StateError(
        'No se puede modificar la ronda ${ronda.numero}: está bloqueada. '
        'Desbloquéala primero si necesitas hacer cambios.',
      );
    }

    final peleaIndex = ronda.peleas.indexWhere((p) => p.id == peleaId);
    if (peleaIndex == -1) return;

    final pelea = ronda.peleas[peleaIndex];
    final nuevaPelea = pelea.conResultado(
      ganadorId: ganadorId,
      empate: empate,
      duracionSegundos: duracionSegundos,
      notas: notas,
    );

    final nuevasPeleas = List<Pelea>.from(ronda.peleas);
    nuevasPeleas[peleaIndex] = nuevaPelea;

    _rondas[indexRonda] = ronda.conPeleasActualizadas(nuevasPeleas);

    // Actualizar puntos del participante ganador si hay ganador
    if (ganadorId != null) {
      await _actualizarPuntosParticipante(ganadorId, _config.puntosVictoria);
      // El perdedor
      final perdedorId = ganadorId == pelea.galloRojoId
          ? pelea.galloVerdeId
          : pelea.galloRojoId;
      await _actualizarPuntosParticipantePerdedor(perdedorId);
    } else if (empate) {
      await _actualizarPuntosParticipanteEmpate(pelea.galloRojoId);
      await _actualizarPuntosParticipanteEmpate(pelea.galloVerdeId);
    }

    notifyListeners();

    // Persistir pelea y participantes actualizados
    await _repo.actualizarPelea(nuevaPelea);
    await _registrarEvento(
      tipo: 'pelea',
      descripcion:
          'Resultado registrado en pelea ${pelea.numero} (ronda ${indexRonda + 1})',
    );

    // Auditoría inmutable
    await _auditService.registrarEvento(
      tipo: 'resultado',
      descripcion: empate
          ? 'Empate en pelea ${pelea.numero}, ronda ${indexRonda + 1}'
          : 'Victoria gallo $ganadorId en pelea ${pelea.numero}, ronda ${indexRonda + 1}',
      payload: {
        'peleaId': peleaId,
        'ronda': indexRonda + 1,
        'pelea': pelea.numero,
        'galloRojoId': pelea.galloRojoId,
        'galloVerdeId': pelea.galloVerdeId,
        'ganadorId': ganadorId,
        'empate': empate,
      },
    );

    // P0-2: Auto-bloquear ronda si todas las peleas están finalizadas
    final rondaActualizada = _rondas[indexRonda];
    if (rondaActualizada.todasFinalizadas && !rondaActualizada.bloqueada) {
      await bloquearRonda(indexRonda, autoBloqueo: true);
    }
  }

  Future<void> _actualizarPuntosParticipante(String galloId, int puntos) async {
    final gallo = _gallos.where((g) => g.id == galloId).firstOrNull;
    if (gallo == null) return;

    final index = _participantes.indexWhere(
      (p) => p.id == gallo.participanteId,
    );
    if (index == -1) return;

    final p = _participantes[index];
    p.puntosTotales += puntos;
    p.peleasGanadas++;
    await _repo.guardarParticipante(p);
  }

  Future<void> _actualizarPuntosParticipantePerdedor(String galloId) async {
    final gallo = _gallos.where((g) => g.id == galloId).firstOrNull;
    if (gallo == null) return;

    final index = _participantes.indexWhere(
      (p) => p.id == gallo.participanteId,
    );
    if (index == -1) return;

    final p = _participantes[index];
    p.puntosTotales += _config.puntosDerrota;
    p.peleasPerdidas++;
    await _repo.guardarParticipante(p);
  }

  Future<void> _actualizarPuntosParticipanteEmpate(String galloId) async {
    final gallo = _gallos.where((g) => g.id == galloId).firstOrNull;
    if (gallo == null) return;

    final index = _participantes.indexWhere(
      (p) => p.id == gallo.participanteId,
    );
    if (index == -1) return;

    final p = _participantes[index];
    p.puntosTotales += _config.puntosEmpate;
    p.peleasEmpatadas++;
    await _repo.guardarParticipante(p);
  }

  /// Deshace el resultado de una pelea.
  ///
  /// CORREGIDO P0-1: Ahora revierte correctamente puntos, victorias, derrotas y empates.
  /// Lanza [StateError] si la ronda está bloqueada.
  Future<void> deshacerResultado({
    required int indexRonda,
    required String peleaId,
  }) async {
    if (indexRonda >= _rondas.length) return;

    final ronda = _rondas[indexRonda];

    // P0-2: Verificar bloqueo de ronda
    if (ronda.bloqueada) {
      throw StateError(
        'No se puede modificar la ronda ${ronda.numero}: está bloqueada. '
        'Desbloquéala primero si necesitas hacer cambios.',
      );
    }

    final peleaIndex = ronda.peleas.indexWhere((p) => p.id == peleaId);
    if (peleaIndex == -1) return;

    final pelea = ronda.peleas[peleaIndex];

    // P0-1: Solo deshacer si la pelea tiene resultado
    if (!pelea.tieneResultado) return;

    // P0-1: REVERTIR PUNTOS ANTES DE BORRAR EL RESULTADO
    if (pelea.ganadorId != null) {
      // Había un ganador - revertir victoria y derrota
      await _revertirVictoria(pelea.ganadorId!);
      final perdedorId = pelea.ganadorId == pelea.galloRojoId
          ? pelea.galloVerdeId
          : pelea.galloRojoId;
      await _revertirDerrota(perdedorId);
    } else if (pelea.empate) {
      // Era empate - revertir ambos empates
      await _revertirEmpate(pelea.galloRojoId);
      await _revertirEmpate(pelea.galloVerdeId);
    }

    // Crear pelea sin resultado
    final nuevaPelea = Pelea(
      id: pelea.id,
      numero: pelea.numero,
      galloRojoId: pelea.galloRojoId,
      galloVerdeId: pelea.galloVerdeId,
      // Sin resultado
    );

    final nuevasPeleas = List<Pelea>.from(ronda.peleas);
    nuevasPeleas[peleaIndex] = nuevaPelea;

    _rondas[indexRonda] = ronda.conPeleasActualizadas(nuevasPeleas);
    notifyListeners();

    await _repo.actualizarPelea(nuevaPelea);
    await _registrarEvento(
      tipo: 'pelea',
      descripcion:
          'Resultado deshecho en pelea ${pelea.numero} (ronda ${indexRonda + 1}) - puntos revertidos',
    );

    // Auditoría inmutable
    await _auditService.registrarEvento(
      tipo: 'deshacer',
      descripcion:
          'Deshacer resultado pelea ${pelea.numero}, ronda ${indexRonda + 1}',
      payload: {
        'peleaId': peleaId,
        'ronda': indexRonda + 1,
        'pelea': pelea.numero,
        'resultadoPrevio': {
          'ganadorId': pelea.ganadorId,
          'empate': pelea.empate,
        },
      },
    );
  }

  /// Revierte una victoria previamente registrada.
  Future<void> _revertirVictoria(String galloId) async {
    final gallo = _gallos.where((g) => g.id == galloId).firstOrNull;
    if (gallo == null) return;

    final index = _participantes.indexWhere(
      (p) => p.id == gallo.participanteId,
    );
    if (index == -1) return;

    final p = _participantes[index];
    p.puntosTotales -= _config.puntosVictoria;
    p.peleasGanadas--;
    // Asegurar que no queden valores negativos
    if (p.puntosTotales < 0) p.puntosTotales = 0;
    if (p.peleasGanadas < 0) p.peleasGanadas = 0;
    await _repo.guardarParticipante(p);
  }

  /// Revierte una derrota previamente registrada.
  Future<void> _revertirDerrota(String galloId) async {
    final gallo = _gallos.where((g) => g.id == galloId).firstOrNull;
    if (gallo == null) return;

    final index = _participantes.indexWhere(
      (p) => p.id == gallo.participanteId,
    );
    if (index == -1) return;

    final p = _participantes[index];
    p.puntosTotales -= _config.puntosDerrota;
    p.peleasPerdidas--;
    if (p.puntosTotales < 0) p.puntosTotales = 0;
    if (p.peleasPerdidas < 0) p.peleasPerdidas = 0;
    await _repo.guardarParticipante(p);
  }

  /// Revierte un empate previamente registrado.
  Future<void> _revertirEmpate(String galloId) async {
    final gallo = _gallos.where((g) => g.id == galloId).firstOrNull;
    if (gallo == null) return;

    final index = _participantes.indexWhere(
      (p) => p.id == gallo.participanteId,
    );
    if (index == -1) return;

    final p = _participantes[index];
    p.puntosTotales -= _config.puntosEmpate;
    p.peleasEmpatadas--;
    if (p.puntosTotales < 0) p.puntosTotales = 0;
    if (p.peleasEmpatadas < 0) p.peleasEmpatadas = 0;
    await _repo.guardarParticipante(p);
  }

  // === Bloqueo de Rondas (P0-2) ===

  /// Bloquea una ronda para evitar modificaciones accidentales.
  Future<void> bloquearRonda(int indexRonda, {bool autoBloqueo = false}) async {
    if (indexRonda >= _rondas.length) return;

    final ronda = _rondas[indexRonda];
    if (ronda.bloqueada) return; // Ya está bloqueada

    _rondas[indexRonda] = ronda.copyWith(bloqueada: true);
    notifyListeners();

    await _repo.actualizarRonda(_rondas[indexRonda]);
    await _registrarEvento(
      tipo: 'ronda',
      descripcion: autoBloqueo
          ? 'Ronda ${ronda.numero} bloqueada automáticamente (completada)'
          : 'Ronda ${ronda.numero} bloqueada manualmente',
    );

    // Auditoría inmutable
    await _auditService.registrarEvento(
      tipo: 'bloqueo',
      descripcion: 'Ronda ${ronda.numero} bloqueada',
      payload: {'ronda': ronda.numero, 'autoBloqueo': autoBloqueo},
    );
  }

  /// Desbloquea una ronda para permitir correcciones.
  ///
  /// Esta acción debe requerir doble confirmación en la UI.
  Future<void> desbloquearRonda(int indexRonda) async {
    if (indexRonda >= _rondas.length) return;

    final ronda = _rondas[indexRonda];
    if (!ronda.bloqueada) return; // Ya está desbloqueada

    _rondas[indexRonda] = ronda.copyWith(bloqueada: false);
    notifyListeners();

    await _repo.actualizarRonda(_rondas[indexRonda]);
    await _registrarEvento(
      tipo: 'ronda',
      descripcion: 'Ronda ${ronda.numero} DESBLOQUEADA para correcciones',
    );

    // Auditoría inmutable - CRÍTICO
    await _auditService.registrarEvento(
      tipo: 'desbloqueo',
      descripcion: 'Ronda ${ronda.numero} DESBLOQUEADA - acción crítica',
      payload: {
        'ronda': ronda.numero,
        'peleasFinalizadas': ronda.peleas.where((p) => p.tieneResultado).length,
        'peleasTotales': ronda.peleas.length,
      },
    );
  }

  /// Verifica si una ronda está bloqueada.
  bool rondaEstaBloqueada(int indexRonda) {
    if (indexRonda >= _rondas.length) return false;
    return _rondas[indexRonda].bloqueada;
  }

  /// Activa una licencia con el código proporcionado.
  ///
  /// Retorna el resultado de la activación para mostrar mensaje apropiado.
  Future<ActivationResult> activarLicencia(String codigo) async {
    if (_licenseManager == null) {
      return ActivationResult.parseError;
    }

    final result = await _licenseManager!.activate(codigo);
    notifyListeners();

    if (result == ActivationResult.success) {
      final status = _licenseManager!.status;
      final tipoStr = status.type.name;
      await _registrarEvento(
        tipo: 'licencia',
        descripcion: 'Licencia $tipoStr activada',
      );
    }

    return result;
  }

  /// Obtiene mensaje legible del resultado de activación.
  String getMensajeActivacion(ActivationResult result) {
    return _licenseManager?.getActivationMessage(result) ?? 'Error desconocido';
  }

  /// Desactiva la licencia actual (vuelve a modo demo).
  Future<void> desactivarLicencia() async {
    await _licenseManager?.reset();
    notifyListeners();
    await _registrarEvento(
      tipo: 'licencia',
      descripcion: 'Licencia desactivada',
    );
  }

  /// Reparación completa del sistema de licencias.
  /// Útil cuando hay datos corruptos que impiden activaciones.
  Future<void> repararLicencias() async {
    await _licenseManager?.repairAndReset();
    notifyListeners();
    await _registrarEvento(
      tipo: 'licencia',
      descripcion: 'Sistema de licencias reparado',
    );
  }

  /// Exporta todos los datos del torneo a JSON.
  ///
  /// Lanza [StateError] si la licencia no permite backups (modo demo).
  Future<String> exportarTorneoJson() async {
    // P0-LICENCIA: Verificar si la licencia permite backups
    if (!permiteBackup) {
      throw StateError(
        'Modo demo: exportar backup JSON requiere licencia Pro.',
      );
    }
    final warningsRetiro = <String>[];

    // Preparar resumen de retiros y descalificaciones
    final gallosFuera = _gallos.where(
      (g) =>
          g.estado == EstadoGallo.retirado ||
          g.estado == EstadoGallo.descalificado,
    );

    final retirosDescalificaciones = gallosFuera.map((g) {
      final participante = _participantes
          .where((p) => p.id == g.participanteId)
          .firstOrNull;
      // Contar peleas canceladas de este gallo
      var peleasCanceladas = 0;
      for (final ronda in _rondas) {
        for (final pelea in ronda.peleas) {
          if (pelea.participoGallo(g.id) &&
              pelea.estado == EstadoPelea.cancelada) {
            peleasCanceladas++;
          }
        }
      }
      return {
        'galloId': g.id,
        'anillo': g.anillo,
        'participanteId': g.participanteId,
        'participanteNombre': participante?.nombre ?? 'Desconocido',
        'estado': g.estado.name,
        'peleasCanceladas': peleasCanceladas,
        'motivo': _infoRetiros[g.id]?.motivo,
        'rondaRetiro': _infoRetiros[g.id]?.ronda,
        'esMuerte': _infoRetiros[g.id]?.esMuerte ?? false,
      };
    }).toList();

    final payload = <String, dynamic>{
      'meta': {
        'app': 'Derby Manager',
        'version': 1,
        'exportedAt': DateTime.now().toIso8601String(),
      },
      'derby': {
        'id': _derbyId,
        'nombre': _derbyNombre,
        'config': {
          'numeroRondas': _config.numeroRondas,
          'toleranciaPeso': _config.toleranciaPeso,
          'puntosVictoria': _config.puntosVictoria,
          'puntosDerrota': _config.puntosDerrota,
          'puntosEmpate': _config.puntosEmpate,
        },
      },
      'participantes': _participantes
          .map(
            (p) => {
              'id': p.id,
              'nombre': p.nombre,
              'equipo': p.equipo,
              'telefono': p.telefono,
              'puntosTotales': p.puntosTotales,
              'peleasGanadas': p.peleasGanadas,
              'peleasPerdidas': p.peleasPerdidas,
              'peleasEmpatadas': p.peleasEmpatadas,
            },
          )
          .toList(),
      'gallos': _gallos.map((g) {
        final info = _infoRetiros[g.id];
        final camposRetiro = RetiroBackupUtils.camposRetiroParaJson(
          gallo: g,
          info: info,
        );

        final rondaRetiro = info?.ronda;
        final fuera =
            g.estado == EstadoGallo.retirado ||
            g.estado == EstadoGallo.descalificado;
        if (fuera && rondaRetiro == null) {
          warningsRetiro.add(
            'Gallo ${g.anillo} marcado como retirado/descalificado sin rondaRetiro',
          );
        } else if (rondaRetiro != null) {
          warningsRetiro.addAll(
            RetiroBackupUtils.validarCoherenciaRetiro(
              galloId: g.id,
              rondaRetiro: rondaRetiro,
              anillo: g.anillo,
              rondas: _rondas,
            ),
          );
        }

        return {
          'id': g.id,
          'participanteId': g.participanteId,
          'anillo': g.anillo,
          'peso': g.peso,
          'estado': g.estado.name,
          ...camposRetiro,
        };
      }).toList(),
      'rondas': _rondas
          .map(
            (r) => {
              'id': r.id,
              'numero': r.numero,
              'estado': r.estado.name,
              'bloqueada': r.bloqueada,
              'fechaGeneracion': r.fechaGeneracion?.toIso8601String(),
              'peleas': r.peleas
                  .map(
                    (p) => {
                      'id': p.id,
                      'numero': p.numero,
                      'galloRojoId': p.galloRojoId,
                      'galloVerdeId': p.galloVerdeId,
                      'ganadorId': p.ganadorId,
                      'empate': p.empate,
                      'estado': p.estado.name,
                      'duracionSegundos': p.duracionSegundos,
                      'notas': p.notas,
                    },
                  )
                  .toList(),
            },
          )
          .toList(),
      // Sección de retiros y descalificaciones
      'retirosDescalificaciones': retirosDescalificaciones,
      // Info de retiros (para re-importar con motivos y rondas)
      'infoRetiros': _infoRetiros.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      if (warningsRetiro.isNotEmpty) 'warningsRetiro': warningsRetiro,
    };

    if (warningsRetiro.isNotEmpty) {
      debugPrint(
        '⚠️ Export backup con advertencias de coherencia en retiros: '
        '${warningsRetiro.length}',
      );
    }

    final path = await _backupService.exportarJson(payload);
    await _registrarEvento(
      tipo: 'backup',
      descripcion: 'Backup JSON exportado',
    );
    return path;
  }

  /// Exporta la lista de participantes como CSV y abre el archivo.
  /// Retorna la ruta del archivo creado.
  Future<String> exportarParticipantesCsv() async {
    final vms = participantesVM;
    final sb = StringBuffer();

    // Cabecera (incluye gallos activos/retirados/descalificados)
    sb.writeln(
      '#,Nombre,Equipo,Teléfono,Gallos Total,Activos,Retirados,Descalif,Puntos,V,E,D,Compadres,Estado',
    );

    // Filas
    for (final vm in vms) {
      // Escapar campos con coma o comillas
      String esc(String? v) {
        if (v == null || v.isEmpty) return '';
        if (v.contains(',') || v.contains('"') || v.contains('\n')) {
          return '"${v.replaceAll('"', '""')}"';
        }
        return v;
      }

      final compadresNames = vm.compadres
          .map((cid) {
            final p = _participantes.where((x) => x.id == cid).firstOrNull;
            return p?.nombre ?? cid;
          })
          .join(' | ');

      // Estado del participante
      final estadoParticipante = vm.todosDescalificados
          ? 'DESCALIFICADO'
          : vm.todosFueraDelTorneo
          ? 'SIN GALLOS'
          : 'ACTIVO';

      sb.writeln(
        '${vm.posicion},'
        '${esc(vm.nombre)},'
        '${esc(vm.equipo)},'
        '${esc(vm.telefono)},'
        '${vm.totalGallos},'
        '${vm.gallosActivos.length},'
        '${vm.gallosRetirados.length},'
        '${vm.gallosDescalificados.length},'
        '${vm.puntosTotales},'
        '${vm.victorias},'
        '${vm.empates},'
        '${vm.derrotas},'
        '${esc(compadresNames)},'
        '$estadoParticipante',
      );
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = 'derby_participantes_$timestamp.csv';
    final path = await _backupService.exportarCsv(sb.toString(), filename);
    return path;
  }

  /// Exporta un CSV con información de retiros y descalificaciones.
  /// Incluye gallo, participante, estado, y peleas afectadas.
  Future<String> exportarRetirosCsv() async {
    final sb = StringBuffer();

    // Cabecera
    sb.writeln(
      'Anillo,Participante,Estado,Peleas Canceladas,Victorias Previas,Derrotas Previas',
    );

    // Gallos retirados o descalificados
    final gallosFuera = _gallos.where(
      (g) =>
          g.estado == EstadoGallo.retirado ||
          g.estado == EstadoGallo.descalificado,
    );

    for (final gallo in gallosFuera) {
      final participante = _participantes
          .where((p) => p.id == gallo.participanteId)
          .firstOrNull;

      // Calcular estadísticas del gallo
      var victorias = 0;
      var derrotas = 0;
      var canceladas = 0;

      for (final ronda in _rondas) {
        for (final pelea in ronda.peleas) {
          if (!pelea.participoGallo(gallo.id)) continue;

          if (pelea.estado == EstadoPelea.cancelada) {
            canceladas++;
          } else if (pelea.tieneResultado) {
            if (pelea.empate) {
              // No afecta V/D
            } else if (pelea.ganadorId == gallo.id) {
              victorias++;
            } else {
              derrotas++;
            }
          }
        }
      }

      String esc(String? v) {
        if (v == null || v.isEmpty) return '';
        if (v.contains(',') || v.contains('"') || v.contains('\n')) {
          return '"${v.replaceAll('"', '""')}"';
        }
        return v;
      }

      sb.writeln(
        '${esc(gallo.anillo)},'
        '${esc(participante?.nombre)},'
        '${gallo.estado.name.toUpperCase()},'
        '$canceladas,'
        '$victorias,'
        '$derrotas',
      );
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = 'derby_retiros_$timestamp.csv';
    final path = await _backupService.exportarCsv(sb.toString(), filename);
    return path;
  }

  /// Importa un torneo desde un archivo JSON de backup.
  /// Reemplaza todos los datos actuales con los del backup.
  Future<void> importarTorneoJson() async {
    final result = await _backupService.importarJson();

    if (!result.success) {
      throw StateError(result.error ?? 'Error desconocido al importar');
    }

    final data = result.data!;

    try {
      _cargando = true;
      notifyListeners();

      // Parsear datos del backup
      final derbyData = data['derby'] as Map<String, dynamic>;
      final configData = derbyData['config'] as Map<String, dynamic>;
      final participantesData = data['participantes'] as List<dynamic>;
      final gallosData = data['gallos'] as List<dynamic>;
      final rondasData = data['rondas'] as List<dynamic>? ?? [];
      final warningsRetiro = <String>[];

      // P0-LICENCIA: Validar límites de licencia ANTES de importar
      if (!licenciaPro) {
        final numParticipantes = participantesData.length;
        final numRondas = rondasData.length;

        if (numParticipantes > maxParticipantesDemo) {
          throw StateError(
            'Modo demo: el backup tiene $numParticipantes participantes, '
            'pero el límite es $maxParticipantesDemo. Activa licencia Pro.',
          );
        }

        if (numRondas > maxRondasDemo) {
          throw StateError(
            'Modo demo: el backup tiene $numRondas rondas, '
            'pero el límite es $maxRondasDemo. Activa licencia Pro.',
          );
        }
      }

      // 1. Limpiar datos actuales
      _participantes.clear();
      _gallos.clear();
      _rondas = [];
      _rondasPreview = [];
      _previewGeneradoEn = null;

      // 2. Restaurar configuración
      _derbyId = derbyData['id'] as String;
      _derbyNombre = derbyData['nombre'] as String;
      _config = ConfiguracionDerby(
        numeroRondas: configData['numeroRondas'] as int,
        toleranciaPeso: (configData['toleranciaPeso'] as num).toDouble(),
        puntosVictoria: configData['puntosVictoria'] as int,
        puntosDerrota: configData['puntosDerrota'] as int,
        puntosEmpate: configData['puntosEmpate'] as int,
      );

      // 3. Restaurar participantes
      for (final pData in participantesData) {
        final p = Participante(
          id: pData['id'] as String,
          nombre: pData['nombre'] as String,
          equipo: pData['equipo'] as String?,
          telefono: pData['telefono'] as String?,
          puntosTotales: pData['puntosTotales'] as int? ?? 0,
          peleasGanadas: pData['peleasGanadas'] as int? ?? 0,
          peleasPerdidas: pData['peleasPerdidas'] as int? ?? 0,
          peleasEmpatadas: pData['peleasEmpatadas'] as int? ?? 0,
        );
        _participantes.add(p);
      }

      // 4. Restaurar gallos
      final infoRetirosDesdeGallos = <String, InfoRetiro>{};
      for (final gData in gallosData) {
        final estadoStr = gData['estado'] as String? ?? 'activo';
        final estado = EstadoGallo.values.firstWhere(
          (e) => e.name == estadoStr,
          orElse: () => EstadoGallo.activo,
        );

        final g = Gallo(
          id: gData['id'] as String,
          participanteId: gData['participanteId'] as String,
          anillo: gData['anillo'] as String,
          peso: (gData['peso'] as num).toDouble(),
          estado: estado,
        );
        _gallos.add(g);

        // Compatibilidad extendida: campos opcionales de retiro en entidad gallo.
        final infoRetiroDesdeGallo = RetiroBackupUtils.infoRetiroDesdeGalloJson(
          galloJson: gData as Map<String, dynamic>,
          anillo: g.anillo,
          estado: estado,
        );
        if (infoRetiroDesdeGallo != null) {
          infoRetirosDesdeGallos[g.id] = infoRetiroDesdeGallo;
        }
      }

      // 5. Restaurar rondas
      final rondasRestauradas = <Ronda>[];
      for (final rData in rondasData) {
        final estadoStr = rData['estado'] as String? ?? 'pendiente';
        final estadoRonda = EstadoRonda.values.firstWhere(
          (e) => e.name == estadoStr,
          orElse: () => EstadoRonda.generada,
        );

        final peleasData = rData['peleas'] as List<dynamic>? ?? [];
        final peleas = <Pelea>[];

        for (final peleaData in peleasData) {
          final estadoPeleaStr = peleaData['estado'] as String? ?? 'pendiente';
          final estadoPelea = EstadoPelea.values.firstWhere(
            (e) => e.name == estadoPeleaStr,
            orElse: () => EstadoPelea.pendiente,
          );

          peleas.add(
            Pelea(
              id: peleaData['id'] as String,
              numero: peleaData['numero'] as int,
              galloRojoId: peleaData['galloRojoId'] as String,
              galloVerdeId: peleaData['galloVerdeId'] as String,
              ganadorId: peleaData['ganadorId'] as String?,
              empate: peleaData['empate'] as bool? ?? false,
              estado: estadoPelea,
              duracionSegundos: peleaData['duracionSegundos'] as int?,
              notas: peleaData['notas'] as String?,
            ),
          );
        }

        final fechaGenStr = rData['fechaGeneracion'] as String?;

        rondasRestauradas.add(
          Ronda(
            id: rData['id'] as String,
            numero: rData['numero'] as int,
            estado: estadoRonda,
            bloqueada: rData['bloqueada'] as bool? ?? false,
            fechaGeneracion: fechaGenStr != null
                ? DateTime.tryParse(fechaGenStr)
                : null,
            peleas: peleas,
          ),
        );
      }
      _rondas = rondasRestauradas;

      // 5b. Restaurar info de retiros
      _infoRetiros.clear();
      final infoRetirosData = data['infoRetiros'] as Map<String, dynamic>?;
      if (infoRetirosData != null) {
        for (final entry in infoRetirosData.entries) {
          _infoRetiros[entry.key] = InfoRetiro.fromJson(
            entry.value as Map<String, dynamic>,
          );
        }
      }

      // Compatibilidad: si falta en infoRetiros, completar desde gallos[] opcional
      for (final entry in infoRetirosDesdeGallos.entries) {
        _infoRetiros.putIfAbsent(entry.key, () => entry.value);
      }

      // Validaciones no bloqueantes: coherencia de retiro
      for (final g in _gallos) {
        final info = _infoRetiros[g.id];
        if (info == null) continue;

        warningsRetiro.addAll(
          RetiroBackupUtils.validarCoherenciaRetiro(
            galloId: g.id,
            rondaRetiro: info.ronda,
            anillo: g.anillo,
            rondas: _rondas,
          ),
        );
      }

      // 6. Persistir todo
      await _repo.guardarDerby(
        uid: _derbyId,
        nombre: _derbyNombre,
        config: _config,
      );

      for (final p in _participantes) {
        await _repo.guardarParticipante(p);
      }

      for (final g in _gallos) {
        await _repo.guardarGallo(g);
      }

      await _repo.guardarRondas(_derbyId, _rondas);

      // Validar integridad después de importar
      final erroresIntegridad = _validarIntegridad();
      if (erroresIntegridad.isNotEmpty) {
        _error =
            'Backup importado con advertencias:\n${erroresIntegridad.join('\n')}';
      }

      if (warningsRetiro.isNotEmpty) {
        final avisoRetiros =
            '\nAdvertencias de retiro:\n${warningsRetiro.join('\n')}';
        _error =
            (_error ?? 'Backup importado con advertencias:') + avisoRetiros;
        debugPrint(
          '⚠️ Import backup con advertencias de coherencia en retiros: '
          '${warningsRetiro.length}',
        );
      }

      _rondaSeleccionada = 0;
      _cargando = false;
      notifyListeners();

      await _registrarEvento(
        tipo: 'backup',
        descripcion: 'Backup importado: $_derbyNombre',
      );

      // Auditoría inmutable - CRÍTICO
      await _auditService.registrarEvento(
        tipo: 'import',
        descripcion: 'Backup importado: $_derbyNombre',
        payload: {
          'derbyId': _derbyId,
          'derbyNombre': _derbyNombre,
          'participantes': _participantes.length,
          'gallos': _gallos.length,
          'rondas': _rondas.length,
          'erroresIntegridad': erroresIntegridad,
          'warningsRetiro': warningsRetiro,
        },
      );
    } catch (e) {
      _cargando = false;
      _error = 'Error restaurando backup: $e';
      notifyListeners();
      rethrow;
    }
  }

  // === Limpiar error ===
  void limpiarError() {
    _error = null;
    notifyListeners();
  }

  // === Reset completo ===
  Future<void> resetear({String? nombre}) async {
    _derby = null;
    _participantes.clear();
    _gallos.clear();
    _rondas = [];
    _rondasPreview = [];
    _previewGeneradoEn = null;
    _infoRetiros.clear();
    _config = ConfiguracionDerby.standard();
    _rondaSeleccionada = 0;
    _error = null;
    _cargando = false;
    _derbyId = 'derby_${DateTime.now().millisecondsSinceEpoch}';
    _derbyNombre = nombre ?? 'Derby Actual';
    notifyListeners();

    // No limpiamos la BD, solo creamos nuevo derby
    await _repo.guardarDerby(
      uid: _derbyId,
      nombre: _derbyNombre,
      config: _config,
    );
    await _registrarEvento(
      tipo: 'derby',
      descripcion: 'Derby reiniciado: $_derbyNombre',
    );
  }

  Future<void> _registrarEvento({
    required String tipo,
    required String descripcion,
  }) async {
    _historial = await _historyService.appendEvent(
      tipo: tipo,
      descripcion: descripcion,
    );
    notifyListeners();
  }
}
