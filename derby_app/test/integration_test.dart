/// Tests de integración exhaustivos para Derby Manager
///
/// Esta suite cubre:
/// - Stress tests con 70+ gallos
/// - Escenarios de gallos (eliminar, retirar, descalificar)
/// - Escenarios de participantes
/// - Escenarios de sorteo y peleas
/// - Validación de integridad de datos
/// - Casos edge y errores
///
/// Ejecutar con: flutter test test/integration_test.dart -r expanded
library;

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:derby_engine/derby_engine.dart';

void main() {
  final random = Random(42);

  // ═══════════════════════════════════════════════════════════════════════════
  // UTILIDADES PARA GENERAR DATOS DE PRUEBA
  // ═══════════════════════════════════════════════════════════════════════════

  /// Genera un torneo aleatorio con los parámetros especificados
  ({
    List<Participante> participantes,
    List<Gallo> gallos,
    ConfiguracionDerby config,
  })
  generarTorneoAleatorio({
    required int numParticipantes,
    required int gallosPorParticipante,
    required int numeroRondas,
    double toleranciaPeso = 80,
    double probabilidadCompadres = 0.1,
  }) {
    final participantes = <Participante>[];
    for (var i = 0; i < numParticipantes; i++) {
      final compadres = <String>[];
      for (var j = 0; j < i; j++) {
        if (random.nextDouble() < probabilidadCompadres) {
          compadres.add('p$j');
        }
      }
      participantes.add(
        Participante(id: 'p$i', nombre: 'Rancho $i', compadres: compadres),
      );
    }

    final gallos = <Gallo>[];
    for (var i = 0; i < numParticipantes; i++) {
      for (var j = 0; j < gallosPorParticipante; j++) {
        final peso = 1900 + random.nextDouble() * 500;
        gallos.add(
          Gallo(
            id: 'g${i}_$j',
            participanteId: 'p$i',
            peso: peso,
            anillo:
                'A${i.toString().padLeft(2, '0')}${j.toString().padLeft(2, '0')}',
          ),
        );
      }
    }

    final config = ConfiguracionDerby(
      toleranciaPeso: toleranciaPeso,
      numeroRondas: numeroRondas,
      evitarCompadres: true,
    );

    return (participantes: participantes, gallos: gallos, config: config);
  }

  /// Valida todas las restricciones del torneo
  void validarRestricciones({
    required List<Ronda> rondas,
    required List<Gallo> gallos,
    required List<Participante> participantes,
    required ConfiguracionDerby config,
  }) {
    final gallosMap = {for (var g in gallos) g.id: g};
    final participantesMap = {for (var p in participantes) p.id: p};
    final historialGlobal = <String>{};

    for (final ronda in rondas) {
      final gallosEnRonda = <String>{};

      for (final pelea in ronda.peleas) {
        final galloRojo = gallosMap[pelea.galloRojoId];
        final galloVerde = gallosMap[pelea.galloVerdeId];

        // 1. Gallos existen
        expect(
          galloRojo,
          isNotNull,
          reason: 'Gallo rojo no existe: ${pelea.galloRojoId}',
        );
        expect(
          galloVerde,
          isNotNull,
          reason: 'Gallo verde no existe: ${pelea.galloVerdeId}',
        );

        // 2. No es el mismo gallo
        expect(
          pelea.galloRojoId != pelea.galloVerdeId,
          isTrue,
          reason: 'Mismo gallo en ambos lados',
        );

        // 3. Tolerancia de peso
        final diffPeso = (galloRojo!.peso - galloVerde!.peso).abs();
        expect(
          diffPeso <= config.toleranciaPeso,
          isTrue,
          reason:
              'Diferencia de peso ($diffPeso) excede tolerancia (${config.toleranciaPeso})',
        );

        // 4. Distinto participante
        expect(
          galloRojo.participanteId != galloVerde.participanteId,
          isTrue,
          reason: 'Mismo participante: ${galloRojo.participanteId}',
        );

        // 5. Compadres
        final pRojo = participantesMap[galloRojo.participanteId];
        final pVerde = participantesMap[galloVerde.participanteId];
        if (config.evitarCompadres && pRojo != null && pVerde != null) {
          expect(
            !pRojo.esCompadreDe(pVerde.id) && !pVerde.esCompadreDe(pRojo.id),
            isTrue,
            reason: 'Compadres enfrentados',
          );
        }

        // 6. No repetir gallo en misma ronda
        expect(
          !gallosEnRonda.contains(pelea.galloRojoId),
          isTrue,
          reason: 'Gallo ${pelea.galloRojoId} repetido en ronda',
        );
        expect(
          !gallosEnRonda.contains(pelea.galloVerdeId),
          isTrue,
          reason: 'Gallo ${pelea.galloVerdeId} repetido en ronda',
        );
        gallosEnRonda.add(pelea.galloRojoId);
        gallosEnRonda.add(pelea.galloVerdeId);

        // 7. No repetir enfrentamientos
        final par = MatchingValidators.normalizarPar(
          pelea.galloRojoId,
          pelea.galloVerdeId,
        );
        expect(
          !historialGlobal.contains(par),
          isTrue,
          reason: 'Enfrentamiento repetido: $par',
        );
        historialGlobal.add(par);
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STRESS TESTS CON 70+ GALLOS
  // ═══════════════════════════════════════════════════════════════════════════

  group('🔥 STRESS TEST - 70+ Gallos', () {
    test('Derby con 72 gallos (12 participantes x 6 gallos), 5 rondas', () {
      const numParticipantes = 12;
      const gallosPorParticipante = 6;
      const totalGallos = numParticipantes * gallosPorParticipante; // 72
      const numeroRondas = 5;

      print('\n${'=' * 60}');
      print(
        'STRESS TEST: $totalGallos gallos, $numParticipantes participantes, $numeroRondas rondas',
      );
      print('=' * 60);

      final torneo = generarTorneoAleatorio(
        numParticipantes: numParticipantes,
        gallosPorParticipante: gallosPorParticipante,
        numeroRondas: numeroRondas,
      );

      expect(torneo.gallos.length, equals(totalGallos));

      final stopwatch = Stopwatch()..start();
      final generator = RoundGenerator(
        configuracion: torneo.config,
        participantes: torneo.participantes,
      );

      final resultado = generator.generarRondas(
        gallos: torneo.gallos,
        optimizar: true,
      );
      stopwatch.stop();

      validarRestricciones(
        rondas: resultado.rondas,
        gallos: torneo.gallos,
        participantes: torneo.participantes,
        config: torneo.config,
      );

      var totalSinCotejo = 0;
      for (final ronda in resultado.rondas) {
        totalSinCotejo += ronda.sinCotejo.length;
      }

      print('✅ Rondas generadas: ${resultado.rondas.length}');
      print('✅ Total peleas: ${resultado.totalPeleas}');
      print('✅ Gallos sin cotejo: $totalSinCotejo');
      print('✅ Tiempo: ${stopwatch.elapsedMilliseconds}ms');

      expect(resultado.rondas.length, equals(numeroRondas));
      expect(resultado.totalPeleas, greaterThan(0));
    });

    test('Derby con 80 gallos (16 participantes x 5 gallos), 8 rondas', () {
      const numParticipantes = 16;
      const gallosPorParticipante = 5;
      const totalGallos = numParticipantes * gallosPorParticipante; // 80
      const numeroRondas = 8;

      print('\n${'=' * 60}');
      print(
        'STRESS TEST: $totalGallos gallos, $numParticipantes participantes, $numeroRondas rondas',
      );
      print('=' * 60);

      final torneo = generarTorneoAleatorio(
        numParticipantes: numParticipantes,
        gallosPorParticipante: gallosPorParticipante,
        numeroRondas: numeroRondas,
      );

      expect(torneo.gallos.length, equals(totalGallos));

      final stopwatch = Stopwatch()..start();
      final generator = RoundGenerator(
        configuracion: torneo.config,
        participantes: torneo.participantes,
      );

      final resultado = generator.generarRondas(
        gallos: torneo.gallos,
        optimizar: true,
      );
      stopwatch.stop();

      validarRestricciones(
        rondas: resultado.rondas,
        gallos: torneo.gallos,
        participantes: torneo.participantes,
        config: torneo.config,
      );

      var totalSinCotejo = 0;
      for (final ronda in resultado.rondas) {
        totalSinCotejo += ronda.sinCotejo.length;
      }

      print('✅ Rondas generadas: ${resultado.rondas.length}');
      print('✅ Total peleas: ${resultado.totalPeleas}');
      print('✅ Gallos sin cotejo: $totalSinCotejo');
      print('✅ Tiempo: ${stopwatch.elapsedMilliseconds}ms');

      expect(resultado.rondas.length, equals(numeroRondas));
    });

    test(
      'Derby EXTREMO: 100 gallos (20 participantes x 5 gallos), 10 rondas',
      () {
        const numParticipantes = 20;
        const gallosPorParticipante = 5;
        const totalGallos = numParticipantes * gallosPorParticipante; // 100
        const numeroRondas = 10;

        print('\n${'=' * 60}');
        print('STRESS TEST EXTREMO: $totalGallos gallos, $numeroRondas rondas');
        print('=' * 60);

        final torneo = generarTorneoAleatorio(
          numParticipantes: numParticipantes,
          gallosPorParticipante: gallosPorParticipante,
          numeroRondas: numeroRondas,
          probabilidadCompadres: 0.15,
        );

        final stopwatch = Stopwatch()..start();
        final generator = RoundGenerator(
          configuracion: torneo.config,
          participantes: torneo.participantes,
        );

        final resultado = generator.generarRondas(
          gallos: torneo.gallos,
          optimizar: true,
        );
        stopwatch.stop();

        validarRestricciones(
          rondas: resultado.rondas,
          gallos: torneo.gallos,
          participantes: torneo.participantes,
          config: torneo.config,
        );

        print('✅ Rondas generadas: ${resultado.rondas.length}');
        print('✅ Total peleas: ${resultado.totalPeleas}');
        print('✅ Tiempo: ${stopwatch.elapsedMilliseconds}ms');
        print('✅ PASÓ PRUEBA EXTREMA');

        expect(resultado.rondas.length, equals(numeroRondas));
      },
    );

    test(
      '500 torneos aleatorios de 70+ gallos',
      () {
        const numTorneos = 500;
        var exitosos = 0;
        var totalPeleas = 0;
        final stopwatch = Stopwatch()..start();

        print('\n${'=' * 60}');
        print('STRESS TEST MASIVO: $numTorneos torneos de 70+ gallos');
        print('=' * 60);

        for (var t = 0; t < numTorneos; t++) {
          try {
            // Variar configuraciones
            final numParticipantes = 10 + random.nextInt(15); // 10-24
            final gallosPorParticipante = 3 + random.nextInt(5); // 3-7
            final totalGallos = numParticipantes * gallosPorParticipante;

            if (totalGallos < 70) continue; // Solo contar si >= 70 gallos

            final torneo = generarTorneoAleatorio(
              numParticipantes: numParticipantes,
              gallosPorParticipante: gallosPorParticipante,
              numeroRondas: 3 + random.nextInt(8), // 3-10 rondas
              toleranciaPeso: 50 + random.nextDouble() * 100, // 50-150g
              probabilidadCompadres: random.nextDouble() * 0.2, // 0-20%
            );

            final generator = RoundGenerator(
              configuracion: torneo.config,
              participantes: torneo.participantes,
            );

            final resultado = generator.generarRondas(gallos: torneo.gallos);

            validarRestricciones(
              rondas: resultado.rondas,
              gallos: torneo.gallos,
              participantes: torneo.participantes,
              config: torneo.config,
            );

            exitosos++;
            totalPeleas += resultado.totalPeleas;
          } catch (e) {
            fail('Torneo $t falló: $e');
          }
        }

        stopwatch.stop();

        print('✅ Torneos exitosos: $exitosos');
        print('✅ Total peleas: $totalPeleas');
        print('✅ Tiempo total: ${stopwatch.elapsedMilliseconds}ms');
        print(
          '✅ Promedio por torneo: ${stopwatch.elapsedMilliseconds / exitosos}ms',
        );

        expect(exitosos, greaterThan(0));
      },
      timeout: const Timeout(Duration(minutes: 5)),
    );
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ESCENARIOS DE GALLOS
  // ═══════════════════════════════════════════════════════════════════════════

  group('🐓 Escenarios de Gallos', () {
    test(
      'Gallo con peso extremadamente bajo (1500g) puede emparejar con tolerancia adecuada',
      () {
        final participantes = [
          Participante(id: 'p1', nombre: 'Rancho 1'),
          Participante(id: 'p2', nombre: 'Rancho 2'),
        ];

        final gallos = [
          Gallo(
            id: 'g1',
            participanteId: 'p1',
            peso: 1500,
            anillo: 'A001',
          ), // Muy bajo
          Gallo(id: 'g2', participanteId: 'p2', peso: 1550, anillo: 'A002'),
          Gallo(id: 'g3', participanteId: 'p1', peso: 2000, anillo: 'A003'),
          Gallo(id: 'g4', participanteId: 'p2', peso: 2030, anillo: 'A004'),
        ];

        final config = const ConfiguracionDerby(
          toleranciaPeso: 60,
          numeroRondas: 2,
        );

        final generator = RoundGenerator(
          configuracion: config,
          participantes: participantes,
        );
        final resultado = generator.generarRondas(gallos: gallos);

        print(
          '\n✅ Gallos con peso bajo: ${resultado.totalPeleas} peleas generadas',
        );
        expect(resultado.totalPeleas, greaterThan(0));
      },
    );

    test('Gallo con peso muy alto (3000g) queda sin cotejo si no hay par', () {
      final participantes = [
        Participante(id: 'p1', nombre: 'Rancho 1'),
        Participante(id: 'p2', nombre: 'Rancho 2'),
      ];

      final gallos = [
        Gallo(
          id: 'g1',
          participanteId: 'p1',
          peso: 3000,
          anillo: 'A001',
        ), // Muy alto
        Gallo(id: 'g2', participanteId: 'p2', peso: 2000, anillo: 'A002'),
        Gallo(id: 'g3', participanteId: 'p1', peso: 2050, anillo: 'A003'),
        Gallo(id: 'g4', participanteId: 'p2', peso: 2080, anillo: 'A004'),
      ];

      final config = const ConfiguracionDerby(
        toleranciaPeso: 50, // Tolerancia baja
        numeroRondas: 1,
      );

      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );
      final resultado = generator.generarRondas(gallos: gallos);

      // El gallo de 3000g debería quedar sin cotejo
      final sinCotejo = resultado.rondas.first.sinCotejo;
      print('\n✅ Gallo muy pesado: ${sinCotejo.length} sin cotejo');
      expect(sinCotejo.contains('g1'), isTrue);
    });

    test(
      'Todos los gallos de un participante - imposible emparejar entre sí',
      () {
        final participantes = [Participante(id: 'p1', nombre: 'Rancho Solo')];

        final gallos = [
          Gallo(id: 'g1', participanteId: 'p1', peso: 2000, anillo: 'A001'),
          Gallo(id: 'g2', participanteId: 'p1', peso: 2050, anillo: 'A002'),
          Gallo(id: 'g3', participanteId: 'p1', peso: 2100, anillo: 'A003'),
        ];

        final config = const ConfiguracionDerby(numeroRondas: 1);

        final generator = RoundGenerator(
          configuracion: config,
          participantes: participantes,
        );
        final resultado = generator.generarRondas(gallos: gallos);

        // No debería haber peleas (mismo participante)
        print(
          '\n✅ Un solo participante: ${resultado.totalPeleas} peleas (esperado: 0)',
        );
        expect(resultado.totalPeleas, equals(0));
        expect(resultado.rondas.first.sinCotejo.length, equals(3));
      },
    );

    test('Gallos con estados mixtos (activo, retirado, descalificado)', () {
      final galloActivo = Gallo(
        id: 'g1',
        participanteId: 'p1',
        peso: 2000,
        anillo: 'A001',
      );
      final galloRetirado = Gallo(
        id: 'g2',
        participanteId: 'p2',
        peso: 2000,
        anillo: 'A002',
        estado: EstadoGallo.retirado,
      );
      final galloDescal = Gallo(
        id: 'g3',
        participanteId: 'p3',
        peso: 2000,
        anillo: 'A003',
        estado: EstadoGallo.descalificado,
      );

      expect(galloActivo.estado, equals(EstadoGallo.activo));
      expect(galloRetirado.estado, equals(EstadoGallo.retirado));
      expect(galloDescal.estado, equals(EstadoGallo.descalificado));

      // Verificar copyWith para cambiar estado
      final galloAhoraRetirado = galloActivo.copyWith(
        estado: EstadoGallo.retirado,
      );
      expect(galloAhoraRetirado.estado, equals(EstadoGallo.retirado));
      expect(galloAhoraRetirado.id, equals(galloActivo.id));
      expect(galloAhoraRetirado.peso, equals(galloActivo.peso));

      print('\n✅ Estados de gallo funcionan correctamente');
    });

    test('Gallo con anillo vacío - debe tener ID válido', () {
      final gallo = Gallo(
        id: 'g_test_123',
        participanteId: 'p1',
        peso: 2000,
        anillo: '', // Anillo vacío
      );

      expect(gallo.id, isNotEmpty);
      expect(gallo.anillo, isEmpty);

      // Simular lo que haría la app
      final anilloMostrar = gallo.anillo.isEmpty ? 'SIN-ANILLO' : gallo.anillo;
      expect(anilloMostrar, equals('SIN-ANILLO'));

      print('\n✅ Gallo sin anillo manejado correctamente');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ESCENARIOS DE PARTICIPANTES
  // ═══════════════════════════════════════════════════════════════════════════

  group('👥 Escenarios de Participantes', () {
    test('Participantes compadres - no se enfrentan', () {
      final participantes = [
        Participante(id: 'p1', nombre: 'Rancho 1', compadres: ['p2']),
        Participante(id: 'p2', nombre: 'Rancho 2', compadres: ['p1']),
        Participante(id: 'p3', nombre: 'Rancho 3'),
        Participante(id: 'p4', nombre: 'Rancho 4'),
      ];

      final gallos = [
        Gallo(id: 'g1', participanteId: 'p1', peso: 2000, anillo: 'A001'),
        Gallo(id: 'g2', participanteId: 'p2', peso: 2000, anillo: 'A002'),
        Gallo(id: 'g3', participanteId: 'p3', peso: 2000, anillo: 'A003'),
        Gallo(id: 'g4', participanteId: 'p4', peso: 2000, anillo: 'A004'),
      ];

      final config = const ConfiguracionDerby(
        numeroRondas: 3,
        evitarCompadres: true,
      );

      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );
      final resultado = generator.generarRondas(gallos: gallos);

      // Verificar que p1 y p2 nunca se enfrentan
      final gallosMap = {for (var g in gallos) g.id: g};
      for (final ronda in resultado.rondas) {
        for (final pelea in ronda.peleas) {
          final pRojo = gallosMap[pelea.galloRojoId]!.participanteId;
          final pVerde = gallosMap[pelea.galloVerdeId]!.participanteId;

          final sonCompadres =
              (pRojo == 'p1' && pVerde == 'p2') ||
              (pRojo == 'p2' && pVerde == 'p1');
          expect(sonCompadres, isFalse, reason: 'Compadres enfrentados');
        }
      }

      print('\n✅ Compadres nunca se enfrentan');
    });

    test('Todos compadres entre sí - cero peleas posibles', () {
      final participantes = [
        Participante(id: 'p1', nombre: 'R1', compadres: ['p2', 'p3', 'p4']),
        Participante(id: 'p2', nombre: 'R2', compadres: ['p1', 'p3', 'p4']),
        Participante(id: 'p3', nombre: 'R3', compadres: ['p1', 'p2', 'p4']),
        Participante(id: 'p4', nombre: 'R4', compadres: ['p1', 'p2', 'p3']),
      ];

      final gallos = [
        Gallo(id: 'g1', participanteId: 'p1', peso: 2000, anillo: 'A001'),
        Gallo(id: 'g2', participanteId: 'p2', peso: 2000, anillo: 'A002'),
        Gallo(id: 'g3', participanteId: 'p3', peso: 2000, anillo: 'A003'),
        Gallo(id: 'g4', participanteId: 'p4', peso: 2000, anillo: 'A004'),
      ];

      final config = const ConfiguracionDerby(
        numeroRondas: 1,
        evitarCompadres: true,
      );

      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );
      final resultado = generator.generarRondas(gallos: gallos);

      print(
        '\n✅ Todos compadres: ${resultado.totalPeleas} peleas (esperado: 0)',
      );
      expect(resultado.totalPeleas, equals(0));
    });

    test('Participante sin gallos - no afecta sorteo', () {
      final participantes = [
        Participante(id: 'p1', nombre: 'Con Gallos'),
        Participante(id: 'p2', nombre: 'Con Gallos'),
        Participante(id: 'p3', nombre: 'SIN GALLOS'), // No tiene gallos
      ];

      final gallos = [
        Gallo(id: 'g1', participanteId: 'p1', peso: 2000, anillo: 'A001'),
        Gallo(id: 'g2', participanteId: 'p1', peso: 2050, anillo: 'A002'),
        Gallo(id: 'g3', participanteId: 'p2', peso: 2000, anillo: 'A003'),
        Gallo(id: 'g4', participanteId: 'p2', peso: 2050, anillo: 'A004'),
      ];

      final config = const ConfiguracionDerby(numeroRondas: 2);

      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );
      final resultado = generator.generarRondas(gallos: gallos);

      // El sorteo debe funcionar normalmente
      print(
        '\n✅ Participante sin gallos: ${resultado.totalPeleas} peleas generadas',
      );
      expect(resultado.totalPeleas, greaterThan(0));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ESCENARIOS DE SORTEO Y PELEAS
  // ═══════════════════════════════════════════════════════════════════════════

  group('🎲 Escenarios de Sorteo', () {
    test('Sorteo con tolerancia de peso muy baja (20g)', () {
      final participantes = [
        Participante(id: 'p1', nombre: 'Rancho 1'),
        Participante(id: 'p2', nombre: 'Rancho 2'),
      ];

      final gallos = [
        Gallo(id: 'g1', participanteId: 'p1', peso: 2000, anillo: 'A001'),
        Gallo(
          id: 'g2',
          participanteId: 'p2',
          peso: 2015,
          anillo: 'A002',
        ), // Dentro
        Gallo(id: 'g3', participanteId: 'p1', peso: 2100, anillo: 'A003'),
        Gallo(
          id: 'g4',
          participanteId: 'p2',
          peso: 2200,
          anillo: 'A004',
        ), // Fuera de g3
      ];

      final config = const ConfiguracionDerby(
        toleranciaPeso: 20, // Muy estricto
        numeroRondas: 2,
      );

      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );
      final resultado = generator.generarRondas(gallos: gallos);

      print(
        '\n✅ Tolerancia 20g: ${resultado.totalPeleas} peleas, ${resultado.rondas.first.sinCotejo.length} sin cotejo',
      );

      // g1 vs g2 debe funcionar (diff 15g < 20g)
      // g3 vs g4 NO debe funcionar (diff 100g > 20g)
      expect(resultado.totalPeleas, greaterThanOrEqualTo(1));
    });

    test('Sorteo con muchas rondas - no repetir enfrentamientos', () {
      final participantes = [
        Participante(id: 'p1', nombre: 'R1'),
        Participante(id: 'p2', nombre: 'R2'),
        Participante(id: 'p3', nombre: 'R3'),
        Participante(id: 'p4', nombre: 'R4'),
      ];

      final gallos = [
        Gallo(id: 'g1', participanteId: 'p1', peso: 2000, anillo: 'A001'),
        Gallo(id: 'g2', participanteId: 'p2', peso: 2000, anillo: 'A002'),
        Gallo(id: 'g3', participanteId: 'p3', peso: 2000, anillo: 'A003'),
        Gallo(id: 'g4', participanteId: 'p4', peso: 2000, anillo: 'A004'),
      ];

      // Con 4 gallos de 4 participantes, máximo 3 rondas posibles sin repetir
      // (cada gallo puede pelear con 3 oponentes diferentes)
      final config = const ConfiguracionDerby(numeroRondas: 5);

      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );
      final resultado = generator.generarRondas(gallos: gallos);

      // Verificar no repetición
      final enfrentamientos = <String>{};
      for (final ronda in resultado.rondas) {
        for (final pelea in ronda.peleas) {
          final par = MatchingValidators.normalizarPar(
            pelea.galloRojoId,
            pelea.galloVerdeId,
          );
          expect(
            enfrentamientos.contains(par),
            isFalse,
            reason: 'Enfrentamiento repetido: $par',
          );
          enfrentamientos.add(par);
        }
      }

      print(
        '\n✅ Sin enfrentamientos repetidos: ${enfrentamientos.length} únicos',
      );
    });

    test('Sorteo optimizado vs no optimizado', () {
      final torneo = generarTorneoAleatorio(
        numParticipantes: 10,
        gallosPorParticipante: 5,
        numeroRondas: 5,
      );

      final generator = RoundGenerator(
        configuracion: torneo.config,
        participantes: torneo.participantes,
      );

      final sw1 = Stopwatch()..start();
      final sinOptimizar = generator.generarRondas(
        gallos: torneo.gallos,
        optimizar: false,
      );
      sw1.stop();

      final sw2 = Stopwatch()..start();
      final conOptimizar = generator.generarRondas(
        gallos: torneo.gallos,
        optimizar: true,
      );
      sw2.stop();

      print('\n📊 Comparación optimización:');
      print(
        '   Sin optimizar: ${sinOptimizar.totalPeleas} peleas, ${sw1.elapsedMilliseconds}ms',
      );
      print(
        '   Con optimizar: ${conOptimizar.totalPeleas} peleas, ${sw2.elapsedMilliseconds}ms',
      );

      // Ambos deben generar sorteos válidos
      expect(sinOptimizar.rondas.length, equals(5));
      expect(conOptimizar.rondas.length, equals(5));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ESCENARIOS DE PELEAS Y RESULTADOS
  // ═══════════════════════════════════════════════════════════════════════════

  group('⚔️ Escenarios de Peleas', () {
    test('Pelea - estados válidos', () {
      final pelea = Pelea(
        id: 'p1',
        numero: 1,
        galloRojoId: 'g1',
        galloVerdeId: 'g2',
      );

      expect(pelea.estado, equals(EstadoPelea.pendiente));
      expect(pelea.tieneResultado, isFalse);

      // Registrar resultado
      final peleaGanada = pelea.conResultado(ganadorId: 'g1');
      expect(peleaGanada.estado, equals(EstadoPelea.finalizada));
      expect(peleaGanada.ganadorId, equals('g1'));
      expect(peleaGanada.tieneResultado, isTrue);

      // Empate
      final peleaEmpate = pelea.conResultado(empate: true);
      expect(peleaEmpate.estado, equals(EstadoPelea.finalizada));
      expect(peleaEmpate.empate, isTrue);
      expect(peleaEmpate.ganadorId, isNull);

      print('\n✅ Estados de pelea funcionan correctamente');
    });

    test('Pelea cancelada mantiene datos', () {
      final pelea = Pelea(
        id: 'p1',
        numero: 1,
        galloRojoId: 'g1',
        galloVerdeId: 'g2',
      );

      final cancelada = pelea.copyWith(
        estado: EstadoPelea.cancelada,
        notas: 'Gallo g1 retirado por lesión',
      );

      expect(cancelada.estado, equals(EstadoPelea.cancelada));
      expect(cancelada.galloRojoId, equals('g1'));
      expect(cancelada.galloVerdeId, equals('g2'));
      expect(cancelada.notas, contains('retirado'));

      print('\n✅ Pelea cancelada mantiene referencias');
    });

    test('Pelea - participoGallo funciona', () {
      final pelea = Pelea(
        id: 'p1',
        numero: 1,
        galloRojoId: 'g1',
        galloVerdeId: 'g2',
      );

      expect(pelea.participoGallo('g1'), isTrue);
      expect(pelea.participoGallo('g2'), isTrue);
      expect(pelea.participoGallo('g3'), isFalse);

      print('\n✅ participoGallo funciona correctamente');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ESCENARIOS DE RONDAS
  // ═══════════════════════════════════════════════════════════════════════════

  group('🔄 Escenarios de Rondas', () {
    test('Ronda - bloqueo funciona', () {
      final ronda = Ronda(
        id: 'r1',
        numero: 1,
        peleas: [
          Pelea(id: 'p1', numero: 1, galloRojoId: 'g1', galloVerdeId: 'g2'),
        ],
      );

      expect(ronda.bloqueada, isFalse);

      final rondaBloqueada = ronda.copyWith(bloqueada: true);
      expect(rondaBloqueada.bloqueada, isTrue);

      print('\n✅ Bloqueo de ronda funciona');
    });

    test('Ronda - todasFinalizadas detecta correctamente', () {
      final rondaIncompleta = Ronda(
        id: 'r1',
        numero: 1,
        peleas: [
          Pelea(id: 'p1', numero: 1, galloRojoId: 'g1', galloVerdeId: 'g2'),
          Pelea(id: 'p2', numero: 2, galloRojoId: 'g3', galloVerdeId: 'g4'),
        ],
      );

      expect(rondaIncompleta.todasFinalizadas, isFalse);

      final peleasFinalizadas = [
        Pelea(
          id: 'p1',
          numero: 1,
          galloRojoId: 'g1',
          galloVerdeId: 'g2',
          estado: EstadoPelea.finalizada,
          ganadorId: 'g1',
        ),
        Pelea(
          id: 'p2',
          numero: 2,
          galloRojoId: 'g3',
          galloVerdeId: 'g4',
          estado: EstadoPelea.finalizada,
          ganadorId: 'g3',
        ),
      ];

      final rondaCompleta = rondaIncompleta.conPeleasActualizadas(
        peleasFinalizadas,
      );
      expect(rondaCompleta.todasFinalizadas, isTrue);

      print('\n✅ Detección de ronda completada funciona');
    });

    test('Ronda con peleas canceladas cuenta como terminadas', () {
      final peleas = [
        Pelea(
          id: 'p1',
          numero: 1,
          galloRojoId: 'g1',
          galloVerdeId: 'g2',
          estado: EstadoPelea.finalizada,
          ganadorId: 'g1',
        ),
        Pelea(
          id: 'p2',
          numero: 2,
          galloRojoId: 'g3',
          galloVerdeId: 'g4',
          estado: EstadoPelea.cancelada,
          notas: 'Gallo retirado',
        ),
      ];

      final ronda = Ronda(id: 'r1', numero: 1, peleas: peleas);

      expect(ronda.peleasTerminadas, equals(2)); // Ambas cuentan
      expect(ronda.todasFinalizadas, isTrue);

      print('\n✅ Peleas canceladas cuentan como terminadas');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // CASOS EDGE Y ERRORES
  // ═══════════════════════════════════════════════════════════════════════════

  group('⚠️ Casos Edge', () {
    test('Torneo con 0 gallos - no falla', () {
      final participantes = [Participante(id: 'p1', nombre: 'Rancho 1')];

      final gallos = <Gallo>[];
      final config = const ConfiguracionDerby(numeroRondas: 1);

      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );
      final resultado = generator.generarRondas(gallos: gallos);

      expect(resultado.totalPeleas, equals(0));
      print('\n✅ Torneo vacío manejado correctamente');
    });

    test('Torneo con 1 solo gallo - sin peleas', () {
      final participantes = [Participante(id: 'p1', nombre: 'Rancho 1')];

      final gallos = [
        Gallo(id: 'g1', participanteId: 'p1', peso: 2000, anillo: 'A001'),
      ];

      final config = const ConfiguracionDerby(numeroRondas: 1);
      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );
      final resultado = generator.generarRondas(gallos: gallos);

      expect(resultado.totalPeleas, equals(0));
      expect(resultado.rondas.first.sinCotejo, contains('g1'));
      print('\n✅ Un solo gallo: sin peleas, queda sin cotejo');
    });

    test('Torneo con 2 gallos del mismo participante - imposible', () {
      final participantes = [Participante(id: 'p1', nombre: 'Rancho 1')];

      final gallos = [
        Gallo(id: 'g1', participanteId: 'p1', peso: 2000, anillo: 'A001'),
        Gallo(id: 'g2', participanteId: 'p1', peso: 2000, anillo: 'A002'),
      ];

      final config = const ConfiguracionDerby(numeroRondas: 1);
      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );
      final resultado = generator.generarRondas(gallos: gallos);

      expect(resultado.totalPeleas, equals(0));
      print('\n✅ Mismo participante: 0 peleas posibles');
    });

    test('Gallos con peso 0 - aún pueden emparejar', () {
      final participantes = [
        Participante(id: 'p1', nombre: 'R1'),
        Participante(id: 'p2', nombre: 'R2'),
      ];

      final gallos = [
        Gallo(id: 'g1', participanteId: 'p1', peso: 0, anillo: 'A001'),
        Gallo(id: 'g2', participanteId: 'p2', peso: 0, anillo: 'A002'),
      ];

      final config = const ConfiguracionDerby(
        toleranciaPeso: 100,
        numeroRondas: 1,
      );
      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );
      final resultado = generator.generarRondas(gallos: gallos);

      // Diferencia de peso es 0, está dentro de tolerancia
      expect(resultado.totalPeleas, equals(1));
      print('\n✅ Peso 0 manejado correctamente');
    });

    test('Gallos con peso negativo - comportamiento', () {
      final participantes = [
        Participante(id: 'p1', nombre: 'R1'),
        Participante(id: 'p2', nombre: 'R2'),
      ];

      final gallos = [
        Gallo(
          id: 'g1',
          participanteId: 'p1',
          peso: -100,
          anillo: 'A001',
        ), // Inválido
        Gallo(id: 'g2', participanteId: 'p2', peso: 0, anillo: 'A002'),
      ];

      final config = const ConfiguracionDerby(
        toleranciaPeso: 200,
        numeroRondas: 1,
      );
      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );
      final resultado = generator.generarRondas(gallos: gallos);

      // El sistema debería manejar esto (diff = 100, dentro de tolerancia)
      print(
        '\n✅ Peso negativo: ${resultado.totalPeleas} peleas (sistema no falla)',
      );
    });

    test('ID de gallo con caracteres especiales', () {
      final gallo = Gallo(
        id: 'g_2024-01-01_test@123',
        participanteId: 'p1',
        peso: 2000,
        anillo: 'A001',
      );

      expect(gallo.id, contains('@'));
      expect(gallo.id, contains('-'));

      print('\n✅ IDs con caracteres especiales funcionan');
    });

    test('Nombre de participante muy largo', () {
      final nombre = 'A' * 500; // 500 caracteres
      final participante = Participante(id: 'p1', nombre: nombre);

      expect(participante.nombre.length, equals(500));
      print('\n✅ Nombres largos permitidos');
    });

    test('Muchos compadres - no causa problemas', () {
      final compadresIds = List.generate(100, (i) => 'p$i');
      final participante = Participante(
        id: 'p_main',
        nombre: 'Principal',
        compadres: compadresIds,
      );

      expect(participante.compadres.length, equals(100));
      expect(participante.esCompadreDe('p50'), isTrue);
      expect(participante.esCompadreDe('p999'), isFalse);

      print('\n✅ Muchos compadres manejados');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // INTEGRIDAD DE DATOS
  // ═══════════════════════════════════════════════════════════════════════════

  group('🔒 Integridad de Datos', () {
    test('MatchingValidators.normalizarPar siempre consistente', () {
      final par1 = MatchingValidators.normalizarPar('g1', 'g2');
      final par2 = MatchingValidators.normalizarPar('g2', 'g1');

      expect(par1, equals(par2));

      final par3 = MatchingValidators.normalizarPar('abc', 'xyz');
      final par4 = MatchingValidators.normalizarPar('xyz', 'abc');

      expect(par3, equals(par4));

      print('\n✅ Normalización de pares consistente');
    });

    test('Pelea no puede tener mismo gallo en ambos lados conceptualmente', () {
      // Esto es más una validación de lógica - el engine no debe crear esto
      final torneo = generarTorneoAleatorio(
        numParticipantes: 5,
        gallosPorParticipante: 4,
        numeroRondas: 3,
      );

      final generator = RoundGenerator(
        configuracion: torneo.config,
        participantes: torneo.participantes,
      );

      final resultado = generator.generarRondas(gallos: torneo.gallos);

      for (final ronda in resultado.rondas) {
        for (final pelea in ronda.peleas) {
          expect(
            pelea.galloRojoId != pelea.galloVerdeId,
            isTrue,
            reason: 'Mismo gallo en ambos lados',
          );
        }
      }

      print('\n✅ Ninguna pelea tiene mismo gallo en ambos lados');
    });

    test('Cada gallo solo pelea una vez por ronda', () {
      final torneo = generarTorneoAleatorio(
        numParticipantes: 10,
        gallosPorParticipante: 5,
        numeroRondas: 5,
      );

      final generator = RoundGenerator(
        configuracion: torneo.config,
        participantes: torneo.participantes,
      );

      final resultado = generator.generarRondas(gallos: torneo.gallos);

      for (final ronda in resultado.rondas) {
        final gallosEnRonda = <String>{};
        for (final pelea in ronda.peleas) {
          expect(
            gallosEnRonda.contains(pelea.galloRojoId),
            isFalse,
            reason: 'Gallo ${pelea.galloRojoId} repetido',
          );
          expect(
            gallosEnRonda.contains(pelea.galloVerdeId),
            isFalse,
            reason: 'Gallo ${pelea.galloVerdeId} repetido',
          );
          gallosEnRonda.add(pelea.galloRojoId);
          gallosEnRonda.add(pelea.galloVerdeId);
        }
      }

      print('\n✅ Cada gallo pelea máximo una vez por ronda');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // RENDIMIENTO
  // ═══════════════════════════════════════════════════════════════════════════

  group('⚡ Rendimiento', () {
    test('Generación de 150 gallos en menos de 5 segundos', () {
      const numParticipantes = 30;
      const gallosPorParticipante = 5;

      final torneo = generarTorneoAleatorio(
        numParticipantes: numParticipantes,
        gallosPorParticipante: gallosPorParticipante,
        numeroRondas: 10,
      );

      expect(torneo.gallos.length, equals(150));

      final stopwatch = Stopwatch()..start();
      final generator = RoundGenerator(
        configuracion: torneo.config,
        participantes: torneo.participantes,
      );

      final resultado = generator.generarRondas(
        gallos: torneo.gallos,
        optimizar: true,
      );
      stopwatch.stop();

      print('\n⚡ 150 gallos, 10 rondas: ${stopwatch.elapsedMilliseconds}ms');
      print('   Peleas generadas: ${resultado.totalPeleas}');

      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });

    test('Memoria: crear y destruir muchos objetos', () {
      // Simular carga de trabajo
      for (var i = 0; i < 100; i++) {
        final gallos = List.generate(
          50,
          (j) => Gallo(
            id: 'g${i}_$j',
            participanteId: 'p$j',
            peso: 2000.0,
            anillo: 'A$j',
          ),
        );
        expect(gallos.length, equals(50));
      }

      print('\n⚡ Creación/destrucción de objetos OK');
    });
  });
}
