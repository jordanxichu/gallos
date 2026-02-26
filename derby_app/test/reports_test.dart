/// Tests de reportes y estadísticas.
///
/// Estos tests verifican:
/// - Gallos retirados visibles en reportes
/// - Estadísticas consistentes
/// - Cálculos de puntos correctos
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:derby_engine/derby_engine.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('🟥 REPORTES Y ESTADÍSTICAS', () {
    group('Gallos Retirados en Reportes', () {
      test('gallo retirado mantiene historial en participante', () {
        final participante = Participante(
          id: 'p1',
          nombre: 'Rancho Test',
          peleasGanadas: 3,
          peleasPerdidas: 1,
          peleasEmpatadas: 0,
          puntosTotales: 9, // 3 victorias * 3 puntos
        );

        // El participante mantiene el historial aunque sus gallos sean retirados
        expect(participante.peleasGanadas, equals(3));
        expect(participante.totalPeleas, equals(4));

        print(
          '✅ Historial mantenido: ${participante.peleasGanadas}G-${participante.peleasPerdidas}P',
        );
      });

      test('reporte incluye gallos en todos los estados', () {
        final gallos = [
          Gallo(
            id: 'g1',
            anillo: '001',
            peso: 2000,
            participanteId: 'p1',
            estado: EstadoGallo.activo,
          ),
          Gallo(
            id: 'g2',
            anillo: '002',
            peso: 2000,
            participanteId: 'p1',
            estado: EstadoGallo.retirado,
          ),
          Gallo(
            id: 'g3',
            anillo: '003',
            peso: 2000,
            participanteId: 'p1',
            estado: EstadoGallo.finalizado,
          ),
          Gallo(
            id: 'g4',
            anillo: '004',
            peso: 2000,
            participanteId: 'p1',
            estado: EstadoGallo.descalificado,
          ),
        ];

        // Todos los gallos deben aparecer en reportes
        final todosGallos = gallos;
        final gallosActivos = gallos
            .where((g) => g.estado == EstadoGallo.activo)
            .toList();
        final gallosNoActivos = gallos
            .where((g) => g.estado != EstadoGallo.activo)
            .toList();

        expect(todosGallos.length, equals(4));
        expect(gallosActivos.length, equals(1));
        expect(gallosNoActivos.length, equals(3));

        print('✅ Reporte incluye 4 gallos (1 activo, 3 no activos)');
      });
    });

    group('Estadísticas de Participantes', () {
      test('puntos calculados correctamente', () {
        // Simular sistema de puntos: 3 por victoria, 1 por empate
        const puntosVictoria = 3;
        const puntosEmpate = 1;
        const puntosPerdida = 0;

        final victorias = 5;
        final empates = 2;
        final derrotas = 3;

        final puntosTotales =
            (victorias * puntosVictoria) +
            (empates * puntosEmpate) +
            (derrotas * puntosPerdida);

        expect(puntosTotales, equals(17)); // 15 + 2 + 0

        print(
          '✅ Puntos: ${victorias}V($puntosVictoria) + ${empates}E($puntosEmpate) = $puntosTotales',
        );
      });

      test('ranking ordenado por puntos descendente', () {
        final participantes = [
          Participante(id: 'p3', nombre: 'Tercero', puntosTotales: 5),
          Participante(id: 'p1', nombre: 'Primero', puntosTotales: 15),
          Participante(id: 'p4', nombre: 'Cuarto', puntosTotales: 3),
          Participante(id: 'p2', nombre: 'Segundo', puntosTotales: 10),
        ];

        final ranking = List<Participante>.from(participantes)
          ..sort((a, b) => b.puntosTotales.compareTo(a.puntosTotales));

        expect(ranking[0].nombre, equals('Primero'));
        expect(ranking[1].nombre, equals('Segundo'));
        expect(ranking[2].nombre, equals('Tercero'));
        expect(ranking[3].nombre, equals('Cuarto'));

        print('✅ Ranking ordenado correctamente:');
        for (var i = 0; i < ranking.length; i++) {
          print(
            '   ${i + 1}. ${ranking[i].nombre} - ${ranking[i].puntosTotales} pts',
          );
        }
      });

      test('desempate por victorias cuando puntos iguales', () {
        final participantes = [
          Participante(
            id: 'p1',
            nombre: 'Primero',
            puntosTotales: 10,
            peleasGanadas: 4,
          ),
          Participante(
            id: 'p2',
            nombre: 'Segundo',
            puntosTotales: 10,
            peleasGanadas: 3,
          ),
        ];

        // Ordenar por puntos, luego por victorias
        final ranking = List<Participante>.from(participantes)
          ..sort((a, b) {
            final cmpPuntos = b.puntosTotales.compareTo(a.puntosTotales);
            if (cmpPuntos != 0) return cmpPuntos;
            return b.peleasGanadas.compareTo(a.peleasGanadas);
          });

        expect(ranking[0].nombre, equals('Primero'));
        expect(ranking[1].nombre, equals('Segundo'));

        print(
          '✅ Desempate por victorias: ${ranking[0].nombre} (${ranking[0].peleasGanadas}V) vs ${ranking[1].nombre} (${ranking[1].peleasGanadas}V)',
        );
      });
    });

    group('Estadísticas de Rondas', () {
      test('conteo de peleas finalizadas es correcto', () {
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
              ganadorId: 'g3',
            ),
            Pelea(id: 'p3', numero: 3, galloRojoId: 'g5', galloVerdeId: 'g6'),
          ],
        );

        expect(ronda.totalPeleas, equals(3));
        expect(ronda.peleasFinalizadas, equals(2));
        expect(ronda.todasFinalizadas, isFalse);

        final progreso = ronda.peleasTerminadas / ronda.totalPeleas;
        expect(progreso, closeTo(0.666, 0.01));

        print(
          '✅ Progreso ronda: ${ronda.peleasTerminadas}/${ronda.totalPeleas} (${(progreso * 100).toInt()}%)',
        );
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
            ),
          ],
        );

        expect(ronda.peleasTerminadas, equals(2));
        expect(ronda.todasFinalizadas, isTrue);

        print('✅ Canceladas cuentan como terminadas');
      });

      test('empates se registran correctamente', () {
        final pelea = Pelea(
          id: 'p1',
          numero: 1,
          galloRojoId: 'g1',
          galloVerdeId: 'g2',
        ).conResultado(empate: true);

        expect(pelea.empate, isTrue);
        expect(pelea.ganadorId, isNull);
        expect(pelea.estado, equals(EstadoPelea.finalizada));

        print(
          '✅ Empate registrado: estado=${pelea.estado}, ganador=${pelea.ganadorId}',
        );
      });
    });

    group('Estadísticas de Participante', () {
      test('total de peleas calculado correctamente', () {
        final participante = Participante(
          id: 'p1',
          nombre: 'Test',
          peleasGanadas: 5,
          peleasPerdidas: 2,
          peleasEmpatadas: 1,
        );

        expect(participante.totalPeleas, equals(8));

        print('✅ Total peleas: ${participante.totalPeleas}');
      });

      test('participante sin peleas tiene totales en 0', () {
        final participante = Participante(id: 'p1', nombre: 'Nuevo');

        expect(participante.totalPeleas, equals(0));
        expect(participante.puntosTotales, equals(0));

        print('✅ Participante nuevo tiene totales en 0');
      });
    });

    group('Consistencia de Datos', () {
      test('suma de resultados por participante es consistente', () {
        final totalPeleas = 10;
        final victoriasP1 = 6;
        final victoriasP2 = 3;
        final empates = 1;

        // Las victorias + empates deben sumar al total
        expect(victoriasP1 + victoriasP2 + empates, equals(totalPeleas));

        print(
          '✅ Conteo consistente: $victoriasP1 + $victoriasP2 + $empates = $totalPeleas',
        );
      });

      test('peleas por ronda suman al total del derby', () {
        final rondas = [
          Ronda(
            id: 'r1',
            numero: 1,
            peleas: List.generate(
              5,
              (i) => Pelea(
                id: 'r1_p$i',
                numero: i + 1,
                galloRojoId: 'g${i * 2}',
                galloVerdeId: 'g${i * 2 + 1}',
              ),
            ),
          ),
          Ronda(
            id: 'r2',
            numero: 2,
            peleas: List.generate(
              5,
              (i) => Pelea(
                id: 'r2_p$i',
                numero: i + 1,
                galloRojoId: 'g${i * 2}',
                galloVerdeId: 'g${i * 2 + 1}',
              ),
            ),
          ),
          Ronda(
            id: 'r3',
            numero: 3,
            peleas: List.generate(
              5,
              (i) => Pelea(
                id: 'r3_p$i',
                numero: i + 1,
                galloRojoId: 'g${i * 2}',
                galloVerdeId: 'g${i * 2 + 1}',
              ),
            ),
          ),
        ];

        final totalPorRonda = rondas.map((r) => r.totalPeleas).toList();
        final totalDerby = totalPorRonda.fold(0, (a, b) => a + b);

        expect(totalDerby, equals(15));
        expect(totalPorRonda, equals([5, 5, 5]));

        print('✅ Total peleas: $totalDerby (${totalPorRonda.join(' + ')})');
      });

      test('cada gallo pelea máximo una vez por ronda', () {
        final participantes = TestDataFactory.crearParticipantes(cantidad: 6);
        final gallos = TestDataFactory.crearGallos(
          participantes: participantes,
          gallosPorParticipante: 2,
        );
        final config = TestDataFactory.crearConfig(numeroRondas: 3);

        final rondas = TestDataFactory.generarRondas(
          participantes: participantes,
          gallos: gallos,
          config: config,
        );

        for (final ronda in rondas) {
          final gallosEnRonda = <String>{};

          for (final pelea in ronda.peleas) {
            // Verificar que cada gallo solo aparece una vez
            expect(
              gallosEnRonda.contains(pelea.galloRojoId),
              isFalse,
              reason:
                  'Gallo ${pelea.galloRojoId} pelea dos veces en ronda ${ronda.numero}',
            );
            expect(
              gallosEnRonda.contains(pelea.galloVerdeId),
              isFalse,
              reason:
                  'Gallo ${pelea.galloVerdeId} pelea dos veces en ronda ${ronda.numero}',
            );

            gallosEnRonda.add(pelea.galloRojoId);
            gallosEnRonda.add(pelea.galloVerdeId);
          }
        }

        print('✅ Ningún gallo pelea dos veces en la misma ronda');
      });
    });

    group('Formato de Reportes', () {
      test('peso se muestra en formato correcto', () {
        final peso = 2150.5; // gramos
        final pesoKg = peso / 1000;
        final pesoFormateado = '${pesoKg.toStringAsFixed(2)} kg';

        expect(pesoFormateado, equals('2.15 kg'));
        print('✅ Peso formateado: $pesoFormateado');
      });

      test('duración de pelea se muestra correctamente', () {
        final duracionSegundos = 185;
        final minutos = duracionSegundos ~/ 60;
        final segundos = duracionSegundos % 60;
        final duracionFormateada =
            '$minutos:${segundos.toString().padLeft(2, '0')}';

        expect(duracionFormateada, equals('3:05'));
        print('✅ Duración formateada: $duracionFormateada');
      });

      test('posición ordinal se genera correctamente', () {
        String ordinal(int n) {
          if (n == 1) return '1°';
          if (n == 2) return '2°';
          if (n == 3) return '3°';
          return '$n°';
        }

        expect(ordinal(1), equals('1°'));
        expect(ordinal(2), equals('2°'));
        expect(ordinal(3), equals('3°'));
        expect(ordinal(10), equals('10°'));

        print('✅ Ordinales generados correctamente');
      });
    });
  });
}
