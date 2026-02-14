import 'package:derby_engine/derby_engine.dart';

/// ViewModel para presentar un Gallo en la UI.
///
/// Extiende el modelo base con campos calculados y de presentación
/// sin modificar el engine.
class GalloVM {
  final Gallo gallo;
  final Participante? participante;

  /// Posición en la lista (para mostrar #1, #2, etc.)
  final int posicion;

  /// Total de peleas del gallo (calculado de las rondas)
  final int totalPeleas;

  /// Victorias del gallo
  final int victorias;

  /// Derrotas del gallo
  final int derrotas;

  /// Empates del gallo
  final int empates;

  const GalloVM({
    required this.gallo,
    this.participante,
    this.posicion = 0,
    this.totalPeleas = 0,
    this.victorias = 0,
    this.derrotas = 0,
    this.empates = 0,
  });

  // === Delegates al modelo base ===
  String get id => gallo.id;
  String get participanteId => gallo.participanteId;
  double get peso => gallo.peso;
  String get anillo => gallo.anillo;
  EstadoGallo get estado => gallo.estado;

  // === Campos de presentación ===

  /// Peso formateado como string (e.g., "2,100g")
  String get pesoFormateado => '${peso.toStringAsFixed(0)}g';

  /// Nombre del participante o "Sin asignar"
  String get nombreParticipante => participante?.nombre ?? 'Sin asignar';

  /// Equipo del participante o "-"
  String get equipoParticipante => participante?.equipo ?? '-';

  /// Porcentaje de victorias (0-100)
  int get porcentajeVictorias =>
      totalPeleas > 0 ? (victorias * 100 ~/ totalPeleas) : 0;

  /// Label corto para el estado
  String get estadoLabel {
    switch (estado) {
      case EstadoGallo.activo:
        return 'Activo';
      case EstadoGallo.finalizado:
        return 'Finalizado';
      case EstadoGallo.retirado:
        return 'Retirado';
      case EstadoGallo.descalificado:
        return 'Descalificado';
    }
  }

  /// Crea un GalloVM desde un Gallo con datos enriquecidos.
  factory GalloVM.fromGallo(
    Gallo gallo, {
    required List<Participante> participantes,
    List<Ronda> rondas = const [],
    int posicion = 0,
  }) {
    // Buscar participante
    final participante = participantes
        .where((p) => p.id == gallo.participanteId)
        .firstOrNull;

    // Calcular estadísticas desde las rondas
    var victorias = 0;
    var derrotas = 0;
    var empates = 0;

    for (final ronda in rondas) {
      for (final pelea in ronda.peleas) {
        if (!pelea.participoGallo(gallo.id)) continue;
        if (!pelea.tieneResultado) continue;

        if (pelea.empate) {
          empates++;
        } else if (pelea.ganadorId == gallo.id) {
          victorias++;
        } else {
          derrotas++;
        }
      }
    }

    return GalloVM(
      gallo: gallo,
      participante: participante,
      posicion: posicion,
      totalPeleas: victorias + derrotas + empates,
      victorias: victorias,
      derrotas: derrotas,
      empates: empates,
    );
  }

  /// Crea lista de GalloVM desde lista de Gallos.
  static List<GalloVM> fromList(
    List<Gallo> gallos, {
    required List<Participante> participantes,
    List<Ronda> rondas = const [],
  }) {
    return gallos.asMap().entries.map((entry) {
      return GalloVM.fromGallo(
        entry.value,
        participantes: participantes,
        rondas: rondas,
        posicion: entry.key + 1,
      );
    }).toList();
  }
}
