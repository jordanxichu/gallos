/// Tests de UI para Peleas Screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:derby_app/screens/peleas_screen.dart';
import 'package:derby_app/core/test_keys.dart';
import 'ui_test_helpers.dart';

void main() {
  setUpAll(() => ignoreOverflowErrors());

  group('🥊 PELEAS - Existencia de UI', () {
    testWidgets('renderiza sin errores', (tester) async {
      await tester.pumpScreen(const PeleasScreen());
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('muestra título Peleas', (tester) async {
      await tester.pumpScreen(const PeleasScreen());
      await tester.expectTextVisible('Peleas');
    });
  });

  group('🥊 PELEAS - Estado Sin Sorteo', () {
    testWidgets('muestra mensaje sin peleas', (tester) async {
      await tester.pumpScreen(const PeleasScreen());
      await tester.expectTextVisible('No hay peleas programadas');
    });

    testWidgets('indica que se necesita sorteo', (tester) async {
      await tester.pumpScreen(const PeleasScreen());
      await tester.expectTextVisible('Realiza el sorteo primero');
    });

    testWidgets('muestra icono sports_kabaddi', (tester) async {
      await tester.pumpScreen(const PeleasScreen());
      expect(find.byIcon(Icons.sports_kabaddi), findsWidgets);
    });
  });

  group('🥊 PELEAS - Keys', () {
    testWidgets('keys de peleas definidas', (tester) async {
      expect(PeleasKeys.btnRondaAnterior, isA<Key>());
      expect(PeleasKeys.btnRondaSiguiente, isA<Key>());
      expect(PeleasKeys.bannerRondaBloqueada, isA<Key>());
      expect(PeleasKeys.btnDesbloquearRonda, isA<Key>());
    });

    testWidgets('key functions para peleas', (tester) async {
      expect(PeleasKeys.peleaCard('test'), isA<Key>());
      expect(PeleasKeys.btnGanaRojo('test'), isA<Key>());
      expect(PeleasKeys.btnGanaVerde('test'), isA<Key>());
      expect(PeleasKeys.btnEmpate('test'), isA<Key>());
      expect(PeleasKeys.btnDeshacer('test'), isA<Key>());
    });
  });

  group('🥊 PELEAS - Anti-regresión', () {
    testWidgets('AppBar siempre visible', (tester) async {
      await tester.pumpScreen(const PeleasScreen());
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
