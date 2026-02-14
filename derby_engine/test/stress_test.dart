import 'dart:math';
import 'package:derby_engine/derby_engine.dart';
import 'package:test/test.dart';

/// Simulador masivo para validar el algoritmo de emparejamiento.
///
/// Genera torneos aleatorios y verifica que todas las restricciones
/// se cumplan correctamente.
void main() {
  group('Stress Test - Simulador Masivo', () {
    final random = Random(42); // Seed fijo para reproducibilidad

    /// Genera un torneo aleatorio.
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
      // Crear participantes
      final participantes = <Participante>[];
      for (var i = 0; i < numParticipantes; i++) {
        final compadres = <String>[];

        // Asignar compadres aleatorios
        for (var j = 0; j < i; j++) {
          if (random.nextDouble() < probabilidadCompadres) {
            compadres.add('p$j');
          }
        }

        participantes.add(
          Participante(id: 'p$i', nombre: 'Rancho $i', compadres: compadres),
        );
      }

      // Crear gallos
      final gallos = <Gallo>[];
      for (var i = 0; i < numParticipantes; i++) {
        for (var j = 0; j < gallosPorParticipante; j++) {
          // Peso aleatorio entre 1900 y 2400 gramos
          final peso = 1900 + random.nextDouble() * 500;
          gallos.add(
            Gallo(
              id: 'g${i}_$j',
              participanteId: 'p$i',
              peso: peso,
              anillo:
                  '${i.toString().padLeft(2, '0')}${j.toString().padLeft(2, '0')}',
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

    /// Valida que todas las restricciones se cumplan en las rondas.
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

          // 1. Verificar que no es el mismo gallo
          expect(
            pelea.galloRojoId != pelea.galloVerdeId,
            isTrue,
            reason: 'Mismo gallo en ambos lados: ${pelea.galloRojoId}',
          );

          // 2. Verificar tolerancia de peso
          final diffPeso = (galloRojo!.peso - galloVerde!.peso).abs();
          expect(
            diffPeso <= config.toleranciaPeso,
            isTrue,
            reason:
                'Diferencia de peso ($diffPeso) excede tolerancia (${config.toleranciaPeso})',
          );

          // 3. Verificar distinto participante
          expect(
            galloRojo.participanteId != galloVerde.participanteId,
            isTrue,
            reason: 'Mismo participante: ${galloRojo.participanteId}',
          );

          // 4. Verificar compadres
          final pRojo = participantesMap[galloRojo.participanteId];
          final pVerde = participantesMap[galloVerde.participanteId];
          if (config.evitarCompadres && pRojo != null && pVerde != null) {
            expect(
              !pRojo.esCompadreDe(pVerde.id) && !pVerde.esCompadreDe(pRojo.id),
              isTrue,
              reason: 'Compadres enfrentados: ${pRojo.id} vs ${pVerde.id}',
            );
          }

          // 5. Verificar que cada gallo solo pelea una vez por ronda
          expect(
            !gallosEnRonda.contains(pelea.galloRojoId),
            isTrue,
            reason:
                'Gallo ${pelea.galloRojoId} aparece más de una vez en ronda ${ronda.numero}',
          );
          expect(
            !gallosEnRonda.contains(pelea.galloVerdeId),
            isTrue,
            reason:
                'Gallo ${pelea.galloVerdeId} aparece más de una vez en ronda ${ronda.numero}',
          );

          gallosEnRonda.add(pelea.galloRojoId);
          gallosEnRonda.add(pelea.galloVerdeId);

          // 6. Verificar no repetición de enfrentamientos
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

    test(
      '1000 torneos con 60 gallos y 10 rondas',
      () {
        const numTorneos = 1000;
        const numParticipantes = 10; // 10 participantes
        const gallosPorParticipante = 6; // 6 gallos cada uno = 60 gallos
        const numeroRondas = 10;

        var torneosFallidos = 0;
        var totalPeleas = 0;
        var totalSinCotejo = 0;

        for (var t = 0; t < numTorneos; t++) {
          try {
            final torneo = generarTorneoAleatorio(
              numParticipantes: numParticipantes,
              gallosPorParticipante: gallosPorParticipante,
              numeroRondas: numeroRondas,
              toleranciaPeso: 80,
              probabilidadCompadres: 0.1,
            );

            final generator = RoundGenerator(
              configuracion: torneo.config,
              participantes: torneo.participantes,
            );

            final resultado = generator.generarRondas(gallos: torneo.gallos);

            // Validar todas las restricciones
            validarRestricciones(
              rondas: resultado.rondas,
              gallos: torneo.gallos,
              participantes: torneo.participantes,
              config: torneo.config,
            );

            // Acumular estadísticas
            totalPeleas += resultado.totalPeleas;
            for (final ronda in resultado.rondas) {
              totalSinCotejo += ronda.sinCotejo.length;
            }
          } catch (e) {
            torneosFallidos++;
            fail('Torneo $t falló: $e');
          }
        }

        // Imprimir resumen
        print('\n=== RESULTADOS STRESS TEST ===');
        print('Torneos ejecutados: $numTorneos');
        print('Torneos fallidos: $torneosFallidos');
        print('Total peleas generadas: $totalPeleas');
        print('Total gallos sin cotejo: $totalSinCotejo');
        print('Promedio peleas por torneo: ${totalPeleas / numTorneos}');
        print('Promedio sin cotejo por torneo: ${totalSinCotejo / numTorneos}');

        expect(torneosFallidos, equals(0));
      },
      timeout: const Timeout(Duration(minutes: 5)),
    );

    test(
      '100 torneos con configuraciones extremas',
      () {
        const numTorneos = 100;

        final configuraciones = [
          // Tolerancia muy baja
          (participantes: 8, gallos: 5, rondas: 5, tolerancia: 30.0),
          // Muchas rondas
          (participantes: 6, gallos: 4, rondas: 15, tolerancia: 100.0),
          // Muchos participantes
          (participantes: 20, gallos: 3, rondas: 5, tolerancia: 80.0),
          // Muchos gallos por participante
          (participantes: 5, gallos: 10, rondas: 8, tolerancia: 80.0),
        ];

        for (final cfg in configuraciones) {
          var fallidos = 0;

          for (var t = 0; t < numTorneos; t++) {
            try {
              final torneo = generarTorneoAleatorio(
                numParticipantes: cfg.participantes,
                gallosPorParticipante: cfg.gallos,
                numeroRondas: cfg.rondas,
                toleranciaPeso: cfg.tolerancia,
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
            } catch (e) {
              fallidos++;
            }
          }

          print(
            'Config (p:${cfg.participantes}, g:${cfg.gallos}, r:${cfg.rondas}, t:${cfg.tolerancia}): '
            '$fallidos/$numTorneos fallidos',
          );
          expect(fallidos, equals(0));
        }
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );

    test('Validación de compadres funciona correctamente', () {
      // Crear torneo donde todos son compadres entre sí
      final participantes = <Participante>[];
      for (var i = 0; i < 4; i++) {
        final compadres = <String>[];
        for (var j = 0; j < 4; j++) {
          if (i != j) compadres.add('p$j');
        }
        participantes.add(
          Participante(id: 'p$i', nombre: 'Rancho $i', compadres: compadres),
        );
      }

      final gallos = <Gallo>[];
      for (var i = 0; i < 4; i++) {
        gallos.add(
          Gallo(id: 'g$i', participanteId: 'p$i', peso: 2100, anillo: '00$i'),
        );
      }

      final config = const ConfiguracionDerby(
        toleranciaPeso: 100,
        evitarCompadres: true,
      );

      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );

      final resultado = generator.generarRondas(gallos: gallos);

      // No debería haber peleas porque todos son compadres
      expect(resultado.rondas.every((r) => r.peleas.isEmpty), isTrue);
    });
  });
}
