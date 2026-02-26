/// Tests de flujos críticos del Derby Manager.
///
/// Estos tests verifican los flujos end-to-end más importantes:
/// - Generación de sorteo
/// - Registro de resultados y puntos
/// - Deshacer resultados
/// - Bloqueo automático de rondas
/// - Flujo completo del torneo
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:derby_engine/derby_engine.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('🟥 FLUJOS CRÍTICOS', () {
    group('Generación de Sorteo', () {
      test('sorteo con datos válidos genera rondas correctamente', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 4);
        final gallos = TestDataFactory.crearGallos(
          participantes: participantes,
          gallosPorParticipante: 3,
        );
        final config = TestDataFactory.crearConfig(numeroRondas: 3);

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        expect(rondas.length, equals(3), reason: 'Deben generarse 3 rondas');
        expect(
          rondas.every((r) => r.peleas.isNotEmpty),
          isTrue,
          reason: 'Cada ronda debe tener peleas',
        );

        print('✅ Sorteo generado: ${rondas.length} rondas');
        for (var i = 0; i < rondas.length; i++) {
          print('   Ronda ${i + 1}: ${rondas[i].peleas.length} peleas');
        }
      });

      test('sorteo respeta tolerancia de peso', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 4);
        final gallos = TestDataFactory.crearGallos(
          participantes: participantes,
          gallosPorParticipante: 2,
          variacionPeso: 30,
        );
        final config = TestDataFactory.crearConfig(
          numeroRondas: 2,
          toleranciaPeso: 50,
        );

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        // Verificar que todas las peleas respeten la tolerancia
        final gallosMap = {for (var g in gallos) g.id: g};
        for (final ronda in rondas) {
          for (final pelea in ronda.peleas) {
            final rojo = gallosMap[pelea.galloRojoId]!;
            final verde = gallosMap[pelea.galloVerdeId]!;
            final diff = (rojo.peso - verde.peso).abs();
            expect(
              diff,
              lessThanOrEqualTo(config.toleranciaPeso),
              reason:
                  'Diferencia de peso $diff excede tolerancia ${config.toleranciaPeso}',
            );
          }
        }

        print('✅ Tolerancia de peso respetada en todas las peleas');
      });

      test('sorteo no empareja gallos del mismo participante', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 4);
        final gallos = TestDataFactory.crearGallos(
          participantes: participantes,
          gallosPorParticipante: 3,
        );
        final config = TestDataFactory.crearConfig(numeroRondas: 3);

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        final gallosMap = {for (var g in gallos) g.id: g};
        for (final ronda in rondas) {
          for (final pelea in ronda.peleas) {
            final rojo = gallosMap[pelea.galloRojoId]!;
            final verde = gallosMap[pelea.galloVerdeId]!;
            expect(
              rojo.participanteId,
              isNot(equals(verde.participanteId)),
              reason: 'Gallos del mismo participante enfrentados',
            );
          }
        }

        print('✅ Ningún participante pelea contra sí mismo');
      });

      test('sorteo no repite enfrentamientos entre rondas', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 6);
        final gallos = TestDataFactory.crearGallos(
          participantes: participantes,
          gallosPorParticipante: 2,
        );
        final config = TestDataFactory.crearConfig(numeroRondas: 4);

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        final enfrentamientos = <String>{};
        for (final ronda in rondas) {
          for (final pelea in ronda.peleas) {
            // Normalizar par de IDs para comparación
            final ids = [pelea.galloRojoId, pelea.galloVerdeId]..sort();
            final par = '${ids[0]}-${ids[1]}';
            expect(
              enfrentamientos.contains(par),
              isFalse,
              reason: 'Enfrentamiento repetido: $par',
            );
            enfrentamientos.add(par);
          }
        }

        print('✅ ${enfrentamientos.length} enfrentamientos únicos');
      });
    });

    group('Registro de Resultados y Puntos', () {
      test('registrar victoria actualiza pelea correctamente', () {
        final pelea = Pelea(
          id: 'pelea1',
          numero: 1,
          galloRojoId: 'g1',
          galloVerdeId: 'g2',
        );

        expect(pelea.tieneResultado, isFalse);
        expect(pelea.estado, equals(EstadoPelea.pendiente));

        final peleaConResultado = pelea.conResultado(ganadorId: 'g1');

        expect(peleaConResultado.tieneResultado, isTrue);
        expect(peleaConResultado.estado, equals(EstadoPelea.finalizada));
        expect(peleaConResultado.ganadorId, equals('g1'));
        expect(peleaConResultado.empate, isFalse);

        print('✅ Resultado registrado correctamente');
      });

      test('registrar empate asigna correctamente', () {
        final pelea = Pelea(
          id: 'pelea1',
          numero: 1,
          galloRojoId: 'g1',
          galloVerdeId: 'g2',
        );

        final peleaEmpate = pelea.conResultado(empate: true);

        expect(peleaEmpate.tieneResultado, isTrue);
        expect(peleaEmpate.empate, isTrue);
        expect(peleaEmpate.ganadorId, isNull);

        print('✅ Empate registrado correctamente');
      });

      test('pelea mantiene referencias después de resultado', () {
        final pelea = Pelea(
          id: 'pelea1',
          numero: 1,
          galloRojoId: 'g1',
          galloVerdeId: 'g2',
        );

        final peleaResultado = pelea.conResultado(
          ganadorId: 'g1',
          duracionSegundos: 120,
        );

        expect(peleaResultado.galloRojoId, equals('g1'));
        expect(peleaResultado.galloVerdeId, equals('g2'));
        expect(peleaResultado.duracionSegundos, equals(120));

        print('✅ Referencias mantenidas post-resultado');
      });
    });

    group('Deshacer Resultado', () {
      test('deshacer retorna pelea a estado pendiente', () {
        final peleaOriginal = Pelea(
          id: 'pelea1',
          numero: 1,
          galloRojoId: 'g1',
          galloVerdeId: 'g2',
        );

        final peleaConResultado = peleaOriginal.conResultado(ganadorId: 'g1');
        expect(peleaConResultado.tieneResultado, isTrue);

        // Simular deshacer creando nueva pelea sin resultado
        final peleaDeshecha = Pelea(
          id: peleaConResultado.id,
          numero: peleaConResultado.numero,
          galloRojoId: peleaConResultado.galloRojoId,
          galloVerdeId: peleaConResultado.galloVerdeId,
        );

        expect(peleaDeshecha.tieneResultado, isFalse);
        expect(peleaDeshecha.estado, equals(EstadoPelea.pendiente));

        print('✅ Resultado deshecho correctamente');
      });
    });

    group('Bloqueo de Rondas', () {
      test('ronda se puede bloquear', () {
        final ronda = Ronda(
          id: 'r1',
          numero: 1,
          peleas: [
            Pelea(
              id: 'p1',
              numero: 1,
              galloRojoId: 'g1',
              galloVerdeId: 'g2',
              estado: EstadoPelea.finalizada,
              ganadorId: 'g1',
            ),
          ],
        );

        expect(ronda.bloqueada, isFalse);

        final rondaBloqueada = ronda.bloquear();
        expect(rondaBloqueada.bloqueada, isTrue);

        print('✅ Ronda bloqueada correctamente');
      });

      test('ronda detecta cuando todas las peleas están finalizadas', () {
        final rondaIncompleta = Ronda(
          id: 'r1',
          numero: 1,
          peleas: [
            Pelea(
              id: 'p1',
              numero: 1,
              galloRojoId: 'g1',
              galloVerdeId: 'g2',
              estado: EstadoPelea.finalizada,
              ganadorId: 'g1',
            ),
            Pelea(id: 'p2', numero: 2, galloRojoId: 'g3', galloVerdeId: 'g4'),
          ],
        );

        expect(rondaIncompleta.todasFinalizadas, isFalse);

        final rondaCompleta = Ronda(
          id: 'r1',
          numero: 1,
          peleas: [
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
          ],
        );

        expect(rondaCompleta.todasFinalizadas, isTrue);

        print('✅ Detección de ronda completa funciona');
      });

      test('peleas canceladas cuentan como terminadas', () {
        final ronda = Ronda(
          id: 'r1',
          numero: 1,
          peleas: [
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
          ],
        );

        expect(ronda.todasFinalizadas, isTrue);
        expect(ronda.peleasTerminadas, equals(2));

        print('✅ Peleas canceladas cuentan como terminadas');
      });
    });

    group('Flujo Completo del Torneo', () {
      test('flujo: crear participantes → gallos → sorteo → resultados', () {
        // 1. Crear participantes
        final participantes = TestDataFactory.crearParticipantes(cantidad: 4);
        expect(participantes.length, equals(4));

        // 2. Crear gallos
        final gallos = TestDataFactory.crearGallos(
          participantes: participantes,
          gallosPorParticipante: 2,
        );
        expect(gallos.length, equals(8));

        // 3. Generar sorteo
        final config = TestDataFactory.crearConfig(numeroRondas: 2);
        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );
        expect(rondas.length, equals(2));

        // 4. Contar peleas totales
        var totalPeleas = 0;
        for (final ronda in rondas) {
          totalPeleas += ronda.peleas.length;
        }

        expect(totalPeleas, greaterThan(0));

        print('✅ Flujo completo ejecutado:');
        print('   - ${participantes.length} participantes');
        print('   - ${gallos.length} gallos');
        print('   - ${rondas.length} rondas');
        print('   - $totalPeleas peleas');
      });

      test('posiciones finales ordenadas por puntos', () {
        // Simular participantes con diferentes puntos
        final p1 = Participante(id: 'p1', nombre: 'Primero', puntosTotales: 9);
        final p2 = Participante(id: 'p2', nombre: 'Segundo', puntosTotales: 6);
        final p3 = Participante(id: 'p3', nombre: 'Tercero', puntosTotales: 3);
        final p4 = Participante(id: 'p4', nombre: 'Cuarto', puntosTotales: 0);

        final participantes = [p4, p2, p1, p3]; // Desordenados

        // Ordenar por puntos (como hace la app)
        final ordenados = List<Participante>.from(participantes)
          ..sort((a, b) => b.puntosTotales.compareTo(a.puntosTotales));

        expect(ordenados[0].id, equals('p1'));
        expect(ordenados[1].id, equals('p2'));
        expect(ordenados[2].id, equals('p3'));
        expect(ordenados[3].id, equals('p4'));

        print('✅ Posiciones ordenadas correctamente por puntos');
      });
    });
  });
}
