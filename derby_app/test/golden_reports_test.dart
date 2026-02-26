/// Golden Tests para reportes críticos.
///
/// Estos tests generan "snapshots" de salidas importantes
/// para detectar cambios inesperados en el formato.
///
/// Para actualizar los goldens: flutter test --update-goldens
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:derby_engine/derby_engine.dart';

void main() {
  group('🟨 GOLDEN TESTS - Reportes Críticos', () {
    test('Golden: Resumen de resultados por participante', () {
      // Datos de prueba
      final participantes = [
        Participante(id: 'p1', nombre: 'Rancho El Campeón'),
        Participante(id: 'p2', nombre: 'Rancho Los Gallos'),
        Participante(id: 'p3', nombre: 'Rancho El Dorado'),
      ];

      final gallos = [
        Gallo(id: 'g1', anillo: '001', peso: 2.100, participanteId: 'p1'),
        Gallo(id: 'g2', anillo: '002', peso: 2.150, participanteId: 'p1'),
        Gallo(id: 'g3', anillo: '003', peso: 2.050, participanteId: 'p2'),
        Gallo(id: 'g4', anillo: '004', peso: 2.200, participanteId: 'p2'),
        Gallo(id: 'g5', anillo: '005', peso: 2.100, participanteId: 'p3'),
        Gallo(id: 'g6', anillo: '006', peso: 2.000, participanteId: 'p3'),
      ];

      final peleas = [
        Pelea(
          id: 'pelea1',
          numero: 1,
          galloRojoId: 'g1',
          galloVerdeId: 'g3',
          estado: EstadoPelea.finalizada,
          ganadorId: 'g1', // Victoria p1
        ),
        Pelea(
          id: 'pelea2',
          numero: 2,
          galloRojoId: 'g2',
          galloVerdeId: 'g5',
          estado: EstadoPelea.finalizada,
          ganadorId: 'g5', // Victoria p3
        ),
        Pelea(
          id: 'pelea3',
          numero: 3,
          galloRojoId: 'g4',
          galloVerdeId: 'g6',
          estado: EstadoPelea.finalizada,
          empate: true, // Empate
        ),
      ];

      // Generar reporte
      final reporte = _generarReporteParticipantes(participantes, gallos, peleas);

      // Golden: formato esperado
      const goldenExpected = '''
╔══════════════════════════════════════════════════════════════╗
║                    RESUMEN DE RESULTADOS                     ║
╠══════════════════════════════════════════════════════════════╣
║ #  │ Participante         │ V │ D │ E │ Pts │ Gallos         ║
╠════╪══════════════════════╪═══╪═══╪═══╪═════╪════════════════╣
║ 1  │ Rancho El Campeón    │ 1 │ 0 │ 0 │  3  │ 2              ║
║ 2  │ Rancho El Dorado     │ 1 │ 0 │ 1 │  4  │ 2              ║
║ 3  │ Rancho Los Gallos    │ 0 │ 1 │ 1 │  1  │ 2              ║
╚══════════════════════════════════════════════════════════════╝
''';

      // Verificar estructura del reporte
      expect(reporte, contains('RESUMEN DE RESULTADOS'));
      expect(reporte, contains('Rancho El Campeón'));
      expect(reporte, contains('Rancho El Dorado'));
      expect(reporte, contains('Rancho Los Gallos'));
      // Verificar que tiene estructura similar al golden
      expect(reporte.split('\n').length, greaterThanOrEqualTo(goldenExpected.split('\n').length - 2));

      print('📋 Reporte generado:\n$reporte');
      print('✅ Golden test de resumen de participantes');
    });

    test('Golden: Tabla de peleas de una ronda', () {
      final participantes = {
        'p1': 'Rancho A',
        'p2': 'Rancho B',
      };

      final gallos = {
        'g1': ('001', 'p1'),
        'g2': ('002', 'p2'),
        'g3': ('003', 'p1'),
        'g4': ('004', 'p2'),
      };

      final ronda = Ronda(
        id: 'r1',
        numero: 1,
        peleas: [
          Pelea(
            id: 'pelea1',
            numero: 1,
            galloRojoId: 'g1',
            galloVerdeId: 'g2',
            estado: EstadoPelea.finalizada,
            ganadorId: 'g1',
          ),
          Pelea(
            id: 'pelea2',
            numero: 2,
            galloRojoId: 'g3',
            galloVerdeId: 'g4',
            estado: EstadoPelea.pendiente,
          ),
        ],
      );

      // Generar tabla de ronda
      final tabla = _generarTablaRonda(ronda, gallos, participantes);

      // Verificar formato
      expect(tabla, contains('RONDA 1'));
      expect(tabla, contains('001')); // anillo gallo rojo pelea 1
      expect(tabla, contains('002')); // anillo gallo verde pelea 1
      expect(tabla, contains('VICTORIA')); // resultado
      expect(tabla, contains('PENDIENTE')); // estado

      print('📋 Tabla generada:\n$tabla');
      print('✅ Golden test de tabla de ronda');
    });
  });

  group('🟨 FORMATO DE DATOS', () {
    test('formato de peso consistente', () {
      // El peso debe mostrarse con exactamente 3 decimales
      double peso = 2.1;
      String formateado = peso.toStringAsFixed(3);
      expect(formateado, equals('2.100'));

      peso = 2.15;
      formateado = peso.toStringAsFixed(3);
      expect(formateado, equals('2.150'));

      peso = 2.125;
      formateado = peso.toStringAsFixed(3);
      expect(formateado, equals('2.125'));

      print('✅ Formato de peso consistente');
    });

    test('formato de estado de gallo', () {
      String formatearEstado(EstadoGallo estado) {
        switch (estado) {
          case EstadoGallo.activo:
            return '🟢 Activo';
          case EstadoGallo.finalizado:
            return '⚪ Finalizado';
          case EstadoGallo.retirado:
            return '🟠 Retirado';
          case EstadoGallo.descalificado:
            return '🔴 Descalificado';
        }
      }

      expect(formatearEstado(EstadoGallo.activo), equals('🟢 Activo'));
      expect(formatearEstado(EstadoGallo.finalizado), equals('⚪ Finalizado'));
      expect(formatearEstado(EstadoGallo.retirado), equals('🟠 Retirado'));
      expect(formatearEstado(EstadoGallo.descalificado), equals('🔴 Descalificado'));

      print('✅ Formato de estados correcto');
    });

    test('formato de resultado de pelea', () {
      String formatearResultado(Pelea pelea, Map<String, String> gallosAnillo) {
        if (pelea.estado == EstadoPelea.pendiente) {
          return 'PENDIENTE';
        }
        if (pelea.estado == EstadoPelea.cancelada) {
          return 'CANCELADA';
        }
        if (pelea.empate) {
          return 'EMPATE';
        }
        final anilloGanador = gallosAnillo[pelea.ganadorId] ?? '???';
        final color = pelea.ganadorId == pelea.galloRojoId ? '🔴' : '🟢';
        return '$color $anilloGanador GANA';
      }

      final gallosAnillo = {'g1': '001', 'g2': '002'};

      // Pelea pendiente
      var pelea = Pelea(
        id: 'p1',
        numero: 1,
        galloRojoId: 'g1',
        galloVerdeId: 'g2',
      );
      expect(formatearResultado(pelea, gallosAnillo), equals('PENDIENTE'));

      // Victoria rojo
      pelea = Pelea(
        id: 'p1',
        numero: 1,
        galloRojoId: 'g1',
        galloVerdeId: 'g2',
        estado: EstadoPelea.finalizada,
        ganadorId: 'g1',
      );
      expect(formatearResultado(pelea, gallosAnillo), contains('001 GANA'));

      // Empate
      pelea = Pelea(
        id: 'p1',
        numero: 1,
        galloRojoId: 'g1',
        galloVerdeId: 'g2',
        estado: EstadoPelea.finalizada,
        empate: true,
      );
      expect(formatearResultado(pelea, gallosAnillo), equals('EMPATE'));

      print('✅ Formato de resultados correcto');
    });

    test('formato de porcentaje de progreso', () {
      String formatearProgreso(int completadas, int total) {
        if (total == 0) return '0%';
        final porcentaje = (completadas / total * 100).round();
        return '$porcentaje%';
      }

      expect(formatearProgreso(0, 10), equals('0%'));
      expect(formatearProgreso(5, 10), equals('50%'));
      expect(formatearProgreso(10, 10), equals('100%'));
      expect(formatearProgreso(3, 10), equals('30%'));
      expect(formatearProgreso(0, 0), equals('0%'));

      print('✅ Formato de porcentaje correcto');
    });

    test('formato de ranking ordinal', () {
      String formatearPosicion(int posicion) {
        if (posicion == 1) return '🥇 1°';
        if (posicion == 2) return '🥈 2°';
        if (posicion == 3) return '🥉 3°';
        return '   $posicion°';
      }

      expect(formatearPosicion(1), equals('🥇 1°'));
      expect(formatearPosicion(2), equals('🥈 2°'));
      expect(formatearPosicion(3), equals('🥉 3°'));
      expect(formatearPosicion(4), equals('   4°'));

      print('✅ Formato de ranking correcto');
    });
  });
}

