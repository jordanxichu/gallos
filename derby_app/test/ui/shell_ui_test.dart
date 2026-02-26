/// Tests de UI para Shell Screen (Navegación).
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:derby_app/screens/shell_screen.dart';
import 'package:derby_app/core/test_keys.dart';
import 'ui_test_helpers.dart';

void main() {
  setUpAll(() => ignoreOverflowErrors());

  group('🧭 NAVEGACIÓN - Existencia de UI', () {
    testWidgets('renderiza sin errores', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('NavigationRail visible', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      expect(find.byType(NavigationRail), findsOneWidget);
    });

    testWidgets('icono logo Derby visible', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      expect(find.byIcon(Icons.emoji_events), findsWidgets);
    });
  });

  group('🧭 NAVEGACIÓN - Destinos', () {
    testWidgets('destino Dashboard existe', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      // Dashboard está seleccionado por defecto, así que muestra selectedIcon sin key
      // Verificamos que el ícono seleccionado está presente
      expect(find.byIcon(Icons.dashboard), findsOneWidget);
    });

    testWidgets('destino Participantes existe', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      await tester.expectKeyExists(ShellKeys.navParticipantes);
    });

    testWidgets('destino Gallos existe', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      await tester.expectKeyExists(ShellKeys.navGallos);
    });

    testWidgets('destino Sorteo existe', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      await tester.expectKeyExists(ShellKeys.navSorteo);
    });

    testWidgets('destino Peleas existe', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      await tester.expectKeyExists(ShellKeys.navPeleas);
    });

    testWidgets('destino Resultados existe', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      await tester.expectKeyExists(ShellKeys.navResultados);
    });

    testWidgets('destino Configuración existe', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      await tester.expectKeyExists(ShellKeys.navConfiguracion);
    });
  });

  group('🧭 NAVEGACIÓN - Cambio de Pantallas', () {
    testWidgets('inicia en Dashboard', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      expect(find.byIcon(Icons.dashboard), findsWidgets);
      await tester.expectTextVisible('Dashboard');
    });

    testWidgets('navegar a Participantes funciona', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      await tester.tapByKey(ShellKeys.navParticipantes);
      await tester.expectTextVisible('Participantes');
    });

    testWidgets('navegar a Gallos funciona', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      await tester.tapByKey(ShellKeys.navGallos);
      await tester.expectTextVisible('Gallos');
    });

    testWidgets('navegar a Sorteo funciona', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      await tester.tapByKey(ShellKeys.navSorteo);
      await tester.expectTextVisible('Sorteo de Peleas');
    });

    testWidgets('navegar a Peleas funciona', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      await tester.tapByKey(ShellKeys.navPeleas);
      await tester.expectTextVisible('Peleas');
    });

    testWidgets('navegar a Resultados funciona', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      await tester.tapByKey(ShellKeys.navResultados);
      await tester.expectTextVisible('Resultados');
    });

    testWidgets('navegar a Configuración funciona', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      await tester.tapByKey(ShellKeys.navConfiguracion);
      await tester.expectTextVisible('Configuración del Derby');
    });
  });

  group('🧭 NAVEGACIÓN - Ida y Vuelta', () {
    testWidgets('ir a Participantes y volver a Dashboard', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      await tester.tapByKey(ShellKeys.navParticipantes);
      await tester.expectTextVisible('Participantes');
      await tester.tapByKey(ShellKeys.navDashboard);
      await tester.expectTextVisible('Dashboard');
    });

    testWidgets('ciclo completo de navegación', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      await tester.tapByKey(ShellKeys.navParticipantes);
      await tester.tapByKey(ShellKeys.navGallos);
      await tester.tapByKey(ShellKeys.navSorteo);
      await tester.tapByKey(ShellKeys.navPeleas);
      await tester.tapByKey(ShellKeys.navResultados);
      await tester.tapByKey(ShellKeys.navConfiguracion);
      await tester.tapByKey(ShellKeys.navDashboard);
      await tester.expectTextVisible('Dashboard');
    });
  });

  group('🧭 NAVEGACIÓN - Consistencia de Estado', () {
    testWidgets('navegación no rompe el estado', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      for (var i = 0; i < 3; i++) {
        await tester.tapByKey(ShellKeys.navParticipantes);
        await tester.tapByKey(ShellKeys.navGallos);
        await tester.tapByKey(ShellKeys.navDashboard);
      }
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  group('🧭 NAVEGACIÓN - Anti-regresión', () {
    testWidgets('divisor vertical presente', (tester) async {
      await tester.pumpScreen(const ShellScreen());
      expect(find.byType(VerticalDivider), findsOneWidget);
    });
  });
}
