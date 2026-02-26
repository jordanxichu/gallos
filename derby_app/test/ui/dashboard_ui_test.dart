/// Tests de UI para Dashboard Screen.
///
/// Verifica:
/// - Widgets y elementos visibles
/// - Botones existentes y funcionales
/// - Estados correctos según datos
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:derby_app/screens/dashboard_screen.dart';
import 'ui_test_helpers.dart';

void main() {
  setUpAll(() => ignoreOverflowErrors());

  group('🖥️ DASHBOARD - Existencia de UI', () {
    testWidgets('renderiza sin errores', (tester) async {
      await tester.pumpScreen(const DashboardScreen());
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('muestra título Dashboard', (tester) async {
      await tester.pumpScreen(const DashboardScreen());
      await tester.expectTextVisible('Dashboard');
    });

    testWidgets('muestra icono de trofeo', (tester) async {
      await tester.pumpScreen(const DashboardScreen());
      await tester.expectIconVisible(Icons.emoji_events);
    });

    testWidgets('muestra tarjetas de estadísticas', (tester) async {
      await tester.pumpScreen(const DashboardScreen());
      expect(find.byType(Card), findsWidgets);
      await tester.expectTextVisible('Participantes');
      await tester.expectTextVisible('Gallos');
      await tester.expectTextVisible('Rondas');
      await tester.expectTextVisible('Peleas');
    });

    testWidgets('muestra texto de resumen', (tester) async {
      await tester.pumpScreen(const DashboardScreen());
      await tester.expectTextVisible('Resumen');
    });
  });

  group('🖥️ DASHBOARD - Botones', () {
    testWidgets('botón Nuevo Derbi existe en AppBar', (tester) async {
      await tester.pumpScreen(const DashboardScreen());
      expect(find.byIcon(Icons.add), findsWidgets);
    });

    testWidgets('botón Nuevo Derbi abre diálogo', (tester) async {
      await tester.pumpScreen(const DashboardScreen());
      final addButton = find.byIcon(Icons.add).first;
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      await tester.expectDialogVisible();
    });
  });

  group('🖥️ DASHBOARD - Estados', () {
    testWidgets('con cero participantes muestra 0', (tester) async {
      await tester.pumpScreen(const DashboardScreen());
      expect(find.text('0'), findsWidgets);
    });

    testWidgets('con cero peleas muestra 0/0', (tester) async {
      await tester.pumpScreen(const DashboardScreen());
      expect(find.text('0/0'), findsWidgets);
    });
  });

  group('🖥️ DASHBOARD - Diálogos', () {
    testWidgets('diálogo nuevo derbi tiene campo de nombre', (tester) async {
      await tester.pumpScreen(const DashboardScreen());
      final addButton = find.byIcon(Icons.add).first;
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('diálogo tiene botón cancelar', (tester) async {
      await tester.pumpScreen(const DashboardScreen());
      final addButton = find.byIcon(Icons.add).first;
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      expect(find.text('Cancelar'), findsWidgets);
    });

    testWidgets('cancelar cierra diálogo', (tester) async {
      await tester.pumpScreen(const DashboardScreen());
      final addButton = find.byIcon(Icons.add).first;
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      await tester.expectNoDialog();
    });
  });

  group('🖥️ DASHBOARD - Anti-regresión', () {
    testWidgets('AppBar tiene título', (tester) async {
      await tester.pumpScreen(const DashboardScreen());
      expect(find.byType(AppBar), findsOneWidget);
      await tester.expectTextVisible('Dashboard');
    });
  });
}
