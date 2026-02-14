import '../models/models.dart';
import 'validators.dart';

/// Algoritmo de emparejamiento para generar rondas de peleas.
///
/// Implementa una estrategia Greedy ordenada con heurística de
/// candidatos restrictivos para maximizar el número de peleas válidas.
class MatchingAlgorithm {
  final ConfiguracionDerby configuracion;
  final List<Participante> participantes;
  final MatchingValidators _validators;

  MatchingAlgorithm({required this.configuracion, required this.participantes})
    : _validators = MatchingValidators(
        configuracion: configuracion,
        participantes: participantes,
      );

  /// Genera una ronda de emparejamientos.
  ///
  /// Retorna un [ResultadoEmparejamiento] con las peleas generadas
  /// y los gallos que quedaron sin cotejo.
  ResultadoEmparejamiento generarRonda({
    required List<Gallo> gallos,
    required Set<String> historial,
    required int numeroRonda,
  }) {
    // Filtrar solo gallos activos
    final gallosActivos = gallos
        .where((g) => g.estado == EstadoGallo.activo)
        .toList();

    if (gallosActivos.isEmpty) {
      return ResultadoEmparejamiento(
        peleas: [],
        sinCotejo: [],
        numeroRonda: numeroRonda,
      );
    }

    // 1️⃣ Ordenar gallos por peso ascendente
    gallosActivos.sort((a, b) => a.peso.compareTo(b.peso));

    // 2️⃣ Construir mapa de candidatos válidos para cada gallo
    final candidatos = _construirMapaCandidatos(gallosActivos, historial);

    // 3️⃣ Ordenar gallos por cantidad de candidatos (heurística: menos opciones primero)
    final gallosOrdenados = List<Gallo>.from(gallosActivos);
    gallosOrdenados.sort((a, b) {
      final candidatosA = candidatos[a.id]?.length ?? 0;
      final candidatosB = candidatos[b.id]?.length ?? 0;
      return candidatosA.compareTo(candidatosB);
    });

    // 4️⃣ Emparejamiento greedy controlado
    final usados = <String>{};
    final peleas = <Pelea>[];
    var numeroPelea = 1;

    for (final gallo in gallosOrdenados) {
      if (usados.contains(gallo.id)) continue;

      final posibles = candidatos[gallo.id] ?? [];

      // Filtrar candidatos ya usados y ordenar por score combinado
      final candidatosDisponibles = posibles
          .where((rival) => !usados.contains(rival.id))
          .toList();

      // Heurística: penalizar rivales con pocos candidatos propios
      // score = diferenciaPeso + (1 / candidatosDelRival)
      // Menor score = mejor candidato
      candidatosDisponibles.sort((a, b) {
        final diffA = (gallo.peso - a.peso).abs();
        final diffB = (gallo.peso - b.peso).abs();

        // Penalización por escasez de opciones del rival
        final candidatosA = candidatos[a.id]?.length ?? 1;
        final candidatosB = candidatos[b.id]?.length ?? 1;
        final penalizacionA = 10.0 / candidatosA; // 10 es factor de escala
        final penalizacionB = 10.0 / candidatosB;

        final scoreA = diffA + penalizacionA;
        final scoreB = diffB + penalizacionB;

        return scoreA.compareTo(scoreB);
      });

      // Tomar el mejor candidato disponible
      if (candidatosDisponibles.isNotEmpty) {
        final rival = candidatosDisponibles.first;

        peleas.add(
          Pelea(
            id: 'r${numeroRonda}_p$numeroPelea',
            numero: numeroPelea,
            galloRojoId: gallo.id,
            galloVerdeId: rival.id,
          ),
        );

        usados.add(gallo.id);
        usados.add(rival.id);
        numeroPelea++;
      }
    }

    // 5️⃣ Detectar gallos sin cotejo
    final sinCotejo = gallosActivos
        .where((g) => !usados.contains(g.id))
        .map((g) => g.id)
        .toList();

    return ResultadoEmparejamiento(
      peleas: peleas,
      sinCotejo: sinCotejo,
      numeroRonda: numeroRonda,
    );
  }

  /// Construye un mapa de candidatos válidos para cada gallo.
  Map<String, List<Gallo>> _construirMapaCandidatos(
    List<Gallo> gallos,
    Set<String> historial,
  ) {
    final candidatos = <String, List<Gallo>>{};

    for (final g1 in gallos) {
      candidatos[g1.id] = [];

      for (final g2 in gallos) {
        if (_validators.emparejamientoValido(g1, g2, historial)) {
          candidatos[g1.id]!.add(g2);
        }
      }
    }

    return candidatos;
  }

  /// Intenta optimizar emparejamientos con backtracking ligero.
  ///
  /// Si hay muchos sin cotejo, intenta reacomodar algunos emparejamientos
  /// para liberar opciones.
  ResultadoEmparejamiento generarRondaOptimizada({
    required List<Gallo> gallos,
    required Set<String> historial,
    required int numeroRonda,
    int intentosMaximos = 3,
  }) {
    var mejorResultado = generarRonda(
      gallos: gallos,
      historial: historial,
      numeroRonda: numeroRonda,
    );

    // Si no hay sin cotejo, ya es óptimo
    if (mejorResultado.sinCotejo.isEmpty) {
      return mejorResultado;
    }

    // Intentar diferentes ordenamientos
    for (var intento = 0; intento < intentosMaximos; intento++) {
      // Crear lista con ordenamiento aleatorio parcial
      final gallosMezclados = List<Gallo>.from(gallos);
      _mezclarParcial(gallosMezclados, intento);

      final resultado = generarRonda(
        gallos: gallosMezclados,
        historial: historial,
        numeroRonda: numeroRonda,
      );

      // Conservar el mejor resultado (menos sin cotejo)
      if (resultado.sinCotejo.length < mejorResultado.sinCotejo.length) {
        mejorResultado = resultado;

        // Si es perfecto, terminar
        if (mejorResultado.sinCotejo.isEmpty) break;
      }
    }

    return mejorResultado;
  }

  /// Mezcla parcial de la lista para explorar diferentes ordenamientos.
  void _mezclarParcial(List<Gallo> gallos, int seed) {
    // Intercambiar elementos basándose en el seed
    for (var i = 0; i < gallos.length ~/ 3; i++) {
      final j = (i + seed + 1) % gallos.length;
      final temp = gallos[i];
      gallos[i] = gallos[j];
      gallos[j] = temp;
    }
  }
}

/// Resultado del algoritmo de emparejamiento para una ronda.
class ResultadoEmparejamiento {
  /// Lista de peleas generadas.
  final List<Pelea> peleas;

  /// IDs de gallos que quedaron sin cotejo.
  final List<String> sinCotejo;

  /// Número de la ronda.
  final int numeroRonda;

  const ResultadoEmparejamiento({
    required this.peleas,
    required this.sinCotejo,
    required this.numeroRonda,
  });

  /// Número de peleas generadas.
  int get totalPeleas => peleas.length;

  /// Número de gallos sin cotejo.
  int get totalSinCotejo => sinCotejo.length;

  /// Porcentaje de emparejamiento exitoso.
  double get porcentajeExito {
    final totalGallos = (peleas.length * 2) + sinCotejo.length;
    if (totalGallos == 0) return 100.0;
    return (peleas.length * 2 / totalGallos) * 100;
  }

  /// Indica si la ronda está completa (sin gallos sin cotejo).
  bool get esCompleta => sinCotejo.isEmpty;

  @override
  String toString() =>
      'Ronda $numeroRonda: ${peleas.length} peleas, ${sinCotejo.length} sin cotejo';
}
