import 'dart:math';
import 'package:derby_engine/derby_engine.dart';
import 'package:flutter/foundation.dart';
import '../viewmodels/derby_state.dart';

/// Servicio para generar datos de prueba realistas.
class SeedData {
  static final _random = Random();

  /// Nombres de participantes mexicanos
  static const _nombres = [
    'Don Chuy García',
    'Rancho El Patrón',
    'Los Hermanos Sánchez',
    'El Gallo de Oro',
    'Rancho Santa Fe',
    'Don Pepe Mendoza',
    'Los Tres Potrillos',
    'El Centurión',
    'Rancho La Herradura',
    'Don Memo Ríos',
    'El Conquistador',
    'Rancho San Miguel',
  ];

  /// Equipos/ranchos
  static const _equipos = [
    'Jalisco',
    'Aguascalientes',
    'Zacatecas',
    'Guanajuato',
    'Michoacán',
    'San Luis Potosí',
    'Querétaro',
    'Nayarit',
  ];

  /// Prefijos para anillos
  static const _prefijosAnillo = [
    'RG', 'GP', 'EO', 'SF', 'PM', 'TP', 'CT', 'HR', 'MR', 'CQ', 'SM', 'JL'
  ];

  /// Genera datos de prueba completos.
  /// 
  /// [numParticipantes] - Número de participantes (default: 8)
  /// [gallosPorParticipante] - Gallos por participante (default: 4)
  static Future<void> poblarDatos(
    DerbyState state, {
    int numParticipantes = 8,
    int gallosPorParticipante = 4,
  }) async {
    debugPrint('🌱 Iniciando seed de datos de prueba...');
    debugPrint('   Participantes: $numParticipantes');
    debugPrint('   Gallos por participante: $gallosPorParticipante');

    // Mezclar nombres para variedad
    final nombresDisponibles = List<String>.from(_nombres)..shuffle(_random);

    for (int i = 0; i < numParticipantes && i < nombresDisponibles.length; i++) {
      // Crear participante
      final participante = Participante(
        id: 'p_${i + 1}_${DateTime.now().millisecondsSinceEpoch}',
        nombre: nombresDisponibles[i],
        equipo: _equipos[_random.nextInt(_equipos.length)],
        telefono: _generarTelefono(),
      );

      await state.agregarParticipante(participante);
      debugPrint('👤 Creado: ${participante.nombre}');

      // Crear gallos para este participante
      final prefijoAnillo = _prefijosAnillo[i % _prefijosAnillo.length];
      for (int j = 0; j < gallosPorParticipante; j++) {
        final gallo = Gallo(
          id: 'g_${i + 1}_${j + 1}_${DateTime.now().millisecondsSinceEpoch + j}',
          participanteId: participante.id,
          peso: _generarPeso(),
          anillo: '$prefijoAnillo-${(i * 100) + j + 1}',
          estado: EstadoGallo.activo,
        );

        await state.agregarGallo(gallo);
        debugPrint('   🐓 Gallo: ${gallo.anillo} (${gallo.peso}g)');
      }
    }

    final totalGallos = numParticipantes * gallosPorParticipante;
    debugPrint('✅ Seed completado: $numParticipantes participantes, $totalGallos gallos');
  }

  /// Genera un peso aleatorio realista (1800-2400g con distribución normal)
  static double _generarPeso() {
    // Peso base alrededor de 2100g con variación de ±300g
    final base = 2100.0;
    final variacion = (_random.nextDouble() - 0.5) * 600;
    final peso = base + variacion;
    // Redondear a decenas
    return (peso / 10).round() * 10.0;
  }

  /// Genera un número de teléfono mexicano ficticio
  static String _generarTelefono() {
    final lada = [33, 55, 81, 442, 449, 477, 443][_random.nextInt(7)];
    final numero = 1000000 + _random.nextInt(9000000);
    return '$lada-${numero.toString().substring(0, 3)}-${numero.toString().substring(3)}';
  }

  /// Limpia todos los datos existentes y genera nuevos.
  static Future<void> resetearYPoblar(DerbyState state) async {
    debugPrint('🗑️ Limpiando datos existentes...');
    
    // Limpiar sorteo si existe
    if (state.sorteoRealizado) {
      await state.limpiarSorteo();
    }

    // Eliminar gallos
    for (final gallo in List.from(state.gallos)) {
      await state.eliminarGallo(gallo.id);
    }

    // Eliminar participantes
    for (final p in List.from(state.participantes)) {
      await state.eliminarParticipante(p.id);
    }

    debugPrint('✅ Datos limpiados');

    // Poblar con nuevos datos
    await poblarDatos(state);
  }

  /// Datos de prueba predefinidos (siempre los mismos para debugging)
  static Future<void> poblarDeterministico(DerbyState state) async {
    debugPrint('🌱 Poblando con datos determinísticos...');

    final participantesData = [
      ('Don Chuy García', 'Jalisco', '33-123-4567'),
      ('Rancho El Patrón', 'Aguascalientes', '449-234-5678'),
      ('Los Hermanos Sánchez', 'Zacatecas', '492-345-6789'),
      ('El Gallo de Oro', 'Guanajuato', '477-456-7890'),
      ('Rancho Santa Fe', 'Michoacán', '443-567-8901'),
      ('Don Pepe Mendoza', 'San Luis Potosí', '444-678-9012'),
      ('Los Tres Potrillos', 'Querétaro', '442-789-0123'),
      ('El Centurión', 'Nayarit', '311-890-1234'),
    ];

    // Pesos predefinidos por participante (4 gallos cada uno)
    final pesosGallos = [
      [2100.0, 2150.0, 2200.0, 1950.0],
      [2080.0, 2120.0, 2180.0, 2000.0],
      [2050.0, 2100.0, 2150.0, 2250.0],
      [2000.0, 2080.0, 2160.0, 2220.0],
      [2030.0, 2110.0, 2190.0, 1980.0],
      [2070.0, 2130.0, 2200.0, 2020.0],
      [2040.0, 2090.0, 2170.0, 2240.0],
      [2060.0, 2140.0, 2210.0, 1990.0],
    ];

    for (int i = 0; i < participantesData.length; i++) {
      final (nombre, equipo, telefono) = participantesData[i];
      
      final participante = Participante(
        id: 'p_${i + 1}',
        nombre: nombre,
        equipo: equipo,
        telefono: telefono,
      );

      await state.agregarParticipante(participante);
      debugPrint('👤 Creado: ${participante.nombre}');

      final prefijoAnillo = _prefijosAnillo[i];
      for (int j = 0; j < pesosGallos[i].length; j++) {
        final gallo = Gallo(
          id: 'g_${i + 1}_${j + 1}',
          participanteId: participante.id,
          peso: pesosGallos[i][j],
          anillo: '$prefijoAnillo-${(i + 1) * 100 + j + 1}',
          estado: EstadoGallo.activo,
        );

        await state.agregarGallo(gallo);
        debugPrint('   🐓 ${gallo.anillo}: ${gallo.peso}g');
      }
    }

    debugPrint('✅ 8 participantes con 32 gallos creados');
  }
}