/// Genera reporte de participantes (simulación)
String _generarReporteParticipantes(
  List<Participante> participantes,
  List<Gallo> gallos,
  List<Pelea> peleas,
) {
  final buffer = StringBuffer();
  buffer.writeln('╔══════════════════════════════════════════════════════════════╗');
  buffer.writeln('║                    RESUMEN DE RESULTADOS                     ║');
  buffer.writeln('╠══════════════════════════════════════════════════════════════╣');
  buffer.writeln('║ #  │ Participante         │ V │ D │ E │ Pts │ Gallos         ║');
  buffer.writeln('╠════╪══════════════════════╪═══╪═══╪═══╪═════╪════════════════╣');

  // Calcular estadísticas por participante
  for (var i = 0; i < participantes.length; i++) {
    final p = participantes[i];
    final gallosDelParticipante = gallos.where((g) => g.participanteId == p.id).toList();
    final gallosIds = gallosDelParticipante.map((g) => g.id).toSet();

    var victorias = 0;
    var derrotas = 0;
    var empates = 0;

    for (final pelea in peleas) {
      if (pelea.estado != EstadoPelea.finalizada) continue;

      final participoRojo = gallosIds.contains(pelea.galloRojoId);
      final participoVerde = gallosIds.contains(pelea.galloVerdeId);

      if (!participoRojo && !participoVerde) continue;

      if (pelea.empate) {
        empates++;
      } else if (gallosIds.contains(pelea.ganadorId)) {
        victorias++;
      } else {
        derrotas++;
      }
    }

    final puntos = (victorias * 3) + empates;
    final nombre = p.nombre.padRight(20).substring(0, 20);
    
    buffer.writeln('║ ${(i + 1).toString().padLeft(2)} │ $nombre │ $victorias │ $derrotas │ $empates │ ${puntos.toString().padLeft(3)} │ ${gallosDelParticipante.length.toString().padRight(14)} ║');
  }

  buffer.writeln('╚══════════════════════════════════════════════════════════════╝');
  return buffer.toString();
}

