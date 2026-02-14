import 'package:derby_engine/derby_engine.dart';
import 'gallo_vm.dart';

/// ViewModel para presentar una Pelea en la UI.
///
/// Incluye los datos enriquecidos de ambos gallos y sus participantes.
class PeleaVM {
  final Pelea pelea;

  /// Número de ronda (viene del objeto Ronda contenedor)
  final int numeroRonda;

  /// GalloVM del lado rojo
  final GalloVM? galloRojo;

  /// GalloVM del lado verde
  final GalloVM? galloVerde;

  const PeleaVM({
    required this.pelea,
    required this.numeroRonda,
    this.galloRojo,
    this.galloVerde,
  });

  // === Delegates al modelo base ===
  String get id => pelea.id;
  int get numero => pelea.numero;
  String get galloRojoId => pelea.galloRojoId;
  String get galloVerdeId => pelea.galloVerdeId;
  String? get ganadorId => pelea.ganadorId;
  bool get empate => pelea.empate;
  EstadoPelea get estado => pelea.estado;
  int? get duracionSegundos => pelea.duracionSegundos;
  String? get notas => pelea.notas;
  bool get tieneResultado => pelea.tieneResultado;

  // === Campos de presentación ===

  /// Indica si ya se completó la pelea
  bool get completada => estado == EstadoPelea.finalizada;

  /// Indica si ganó el lado rojo
  bool get ganoRojo => ganadorId == galloRojoId;

  /// Indica si ganó el lado verde
  bool get ganoVerde => ganadorId == galloVerdeId;

  /// Diferencia de peso absoluta
  double get diferenciaPeso {
    if (galloRojo == null || galloVerde == null) return 0;
    return (galloRojo!.peso - galloVerde!.peso).abs();
  }

  /// Diferencia de peso formateada
  String get diferenciaPesoFormateada =>
      '${diferenciaPeso.toStringAsFixed(0)}g';

  /// Anillo del gallo rojo
  String get anilloRojo => galloRojo?.anillo ?? galloRojoId;

  /// Anillo del gallo verde
  String get anilloVerde => galloVerde?.anillo ?? galloVerdeId;

  /// Peso del gallo rojo formateado
  String get pesoRojoFormateado => galloRojo?.pesoFormateado ?? '-';

  /// Peso del gallo verde formateado
  String get pesoVerdeFormateado => galloVerde?.pesoFormateado ?? '-';

  /// Nombre del dueño del gallo rojo
  String get nombreParticipanteRojo => galloRojo?.nombreParticipante ?? '-';

  /// Nombre del dueño del gallo verde
  String get nombreParticipanteVerde => galloVerde?.nombreParticipante ?? '-';

  /// Label del estado
  String get estadoLabel {
    switch (estado) {
      case EstadoPelea.pendiente:
        return 'Pendiente';
      case EstadoPelea.enCurso:
        return 'En curso';
      case EstadoPelea.finalizada:
        if (empate) return 'Empate';
        return ganoRojo ? 'Ganó Rojo' : 'Ganó Verde';
      case EstadoPelea.cancelada:
        return 'Cancelada';
    }
  }

  /// Duración formateada (mm:ss)
  String get duracionFormateada {
    if (duracionSegundos == null) return '-';
    final mins = duracionSegundos! ~/ 60;
    final secs = duracionSegundos! % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// Crea PeleaVM desde Pelea con datos enriquecidos.
  factory PeleaVM.fromPelea(
    Pelea pelea, {
    required int numeroRonda,
    required List<Gallo> gallos,
    required List<Participante> participantes,
  }) {
    GalloVM? galloRojo;
    GalloVM? galloVerde;

    final galloRojoModel = gallos
        .where((g) => g.id == pelea.galloRojoId)
        .firstOrNull;
    final galloVerdeModel = gallos
        .where((g) => g.id == pelea.galloVerdeId)
        .firstOrNull;

    if (galloRojoModel != null) {
      galloRojo = GalloVM.fromGallo(
        galloRojoModel,
        participantes: participantes,
      );
    }

    if (galloVerdeModel != null) {
      galloVerde = GalloVM.fromGallo(
        galloVerdeModel,
        participantes: participantes,
      );
    }

    return PeleaVM(
      pelea: pelea,
      numeroRonda: numeroRonda,
      galloRojo: galloRojo,
      galloVerde: galloVerde,
    );
  }
}
