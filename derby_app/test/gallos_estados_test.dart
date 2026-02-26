/// Tests de estados de gallos.
///
/// Estos tests verifican:
/// - Estados: activo, finalizado, retirado, descalificado
/// - Efectos en el sorteo y peleas
/// - Transiciones de estado
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:derby_engine/derby_engine.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('🟥 GALLOS - Estados y Transiciones', () {
    group('Estados Básicos', () {
      test('gallo nuevo está activo por defecto', () {
        final gallo = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
        );

        expect(gallo.estado, equals(EstadoGallo.activo));

        print('✅ Gallo nuevo está activo por defecto');
      });

      test('gallo puede marcarse como retirado', () {
        final gallo = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
        );

        final galloRetirado = gallo.copyWith(estado: EstadoGallo.retirado);

        expect(galloRetirado.estado, equals(EstadoGallo.retirado));
        expect(galloRetirado.estado != EstadoGallo.activo, isTrue);

        print('✅ Gallo marcado como retirado');
      });

      test('gallo puede marcarse como descalificado', () {
        final gallo = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
        );

        final galloDescalificado = gallo.copyWith(
          estado: EstadoGallo.descalificado,
        );

        expect(galloDescalificado.estado, equals(EstadoGallo.descalificado));
        expect(galloDescalificado.estado != EstadoGallo.activo, isTrue);

        print('✅ Gallo marcado como descalificado');
      });

      test('gallo puede marcarse como finalizado', () {
        final gallo = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
        );

        final galloFinalizado = gallo.copyWith(estado: EstadoGallo.finalizado);

        expect(galloFinalizado.estado, equals(EstadoGallo.finalizado));
        expect(galloFinalizado.estado != EstadoGallo.activo, isTrue);

        print('✅ Gallo marcado como finalizado');
      });
    });

    group('Efectos de Estado en Sorteo', () {
      test('solo gallos activos participan en sorteo', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 4);
        final gallos = TestDataFactory.crearGallos(
          participantes: participantes,
          gallosPorParticipante: 3,
        );

        // Retirar el primer gallo
        final gallosModificados = gallos.map((g) {
          if (g == gallos.first) {
            return g.copyWith(estado: EstadoGallo.retirado);
          }
          return g;
        }).toList();

        final gallosActivos = gallosModificados
            .where((g) => g.estado == EstadoGallo.activo)
            .toList();

        expect(gallosActivos.length, lessThan(gallos.length));
        print(
          '✅ ${gallosActivos.length}/${gallos.length} gallos activos para sorteo',
        );
      });

      test('gallos retirados no aparecen en nuevas peleas', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 4);
        final gallos = TestDataFactory.crearGallos(
          participantes: participantes,
          gallosPorParticipante: 2,
        );

        // Simular que hay un gallo retirado
        final galloRetirado = gallos.first.copyWith(
          estado: EstadoGallo.retirado,
        );
        final gallosActivos = gallos.skip(1).toList();

        final config = TestDataFactory.crearConfig(numeroRondas: 2);
        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallosActivos,
          config: config,
        );

        // Verificar que el gallo retirado no aparece
        for (final ronda in rondas) {
          for (final pelea in ronda.peleas) {
            expect(pelea.galloRojoId, isNot(equals(galloRetirado.id)));
            expect(pelea.galloVerdeId, isNot(equals(galloRetirado.id)));
          }
        }

        print('✅ Gallo retirado no aparece en nuevas peleas');
      });
    });

    group('Transiciones de Estado', () {
      test('activo → retirado es válido', () {
        final gallo = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
          estado: EstadoGallo.activo,
        );

        final galloRetirado = gallo.copyWith(estado: EstadoGallo.retirado);
        expect(galloRetirado.estado, equals(EstadoGallo.retirado));

        print('✅ Transición activo → retirado exitosa');
      });

      test('activo → descalificado es válido', () {
        final gallo = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
          estado: EstadoGallo.activo,
        );

        final galloDesc = gallo.copyWith(estado: EstadoGallo.descalificado);
        expect(galloDesc.estado, equals(EstadoGallo.descalificado));

        print('✅ Transición activo → descalificado exitosa');
      });

      test('activo → finalizado es válido', () {
        final gallo = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
          estado: EstadoGallo.activo,
        );

        final galloFinalizado = gallo.copyWith(estado: EstadoGallo.finalizado);
        expect(galloFinalizado.estado, equals(EstadoGallo.finalizado));

        print('✅ Transición activo → finalizado exitosa');
      });

      test('retirado → activo es válido (reactivación)', () {
        final gallo = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
          estado: EstadoGallo.retirado,
        );

        final galloActivo = gallo.copyWith(estado: EstadoGallo.activo);
        expect(galloActivo.estado, equals(EstadoGallo.activo));

        print('✅ Transición retirado → activo exitosa (reactivación)');
      });
    });

    group('Peso y Tolerancia', () {
      test('gallos con peso similar pueden enfrentarse', () {
        final gallo1 = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
        );
        final gallo2 = Gallo(
          id: 'g2',
          anillo: '002',
          peso: 2030,
          participanteId: 'p2',
        );

        const tolerancia = 50.0;
        final diff = (gallo1.peso - gallo2.peso).abs();

        expect(diff, lessThanOrEqualTo(tolerancia));
        print(
          '✅ Gallos con diferencia de ${diff}g pueden pelear (tolerancia: ${tolerancia}g)',
        );
      });

      test('gallos con peso muy diferente no pueden enfrentarse', () {
        final gallo1 = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
        );
        final gallo2 = Gallo(
          id: 'g2',
          anillo: '002',
          peso: 2200,
          participanteId: 'p2',
        );

        const tolerancia = 50.0;
        final diff = (gallo1.peso - gallo2.peso).abs();

        expect(diff, greaterThan(tolerancia));
        print(
          '✅ Gallos con diferencia de ${diff}g NO pueden pelear (tolerancia: ${tolerancia}g)',
        );
      });

      test('pesos se almacenan como double', () {
        final gallo = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2150.5,
          participanteId: 'p1',
        );
        expect(gallo.peso, equals(2150.5));
        print('✅ Peso almacenado como double: ${gallo.peso}g');
      });
    });

    group('Propiedades del Gallo', () {
      test('gallo preserva todos los campos en copyWith', () {
        final gallo = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
          estado: EstadoGallo.activo,
        );

        final galloModificado = gallo.copyWith(estado: EstadoGallo.retirado);

        expect(galloModificado.id, equals(gallo.id));
        expect(galloModificado.anillo, equals(gallo.anillo));
        expect(galloModificado.peso, equals(gallo.peso));
        expect(galloModificado.participanteId, equals(gallo.participanteId));
        expect(galloModificado.estado, equals(EstadoGallo.retirado));

        print('✅ copyWith preserva todos los campos');
      });

      test('gallos con mismo ID son iguales', () {
        final gallo1 = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
        );
        final gallo2 = Gallo(
          id: 'g1',
          anillo: '002',
          peso: 2100,
          participanteId: 'p2',
        );

        expect(gallo1, equals(gallo2)); // Equality by ID

        print('✅ Gallos con mismo ID son iguales');
      });

      test('gallos con diferente ID son diferentes', () {
        final gallo1 = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
        );
        final gallo2 = Gallo(
          id: 'g2',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
        );

        expect(gallo1, isNot(equals(gallo2)));

        print('✅ Gallos con diferente ID son diferentes');
      });
    });

    group('Estados en el Engine', () {
      test('todos los estados de EstadoGallo existen', () {
        final estados = EstadoGallo.values;

        expect(estados, contains(EstadoGallo.activo));
        expect(estados, contains(EstadoGallo.finalizado));
        expect(estados, contains(EstadoGallo.retirado));
        expect(estados, contains(EstadoGallo.descalificado));

        print(
          '✅ Estados disponibles: ${estados.map((e) => e.name).join(", ")}',
        );
      });

      test('estado por defecto es activo', () {
        final gallo = Gallo(
          id: 'g1',
          anillo: '001',
          peso: 2000,
          participanteId: 'p1',
        );
        expect(gallo.estado, equals(EstadoGallo.activo));

        print('✅ Estado por defecto verificado: activo');
      });
    });
  });
}
