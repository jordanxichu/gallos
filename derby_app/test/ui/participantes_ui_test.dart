/// Tests de UI para Participantes Screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:derby_app/screens/participantes_screen.dart';
import 'package:derby_app/core/test_keys.dart';
import 'ui_test_helpers.dart';

void main() {
  setUpAll(() => ignoreOverflowErrors());

  group('👥 PARTICIPANTES - Existencia de UI', () {
    testWidgets('renderiza sin errores', (tester) async {
      await tester.pumpScreen(const ParticipantesScreen());
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('muestra título Participantes', (tester) async {
      await tester.pumpScreen(const ParticipantesScreen());
      await tester.expectTextVisible('Participantes');
    });

    testWidgets('tiene AppBar con acciones', (tester) async {
      await tester.pumpScreen(const ParticipantesScreen());
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.search), findsWidgets);
    });
  });

  group('👥 PARTICIPANTES - FAB', () {
    testWidgets('FAB agregar participante visible', (tester) async {
      await tester.pumpScreen(const ParticipantesScreen());
      await tester.expectKeyExists(ParticipantesKeys.fabAgregarParticipante);
    });

    testWidgets('FAB tiene icono person_add', (tester) async {
      await tester.pumpScreen(const ParticipantesScreen());
      expect(find.byIcon(Icons.person_add), findsWidgets);
    });

    testWidgets('FAB tiene texto Agregar', (tester) async {
      await tester.pumpScreen(const ParticipantesScreen());
      expect(find.text('Agregar'), findsWidgets);
    });
  });

  group('👥 PARTICIPANTES - Estado Vacío', () {
    testWidgets('muestra mensaje cuando no hay participantes', (tester) async {
      await tester.pumpScreen(const ParticipantesScreen());
      await tester.expectTextVisible('No hay participantes registrados');
    });

    testWidgets('muestra icono people_outline', (tester) async {
      await tester.pumpScreen(const ParticipantesScreen());
      expect(find.byIcon(Icons.people_outline), findsWidgets);
    });
  });

  group('👥 PARTICIPANTES - Keys', () {
    testWidgets('keys de participantes definidas', (tester) async {
      expect(ParticipantesKeys.fabAgregarParticipante, isA<Key>());
      expect(ParticipantesKeys.inputNombre, isA<Key>());
      expect(ParticipantesKeys.btnGuardarParticipante, isA<Key>());
    });
  });
}
