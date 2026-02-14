/// Representa un gallo inscrito en el derbi.
///
/// Cada gallo tiene un identificador único, pertenece a un participante,
/// tiene un peso registrado y un número de anillo para identificación física.
class Gallo {
  /// Identificador único del gallo en el sistema.
  final String id;

  /// ID del participante dueño del gallo.
  final String participanteId;

  /// Peso del gallo en gramos.
  final double peso;

  /// Número de anillo físico del gallo.
  final String anillo;

  /// Estado actual del gallo en el torneo.
  final EstadoGallo estado;

  const Gallo({
    required this.id,
    required this.participanteId,
    required this.peso,
    required this.anillo,
    this.estado = EstadoGallo.activo,
  });

  /// Crea una copia del gallo con los campos especificados modificados.
  Gallo copyWith({
    String? id,
    String? participanteId,
    double? peso,
    String? anillo,
    EstadoGallo? estado,
  }) {
    return Gallo(
      id: id ?? this.id,
      participanteId: participanteId ?? this.participanteId,
      peso: peso ?? this.peso,
      anillo: anillo ?? this.anillo,
      estado: estado ?? this.estado,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Gallo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Gallo(id: $id, participante: $participanteId, peso: $peso, anillo: $anillo)';
}

/// Estados posibles de un gallo en el torneo.
enum EstadoGallo {
  /// Gallo activo y disponible para pelear.
  activo,

  /// Gallo que ya completó sus peleas.
  finalizado,

  /// Gallo retirado del torneo.
  retirado,

  /// Gallo descalificado.
  descalificado,
}
