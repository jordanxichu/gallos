import 'package:derby_engine/derby_engine.dart';

/// ViewModel para presentar un Participante en la UI.
///
/// Proporciona campos calculados y de presentación.
class ParticipanteVM {
  final Participante participante;

  /// Posición en la tabla de clasificación (1, 2, 3...)
  final int posicion;

  /// Lista de gallos del participante
  final List<Gallo> gallos;

  const ParticipanteVM({
    required this.participante,
    this.posicion = 0,
    this.gallos = const [],
  });

  // === Delegates al modelo base ===
  String get id => participante.id;
  String get nombre => participante.nombre;
  String? get telefono => participante.telefono;
  String? get equipo => participante.equipo;
  List<String> get compadres => participante.compadres;
  int get puntosTotales => participante.puntosTotales;
  int get peleasGanadas => participante.peleasGanadas;
  int get peleasEmpatadas => participante.peleasEmpatadas;
  int get peleasPerdidas => participante.peleasPerdidas;
  int get totalPeleas => participante.totalPeleas;

  // === Campos de presentación ===

  /// Número de gallos inscritos
  int get totalGallos => gallos.length;

  /// Equipo formateado (o "-" si no tiene)
  String get equipoFormateado => equipo ?? '-';

  /// Teléfono formateado (o "-" si no tiene)
  String get telefonoFormateado => telefono ?? '-';

  /// Victorias (alias más intuitivo)
  int get victorias => peleasGanadas;

  /// Derrotas (alias más intuitivo)
  int get derrotas => peleasPerdidas;

  /// Empates (alias más intuitivo)
  int get empates => peleasEmpatadas;

  /// Porcentaje de victorias
  int get porcentajeVictorias =>
      totalPeleas > 0 ? (victorias * 100 ~/ totalPeleas) : 0;

  /// Indica si está en el podio (top 3)
  bool get enPodio => posicion >= 1 && posicion <= 3;

  /// Label de posición con emoji
  String get posicionLabel {
    switch (posicion) {
      case 1:
        return '🥇 1°';
      case 2:
        return '🥈 2°';
      case 3:
        return '🥉 3°';
      default:
        return '$posicion°';
    }
  }

  /// Número de compadres
  int get totalCompadres => compadres.length;

  /// Gallos activos (no retirados ni descalificados)
  List<Gallo> get gallosActivos => gallos
      .where(
        (g) =>
            g.estado != EstadoGallo.retirado &&
            g.estado != EstadoGallo.descalificado,
      )
      .toList();

  /// Gallos retirados del torneo
  List<Gallo> get gallosRetirados =>
      gallos.where((g) => g.estado == EstadoGallo.retirado).toList();

  /// Gallos descalificados
  List<Gallo> get gallosDescalificados =>
      gallos.where((g) => g.estado == EstadoGallo.descalificado).toList();

  /// Indica si todos los gallos fueron descalificados
  bool get todosDescalificados =>
      gallos.isNotEmpty &&
      gallos.every((g) => g.estado == EstadoGallo.descalificado);

  /// Indica si todos los gallos están fuera del torneo (retirados o descalificados)
  bool get todosFueraDelTorneo =>
      gallos.isNotEmpty &&
      gallos.every(
        (g) =>
            g.estado == EstadoGallo.retirado ||
            g.estado == EstadoGallo.descalificado,
      );

  /// Badge de estado para mostrar en UI (vacío si tiene gallos activos)
  String get estadoBadge {
    if (todosDescalificados) return '🚫 DESCALIFICADO';
    if (todosFueraDelTorneo) return '⛔ SIN GALLOS';
    return '';
  }

  /// Crea ParticipanteVM desde Participante con datos enriquecidos.
  factory ParticipanteVM.fromParticipante(
    Participante participante, {
    required List<Gallo> todosLosGallos,
    int posicion = 0,
  }) {
    final gallos = todosLosGallos
        .where((g) => g.participanteId == participante.id)
        .toList();

    return ParticipanteVM(
      participante: participante,
      posicion: posicion,
      gallos: gallos,
    );
  }

  /// Crea lista de ParticipanteVM ordenada por puntos.
  static List<ParticipanteVM> fromListOrdenada(
    List<Participante> participantes, {
    required List<Gallo> gallos,
  }) {
    // Ordenar por puntos descendente
    final ordenados = List<Participante>.from(participantes)
      ..sort((a, b) {
        final puntos = b.puntosTotales.compareTo(a.puntosTotales);
        if (puntos != 0) return puntos;
        final victorias = b.peleasGanadas.compareTo(a.peleasGanadas);
        if (victorias != 0) return victorias;
        return a.nombre.compareTo(b.nombre);
      });

    return ordenados.asMap().entries.map((entry) {
      return ParticipanteVM.fromParticipante(
        entry.value,
        todosLosGallos: gallos,
        posicion: entry.key + 1,
      );
    }).toList();
  }
}
