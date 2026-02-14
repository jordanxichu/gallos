import 'package:flutter/foundation.dart';
import 'package:derby_engine/derby_engine.dart';
import '../data/derby_repository.dart';
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
  String _derbyId = 'derby_default';
  String _derbyNombre = 'Derby Actual';

  // === Datos del modelo ===
  Derby? _derby;
  final List<Participante> _participantes = [];
  final List<Gallo> _gallos = [];
  List<Ronda> _rondas = [];
  ConfiguracionDerby _config = ConfiguracionDerby.standard();

  // === Estado de la UI ===
  bool _cargando = false;
  String? _error;
  int _rondaSeleccionada = 0;

  // === Getters de estado ===
  bool get cargando => _cargando;
  String? get error => _error;
  int get rondaSeleccionada => _rondaSeleccionada;
  String get derbyNombre => _derbyNombre;
  String get derbyId => _derbyId;

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

  /// Ronda actual seleccionada como ViewModel
  RondaVM? get rondaActualVM {
    if (_rondas.isEmpty || _rondaSeleccionada >= _rondas.length) return null;
    return RondaVM.fromRonda(
      _rondas[_rondaSeleccionada],
      gallos: _gallos,
      participantes: _participantes,
    );
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
  }

  Future<void> actualizarParticipante(Participante participante) async {
    final index = _participantes.indexWhere((p) => p.id == participante.id);
    if (index != -1) {
      _participantes[index] = participante;
      notifyListeners();
      await _repo.guardarParticipante(participante);
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
  }

  // === Acciones de Gallos ===

  Future<void> agregarGallo(Gallo gallo) async {
    _gallos.add(gallo);
    notifyListeners();
    await _repo.guardarGallo(gallo);
  }

  Future<void> actualizarGallo(Gallo gallo) async {
    final index = _gallos.indexWhere((g) => g.id == gallo.id);
    if (index != -1) {
      _gallos[index] = gallo;
      notifyListeners();
      await _repo.guardarGallo(gallo);
    }
  }

  Future<void> eliminarGallo(String id) async {
    _gallos.removeWhere((g) => g.id == id);
    notifyListeners();
    await _repo.eliminarGallo(id);
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
  }

  // === Acciones de Sorteo ===

  /// Ejecuta el sorteo generando todas las rondas.
  Future<void> ejecutarSorteo() async {
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

      _rondas = resultado.rondas;
      _rondaSeleccionada = 0;
      _cargando = false;
      notifyListeners();

      // Persistir rondas
      await _repo.guardarRondas(_derbyId, _rondas);
    } catch (e) {
      _error = 'Error en sorteo: $e';
      _cargando = false;
      notifyListeners();
    }
  }

  /// Limpia el sorteo actual.
  Future<void> limpiarSorteo() async {
    _rondas = [];
    _rondaSeleccionada = 0;
    notifyListeners();
    await _repo.guardarRondas(_derbyId, []);
  }

  // === Acciones de Navegación de Rondas ===

  void seleccionarRonda(int index) {
    if (index >= 0 && index < _rondas.length) {
      _rondaSeleccionada = index;
      notifyListeners();
    }
  }

  void siguienteRonda() {
    if (_rondaSeleccionada < _rondas.length - 1) {
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
  }
}
