/// Configuración del derbi.
///
/// Define todas las reglas y parámetros que controlan
/// el comportamiento del algoritmo de emparejamiento.
class ConfiguracionDerby {
  /// Tolerancia máxima de diferencia de peso en gramos.
  /// Ejemplo: 80 significa que dos gallos pueden pelear
  /// si su diferencia de peso es ≤ 80 gramos.
  final double toleranciaPeso;

  /// Peso mínimo permitido para inscripción (en gramos).
  final double pesoMinimo;

  /// Peso máximo permitido para inscripción (en gramos).
  final double pesoMaximo;

  /// Número de rondas a generar.
  final int numeroRondas;

  /// Puntos otorgados por victoria.
  final int puntosVictoria;

  /// Puntos otorgados por empate (tablas).
  final int puntosEmpate;

  /// Puntos otorgados por derrota.
  final int puntosDerrota;

  /// Si es true, evita enfrentamientos entre compadres.
  final bool evitarCompadres;

  /// Si es true, intenta balancear asignaciones rojo/verde.
  final bool balancearLados;

  /// Número de gallos que cada participante debe inscribir.
  final int gallosPorParticipante;

  /// Prefijo para generar anillos automáticamente.
  final String prefijoAnillo;

  /// Número de dígitos para los anillos.
  final int digitosAnillo;

  const ConfiguracionDerby({
    this.toleranciaPeso = 80.0,
    this.pesoMinimo = 1800.0,
    this.pesoMaximo = 2500.0,
    this.numeroRondas = 3,
    this.puntosVictoria = 3,
    this.puntosEmpate = 1,
    this.puntosDerrota = 0,
    this.evitarCompadres = true,
    this.balancearLados = false,
    this.gallosPorParticipante = 5,
    this.prefijoAnillo = '',
    this.digitosAnillo = 3,
  });

  /// Configuración por defecto para derbys estándar.
  factory ConfiguracionDerby.standard() {
    return const ConfiguracionDerby();
  }

  /// Configuración para derbys con tolerancia estricta.
  factory ConfiguracionDerby.estricta() {
    return const ConfiguracionDerby(
      toleranciaPeso: 50.0,
      evitarCompadres: true,
      balancearLados: true,
    );
  }

  /// Verifica si un peso está dentro del rango permitido.
  bool pesoEnRango(double peso) {
    return peso >= pesoMinimo && peso <= pesoMaximo;
  }

  /// Verifica si dos pesos están dentro de la tolerancia.
  bool pesosCompatibles(double peso1, double peso2) {
    return (peso1 - peso2).abs() <= toleranciaPeso;
  }

  /// Crea una copia de la configuración con los campos especificados modificados.
  ConfiguracionDerby copyWith({
    double? toleranciaPeso,
    double? pesoMinimo,
    double? pesoMaximo,
    int? numeroRondas,
    int? puntosVictoria,
    int? puntosEmpate,
    int? puntosDerrota,
    bool? evitarCompadres,
    bool? balancearLados,
    int? gallosPorParticipante,
    String? prefijoAnillo,
    int? digitosAnillo,
  }) {
    return ConfiguracionDerby(
      toleranciaPeso: toleranciaPeso ?? this.toleranciaPeso,
      pesoMinimo: pesoMinimo ?? this.pesoMinimo,
      pesoMaximo: pesoMaximo ?? this.pesoMaximo,
      numeroRondas: numeroRondas ?? this.numeroRondas,
      puntosVictoria: puntosVictoria ?? this.puntosVictoria,
      puntosEmpate: puntosEmpate ?? this.puntosEmpate,
      puntosDerrota: puntosDerrota ?? this.puntosDerrota,
      evitarCompadres: evitarCompadres ?? this.evitarCompadres,
      balancearLados: balancearLados ?? this.balancearLados,
      gallosPorParticipante:
          gallosPorParticipante ?? this.gallosPorParticipante,
      prefijoAnillo: prefijoAnillo ?? this.prefijoAnillo,
      digitosAnillo: digitosAnillo ?? this.digitosAnillo,
    );
  }

  @override
  String toString() =>
      'ConfiguracionDerby(tolerancia: $toleranciaPeso, rondas: $numeroRondas)';
}
