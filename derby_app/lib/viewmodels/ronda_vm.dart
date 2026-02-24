import 'package:derby_engine/derby_engine.dart';
import 'pelea_vm.dart';
import 'gallo_vm.dart';

/// ViewModel para presentar una Ronda en la UI.
///
/// Incluye las peleas enriquecidas y estadísticas calculadas.
class RondaVM {
  final Ronda ronda;

  /// Lista de peleas enriquecidas
  final List<PeleaVM> peleasVM;

  /// Lista de gallos sin cotejo enriquecidos
  final List<GalloVM> sinCotejoVM;

  const RondaVM({
    required this.ronda,
    this.peleasVM = const [],
    this.sinCotejoVM = const [],
  });

  // === Delegates al modelo base ===
  String get id => ronda.id;
  int get numero => ronda.numero;
  List<Pelea> get peleas => ronda.peleas;
  List<String> get sinCotejo => ronda.sinCotejo;
  EstadoRonda get estado => ronda.estado;
  DateTime? get fechaGeneracion => ronda.fechaGeneracion;
  bool get bloqueada => ronda.bloqueada;
  int get totalPeleas => ronda.totalPeleas;
  int get peleasFinalizadas => ronda.peleasFinalizadas;
  int get peleasCanceladas => ronda.peleasCanceladas;
  int get peleasTerminadas => ronda.peleasTerminadas;
  bool get todasFinalizadas => ronda.todasFinalizadas;

  // === Campos de presentación ===

  /// Peleas activas (no canceladas) para UI que necesita solo las disputadas
  List<PeleaVM> get peleasActivasVM =>
      peleasVM.where((p) => !p.cancelada).toList();

  /// Peleas canceladas
  List<PeleaVM> get peleasCanceladasVM =>
      peleasVM.where((p) => p.cancelada).toList();

  /// Número de peleas pendientes (ni finalizadas ni canceladas)
  int get peleasPendientes => ronda.peleasPendientes;

  /// Porcentaje de progreso (0-100) - basado en peleas terminadas
  int get porcentajeProgreso =>
      totalPeleas > 0 ? (peleasTerminadas * 100 ~/ totalPeleas) : 0;

  /// Label del estado
  String get estadoLabel {
    switch (estado) {
      case EstadoRonda.generada:
        return 'Generada';
      case EstadoRonda.enProgreso:
        return 'En progreso';
      case EstadoRonda.finalizada:
        return 'Finalizada';
    }
  }

  /// Label resumido para lista (terminadas incluye canceladas)
  String get resumenLabel => '$peleasTerminadas/$totalPeleas peleas';

  /// Resumen detallado: "16 peleas programadas • 15 realizadas • 1 cancelada"
  String get resumenDetallado {
    final partes = <String>['$totalPeleas programadas'];
    if (peleasFinalizadas > 0) partes.add('$peleasFinalizadas realizadas');
    if (peleasCanceladas > 0) partes.add('$peleasCanceladas canceladas');
    if (peleasPendientes > 0) partes.add('$peleasPendientes pendientes');
    return partes.join(' • ');
  }

  /// Número de gallos sin cotejo
  int get totalSinCotejo => sinCotejo.length;

  /// Fecha formateada
  String get fechaFormateada {
    if (fechaGeneracion == null) return '-';
    final f = fechaGeneracion!;
    return '${f.day}/${f.month}/${f.year} ${f.hour}:${f.minute.toString().padLeft(2, '0')}';
  }

  /// Crea RondaVM desde Ronda con datos enriquecidos.
  factory RondaVM.fromRonda(
    Ronda ronda, {
    required List<Gallo> gallos,
    required List<Participante> participantes,
  }) {
    // INCLUIR todas las peleas (activas + canceladas) para visibilidad completa
    final peleasVM = ronda.peleas.map((p) {
      return PeleaVM.fromPelea(
        p,
        numeroRonda: ronda.numero,
        gallos: gallos,
        participantes: participantes,
      );
    }).toList();

    // Convertir gallos sin cotejo a GalloVM
    final sinCotejoVM = ronda.sinCotejo
        .map((galloId) {
          final gallo = gallos.where((g) => g.id == galloId).firstOrNull;
          if (gallo == null) return null;
          return GalloVM.fromGallo(gallo, participantes: participantes);
        })
        .whereType<GalloVM>()
        .toList();

    return RondaVM(ronda: ronda, peleasVM: peleasVM, sinCotejoVM: sinCotejoVM);
  }

  /// Crea lista de RondaVM desde lista de Rondas.
  static List<RondaVM> fromList(
    List<Ronda> rondas, {
    required List<Gallo> gallos,
    required List<Participante> participantes,
  }) {
    return rondas.map((r) {
      return RondaVM.fromRonda(r, gallos: gallos, participantes: participantes);
    }).toList();
  }
}
