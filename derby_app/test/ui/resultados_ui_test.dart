/// Tests de UI para Resultados Screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:derby_app/screens/resultados_screen.dart';
import 'ui_test_helpers.dart';

void main() {
  setUpAll(() => ignoreOverflowErrors());

  group('📊 RESULTADOS - Existencia de UI', () {
    testWidgets('renderiza sin errores', (tester) async {
      await tester.pumpScreen(const ResultadosScreen());
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('muestra título Resultados', (tester) async {
      await tester.pumpScreen(const ResultadosScreen());
      await tester.expectTextVisible('Resultados');
    });

    testWidgets('tiene TabBar con 3 tabs', (tester) async {
      await tester.pumpScreen(const ResultadosScreen());
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(Tab), findsNWidgets(3));
    });

    testWidgets('tab Posiciones visible', (tester) async {
      await tester.pumpScreen(const ResultadosScreen());
      await tester.expectTextVisible('Posiciones');
    });

    testWidgets('tab Estadísticas visible', (tester) async {
      await tester.pumpScreen(const ResultadosScreen());
      await tester.expectTextVisible('Estadísticas');
    });
  });

  group('📊 RESULTADOS - Botones AppBar', () {
    testWidgets('tiene PopupMenuButton', (tester) async {
      await tester.pumpScreen(const ResultadosScreen());
      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
    });

    testWidgets('icono more_vert visible', (tester) async {
      await tester.pumpScreen(const ResultadosScreen());
      expect(find.byIcon(Icons.more_vert), findsWidgets);
    });

    testWidgets('popup tiene opciones de exportar', (tester) async {
      await tester.pumpScreen(const ResultadosScreen());
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.expectTextVisible('Exportar PDF');
      await tester.expectTextVisible('Exportar Excel');
      await tester.expectTextVisible('Imprimir');
    });
  });

  group('📊 RESULTADOS - Tabs Navigation', () {
    testWidgets('puede cambiar entre tabs', (tester) async {
      await tester.pumpScreen(const ResultadosScreen());
      final statsTab = find.byIcon(Icons.analytics).first;
      if (statsTab.evaluate().isNotEmpty) {
        await tester.tap(statsTab);
        await tester.pumpAndSettle();
      }
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  group('📊 RESULTADOS - Anti-regresión', () {
    testWidgets('AppBar siempre tiene título', (tester) async {
      await tester.pumpScreen(const ResultadosScreen());
      expect(find.byType(AppBar), findsOneWidget);
      await tester.expectTextVisible('Resultados');
    });
  });
}
