/// Tests de UI para Gallos Screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:derby_app/screens/gallos_screen.dart';
import 'package:derby_app/core/test_keys.dart';
import 'ui_test_helpers.dart';

void main() {
  setUpAll(() => ignoreOverflowErrors());

  group('🐓 GALLOS - Existencia de UI', () {
    testWidgets('renderiza sin errores', (tester) async {
      await tester.pumpScreen(const GallosScreen());
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('muestra título Gallos', (tester) async {
      await tester.pumpScreen(const GallosScreen());
      await tester.expectTextVisible('Gallos');
    });

    testWidgets('tiene AppBar con botón filtrar', (tester) async {
      await tester.pumpScreen(const GallosScreen());
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsWidgets);
    });
  });

  group('🐓 GALLOS - FAB', () {
    testWidgets('FAB agregar gallo existe', (tester) async {
      await tester.pumpScreen(const GallosScreen());
      await tester.expectKeyExists(GallosKeys.fabAgregarGallo);
    });

    testWidgets('FAB tiene icono add', (tester) async {
      await tester.pumpScreen(const GallosScreen());
      expect(find.byIcon(Icons.add), findsWidgets);
    });

    testWidgets('FAB tiene texto Agregar Gallo', (tester) async {
      await tester.pumpScreen(const GallosScreen());
      expect(find.text('Agregar Gallo'), findsWidgets);
    });
  });

  group('🐓 GALLOS - Estado Vacío', () {
    testWidgets('muestra mensaje sin gallos', (tester) async {
      await tester.pumpScreen(const GallosScreen());
      await tester.expectTextVisible('No hay gallos registrados');
    });

    testWidgets('muestra icono pets', (tester) async {
      await tester.pumpScreen(const GallosScreen());
      expect(find.byIcon(Icons.pets), findsWidgets);
    });

    testWidgets('indica que se necesitan participantes', (tester) async {
      await tester.pumpScreen(const GallosScreen());
      await tester.expectTextVisible('Primero registra participantes');
    });
  });

  group('🐓 GALLOS - Keys', () {
    testWidgets('keys de gallos definidas', (tester) async {
      expect(GallosKeys.fabAgregarGallo, isA<Key>());
      expect(GallosKeys.inputAnillo, isA<Key>());
      expect(GallosKeys.inputPeso, isA<Key>());
      expect(GallosKeys.btnGuardarGallo, isA<Key>());
    });
  });
}
