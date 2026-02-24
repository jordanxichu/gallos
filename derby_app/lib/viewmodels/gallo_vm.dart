import 'package:derby_engine/derby_engine.dart';
import 'info_retiro.dart';

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

  /// Peleas canceladas por retiro/descalificación
  final int peleasCanceladas;

  /// Info de retiro (si el gallo fue retirado/descalificado)
  final InfoRetiro? infoRetiro;

  const GalloVM({
    required this.gallo,
    this.participante,
    this.posicion = 0,
    this.totalPeleas = 0,
    this.victorias = 0,
    this.derrotas = 0,
    this.empates = 0,
    this.peleasCanceladas = 0,
    this.infoRetiro,
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

  /// Indica si el gallo está retirado
  bool get estaRetirado => estado == EstadoGallo.retirado;

  /// Indica si el gallo está descalificado
  bool get estaDescalificado => estado == EstadoGallo.descalificado;

  /// Indica si el gallo está fuera del torneo (retirado o descalificado)
  bool get fueraDelTorneo => estaRetirado || estaDescalificado;

  /// Indica si el motivo de retiro fue muerte
  bool get estaMuerto => infoRetiro?.esMuerte ?? false;

  /// Ronda donde fue retirado/descalificado (1-based), o null si activo
  int? get rondaRetiro => infoRetiro?.ronda;

  /// Motivo del retiro/descalificación
  String? get motivoRetiro => infoRetiro?.motivo;

  /// Badge de estado para mostrar en UI (vacío si activo)
  String get estadoBadge {
    if (estaDescalificado) return '🚫 DESCALIFICADO';
    if (estaRetirado) {
      if (estaMuerto) return '☠️ MUERTO';
      return '⛔ RETIRADO';
    }
    return '';
  }

  /// Tooltip descriptivo: "Retirado en Ronda 3 – Lesión"
  String get tooltipEstado {
    if (!fueraDelTorneo) return '';
    if (infoRetiro != null) {
      final obs = (motivoRetiro ?? '').trim();
      if (obs.isNotEmpty) {
        return '$estadoDetalleVisible – $obs';
      }
      return estadoDetalleVisible;
    }
    return estadoDetalleVisible;
  }

  /// Texto explícito para trazabilidad en UI/PDF.
  /// Ejemplo: RETIRADO – MUERTE (Ronda 1)
  String get estadoDetalleVisible {
    if (!fueraDelTorneo) return 'ACTIVO';
    if (infoRetiro != null) {
      return infoRetiro!.descripcionAuditable(
        esDescalificado: estaDescalificado,
      );
    }
    if (estaDescalificado) return 'RETIRADO – DESCALIFICACION';
    return 'RETIRADO – ABANDONO';
  }

  /// Crea un GalloVM desde un Gallo con datos enriquecidos.
  factory GalloVM.fromGallo(
    Gallo gallo, {
    required List<Participante> participantes,
    List<Ronda> rondas = const [],
    Map<String, InfoRetiro> infoRetiros = const {},
    int posicion = 0,
  }) {
    // Buscar participante
    final participante = participantes
        .where((p) => p.id == gallo.participanteId)
        .firstOrNull;

    // Buscar info de retiro
    final retiro = infoRetiros[gallo.id];

    // Calcular estadísticas desde las rondas
    var victorias = 0;
    var derrotas = 0;
    var empates = 0;
    var canceladas = 0;

    for (final ronda in rondas) {
      for (final pelea in ronda.peleas) {
        if (!pelea.participoGallo(gallo.id)) continue;

        // Contar peleas canceladas (por retiro/descalificación)
        if (pelea.estado == EstadoPelea.cancelada) {
          canceladas++;
          continue;
        }

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
      peleasCanceladas: canceladas,
      infoRetiro: retiro,
    );
  }

  /// Crea lista de GalloVM desde lista de Gallos.
  static List<GalloVM> fromList(
    List<Gallo> gallos, {
    required List<Participante> participantes,
    List<Ronda> rondas = const [],
    Map<String, InfoRetiro> infoRetiros = const {},
  }) {
    return gallos.asMap().entries.map((entry) {
      return GalloVM.fromGallo(
        entry.value,
        participantes: participantes,
        rondas: rondas,
        infoRetiros: infoRetiros,
        posicion: entry.key + 1,
      );
    }).toList();
  }
}
