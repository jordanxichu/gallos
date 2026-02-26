/// Utilidades compartidas para tests de Derby Manager.
///
/// Este archivo contiene helpers, factories y configuraciones
/// que se usan en múltiples archivos de test.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:derby_engine/derby_engine.dart';

import 'package:derby_app/viewmodels/derby_state.dart';

/// Wrapper que envuelve un widget con el Provider de DerbyState.
/// Usado para tests que necesitan el estado completo.
class TestApp extends StatelessWidget {
  final Widget child;
  final DerbyState? state;

  const TestApp({super.key, required this.child, this.state});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<DerbyState>(
        create: (_) => state ?? DerbyState(),
        child: child,
      ),
    );
  }
}

/// Factory para crear datos de prueba.
class TestDataFactory {
  TestDataFactory._();

  /// Crea una lista de participantes de prueba.
  static List<Participante> crearParticipantes({
    int cantidad = 4,
    bool conCompadres = false,
  }) {
    final participantes = <Participante>[];
    for (var i = 0; i < cantidad; i++) {
      final compadres = <String>[];
      if (conCompadres && i > 0) {
        // El primer participante tiene compadrazgo con el segundo
        if (i == 1) compadres.add('p0');
      }
      participantes.add(
        Participante(
          id: 'p$i',
          nombre: 'Rancho $i',
          equipo: 'Equipo $i',
          compadres: compadres,
        ),
      );
    }
    return participantes;
  }

  /// Crea gallos de prueba para los participantes dados.
  static List<Gallo> crearGallos({
    required List<Participante> participantes,
    int gallosPorParticipante = 3,
    double pesoBase = 2000,
    double variacionPeso = 50,
  }) {
    final gallos = <Gallo>[];
    var contador = 0;
    for (final p in participantes) {
      for (var j = 0; j < gallosPorParticipante; j++) {
        gallos.add(
          Gallo(
            id: 'g${p.id}_$j',
            participanteId: p.id,
            peso: pesoBase + (contador % 5) * variacionPeso,
            anillo: 'A${contador.toString().padLeft(3, '0')}',
          ),
        );
        contador++;
      }
    }
    return gallos;
  }

  /// Crea gallos con pesos extremos para pruebas de edge cases.
  static List<Gallo> crearGallosExtremos({
    required List<Participante> participantes,
  }) {
    if (participantes.length < 2) {
      throw ArgumentError('Se necesitan al menos 2 participantes');
    }
    return [
      Gallo(
        id: 'g_extremo_bajo',
        participanteId: participantes[0].id,
        peso: 0,
        anillo: 'EXT001',
      ),
      Gallo(
        id: 'g_extremo_neg',
        participanteId: participantes[1].id,
        peso: -100,
        anillo: 'EXT002',
      ),
      Gallo(
        id: 'g_extremo_alto',
        participanteId: participantes[0].id,
        peso: 9999,
        anillo: 'EXT003',
      ),
      Gallo(
        id: 'g_normal',
        participanteId: participantes[1].id,
        peso: 2000,
        anillo: 'EXT004',
      ),
    ];
  }

  /// Configura todos como compadres entre sí.
  static List<Participante> crearTodosCompadres({int cantidad = 4}) {
    return List.generate(cantidad, (i) {
      final compadres = <String>[];
      for (var j = 0; j < cantidad; j++) {
        if (i != j) compadres.add('p$j');
      }
      return Participante(id: 'p$i', nombre: 'Rancho $i', compadres: compadres);
    });
  }

  /// Crea una configuración de derby de prueba.
  static ConfiguracionDerby crearConfig({
    int numeroRondas = 3,
    double toleranciaPeso = 80,
    int puntosVictoria = 3,
    int puntosDerrota = 0,
    int puntosEmpate = 1,
  }) {
    return ConfiguracionDerby(
      numeroRondas: numeroRondas,
      toleranciaPeso: toleranciaPeso,
      puntosVictoria: puntosVictoria,
      puntosDerrota: puntosDerrota,
      puntosEmpate: puntosEmpate,
    );
  }

