import '../models/models.dart';
import 'matching_algorithm.dart';
import 'validators.dart';

/// Generador de rondas múltiples para un derbi.
///
/// Maneja el historial acumulativo de enfrentamientos y genera
/// todas las rondas configuradas respetando las restricciones.
class RoundGenerator {
  final ConfiguracionDerby configuracion;
  final List<Participante> participantes;
  final MatchingAlgorithm _algorithm;

  RoundGenerator({required this.configuracion, required this.participantes})
    : _algorithm = MatchingAlgorithm(
        configuracion: configuracion,
        participantes: participantes,
      );

  /// Genera múltiples rondas para el derbi.
  ///
  /// Retorna un [ResultadoGeneracion] con todas las rondas generadas
  /// y estadísticas del proceso.
  ResultadoGeneracion generarRondas({
    required List<Gallo> gallos,
    int? numeroRondas,
    bool optimizar = true,
  }) {
    final rondasAGenerar = numeroRondas ?? configuracion.numeroRondas;
    final historial = <String>{};
    final rondas = <Ronda>[];
    final estadisticasPorRonda = <EstadisticasRonda>[];

    for (var i = 1; i <= rondasAGenerar; i++) {
      // Generar ronda
      final resultado = optimizar
          ? _algorithm.generarRondaOptimizada(
              gallos: gallos,
              historial: historial,
              numeroRonda: i,
            )
          : _algorithm.generarRonda(
              gallos: gallos,
              historial: historial,
              numeroRonda: i,
            );

      // Crear objeto Ronda
      final ronda = Ronda(
        id: 'ronda_$i',
        numero: i,
        peleas: resultado.peleas,
        sinCotejo: resultado.sinCotejo,
        fechaGeneracion: DateTime.now(),
      );

      rondas.add(ronda);

      // Actualizar historial con los emparejamientos
      for (final pelea in resultado.peleas) {
        historial.add(
          MatchingValidators.normalizarPar(
            pelea.galloRojoId,
            pelea.galloVerdeId,
          ),
        );
      }

      // Registrar estadísticas
      estadisticasPorRonda.add(
        EstadisticasRonda(
          numeroRonda: i,
          totalPeleas: resultado.totalPeleas,
          sinCotejo: resultado.totalSinCotejo,
          porcentajeExito: resultado.porcentajeExito,
        ),
      );
    }

    return ResultadoGeneracion(
      rondas: rondas,
      estadisticas: estadisticasPorRonda,
      totalGallos: gallos.length,
      configuracion: configuracion,
    );
  }

  /// Genera una sola ronda adicional dado un historial existente.
  Ronda generarRondaAdicional({
    required List<Gallo> gallos,
    required List<Ronda> rondasPrevias,
    bool optimizar = true,
  }) {
    // Reconstruir historial desde rondas previas
    final historial = <String>{};
    for (final ronda in rondasPrevias) {
      for (final pelea in ronda.peleas) {
        historial.add(
          MatchingValidators.normalizarPar(
            pelea.galloRojoId,
            pelea.galloVerdeId,
          ),
        );
      }
    }

    final numeroRonda = rondasPrevias.length + 1;

    final resultado = optimizar
        ? _algorithm.generarRondaOptimizada(
            gallos: gallos,
            historial: historial,
            numeroRonda: numeroRonda,
          )
        : _algorithm.generarRonda(
            gallos: gallos,
            historial: historial,
            numeroRonda: numeroRonda,
          );

    return Ronda(
      id: 'ronda_$numeroRonda',
      numero: numeroRonda,
      peleas: resultado.peleas,
      sinCotejo: resultado.sinCotejo,
      fechaGeneracion: DateTime.now(),
    );
  }

  /// Valida que una lista de rondas no tenga conflictos.
  ResultadoValidacionRondas validarRondas(List<Ronda> rondas) {
    final errores = <String>[];
    final historial = <String>{};

    for (final ronda in rondas) {
      final gallosPorRonda = <String>{};

      for (final pelea in ronda.peleas) {
        // Verificar que cada gallo solo pelee una vez por ronda
        if (gallosPorRonda.contains(pelea.galloRojoId)) {
          errores.add(
            'Ronda ${ronda.numero}: Gallo ${pelea.galloRojoId} aparece más de una vez',
          );
        }
        if (gallosPorRonda.contains(pelea.galloVerdeId)) {
          errores.add(
            'Ronda ${ronda.numero}: Gallo ${pelea.galloVerdeId} aparece más de una vez',
          );
        }

        gallosPorRonda.add(pelea.galloRojoId);
        gallosPorRonda.add(pelea.galloVerdeId);

        // Verificar que no se repitan enfrentamientos
        final par = MatchingValidators.normalizarPar(
          pelea.galloRojoId,
          pelea.galloVerdeId,
        );

        if (historial.contains(par)) {
          errores.add('Ronda ${ronda.numero}: Enfrentamiento repetido $par');
        }

        historial.add(par);
      }
    }

    return ResultadoValidacionRondas(
      esValido: errores.isEmpty,
      errores: errores,
    );
  }
}

/// Resultado de la generación de múltiples rondas.
class ResultadoGeneracion {
  /// Lista de rondas generadas.
  final List<Ronda> rondas;

  /// Estadísticas por ronda.
  final List<EstadisticasRonda> estadisticas;

  /// Total de gallos considerados.
  final int totalGallos;

  /// Configuración utilizada.
  final ConfiguracionDerby configuracion;

  const ResultadoGeneracion({
    required this.rondas,
    required this.estadisticas,
    required this.totalGallos,
    required this.configuracion,
  });

  /// Número total de rondas generadas.
  int get totalRondas => rondas.length;

  /// Total de peleas en todas las rondas.
  int get totalPeleas => rondas.fold(0, (sum, r) => sum + r.totalPeleas);

  /// Promedio de porcentaje de éxito.
  double get promedioExito {
    if (estadisticas.isEmpty) return 0;
    return estadisticas.fold(0.0, (sum, e) => sum + e.porcentajeExito) /
        estadisticas.length;
  }

  /// Resumen textual del resultado.
  String get resumen {
    final buffer = StringBuffer();
    buffer.writeln('=== Resultado de Generación ===');
    buffer.writeln('Total gallos: $totalGallos');
    buffer.writeln('Rondas generadas: $totalRondas');
    buffer.writeln('Total peleas: $totalPeleas');
    buffer.writeln('Promedio éxito: ${promedioExito.toStringAsFixed(1)}%');
    buffer.writeln('');
    for (final e in estadisticas) {
      buffer.writeln(e.toString());
    }
    return buffer.toString();
  }

  @override
  String toString() => resumen;
}

/// Estadísticas de una ronda individual.
class EstadisticasRonda {
  final int numeroRonda;
  final int totalPeleas;
  final int sinCotejo;
  final double porcentajeExito;

  const EstadisticasRonda({
    required this.numeroRonda,
    required this.totalPeleas,
    required this.sinCotejo,
    required this.porcentajeExito,
  });

  @override
  String toString() =>
      'Ronda $numeroRonda: $totalPeleas peleas, $sinCotejo sin cotejo (${porcentajeExito.toStringAsFixed(1)}% éxito)';
}

/// Resultado de validación de rondas.
class ResultadoValidacionRondas {
  final bool esValido;
  final List<String> errores;

  const ResultadoValidacionRondas({
    required this.esValido,
    required this.errores,
  });

  @override
  String toString() => esValido ? 'Válido' : 'Inválido:\n${errores.join('\n')}';
}
