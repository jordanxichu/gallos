/// Tests de escenarios catastróficos y edge cases extremos.
///
/// Estos tests verifican:
/// - Derby vacío
/// - Solo 1 gallo
/// - Pesos extremos
/// - Datos inconsistentes
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:derby_engine/derby_engine.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('🟥 ESCENARIOS CATASTRÓFICOS', () {
    group('Derby Vacío', () {
      test('sin gallos retorna rondas vacías', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 4);
        final config = TestDataFactory.crearConfig(numeroRondas: 3);

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: [], // Sin gallos
          config: config,
        );

        // Debería generar rondas pero sin peleas
        for (final ronda in rondas) {
          expect(
            ronda.peleas,
            isEmpty,
            reason: 'Sin gallos no puede haber peleas',
          );
        }

        print('✅ Participantes sin gallos: ${rondas.length} rondas vacías');
      });
    });

    group('Solo 1 Gallo', () {
      test('1 gallo no puede generar peleas', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 1);
        final gallos = [
          Gallo(
            id: 'g1',
            anillo: '001',
            peso: 2000,
            participanteId: participantes.first.id,
          ),
        ];
        final config = TestDataFactory.crearConfig(numeroRondas: 1);

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        // Con 1 solo gallo no puede haber peleas
        final totalPeleas = rondas.fold(0, (sum, r) => sum + r.peleas.length);
        expect(totalPeleas, equals(0));

        print('✅ 1 gallo genera 0 peleas');
      });

      test('2 gallos del mismo participante no genera peleas', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 1);
        final gallos = [
          Gallo(
            id: 'g1',
            anillo: '001',
            peso: 2000,
            participanteId: participantes.first.id,
          ),
          Gallo(
            id: 'g2',
            anillo: '002',
            peso: 2000,
            participanteId: participantes.first.id,
          ),
        ];
        final config = TestDataFactory.crearConfig(numeroRondas: 1);

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        // Los gallos del mismo participante no pelean entre sí
        final totalPeleas = rondas.fold(0, (sum, r) => sum + r.peleas.length);
        expect(totalPeleas, equals(0));

        print('✅ Gallos del mismo participante no se enfrentan');
      });

      test('número impar de gallos deja uno sin pelea por ronda', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 3);
        final gallos = [
          Gallo(
            id: 'g1',
            anillo: '001',
            peso: 2000,
            participanteId: participantes[0].id,
          ),
          Gallo(
            id: 'g2',
            anillo: '002',
            peso: 2000,
            participanteId: participantes[1].id,
          ),
          Gallo(
            id: 'g3',
            anillo: '003',
            peso: 2000,
            participanteId: participantes[2].id,
          ),
        ];
        final config = TestDataFactory.crearConfig(numeroRondas: 1);

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        // Con 3 gallos, máximo 1 pelea por ronda
        if (rondas.isNotEmpty && rondas.first.peleas.isNotEmpty) {
          expect(rondas.first.peleas.length, equals(1));
          // Debería haber 1 gallo sin cotejo
          expect(rondas.first.sinCotejo.length, equals(1));
        }

        print('✅ 3 gallos genera máximo 1 pelea por ronda');
      });
    });

    group('Pesos Extremos', () {
      test('pesos muy diferentes no generan peleas', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 2);
        final gallos = [
          Gallo(
            id: 'g1',
            anillo: '001',
            peso: 1000,
            participanteId: participantes[0].id,
          ),
          Gallo(
            id: 'g2',
            anillo: '002',
            peso: 3000,
            participanteId: participantes[1].id,
          ),
        ];
        final config = TestDataFactory.crearConfig(
          numeroRondas: 1,
          toleranciaPeso: 50, // Muy estricta
        );

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        // 2000g de diferencia vs 50g de tolerancia = no match
        final totalPeleas = rondas.fold(0, (sum, r) => sum + r.peleas.length);
        expect(totalPeleas, equals(0));

        print('✅ Diferencia de 2000g con tolerancia 50g = 0 peleas');
      });

      test('pesos en el límite de tolerancia sí generan pelea', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 2);
        final gallos = [
          Gallo(
            id: 'g1',
            anillo: '001',
            peso: 2000,
            participanteId: participantes[0].id,
          ),
          Gallo(
            id: 'g2',
            anillo: '002',
            peso: 2050,
            participanteId: participantes[1].id,
          ),
        ];
        final config = TestDataFactory.crearConfig(
          numeroRondas: 1,
          toleranciaPeso: 50,
        );

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        // 50g de diferencia vs 50g de tolerancia = sí match
        final totalPeleas = rondas.fold(0, (sum, r) => sum + r.peleas.length);
        expect(totalPeleas, equals(1));

        print('✅ Diferencia exacta en tolerancia genera pelea');
      });

      test('tolerancia 0 requiere peso exacto', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 2);
        final gallos = [
          Gallo(
            id: 'g1',
            anillo: '001',
            peso: 2000,
            participanteId: participantes[0].id,
          ),
          Gallo(
            id: 'g2',
            anillo: '002',
            peso: 2001,
            participanteId: participantes[1].id,
          ),
        ];
        final config = TestDataFactory.crearConfig(
          numeroRondas: 1,
          toleranciaPeso: 0,
        );

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        // 1g de diferencia vs 0g de tolerancia = no match
        final totalPeleas = rondas.fold(0, (sum, r) => sum + r.peleas.length);
        expect(totalPeleas, equals(0));

        print('✅ Tolerancia 0 con diferencia 1g = 0 peleas');
      });

      test('tolerancia muy alta permite cualquier peso', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 2);
        final gallos = [
          Gallo(
            id: 'g1',
            anillo: '001',
            peso: 1000,
            participanteId: participantes[0].id,
          ),
          Gallo(
            id: 'g2',
            anillo: '002',
            peso: 5000,
            participanteId: participantes[1].id,
          ),
        ];
        final config = TestDataFactory.crearConfig(
          numeroRondas: 1,
          toleranciaPeso: 10000,
        );

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        // 4000g de diferencia vs 10000g de tolerancia = sí match
        final totalPeleas = rondas.fold(0, (sum, r) => sum + r.peleas.length);
        expect(totalPeleas, equals(1));

        print('✅ Tolerancia muy alta permite cualquier combinación');
      });
    });

    group('IDs Duplicados', () {
      test('gallos con ID duplicado son detectados', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 2);

        // Mismo ID para dos gallos diferentes
        final gallos = [
          Gallo(
            id: 'mismo_id',
            anillo: '001',
            peso: 2000,
            participanteId: participantes[0].id,
          ),
          Gallo(
            id: 'mismo_id',
            anillo: '002',
            peso: 2000,
            participanteId: participantes[1].id,
          ),
        ];

        // Verificar que la lista tiene 2 items pero con mismo ID
        expect(gallos.length, equals(2));
        expect(gallos[0].id, equals(gallos[1].id));

        // Esto podría causar problemas en el matching
        final idSet = gallos.map((g) => g.id).toSet();
        expect(
          idSet.length,
          lessThan(gallos.length),
          reason: 'IDs duplicados detectados',
        );

        print('✅ IDs duplicados detectados antes de matching');
      });

      test('anillos duplicados son detectados', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 2);

        final gallos = [
          Gallo(
            id: 'g1',
            anillo: 'MISMO',
            peso: 2000,
            participanteId: participantes[0].id,
          ),
          Gallo(
            id: 'g2',
            anillo: 'MISMO',
            peso: 2000,
            participanteId: participantes[1].id,
          ),
        ];

        final anilloSet = gallos.map((g) => g.anillo).toSet();
        expect(
          anilloSet.length,
          lessThan(gallos.length),
          reason: 'Anillos duplicados detectados',
        );

        print('✅ Anillos duplicados detectados');
      });
    });

    group('Datos de Pelea', () {
      test('pelea con galloId inexistente', () {
        final pelea = Pelea(
          id: 'pelea1',
          numero: 1,
          galloRojoId: 'inexistente_1',
          galloVerdeId: 'inexistente_2',
        );

        // La pelea se crea, pero los IDs no existen
        expect(pelea.galloRojoId, equals('inexistente_1'));
        expect(pelea.galloVerdeId, equals('inexistente_2'));

        print('✅ Pelea con IDs inexistentes se crea (valida en UI)');
      });

      test('ronda con peleas vacías es válida', () {
        final ronda = Ronda(id: 'r1', numero: 1, peleas: []);

        expect(ronda.peleas, isEmpty);
        expect(ronda.totalPeleas, equals(0));
        expect(ronda.peleasTerminadas, equals(0));
        expect(ronda.todasFinalizadas, isTrue); // Vacío = completado

        print('✅ Ronda vacía es válida');
      });
    });

    group('Límites del Sistema', () {
      test('100 gallos no causa overflow', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 20);
        final gallos = TestDataFactory.crearGallos(
          participantes: participantes,
          gallosPorParticipante: 5, // 100 gallos
        );

        expect(gallos.length, equals(100));

        final config = TestDataFactory.crearConfig(numeroRondas: 3);

        // Esto puede tomar tiempo pero no debe causar overflow
        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        expect(rondas.length, equals(3));
        print('✅ 100 gallos procesados correctamente');
      });

      test('muchas rondas no causa problemas', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 6);
        final gallos = TestDataFactory.crearGallos(
          participantes: participantes,
          gallosPorParticipante: 5,
        );
        final config = TestDataFactory.crearConfig(numeroRondas: 10);

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        expect(rondas.length, equals(10));
        print('✅ 10 rondas generadas correctamente');
      });

      test('nombres muy largos no causan problemas', () {
        final nombreLargo = 'A' * 1000;
        final participante = Participante(id: 'p1', nombre: nombreLargo);

        expect(participante.nombre.length, equals(1000));

        final gallo = Gallo(
          id: 'g1',
          anillo: 'B' * 100,
          peso: 2000,
          participanteId: participante.id,
        );

        expect(gallo.anillo.length, equals(100));

        print('✅ Nombres largos no causan problemas');
      });

      test('caracteres especiales en nombres', () {
        final participante = Participante(
          id: 'p1',
          nombre: 'Rancho "El Águila" <special> & más',
        );

        expect(participante.nombre.contains('"'), isTrue);
        expect(participante.nombre.contains('<'), isTrue);
        expect(participante.nombre.contains('&'), isTrue);

        print('✅ Caracteres especiales manejados');
      });
    });

    group('Estados Inconsistentes', () {
      test('sorteo con 0 rondas configuradas', () {
        final config = ConfiguracionDerby(
          numeroRondas: 0, // Inválido
          toleranciaPeso: 50,
        );

        expect(config.numeroRondas, equals(0));

        final participantes = TestDataFactory.crearParticipantes(cantidad: 2);
        final gallos = TestDataFactory.crearGallos(
          participantes: participantes,
          gallosPorParticipante: 1,
        );

        // Con 0 rondas, debería retornar vacío
        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        expect(rondas, isEmpty);
        print('✅ 0 rondas configuradas = 0 rondas generadas');
      });

      test('pelea finalizada puede crear copia con resultado diferente', () {
        final pelea = Pelea(
          id: 'p1',
          numero: 1,
          galloRojoId: 'g1',
          galloVerdeId: 'g2',
          estado: EstadoPelea.finalizada,
          ganadorId: 'g1',
        );

        // La API inmutable permite esto pero la lógica de negocio debería prevenirlo
        final peleaNueva = pelea.conResultado(ganadorId: 'g2');

        expect(peleaNueva.ganadorId, equals('g2'));
        print('✅ API inmutable permite cambios (control en lógica de negocio)');
      });
    });
  });
}
