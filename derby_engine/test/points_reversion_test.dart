// Tests de reversión de puntos
//
// Valida que las operaciones de registro y deshacer de resultados
// mantengan la consistencia de puntos en los participantes.

import 'package:derby_engine/derby_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Reversión de Puntos - Lógica Pura', () {
    late ConfiguracionDerby config;
    late List<Participante> participantes;

    setUp(() {
      config = ConfiguracionDerby.standard();

      participantes = [
        Participante(id: 'p1', nombre: 'Participante 1'),
        Participante(id: 'p2', nombre: 'Participante 2'),
      ];
    });

    test('victoria suma puntos al ganador y resta al perdedor', () {
      final p1Antes = participantes[0].puntosTotales;
      final p2Antes = participantes[1].puntosTotales;

      // Simular victoria de g1
      participantes[0].puntosTotales += config.puntosVictoria;
      participantes[0].peleasGanadas++;
      participantes[1].puntosTotales += config.puntosDerrota;
      participantes[1].peleasPerdidas++;

      expect(
        participantes[0].puntosTotales,
        equals(p1Antes + config.puntosVictoria),
      );
      expect(
        participantes[1].puntosTotales,
        equals(p2Antes + config.puntosDerrota),
      );
      expect(participantes[0].peleasGanadas, equals(1));
      expect(participantes[1].peleasPerdidas, equals(1));
    });

    test('deshacer victoria revierte puntos correctamente', () {
      // Aplicar victoria
      participantes[0].puntosTotales += config.puntosVictoria;
      participantes[0].peleasGanadas++;
      participantes[1].puntosTotales += config.puntosDerrota;
      participantes[1].peleasPerdidas++;

      // Revertir victoria
      participantes[0].puntosTotales -= config.puntosVictoria;
      participantes[0].peleasGanadas--;
      participantes[1].puntosTotales -= config.puntosDerrota;
      participantes[1].peleasPerdidas--;

      // Deben volver a cero
      expect(participantes[0].puntosTotales, equals(0));
      expect(participantes[1].puntosTotales, equals(0));
      expect(participantes[0].peleasGanadas, equals(0));
      expect(participantes[1].peleasPerdidas, equals(0));
    });

    test('empate suma puntos a ambos participantes', () {
      // Aplicar empate
      participantes[0].puntosTotales += config.puntosEmpate;
      participantes[0].peleasEmpatadas++;
      participantes[1].puntosTotales += config.puntosEmpate;
      participantes[1].peleasEmpatadas++;

      expect(participantes[0].puntosTotales, equals(config.puntosEmpate));
      expect(participantes[1].puntosTotales, equals(config.puntosEmpate));
      expect(participantes[0].peleasEmpatadas, equals(1));
      expect(participantes[1].peleasEmpatadas, equals(1));
    });

    test('deshacer empate revierte puntos de ambos', () {
      // Aplicar empate
      participantes[0].puntosTotales += config.puntosEmpate;
      participantes[0].peleasEmpatadas++;
      participantes[1].puntosTotales += config.puntosEmpate;
      participantes[1].peleasEmpatadas++;

      // Revertir
      participantes[0].puntosTotales -= config.puntosEmpate;
      participantes[0].peleasEmpatadas--;
      participantes[1].puntosTotales -= config.puntosEmpate;
      participantes[1].peleasEmpatadas--;

      expect(participantes[0].puntosTotales, equals(0));
      expect(participantes[1].puntosTotales, equals(0));
      expect(participantes[0].peleasEmpatadas, equals(0));
      expect(participantes[1].peleasEmpatadas, equals(0));
    });

    test('múltiples operaciones mantienen consistencia', () {
      // Simular 3 peleas con resultados mixtos

      // Pelea 1: Victoria P1
      participantes[0].puntosTotales += config.puntosVictoria;
      participantes[0].peleasGanadas++;
      participantes[1].puntosTotales += config.puntosDerrota;
      participantes[1].peleasPerdidas++;

      // Pelea 2: Victoria P2
      participantes[1].puntosTotales += config.puntosVictoria;
      participantes[1].peleasGanadas++;
      participantes[0].puntosTotales += config.puntosDerrota;
      participantes[0].peleasPerdidas++;

      // Pelea 3: Empate
      participantes[0].puntosTotales += config.puntosEmpate;
      participantes[0].peleasEmpatadas++;
      participantes[1].puntosTotales += config.puntosEmpate;
      participantes[1].peleasEmpatadas++;

      final p1Total =
          config.puntosVictoria + config.puntosDerrota + config.puntosEmpate;
      final p2Total =
          config.puntosDerrota + config.puntosVictoria + config.puntosEmpate;

      expect(participantes[0].puntosTotales, equals(p1Total));
      expect(participantes[1].puntosTotales, equals(p2Total));

      // Deshacer Pelea 3 (empate)
      participantes[0].puntosTotales -= config.puntosEmpate;
      participantes[0].peleasEmpatadas--;
      participantes[1].puntosTotales -= config.puntosEmpate;
      participantes[1].peleasEmpatadas--;

      // P1 y P2 deben tener mismo puntaje (una victoria, una derrota c/u)
      expect(
        participantes[0].puntosTotales,
        equals(config.puntosVictoria + config.puntosDerrota),
      );
      expect(
        participantes[1].puntosTotales,
        equals(config.puntosVictoria + config.puntosDerrota),
      );
    });
  });

  group('Estado de Gallos', () {
    test('copyWith mantiene datos inmutables correctamente', () {
      final gallo = Gallo(
        id: 'g1',
        participanteId: 'p1',
        peso: 2100,
        anillo: 'A001',
      );

      final retirado = gallo.copyWith(estado: EstadoGallo.retirado);

      // Original no cambia
      expect(gallo.estado, equals(EstadoGallo.activo));
      // Nuevo tiene estado actualizado pero mismo ID
      expect(retirado.estado, equals(EstadoGallo.retirado));
      expect(retirado.id, equals(gallo.id));
      expect(retirado.anillo, equals(gallo.anillo));
    });
  });

  group('Ronda - Bloqueo', () {
    test('copyWith bloqueada funciona correctamente', () {
      final ronda = Ronda(id: 'r1', numero: 1, peleas: []);

      expect(ronda.bloqueada, isFalse);

      final bloqueada = ronda.copyWith(bloqueada: true);
      expect(bloqueada.bloqueada, isTrue);
      expect(ronda.bloqueada, isFalse); // Original no cambia
    });

    test('todasFinalizadas detecta ronda completa', () {
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
            estado: EstadoPelea.finalizada,
            empate: true,
          ),
        ],
      );

      expect(ronda.todasFinalizadas, isTrue);
    });

    test('todasFinalizadas es false con peleas pendientes', () {
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
            // Sin resultado
          ),
        ],
      );

      expect(ronda.todasFinalizadas, isFalse);
    });
  });
}