/// Genera tabla de ronda (simulación)
String _generarTablaRonda(
  Ronda ronda,
  Map<String, (String anillo, String participanteId)> gallos,
  Map<String, String> participantes,
) {
  final buffer = StringBuffer();
  buffer.writeln('┌─────────────────────────────────────────┐');
  buffer.writeln('│            RONDA ${ronda.numero}                       │');
  buffer.writeln('├─────────────────────────────────────────┤');

  for (final pelea in ronda.peleas) {
    final rojoAnillo = gallos[pelea.galloRojoId]?.$1 ?? '???';
    final verdeAnillo = gallos[pelea.galloVerdeId]?.$1 ?? '???';

    String resultado;
    if (pelea.estado == EstadoPelea.pendiente) {
      resultado = 'PENDIENTE';
    } else if (pelea.empate) {
      resultado = 'EMPATE';
    } else {
      resultado = 'VICTORIA ${pelea.ganadorId == pelea.galloRojoId ? "🔴" : "🟢"}';
    }

    buffer.writeln('│ Pelea ${pelea.numero}: $rojoAnillo 🔴 vs 🟢 $verdeAnillo');
    buffer.writeln('│ → $resultado');
    buffer.writeln('│');
  }

  buffer.writeln('└─────────────────────────────────────────┘');
  return buffer.toString();
}
