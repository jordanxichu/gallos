import 'dart:math';

import '../models/models.dart';
import 'matching_algorithm.dart';
import 'round_score.dart';

/// Optimizador que ejecuta múltiples corridas del algoritmo de emparejamiento
/// y selecciona la mejor según el score de calidad.
///
/// NO modifica el algoritmo base, solo lo ejecuta varias veces con
/// diferentes ordenamientos de gallos y elige el mejor resultado.
class MultiRunOptimizer {
  final MatchingAlgorithm _algorithm;
  final ConfiguracionDerby _configuracion;
  final List<Gallo> _gallosBase;

  /// Número de corridas por defecto.
  static const int corridasDefault = 5;

  MultiRunOptimizer({
    required MatchingAlgorithm algorithm,
    required ConfiguracionDerby configuracion,
    required List<Gallo> gallos,
  }) : _algorithm = algorithm,
       _configuracion = configuracion,
       _gallosBase = gallos;

  /// Genera una ronda optimizada ejecutando múltiples corridas.
  ///
  /// Parámetros:
  /// - [historial]: Set de enfrentamientos previos
  /// - [numeroRonda]: Número de la ronda a generar
  /// - [corridas]: Número de corridas a ejecutar (default: 5)
  /// - [seed]: Semilla para reproducibilidad (opcional)
  ///
  /// Retorna el [ResultadoEmparejamiento] con mayor score.
  ResultadoMultiRun generarRondaOptimizada({
    required Set<String> historial,
    required int numeroRonda,
    int corridas = corridasDefault,
    int? seed,
  }) {
    final random = Random(seed);
    final scorer = RoundScore(
      configuracion: _configuracion,
      gallos: _gallosBase,
    );

    ResultadoEmparejamiento? mejorResultado;
    double mejorScore = double.negativeInfinity;
    final scoresObtenidos = <double>[];

    for (var i = 0; i < corridas; i++) {
      // Crear lista con shuffle controlado
      final gallosShuffled = _shuffleControlado(
        List<Gallo>.from(_gallosBase),
        random,
        intensidad: i, // Primera corrida sin shuffle, luego incrementa
      );

      // Ejecutar algoritmo base
      final resultado = _algorithm.generarRonda(
        gallos: gallosShuffled,
        historial: historial,
        numeroRonda: numeroRonda,
      );

      // Calcular score
      final score = scorer.calcularScore(_ResultadoScoreableAdapter(resultado));
      scoresObtenidos.add(score);

      // Conservar el mejor (en empate, mantener el primero)
      if (mejorResultado == null || score > mejorScore) {
        mejorResultado = resultado;
        mejorScore = score;
      }
    }

    return ResultadoMultiRun(
      resultado: mejorResultado!,
      score: mejorScore,
      corridasEjecutadas: corridas,
      scoresObtenidos: scoresObtenidos,
      porcentajeCalidad: scorer.calcularPorcentajeCalidad(
        _ResultadoScoreableAdapter(mejorResultado),
        _gallosBase.length,
      ),
    );
  }

  /// Shuffle controlado que mantiene reproducibilidad.
  ///
  /// La intensidad controla cuánto se mezcla:
  /// - 0: Sin mezcla (orden original)
  /// - 1+: Intercambios progresivos
  List<Gallo> _shuffleControlado(
    List<Gallo> gallos,
    Random random, {
    required int intensidad,
  }) {
    if (intensidad == 0) return gallos;

    // Número de intercambios basado en intensidad
    final numIntercambios = (gallos.length * intensidad * 0.1).ceil().clamp(
      1,
      gallos.length,
    );

    for (var i = 0; i < numIntercambios; i++) {
      final a = random.nextInt(gallos.length);
      final b = random.nextInt(gallos.length);
      if (a != b) {
        final temp = gallos[a];
        gallos[a] = gallos[b];
        gallos[b] = temp;
      }
    }

    return gallos;
  }
}

/// Adaptador para hacer ResultadoEmparejamiento compatible con RoundScore.
class _ResultadoScoreableAdapter implements ResultadoRondaScoreable {
  final ResultadoEmparejamiento _resultado;
  _ResultadoScoreableAdapter(this._resultado);

  @override
  List<Pelea> get peleas => _resultado.peleas;

  @override
  List<String> get sinCotejo => _resultado.sinCotejo;
}

/// Resultado del optimizador multi-run.
class ResultadoMultiRun {
  /// Mejor resultado obtenido.
  final ResultadoEmparejamiento resultado;

  /// Score del mejor resultado.
  final double score;

  /// Número de corridas ejecutadas.
  final int corridasEjecutadas;

  /// Scores de todas las corridas (para análisis).
  final List<double> scoresObtenidos;

  /// Porcentaje de calidad (0-100).
  final double porcentajeCalidad;

  const ResultadoMultiRun({
    required this.resultado,
    required this.score,
    required this.corridasEjecutadas,
    required this.scoresObtenidos,
    required this.porcentajeCalidad,
  });

  /// Score promedio de todas las corridas.
  double get scorePromedio => scoresObtenidos.isEmpty
      ? 0
      : scoresObtenidos.reduce((a, b) => a + b) / scoresObtenidos.length;

  /// Mejora obtenida vs la primera corrida.
  double get mejoraVsPrimera =>
      scoresObtenidos.isEmpty ? 0 : score - scoresObtenidos.first;

  @override
  String toString() =>
      'MultiRun: score=$score, corridas=$corridasEjecutadas, '
      'calidad=${porcentajeCalidad.toStringAsFixed(1)}%, '
      'mejora=${mejoraVsPrimera.toStringAsFixed(2)}';
}
