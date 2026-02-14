import '../models/models.dart';

/// Sistema de puntuación para evaluar la calidad de una ronda.
///
/// El score permite comparar diferentes generaciones de la misma ronda
/// y elegir la mejor sin modificar las reglas de emparejamiento.
class RoundScore {
  /// Puntos otorgados por cada pelea válida generada.
  static const double puntosPerPelea = 1.0;

  /// Puntos restados por cada gallo sin cotejo.
  static const double penalizacionSinCotejo = -1.0;

  /// Puntos restados cuando la diferencia de peso supera el 80% de tolerancia.
  static const double penalizacionPesoCercanoLimite = -0.5;

  /// Umbral (80%) para considerar que el peso está cerca del límite.
  static const double umbralPesoLimite = 0.8;

  final ConfiguracionDerby _configuracion;
  final Map<String, Gallo> _gallosMap;

  RoundScore({
    required ConfiguracionDerby configuracion,
    required List<Gallo> gallos,
  }) : _configuracion = configuracion,
       _gallosMap = {for (var g in gallos) g.id: g};

  /// Calcula el score de una ronda.
  ///
  /// Reglas:
  /// - +1 punto por cada pelea válida
  /// - -1 punto por cada gallo sin cotejo
  /// - -0.5 puntos si diferencia de peso > 80% de tolerancia
  double calcularScore(ResultadoRondaScoreable ronda) {
    var score = 0.0;

    // +1 por cada pelea
    score += ronda.peleas.length * puntosPerPelea;

    // -1 por cada sin cotejo
    score += ronda.sinCotejo.length * penalizacionSinCotejo;

    // -0.5 por peleas con peso cercano al límite
    for (final pelea in ronda.peleas) {
      final galloRojo = _gallosMap[pelea.galloRojoId];
      final galloVerde = _gallosMap[pelea.galloVerdeId];

      if (galloRojo != null && galloVerde != null) {
        final diffPeso = (galloRojo.peso - galloVerde.peso).abs();
        final umbral = _configuracion.toleranciaPeso * umbralPesoLimite;

        if (diffPeso > umbral) {
          score += penalizacionPesoCercanoLimite;
        }
      }
    }

    return score;
  }

  /// Calcula el score máximo teórico para una cantidad de gallos.
  double calcularScoreMaximoTeorico(int totalGallos) {
    // Máximo peleas posibles = totalGallos / 2
    return (totalGallos ~/ 2) * puntosPerPelea;
  }

  /// Calcula el porcentaje de calidad (0-100).
  double calcularPorcentajeCalidad(
    ResultadoRondaScoreable ronda,
    int totalGallos,
  ) {
    final score = calcularScore(ronda);
    final maximo = calcularScoreMaximoTeorico(totalGallos);
    if (maximo <= 0) return 100.0;
    return (score / maximo * 100).clamp(0.0, 100.0);
  }
}

/// Interfaz abstracta para resultados que pueden ser puntuados.
///
/// Permite que tanto Ronda como ResultadoEmparejamiento sean evaluados.
abstract class ResultadoRondaScoreable {
  List<Pelea> get peleas;
  List<String> get sinCotejo;
}

/// Extensión para hacer Ronda compatible con el sistema de scoring.
extension RondaScoreable on Ronda {
  ResultadoRondaScoreable toScoreable() => _RondaScoreableAdapter(this);
}

class _RondaScoreableAdapter implements ResultadoRondaScoreable {
  final Ronda _ronda;
  _RondaScoreableAdapter(this._ronda);

  @override
  List<Pelea> get peleas => _ronda.peleas;

  @override
  List<String> get sinCotejo => _ronda.sinCotejo;
}

/// Resultado de ronda con score calculado.
class RondaConScore {
  final Ronda ronda;
  final double score;
  final double porcentajeCalidad;

  const RondaConScore({
    required this.ronda,
    required this.score,
    required this.porcentajeCalidad,
  });

  @override
  String toString() =>
      'Ronda ${ronda.numero}: score=$score (${porcentajeCalidad.toStringAsFixed(1)}%)';
}
