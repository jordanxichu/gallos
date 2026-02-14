import 'package:derby_engine/derby_engine.dart';
import 'package:test/test.dart';

void main() {
  group('MatchingValidators', () {
    late ConfiguracionDerby config;
    late List<Participante> participantes;
    late MatchingValidators validators;

    setUp(() {
      config = const ConfiguracionDerby(
        toleranciaPeso: 80,
        evitarCompadres: true,
      );

      participantes = [
        Participante(id: 'p1', nombre: 'Rancho A'),
        Participante(id: 'p2', nombre: 'Rancho B'),
        Participante(id: 'p3', nombre: 'Rancho C', compadres: ['p1']),
      ];

      validators = MatchingValidators(
        configuracion: config,
        participantes: participantes,
      );
    });

    test('cumplePeso aprueba diferencia dentro de tolerancia', () {
      final g1 = Gallo(
        id: 'g1',
        participanteId: 'p1',
        peso: 2100,
        anillo: '001',
      );
      final g2 = Gallo(
        id: 'g2',
        participanteId: 'p2',
        peso: 2150,
        anillo: '002',
      );

      expect(validators.cumplePeso(g1, g2), isTrue);
    });

    test('cumplePeso rechaza diferencia mayor a tolerancia', () {
      final g1 = Gallo(
        id: 'g1',
        participanteId: 'p1',
        peso: 2100,
        anillo: '001',
      );
      final g2 = Gallo(
        id: 'g2',
        participanteId: 'p2',
        peso: 2200,
        anillo: '002',
      );

      expect(validators.cumplePeso(g1, g2), isFalse);
    });

    test('distintoParticipante funciona correctamente', () {
      final g1 = Gallo(
        id: 'g1',
        participanteId: 'p1',
        peso: 2100,
        anillo: '001',
      );
      final g2 = Gallo(
        id: 'g2',
        participanteId: 'p1',
        peso: 2150,
        anillo: '002',
      );
      final g3 = Gallo(
        id: 'g3',
        participanteId: 'p2',
        peso: 2150,
        anillo: '003',
      );

      expect(validators.distintoParticipante(g1, g2), isFalse);
      expect(validators.distintoParticipante(g1, g3), isTrue);
    });

    test('sonCompadres detecta relación de compadrazgo', () {
      final g1 = Gallo(
        id: 'g1',
        participanteId: 'p1',
        peso: 2100,
        anillo: '001',
      );
      final g2 = Gallo(
        id: 'g2',
        participanteId: 'p3',
        peso: 2150,
        anillo: '002',
      );
      final g3 = Gallo(
        id: 'g3',
        participanteId: 'p2',
        peso: 2150,
        anillo: '003',
      );

      // p3 tiene a p1 como compadre
      expect(validators.sonCompadres(g1, g2), isTrue);
      expect(validators.sonCompadres(g1, g3), isFalse);
    });

    test('yaSeEnfrentaron detecta historial', () {
      final g1 = Gallo(
        id: 'g1',
        participanteId: 'p1',
        peso: 2100,
        anillo: '001',
      );
      final g2 = Gallo(
        id: 'g2',
        participanteId: 'p2',
        peso: 2150,
        anillo: '002',
      );

      final historial = <String>{'g1-g2'};

      expect(validators.yaSeEnfrentaron(g1, g2, historial), isTrue);
      expect(validators.yaSeEnfrentaron(g1, g2, <String>{}), isFalse);
    });

    test('emparejamientoValido valida todas las restricciones', () {
      final g1 = Gallo(
        id: 'g1',
        participanteId: 'p1',
        peso: 2100,
        anillo: '001',
      );
      final g2 = Gallo(
        id: 'g2',
        participanteId: 'p2',
        peso: 2150,
        anillo: '002',
      );

      expect(validators.emparejamientoValido(g1, g2, <String>{}), isTrue);
    });

    test('normalizarPar siempre devuelve mismo formato', () {
      expect(MatchingValidators.normalizarPar('a', 'b'), equals('a-b'));
      expect(MatchingValidators.normalizarPar('b', 'a'), equals('a-b'));
    });
  });

  group('MatchingAlgorithm', () {
    test('genera ronda con emparejamientos válidos', () {
      final config = const ConfiguracionDerby(toleranciaPeso: 100);
      final participantes = [
        Participante(id: 'p1', nombre: 'A'),
        Participante(id: 'p2', nombre: 'B'),
      ];
      final gallos = [
        Gallo(id: 'g1', participanteId: 'p1', peso: 2100, anillo: '001'),
        Gallo(id: 'g2', participanteId: 'p2', peso: 2120, anillo: '002'),
        Gallo(id: 'g3', participanteId: 'p1', peso: 2150, anillo: '003'),
        Gallo(id: 'g4', participanteId: 'p2', peso: 2170, anillo: '004'),
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

      expect(resultado.peleas.length, equals(2));
      expect(resultado.sinCotejo, isEmpty);
    });

    test('no empareja gallos del mismo participante', () {
      final config = const ConfiguracionDerby(toleranciaPeso: 100);
      final participantes = [Participante(id: 'p1', nombre: 'A')];
      final gallos = [
        Gallo(id: 'g1', participanteId: 'p1', peso: 2100, anillo: '001'),
        Gallo(id: 'g2', participanteId: 'p1', peso: 2120, anillo: '002'),
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

      expect(resultado.peleas, isEmpty);
      expect(resultado.sinCotejo.length, equals(2));
    });

    test('no repite enfrentamientos históricos', () {
      final config = const ConfiguracionDerby(toleranciaPeso: 100);
      final participantes = [
        Participante(id: 'p1', nombre: 'A'),
        Participante(id: 'p2', nombre: 'B'),
      ];
      final gallos = [
        Gallo(id: 'g1', participanteId: 'p1', peso: 2100, anillo: '001'),
        Gallo(id: 'g2', participanteId: 'p2', peso: 2120, anillo: '002'),
      ];

      final algorithm = MatchingAlgorithm(
        configuracion: config,
        participantes: participantes,
      );

      // Ya se enfrentaron
      final historial = <String>{'g1-g2'};

      final resultado = algorithm.generarRonda(
        gallos: gallos,
        historial: historial,
        numeroRonda: 2,
      );

      expect(resultado.peleas, isEmpty);
    });
  });

  group('RoundGenerator', () {
    late ConfiguracionDerby config;
    late List<Participante> participantes;
    late List<Gallo> gallos;

    setUp(() {
      config = const ConfiguracionDerby(toleranciaPeso: 100, numeroRondas: 3);

      participantes = List.generate(
        6,
        (i) => Participante(id: 'p$i', nombre: 'Rancho $i'),
      );

      // 2 gallos por participante = 12 gallos
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
    });

    test('genera múltiples rondas sin repetir enfrentamientos', () {
      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );

      final resultado = generator.generarRondas(gallos: gallos);

      expect(resultado.rondas.length, equals(3));

      // Verificar que no hay enfrentamientos repetidos
      final todosLosEnfrentamientos = <String>{};
      for (final ronda in resultado.rondas) {
        for (final pelea in ronda.peleas) {
          final par = MatchingValidators.normalizarPar(
            pelea.galloRojoId,
            pelea.galloVerdeId,
          );
          expect(
            todosLosEnfrentamientos.contains(par),
            isFalse,
            reason: 'Enfrentamiento repetido: $par',
          );
          todosLosEnfrentamientos.add(par);
        }
      }
    });

    test('valida rondas correctamente', () {
      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );

      final resultado = generator.generarRondas(gallos: gallos);
      final validacion = generator.validarRondas(resultado.rondas);

      expect(validacion.esValido, isTrue);
    });

    test('genera ronda adicional respetando historial', () {
      final generator = RoundGenerator(
        configuracion: config,
        participantes: participantes,
      );

      // Generar 2 rondas iniciales
      final resultado = generator.generarRondas(
        gallos: gallos,
        numeroRondas: 2,
      );

      // Generar ronda adicional
      final rondaAdicional = generator.generarRondaAdicional(
        gallos: gallos,
        rondasPrevias: resultado.rondas,
      );

      expect(rondaAdicional.numero, equals(3));

      // Verificar que no repite enfrentamientos
      final historial = <String>{};
      for (final ronda in resultado.rondas) {
        for (final pelea in ronda.peleas) {
          historial.add(
            MatchingValidators.normalizarPar(
              pelea.galloRojoId,
              pelea.galloVerdeId,
            ),
          );
        }
      }

      for (final pelea in rondaAdicional.peleas) {
        final par = MatchingValidators.normalizarPar(
          pelea.galloRojoId,
          pelea.galloVerdeId,
        );
        expect(historial.contains(par), isFalse);
      }
    });
  });
}
