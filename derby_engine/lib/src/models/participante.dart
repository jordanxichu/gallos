/// Representa un participante (criador/equipo) en el derbi.
///
/// Un participante puede inscribir múltiples gallos y puede tener
/// relaciones de "compadrazgo" con otros participantes, lo que impide
/// que sus gallos se enfrenten entre sí.
class Participante {
  /// Identificador único del participante.
  final String id;

  /// Nombre del participante o equipo.
  final String nombre;

  /// Teléfono de contacto (opcional).
  final String? telefono;

  /// Nombre del equipo o rancho (opcional).
  final String? equipo;

  /// Lista de IDs de participantes que son "compadres".
  /// Los gallos de compadres no deben enfrentarse.
  final List<String> compadres;

  /// Puntos totales acumulados en el derbi.
  int puntosTotales;

  /// Número de peleas ganadas.
  int peleasGanadas;

  /// Número de peleas empatadas.
  int peleasEmpatadas;

  /// Número de peleas perdidas.
  int peleasPerdidas;

  Participante({
    required this.id,
    required this.nombre,
    this.telefono,
    this.equipo,
    List<String>? compadres,
    this.puntosTotales = 0,
    this.peleasGanadas = 0,
    this.peleasEmpatadas = 0,
    this.peleasPerdidas = 0,
  }) : compadres = compadres ?? [];

  /// Verifica si otro participante es compadre.
  bool esCompadreDe(String otroParticipanteId) {
    return compadres.contains(otroParticipanteId);
  }

  /// Agrega un compadre a la lista.
  void agregarCompadre(String participanteId) {
    if (!compadres.contains(participanteId)) {
      compadres.add(participanteId);
    }
  }

  /// Total de peleas jugadas.
  int get totalPeleas => peleasGanadas + peleasEmpatadas + peleasPerdidas;

  /// Crea una copia del participante con los campos especificados modificados.
  Participante copyWith({
    String? id,
    String? nombre,
    String? telefono,
    String? equipo,
    List<String>? compadres,
    int? puntosTotales,
    int? peleasGanadas,
    int? peleasEmpatadas,
    int? peleasPerdidas,
  }) {
    return Participante(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      equipo: equipo ?? this.equipo,
      compadres: compadres ?? List.from(this.compadres),
      puntosTotales: puntosTotales ?? this.puntosTotales,
      peleasGanadas: peleasGanadas ?? this.peleasGanadas,
      peleasEmpatadas: peleasEmpatadas ?? this.peleasEmpatadas,
      peleasPerdidas: peleasPerdidas ?? this.peleasPerdidas,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Participante &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Participante(id: $id, nombre: $nombre, puntos: $puntosTotales)';
}
