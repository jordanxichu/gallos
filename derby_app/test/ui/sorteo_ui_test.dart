/// Tests de UI para Sorteo Screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:derby_app/screens/sorteo_screen.dart';
import 'package:derby_app/core/test_keys.dart';
import 'ui_test_helpers.dart';

void main() {
  setUpAll(() => ignoreOverflowErrors());

  group('🎲 SORTEO - Existencia de UI', () {
    testWidgets('renderiza sin errores', (tester) async {
      await tester.pumpScreen(const SorteoScreen());
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('muestra título Sorteo de Peleas', (tester) async {
      await tester.pumpScreen(const SorteoScreen());
      await tester.expectTextVisible('Sorteo de Peleas');
    });

    testWidgets('tiene AppBar con botón configuración', (tester) async {
      await tester.pumpScreen(const SorteoScreen());
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsWidgets);
    });
  });

  group('🎲 SORTEO - Estado Pre-Sorteo', () {
    testWidgets('muestra icono casino', (tester) async {
      await tester.pumpScreen(const SorteoScreen());
      expect(find.byIcon(Icons.casino), findsWidgets);
    });

    testWidgets('muestra estadísticas del derby', (tester) async {
      await tester.pumpScreen(const SorteoScreen());
      await tester.expectTextVisible('Participantes');
      await tester.expectTextVisible('Gallos');
      await tester.expectTextVisible('Rondas');
      await tester.expectTextVisible('Tolerancia');
    });

    testWidgets('muestra sección de validaciones', (tester) async {
      await tester.pumpScreen(const SorteoScreen());
      await tester.expectTextVisible('Validaciones');
    });
  });

  group('🎲 SORTEO - Botones', () {
    testWidgets('botón generar preview existe', (tester) async {
      await tester.pumpScreen(const SorteoScreen());
      // Buscar por key definida en SorteoKeys
      expect(find.byKey(SorteoKeys.btnGenerarPreview), findsOneWidget);
    });

    testWidgets('botón generar preview tiene texto correcto', (tester) async {
      await tester.pumpScreen(const SorteoScreen());
      expect(find.textContaining('GENERAR PREVIEW'), findsOneWidget);
    });
  });

  group('🎲 SORTEO - Diálogos', () {
    testWidgets('icono configuración abre diálogo', (tester) async {
      await tester.pumpScreen(const SorteoScreen());
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      await tester.expectDialogVisible();
    });
  });

  group('🎲 SORTEO - Keys definidas', () {
    testWidgets('keys de sorteo definidas', (tester) async {
      expect(SorteoKeys.btnGenerarPreview, isA<Key>());
      expect(SorteoKeys.btnAprobarSorteo, isA<Key>());
      expect(SorteoKeys.btnDescartarSorteo, isA<Key>());
    });
  });
}
