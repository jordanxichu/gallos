/// Tests de UI para Configuración Screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:derby_app/screens/configuracion_screen.dart';
import 'package:derby_app/core/test_keys.dart';
import 'ui_test_helpers.dart';

void main() {
  setUpAll(() => ignoreOverflowErrors());

  group('⚙️ CONFIGURACIÓN - Existencia de UI', () {
    testWidgets('renderiza sin errores', (tester) async {
      await tester.pumpScreen(const ConfiguracionScreen());
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('muestra título Configuración del Derby', (tester) async {
      await tester.pumpScreen(const ConfiguracionScreen());
      await tester.expectTextVisible('Configuración del Derby');
    });

    testWidgets('tiene AppBar con botón restaurar', (tester) async {
      await tester.pumpScreen(const ConfiguracionScreen());
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.restore), findsWidgets);
    });
  });

  group('⚙️ CONFIGURACIÓN - Secciones', () {
    testWidgets('sección Formato del Torneo visible', (tester) async {
      await tester.pumpScreen(const ConfiguracionScreen());
      await tester.expectTextVisible('Formato del Torneo');
    });

    testWidgets('sección Sistema de Puntos visible', (tester) async {
      await tester.pumpScreen(const ConfiguracionScreen());
      await tester.expectTextVisible('Sistema de Puntos');
    });

    testWidgets('sección Estado Actual visible', (tester) async {
      await tester.pumpScreen(const ConfiguracionScreen());
      await tester.expectTextVisible('Estado Actual');
    });

    testWidgets('sección Licencia visible', (tester) async {
      await tester.pumpScreen(const ConfiguracionScreen());
      await tester.expectTextVisible('Licencia');
    });
  });

  group('⚙️ CONFIGURACIÓN - Campos', () {
    testWidgets('campo Número de Rondas existe', (tester) async {
      await tester.pumpScreen(const ConfiguracionScreen());
      await tester.expectTextVisible('Número de Rondas');
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('campo Tolerancia de Peso existe', (tester) async {
      await tester.pumpScreen(const ConfiguracionScreen());
      await tester.expectTextVisible('Tolerancia de Peso');
    });

    testWidgets('campos de puntos existen', (tester) async {
      await tester.pumpScreen(const ConfiguracionScreen());
      await tester.expectTextVisible('Victoria');
      await tester.expectTextVisible('Derrota');
      await tester.expectTextVisible('Empate');
    });
  });

  group('⚙️ CONFIGURACIÓN - Keys', () {
    testWidgets('keys de configuración definidas', (tester) async {
      expect(ConfiguracionKeys.inputNumeroRondas, isA<Key>());
      expect(ConfiguracionKeys.inputTolerancia, isA<Key>());
      expect(ConfiguracionKeys.btnGuardarConfig, isA<Key>());
      expect(ConfiguracionKeys.btnExportarBackup, isA<Key>());
      expect(ConfiguracionKeys.btnImportarBackup, isA<Key>());
      expect(ConfiguracionKeys.btnActivarLicencia, isA<Key>());
    });
  });

  group('⚙️ CONFIGURACIÓN - Anti-regresión', () {
    testWidgets('scroll funciona', (tester) async {
      await tester.pumpScreen(const ConfiguracionScreen());
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });
  });
}
