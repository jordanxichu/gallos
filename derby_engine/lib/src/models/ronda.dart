import 'pelea.dart';

/// Representa una ronda del derbi.
///
/// Una ronda contiene múltiples peleas generadas por el algoritmo
/// de emparejamiento, siguiendo todas las restricciones configuradas.
class Ronda {
  /// Identificador único de la ronda.
  final String id;

  /// Número de la ronda (1, 2, 3...).
  final int numero;

  /// Lista de peleas en esta ronda.
  final List<Pelea> peleas;

  /// IDs de gallos que quedaron sin cotejo en esta ronda.
  final List<String> sinCotejo;

  /// Estado de la ronda.
  final EstadoRonda estado;

  /// Fecha y hora de generación de la ronda.
  final DateTime? fechaGeneracion;

  /// Indica si la ronda ha sido bloqueada (no se puede modificar).
  final bool bloqueada;

  const Ronda({
    required this.id,
    required this.numero,
    required this.peleas,
    this.sinCotejo = const [],
    this.estado = EstadoRonda.generada,
    this.fechaGeneracion,
    this.bloqueada = false,
  });

  /// Número total de peleas en la ronda.
  int get totalPeleas => peleas.length;

  /// Número de peleas finalizadas.
  int get peleasFinalizadas =>
      peleas.where((p) => p.estado == EstadoPelea.finalizada).length;

  /// Verifica si todas las peleas han sido finalizadas.
  bool get todasFinalizadas => peleasFinalizadas == totalPeleas;

  /// Obtiene la pelea de un gallo específico en esta ronda.
  Pelea? obtenerPeleaDeGallo(String galloId) {
    try {
      return peleas.firstWhere((p) => p.participoGallo(galloId));
    } catch (_) {
      return null;
    }
  }

  /// Verifica si un gallo peleó en esta ronda.
  bool galloParticipo(String galloId) {
    return peleas.any((p) => p.participoGallo(galloId));
  }

  /// Verifica si un gallo quedó sin cotejo en esta ronda.
  bool galloSinCotejo(String galloId) {
    return sinCotejo.contains(galloId);
  }

  /// Crea una copia de la ronda con las peleas actualizadas.
  Ronda conPeleasActualizadas(List<Pelea> nuevasPeleas) {
    return Ronda(
      id: id,
      numero: numero,
      peleas: nuevasPeleas,
      sinCotejo: sinCotejo,
      estado: estado,
      fechaGeneracion: fechaGeneracion,
      bloqueada: bloqueada,
    );
  }

  /// Bloquea la ronda para evitar modificaciones.
  Ronda bloquear() {
    return Ronda(
      id: id,
      numero: numero,
      peleas: peleas,
      sinCotejo: sinCotejo,
      estado: estado,
      fechaGeneracion: fechaGeneracion,
      bloqueada: true,
    );
  }

  /// Crea una copia de la ronda con los campos especificados modificados.
  Ronda copyWith({
    String? id,
    int? numero,
    List<Pelea>? peleas,
    List<String>? sinCotejo,
    EstadoRonda? estado,
    DateTime? fechaGeneracion,
    bool? bloqueada,
  }) {
    return Ronda(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      peleas: peleas ?? this.peleas,
      sinCotejo: sinCotejo ?? this.sinCotejo,
      estado: estado ?? this.estado,
      fechaGeneracion: fechaGeneracion ?? this.fechaGeneracion,
      bloqueada: bloqueada ?? this.bloqueada,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ronda && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Ronda(numero: $numero, peleas: ${peleas.length}, sinCotejo: ${sinCotejo.length})';
}

/// Estados posibles de una ronda.
enum EstadoRonda {
  /// Ronda generada pero no iniciada.
  generada,

  /// Ronda en progreso (algunas peleas finalizadas).
  enProgreso,

  /// Todas las peleas de la ronda finalizadas.
  finalizada,
}