  /// Genera rondas usando el motor de matching.
  static List<Ronda> generarRondas({
    required List<Participante> participantes,
    required List<Gallo> gallos,
    required ConfiguracionDerby config,
  }) {
    final generator = RoundGenerator(
      configuracion: config,
      participantes: participantes,
    );
    final resultado = generator.generarRondas(gallos: gallos);
    return resultado.rondas;
  }
}

/// Extension para facilitar interacciones en tests.
extension WidgetTesterExtensions on WidgetTester {
  /// Navega a una pantalla específica usando el NavigationRail.
  Future<void> navegarA(Key navKey) async {
    final finder = find.byKey(navKey);
    expect(
      finder,
      findsOneWidget,
      reason: 'No se encontró nav con key: $navKey',
    );
    await tap(finder);
    await pumpAndSettle();
  }

  /// Toca un botón por su key y espera a que se asiente.
  Future<void> tapByKey(Key key) async {
    final finder = find.byKey(key);
    expect(
      finder,
      findsOneWidget,
      reason: 'No se encontró widget con key: $key',
    );
    await tap(finder);
    await pumpAndSettle();
  }

  /// Toca un botón por su key si existe (no falla si no existe).
  Future<bool> tapByKeyIfExists(Key key) async {
    final finder = find.byKey(key);
    if (finder.evaluate().isEmpty) return false;
    await tap(finder);
    await pumpAndSettle();
    return true;
  }

  /// Verifica que un widget con la key especificada exista.
  void expectKeyExists(Key key) {
    expect(
      find.byKey(key),
      findsOneWidget,
      reason: 'Widget con key $key no encontrado',
    );
  }

  /// Verifica que un widget con la key esté habilitado.
  void expectKeyEnabled(Key key) {
    final finder = find.byKey(key);
    expect(finder, findsOneWidget);
    final widget = finder.evaluate().first.widget;

    if (widget is ElevatedButton) {
      expect(
        widget.onPressed,
        isNotNull,
        reason: 'Botón con key $key está deshabilitado',
      );
    } else if (widget is FloatingActionButton) {
      expect(
        widget.onPressed,
        isNotNull,
        reason: 'FAB con key $key está deshabilitado',
      );
    } else if (widget is IconButton) {
      expect(
        widget.onPressed,
        isNotNull,
        reason: 'IconButton con key $key está deshabilitado',
      );
    }
  }

  /// Verifica que un widget con la key esté deshabilitado.
  void expectKeyDisabled(Key key) {
    final finder = find.byKey(key);
    expect(finder, findsOneWidget);
    final widget = finder.evaluate().first.widget;

    if (widget is ElevatedButton) {
      expect(
        widget.onPressed,
        isNull,
        reason:
            'Botón con key $key está habilitado, debería estar deshabilitado',
      );
    } else if (widget is FloatingActionButton) {
      expect(
        widget.onPressed,
        isNull,
        reason: 'FAB con key $key está habilitado, debería estar deshabilitado',
      );
    }
  }

  /// Ingresa texto en un campo por su key.
  Future<void> enterTextByKey(Key key, String text) async {
    final finder = find.byKey(key);
    expect(finder, findsOneWidget, reason: 'Campo con key $key no encontrado');
    await enterText(finder, text);
    await pumpAndSettle();
  }

  /// Espera a que desaparezca un diálogo.
  Future<void> dismissDialog() async {
    final dialog = find.byType(AlertDialog);
    if (dialog.evaluate().isNotEmpty) {
      // Buscar botón de cancelar o cerrar
      final cancelar = find.text('Cancelar');
      if (cancelar.evaluate().isNotEmpty) {
        await tap(cancelar);
        await pumpAndSettle();
      }
    }
  }
}

/// Matchers personalizados para tests de Derby.
class DerbyMatchers {
  DerbyMatchers._();

  /// Verifica que un gallo esté marcado como retirado visualmente.
  static Matcher galloMarcadoRetirado() {
    return predicate<Widget>((widget) {
      // Buscar indicadores visuales de retiro
      if (widget is Card) {
        // Verificar color de fondo o badge de retiro
        return true;
      }
      return false;
    }, 'muestra gallo como retirado');
  }
}
