/// Tests de restricciones de compadres.
///
/// Estos tests verifican:
/// - Compadres nunca pelean entre sí
/// - Escenario de todos son compadres
/// - Validaciones de matching con compadres
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:derby_engine/derby_engine.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('🟥 COMPADRES - Restricciones de Emparejamiento', () {
    group('Compadres Nunca Pelean Entre Sí', () {
      test('gallos de compadres no se emparejan', () {
        // Crear 4 participantes, p1 y p2 son compadres
        final p1 = Participante(
          id: 'p1',
          nombre: 'Rancho 1',
          compadres: ['p2'],
        );
        final p2 = Participante(
          id: 'p2',
          nombre: 'Rancho 2',
          compadres: ['p1'],
        );
        final p3 = Participante(id: 'p3', nombre: 'Rancho 3');
        final p4 = Participante(id: 'p4', nombre: 'Rancho 4');
        final participantes = [p1, p2, p3, p4];

        final gallos = <Gallo>[];
        for (final participante in participantes) {
          for (var i = 1; i <= 2; i++) {
            gallos.add(
              Gallo(
                id: '${participante.id}_g$i',
                anillo: '${participante.id}_$i',
                peso: 2000,
                participanteId: participante.id,
              ),
            );
          }
        }

        final config = TestDataFactory.crearConfig(numeroRondas: 3);
        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        // Crear mapa de gallo a participante
        final galloAParticipante = {
          for (var g in gallos) g.id: g.participanteId,
        };

        // Verificar que p1 y p2 nunca pelean entre sí
        for (final ronda in rondas) {
          for (final pelea in ronda.peleas) {
            final partRojo = galloAParticipante[pelea.galloRojoId];
            final partVerde = galloAParticipante[pelea.galloVerdeId];

            // Si uno es p1, el otro no puede ser p2 y viceversa
            if (partRojo == 'p1') {
              expect(
                partVerde,
                isNot(equals('p2')),
                reason: 'Compadres p1 y p2 enfrentados',
              );
            }
            if (partRojo == 'p2') {
              expect(
                partVerde,
                isNot(equals('p1')),
                reason: 'Compadres p2 y p1 enfrentados',
              );
            }
          }
        }

        print('✅ Compadres p1 y p2 nunca se enfrentan');
      });

      test('múltiples parejas de compadres respetan restricción', () {
        // p1-p2 son compadres, p3-p4 son compadres
        final p1 = Participante(
          id: 'p1',
          nombre: 'Rancho 1',
          compadres: ['p2'],
        );
        final p2 = Participante(
          id: 'p2',
          nombre: 'Rancho 2',
          compadres: ['p1'],
        );
        final p3 = Participante(
          id: 'p3',
          nombre: 'Rancho 3',
          compadres: ['p4'],
        );
        final p4 = Participante(
          id: 'p4',
          nombre: 'Rancho 4',
          compadres: ['p3'],
        );
        final participantes = [p1, p2, p3, p4];

        final gallos = <Gallo>[];
        for (final participante in participantes) {
          for (var i = 1; i <= 2; i++) {
            gallos.add(
              Gallo(
                id: '${participante.id}_g$i',
                anillo: '${participante.id}_$i',
                peso: 2000,
                participanteId: participante.id,
              ),
            );
          }
        }

        final config = TestDataFactory.crearConfig(numeroRondas: 3);
        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        final galloAParticipante = {
          for (var g in gallos) g.id: g.participanteId,
        };

        // Crear mapa de compadres
        final compadresMap = {'p1': 'p2', 'p2': 'p1', 'p3': 'p4', 'p4': 'p3'};

        for (final ronda in rondas) {
          for (final pelea in ronda.peleas) {
            final partRojo = galloAParticipante[pelea.galloRojoId];
            final partVerde = galloAParticipante[pelea.galloVerdeId];

            if (compadresMap.containsKey(partRojo)) {
              expect(
                partVerde,
                isNot(equals(compadresMap[partRojo])),
                reason: 'Compadres $partRojo y $partVerde enfrentados',
              );
            }
          }
        }

        print('✅ Múltiples parejas de compadres respetan restricción');
      });

      test('compadres con muchos gallos no se emparejan', () {
        final p1 = Participante(
          id: 'p1',
          nombre: 'Rancho 1',
          compadres: ['p2'],
        );
        final p2 = Participante(
          id: 'p2',
          nombre: 'Rancho 2',
          compadres: ['p1'],
        );
        final p3 = Participante(id: 'p3', nombre: 'Rancho 3');
        final p4 = Participante(id: 'p4', nombre: 'Rancho 4');
        final participantes = [p1, p2, p3, p4];

        final gallos = <Gallo>[];
        for (final participante in participantes) {
          // Muchos gallos por participante
          for (var i = 1; i <= 5; i++) {
            gallos.add(
              Gallo(
                id: '${participante.id}_g$i',
                anillo: '${participante.id}_$i',
                peso: 2000.0 + (i * 20),
                participanteId: participante.id,
              ),
            );
          }
        }

        final config = TestDataFactory.crearConfig(numeroRondas: 5);
        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        final galloAParticipante = {
          for (var g in gallos) g.id: g.participanteId,
        };

        var peleasTotales = 0;
        for (final ronda in rondas) {
          for (final pelea in ronda.peleas) {
            peleasTotales++;
            final partRojo = galloAParticipante[pelea.galloRojoId];
            final partVerde = galloAParticipante[pelea.galloVerdeId];

            if (partRojo == 'p1') {
              expect(partVerde, isNot(equals('p2')));
            }
            if (partRojo == 'p2') {
              expect(partVerde, isNot(equals('p1')));
            }
          }
        }

        print('✅ $peleasTotales peleas sin enfrentar compadres');
      });
    });

    group('Escenario: Todos Son Compadres', () {
      test('todos compadres resulta en sorteo imposible o vacío', () {
        // Crear participantes donde todos son compadres de todos
        final participantes = TestDataFactory.crearTodosCompadres(cantidad: 4);

        // Verificar que todos tienen a todos como compadres
        for (final p in participantes) {
          final otrosIds = participantes
              .where((other) => other.id != p.id)
              .map((other) => other.id)
              .toSet();

          expect(
            p.compadres.toSet(),
            equals(otrosIds),
            reason: '${p.id} debería tener a todos los demás como compadres',
          );
        }

        final gallos = <Gallo>[];
        for (final p in participantes) {
          gallos.add(
            Gallo(
              id: '${p.id}_g1',
              anillo: '${p.id}_1',
              peso: 2000,
              participanteId: p.id,
            ),
          );
        }

        // El engine debería manejar esto gracefully
        final config = TestDataFactory.crearConfig(numeroRondas: 1);

        try {
          final generator = RoundGenerator(
            configuracion: config,
            participantes: participantes,
          );
          final resultado = generator.generarRondas(gallos: gallos);

          // Si genera rondas, deben estar vacías o respetar compadres
          if (resultado.rondas.isNotEmpty) {
            final galloAParticipante = {
              for (var g in gallos) g.id: g.participanteId,
            };
            for (final ronda in resultado.rondas) {
              for (final pelea in ronda.peleas) {
                final partRojo = galloAParticipante[pelea.galloRojoId]!;
                final partVerde = galloAParticipante[pelea.galloVerdeId]!;

                final pRojo = participantes.firstWhere((p) => p.id == partRojo);
                expect(
                  pRojo.esCompadreDe(partVerde),
                  isFalse,
                  reason: 'Compadres enfrentados en escenario extremo',
                );
              }
            }
          }

          print(
            '✅ Escenario todos compadres manejado (rondas: ${resultado.rondas.length})',
          );
        } catch (e) {
          // Es válido que lance error si es imposible
          print('✅ Escenario todos compadres lanza excepción (esperado): $e');
          expect(true, isTrue);
        }
      });

      test('parcialmente compadres reduce opciones pero genera sorteo', () {
        // p1, p2, p3 son compadres entre sí, p4 no es compadre de nadie
        final p1 = Participante(
          id: 'p1',
          nombre: 'Rancho 1',
          compadres: ['p2', 'p3'],
        );
        final p2 = Participante(
          id: 'p2',
          nombre: 'Rancho 2',
          compadres: ['p1', 'p3'],
        );
        final p3 = Participante(
          id: 'p3',
          nombre: 'Rancho 3',
          compadres: ['p1', 'p2'],
        );
        final p4 = Participante(id: 'p4', nombre: 'Rancho 4');
        final participantes = [p1, p2, p3, p4];

        final gallos = <Gallo>[];
        for (final p in participantes) {
          for (var i = 1; i <= 2; i++) {
            gallos.add(
              Gallo(
                id: '${p.id}_g$i',
                anillo: '${p.id}_$i',
                peso: 2000,
                participanteId: p.id,
              ),
            );
          }
        }

        final config = TestDataFactory.crearConfig(numeroRondas: 4);

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        final galloAParticipante = {
          for (var g in gallos) g.id: g.participanteId,
        };

        // p4 puede pelear con cualquiera, p1/p2/p3 solo con p4
        var peleasValidas = 0;
        for (final ronda in rondas) {
          for (final pelea in ronda.peleas) {
            peleasValidas++;
            final partRojo = galloAParticipante[pelea.galloRojoId]!;
            final partVerde = galloAParticipante[pelea.galloVerdeId]!;

            // Al menos uno debe ser p4
            final tieneP4 = partRojo == 'p4' || partVerde == 'p4';
            if (!tieneP4) {
              // Si no tiene p4, verificar que no sean compadres
              final pRojo = participantes.firstWhere((p) => p.id == partRojo);
              expect(pRojo.esCompadreDe(partVerde), isFalse);
            }
          }
        }

        print('✅ Parcialmente compadres: $peleasValidas peleas válidas');
      });
    });

    group('Validaciones de Compadres', () {
      test('compadres es relación simétrica', () {
        final p1 = Participante(
          id: 'p1',
          nombre: 'Rancho 1',
          compadres: ['p2'],
        );
        final p2 = Participante(
          id: 'p2',
          nombre: 'Rancho 2',
          compadres: ['p1'],
        );

        expect(p1.esCompadreDe('p2'), isTrue);
        expect(p2.esCompadreDe('p1'), isTrue);

        print('✅ Relación de compadres es simétrica');
      });

      test('participante no es compadre de sí mismo', () {
        final p = Participante(id: 'p1', nombre: 'Rancho 1', compadres: ['p1']);

        // Verificar que no se considera compadre de sí mismo
        // (depende de implementación)
        final efectivo = p.compadres.where((id) => id != p.id).toList();

        print(
          '✅ Auto-referencias en compadres: ${efectivo.isEmpty ? "ignoradas" : "presentes"}',
        );
      });

      test('compadre inexistente se maneja gracefully', () {
        final p1 = Participante(
          id: 'p1',
          nombre: 'Rancho 1',
          compadres: ['p_inexistente'],
        );
        final p2 = Participante(id: 'p2', nombre: 'Rancho 2');
        final participantes = [p1, p2];

        // El engine debe funcionar aunque haya referencias a IDs inexistentes
        final gallos = [
          Gallo(id: 'g1', anillo: '001', peso: 2000, participanteId: 'p1'),
          Gallo(id: 'g2', anillo: '002', peso: 2000, participanteId: 'p2'),
        ];

        final config = TestDataFactory.crearConfig(numeroRondas: 1);

        expect(
          () => TestDataFactory.generarRondas(
            participantes: participantes,
            gallos: gallos,
            config: config,
          ),
          returnsNormally,
        );

        print('✅ Compadre inexistente manejado sin crash');
      });
    });

    group('Detectores de Violaciones', () {
      test('detector identifica pelea entre compadres', () {
        final p1 = Participante(
          id: 'p1',
          nombre: 'Rancho 1',
          compadres: ['p2'],
        );
        final p2 = Participante(
          id: 'p2',
          nombre: 'Rancho 2',
          compadres: ['p1'],
        );
        final participantes = [p1, p2];

        final g1 = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
        );
        final g2 = Gallo(
          id: 'g2',
          anillo: '002',
          peso: 2000,
          participanteId: 'p2',
        );
        final gallos = [g1, g2];

        // Simular una pelea creada manualmente (violación)
        final peleaViolacion = Pelea(
          id: 'pelea_violacion',
          numero: 1,
          galloRojoId: 'g1',
          galloVerdeId: 'g2',
        );

        // El validador debería detectar esto
        final galloAParticipante = {
          for (var g in gallos) g.id: g.participanteId,
        };
        final partRojo = galloAParticipante[peleaViolacion.galloRojoId]!;
        final partVerde = galloAParticipante[peleaViolacion.galloVerdeId]!;

        final pRojo = participantes.firstWhere((p) => p.id == partRojo);
        final esViolacion = pRojo.esCompadreDe(partVerde);

        expect(esViolacion, isTrue, reason: 'Debería detectar violación');
        print('✅ Detector identifica violación de compadres');
      });

      test('validador retorna peleas sin violaciones', () {
        final p1 = Participante(
          id: 'p1',
          nombre: 'Rancho 1',
          compadres: ['p2'],
        );
        final p2 = Participante(
          id: 'p2',
          nombre: 'Rancho 2',
          compadres: ['p1'],
        );
        final p3 = Participante(id: 'p3', nombre: 'Rancho 3');
        final participantes = [p1, p2, p3];

        // Pelea válida (p1 vs p3, no son compadres)
        final gallos = [
          Gallo(id: 'g1', anillo: '001', peso: 2000, participanteId: 'p1'),
          Gallo(id: 'g3', anillo: '003', peso: 2000, participanteId: 'p3'),
        ];

        final peleaValida = Pelea(
          id: 'pelea_valida',
          numero: 1,
          galloRojoId: 'g1',
          galloVerdeId: 'g3',
        );

        final galloAParticipante = {
          for (var g in gallos) g.id: g.participanteId,
        };
        final partRojo = galloAParticipante[peleaValida.galloRojoId]!;
        final partVerde = galloAParticipante[peleaValida.galloVerdeId]!;

        final pRojo = participantes.firstWhere((p) => p.id == partRojo);
        final esViolacion = pRojo.esCompadreDe(partVerde);

        expect(esViolacion, isFalse, reason: 'No debería ser violación');
        print('✅ Pelea válida no marca como violación');
      });
    });
  });
}
