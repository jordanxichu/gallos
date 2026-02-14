/// Representa una pelea entre dos gallos en el derbi.
///
/// Una pelea tiene un gallo en el lado rojo y otro en el lado verde,
/// siguiendo la nomenclatura tradicional de los palenques.
class Pelea {
  /// Identificador único de la pelea.
  final String id;

  /// Número de la pelea dentro de la ronda.
  final int numero;

  /// ID del gallo en el lado rojo.
  final String galloRojoId;

  /// ID del gallo en el lado verde.
  final String galloVerdeId;

  /// ID del gallo ganador (null si no ha terminado o empate).
  final String? ganadorId;

  /// Indica si la pelea terminó en empate (tablas).
  final bool empate;

  /// Estado actual de la pelea.
  final EstadoPelea estado;

  /// Tiempo de duración de la pelea en segundos (opcional).
  final int? duracionSegundos;

  /// Notas adicionales sobre la pelea.
  final String? notas;

  const Pelea({
    required this.id,
    required this.numero,
    required this.galloRojoId,
    required this.galloVerdeId,
    this.ganadorId,
    this.empate = false,
    this.estado = EstadoPelea.pendiente,
    this.duracionSegundos,
    this.notas,
  });

  /// Verifica si un gallo específico participó en esta pelea.
  bool participoGallo(String galloId) {
    return galloRojoId == galloId || galloVerdeId == galloId;
  }

  /// Obtiene el ID del oponente de un gallo en esta pelea.
  String? obtenerOponente(String galloId) {
    if (galloRojoId == galloId) return galloVerdeId;
    if (galloVerdeId == galloId) return galloRojoId;
    return null;
  }

  /// Verifica si la pelea ya tiene resultado.
  bool get tieneResultado => estado == EstadoPelea.finalizada;

  /// Registra el resultado de la pelea.
  Pelea conResultado({
    String? ganadorId,
    bool empate = false,
    int? duracionSegundos,
    String? notas,
  }) {
    return Pelea(
      id: id,
      numero: numero,
      galloRojoId: galloRojoId,
      galloVerdeId: galloVerdeId,
      ganadorId: ganadorId,
      empate: empate,
      estado: EstadoPelea.finalizada,
      duracionSegundos: duracionSegundos,
      notas: notas,
    );
  }

  /// Crea una copia de la pelea con los campos especificados modificados.
  Pelea copyWith({
    String? id,
    int? numero,
    String? galloRojoId,
    String? galloVerdeId,
    String? ganadorId,
    bool? empate,
    EstadoPelea? estado,
    int? duracionSegundos,
    String? notas,
  }) {
    return Pelea(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      galloRojoId: galloRojoId ?? this.galloRojoId,
      galloVerdeId: galloVerdeId ?? this.galloVerdeId,
      ganadorId: ganadorId ?? this.ganadorId,
      empate: empate ?? this.empate,
      estado: estado ?? this.estado,
      duracionSegundos: duracionSegundos ?? this.duracionSegundos,
      notas: notas ?? this.notas,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pelea && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Pelea(id: $id, rojo: $galloRojoId vs verde: $galloVerdeId, estado: $estado)';
}

/// Estados posibles de una pelea.
enum EstadoPelea {
  /// Pelea programada pero no iniciada.
  pendiente,

  /// Pelea en curso.
  enCurso,

  /// Pelea finalizada con resultado.
  finalizada,

  /// Pelea cancelada.
  cancelada,
}
