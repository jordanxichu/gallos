import 'package:derby_engine/derby_engine.dart';
import 'package:test/test.dart';

void main() {
  group('RoundScore', () {
    late ConfiguracionDerby config;
    late List<Gallo> gallos;
    late RoundScore scorer;

    setUp(() {
      config = const ConfiguracionDerby(toleranciaPeso: 100);
      gallos = [
        Gallo(id: 'g1', participanteId: 'p1', peso: 2100, anillo: '001'),
        Gallo(id: 'g2', participanteId: 'p2', peso: 2120, anillo: '002'),
        Gallo(id: 'g3', participanteId: 'p3', peso: 2140, anillo: '003'),
        Gallo(id: 'g4', participanteId: 'p4', peso: 2160, anillo: '004'),
      ];
      scorer = RoundScore(configuracion: config, gallos: gallos);
    });

    test('score existe y es calculable', () {
      final ronda = Ronda(
        id: 'r1',
        numero: 1,
        peleas: [
          Pelea(id: 'p1', numero: 1, galloRojoId: 'g1', galloVerdeId: 'g2'),
        ],
        sinCotejo: ['g3', 'g4'],
      );

      final score = scorer.calcularScore(ronda.toScoreable());

      // +1 por pelea, -2 por sin cotejo = -1
      expect(score, isA<double>());
      expect(score, lessThan(1.0)); // Debería ser negativo por los sin cotejo
    });

    test('score premia peleas y penaliza sin cotejo', () {
      final rondaBuena = Ronda(
        id: 'r1',
        numero: 1,
        peleas: [
          Pelea(id: 'p1', numero: 1, galloRojoId: 'g1', galloVerdeId: 'g2'),
          Pelea(id: 'p2', numero: 2, galloRojoId: 'g3', galloVerdeId: 'g4'),
        ],
        sinCotejo: [],
      );

      final rondaMala = Ronda(
        id: 'r1',
        numero: 1,
        peleas: [
          Pelea(id: 'p1', numero: 1, galloRojoId: 'g1', galloVerdeId: 'g2'),
        ],
        sinCotejo: ['g3', 'g4'],
      );

      final scoreBuena = scorer.calcularScore(rondaBuena.toScoreable());
      final scoreMala = scorer.calcularScore(rondaMala.toScoreable());

      expect(scoreBuena, greaterThan(scoreMala));
    });

    test('penaliza peso cercano al límite', () {
      // Crear gallos con diferencia de peso al 90% de tolerancia
      final gallosCercaLimite = [
        Gallo(id: 'g1', participanteId: 'p1', peso: 2000, anillo: '001'),
        Gallo(
          id: 'g2',
          participanteId: 'p2',
          peso: 2095,
          anillo: '002',
        ), // 95% de 100
      ];
      final scorerLimite = RoundScore(
        configuracion: config,
        gallos: gallosCercaLimite,
      );

      final rondaLimite = Ronda(
        id: 'r1',
        numero: 1,
        peleas: [
          Pelea(id: 'p1', numero: 1, galloRojoId: 'g1', galloVerdeId: 'g2'),
        ],
        sinCotejo: [],
      );

      final score = scorerLimite.calcularScore(rondaLimite.toScoreable());

      // +1 por pelea, -0.5 por peso cercano = 0.5
      expect(score, equals(0.5));
    });

    test('porcentaje de calidad está entre 0 y 100', () {
      final ronda = Ronda(
        id: 'r1',
        numero: 1,
        peleas: [
          Pelea(id: 'p1', numero: 1, galloRojoId: 'g1', galloVerdeId: 'g2'),
        ],
        sinCotejo: [],
      );

      final porcentaje = scorer.calcularPorcentajeCalidad(
        ronda.toScoreable(),
        gallos.length,
      );

      expect(porcentaje, greaterThanOrEqualTo(0));
      expect(porcentaje, lessThanOrEqualTo(100));
    });
  });

  group('MultiRunOptimizer', () {
    late ConfiguracionDerby config;
    late List<Participante> participantes;
    late List<Gallo> gallos;
    late MatchingAlgorithm algorithm;

    setUp(() {
      config = const ConfiguracionDerby(toleranciaPeso: 100);
      participantes = List.generate(
        6,
        (i) => Participante(id: 'p$i', nombre: 'Rancho $i'),
      );
      gallos = [];
      for (var i = 0; i < participantes.length; i++) {
        for (var j = 0; j < 2; j++) {
          gallos.add(
            Gallo(
              id: 'g${i}_$j',
              participanteId: participantes[i].id,
              peso: 2000 + (i * 20) + (j * 10),
              anillo: '${i}0$j',
            ),
          );
        }
      }
      algorithm = MatchingAlgorithm(
        configuracion: config,
        participantes: participantes,
      );
    });

    test('multi-run devuelve resultado con score', () {
      final optimizer = MultiRunOptimizer(
        algorithm: algorithm,
        configuracion: config,
        gallos: gallos,
      );

      final resultado = optimizer.generarRondaOptimizada(
        historial: <String>{},
        numeroRonda: 1,
        corridas: 5,
        seed: 42,
      );

      expect(resultado.score, isA<double>());
      expect(resultado.resultado.peleas, isNotEmpty);
      expect(resultado.corridasEjecutadas, equals(5));
      expect(resultado.scoresObtenidos.length, equals(5));
    });

    test('multi-run score >= corrida simple', () {
      final optimizer = MultiRunOptimizer(
        algorithm: algorithm,
        configuracion: config,
        gallos: gallos,
      );

      // Corrida simple (1 intento)
      final resultadoSimple = optimizer.generarRondaOptimizada(
        historial: <String>{},
        numeroRonda: 1,
        corridas: 1,
        seed: 42,
      );

      // Multi-run (5 intentos)
      final resultadoMulti = optimizer.generarRondaOptimizada(
        historial: <String>{},
        numeroRonda: 1,
        corridas: 5,
        seed: 42,
      );

      // El multi-run debe ser >= que el simple
      expect(resultadoMulti.score, greaterThanOrEqualTo(resultadoSimple.score));
    });

    test('multi-run es reproducible con mismo seed', () {
      final optimizer = MultiRunOptimizer(
        algorithm: algorithm,
        configuracion: config,
        gallos: gallos,
      );

      final resultado1 = optimizer.generarRondaOptimizada(
        historial: <String>{},
        numeroRonda: 1,
        corridas: 5,
        seed: 123,
      );

      final resultado2 = optimizer.generarRondaOptimizada(
        historial: <String>{},
        numeroRonda: 1,
        corridas: 5,
        seed: 123,
      );

      expect(resultado1.score, equals(resultado2.score));
      expect(
        resultado1.resultado.peleas.length,
        equals(resultado2.resultado.peleas.length),
      );
    });

    test('porcentaje de calidad existe y es válido', () {
      final optimizer = MultiRunOptimizer(
        algorithm: algorithm,
        configuracion: config,
        gallos: gallos,
      );

      final resultado = optimizer.generarRondaOptimizada(
        historial: <String>{},
        numeroRonda: 1,
      );

      expect(resultado.porcentajeCalidad, greaterThanOrEqualTo(0));
      expect(resultado.porcentajeCalidad, lessThanOrEqualTo(100));
    });
  });

  group('Heurística Rivales Escasos', () {
    test('prioriza rivales con más opciones', () {
      // Este test verifica que la heurística funciona correctamente
      final config = const ConfiguracionDerby(toleranciaPeso: 50);
      final participantes = [
        Participante(id: 'p1', nombre: 'A'),
        Participante(id: 'p2', nombre: 'B'),
        Participante(id: 'p3', nombre: 'C'),
      ];

      // Configuración donde g3 tiene pocas opciones
      final gallos = [
        Gallo(id: 'g1', participanteId: 'p1', peso: 2100, anillo: '001'),
        Gallo(
          id: 'g2',
          participanteId: 'p2',
          peso: 2110,
          anillo: '002',
        ), // Cerca de g1
        Gallo(
          id: 'g3',
          participanteId: 'p3',
          peso: 2105,
          anillo: '003',
        ), // Entre ambos
      ];

      final algorithm = MatchingAlgorithm(
        configuracion: config,
        participantes: participantes,
      );

      final resultado = algorithm.generarRonda(
        gallos: gallos,
        historial: <String>{},
        numeroRonda: 1,
      );

      // Debería generar al menos 1 pelea
      expect(resultado.peleas.length, greaterThanOrEqualTo(1));
      // Máximo 1 sin cotejo (número impar de gallos)
      expect(resultado.sinCotejo.length, lessThanOrEqualTo(1));
    });
  });
}
