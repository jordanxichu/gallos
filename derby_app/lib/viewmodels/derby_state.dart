import 'package:flutter/foundation.dart';
import 'package:derby_engine/derby_engine.dart';
import '../data/derby_repository.dart';
import '../data/database_service.dart';
import '../services/backup_service.dart';
import '../services/history_service.dart';
import '../services/license_manager.dart';
import 'gallo_vm.dart';
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

  // === Getters de estado ===
  bool get cargando => _cargando;
  String? get error => _error;
  int get rondaSeleccionada => _rondaSeleccionada;
  String get derbyNombre => _derbyNombre;
  String get derbyId => _derbyId;
  bool get tienePreview => _rondasPreview.isNotEmpty;
  DateTime? get previewGeneradoEn => _previewGeneradoEn;
  List<HistorialEvento> get historialEventos => List.unmodifiable(_historial);
  
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

  int get peleasCompletadas =>
      _rondas.fold(0, (sum, r) => sum + r.peleasFinalizadas);

  int get porcentajeProgreso =>
      totalPeleas > 0 ? (peleasCompletadas * 100 ~/ totalPeleas) : 0;

  bool get sorteoRealizado => _rondas.isNotEmpty;
  int get totalRondasMostradas => sorteoRealizado ? _rondas.length : _rondasPreview.length;

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

      // Cargar rondas
      _rondas = await _repo.cargarRondas(_derbyId);
      _historial = await _historyService.loadHistory();
      
      // Inicializar sistema de licencias
      final isar = await DatabaseService.instance;
      _licenseManager = LicenseManager(isar);
      await _licenseManager!.initialize();
      
      _rondaSeleccionada = 0;

      _cargando = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Error cargando datos: $e';
      _cargando = false;
      notifyListeners();
    }
  }

  // === Acciones de Participantes ===

  Future<void> agregarParticipante(Participante participante) async {
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

  Future<void> eliminarGallo(String id) async {
    _gallos.removeWhere((g) => g.id == id);
    notifyListeners();
    await _repo.eliminarGallo(id);
    await _registrarEvento(
      tipo: 'gallo',
      descripcion: 'Gallo eliminado (id: $id)',
    );
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
  Future<void> ejecutarSorteo() async {
    await generarPreviewSorteo();
  }

  Future<void> generarPreviewSorteo() async {
    if (_gallos.length < 2) {
      _error = 'Se necesitan al menos 2 gallos';
      notifyListeners();
      return;
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
        descripcion: 'Preview de sorteo generado (${_rondasPreview.length} rondas)',
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
    await _registrarEvento(
      tipo: 'sorteo',
      descripcion: 'Sorteo eliminado',
    );
  }

  // === Acciones de Navegación de Rondas ===

  void seleccionarRonda(int index) {
    if (index >= 0 && index < totalRondasMostradas) {
      _rondaSeleccionada = index;
      notifyListeners();
    }
  }

  void siguienteRonda() {
    if (_rondaSeleccionada < totalRondasMostradas - 1) {
      _rondaSeleccionada++;
      notifyListeners();
    }
  }

  void rondaAnterior() {
    if (_rondaSeleccionada > 0) {
      _rondaSeleccionada--;
      notifyListeners();
    }
  }

  // === Acciones de Peleas ===

  /// Registra el resultado de una pelea.
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
      descripcion: 'Resultado registrado en pelea ${pelea.numero} (ronda ${indexRonda + 1})',
    );
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
  Future<void> deshacerResultado({
    required int indexRonda,
    required String peleaId,
  }) async {
    if (indexRonda >= _rondas.length) return;

    final ronda = _rondas[indexRonda];
    final peleaIndex = ronda.peleas.indexWhere((p) => p.id == peleaId);
    if (peleaIndex == -1) return;

    final pelea = ronda.peleas[peleaIndex];
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
      descripcion: 'Resultado deshecho en pelea ${pelea.numero} (ronda ${indexRonda + 1})',
    );
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

  Future<void> desactivarLicencia() async {
    await _licenseManager?.reset();
    notifyListeners();
    await _registrarEvento(
      tipo: 'licencia',
      descripcion: 'Licencia desactivada',
    );
  }

  Future<String> exportarTorneoJson() async {
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
      'gallos': _gallos
          .map(
            (g) => {
              'id': g.id,
              'participanteId': g.participanteId,
              'anillo': g.anillo,
              'peso': g.peso,
              'estado': g.estado.name,
            },
          )
          .toList(),
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
    };

    final path = await _backupService.exportarJson(payload);
    await _registrarEvento(
      tipo: 'backup',
      descripcion: 'Backup JSON exportado',
    );
    return path;
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
