// Basic widget test for Derby App

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:derby_app/app.dart';

void main() {
  testWidgets('Derby app smoke test - shows terms on first launch', (
    WidgetTester tester,
  ) async {
    // Reset SharedPreferences for clean test
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(const DerbyApp());
    await tester.pumpAndSettle();

    // Verify that the app loads with Terms screen on first launch
    expect(find.text('HOJA DE DESCARGO DE RESPONSABILIDAD'), findsOneWidget);
  });

  testWidgets('Derby app - shows Dashboard after terms accepted', (
    WidgetTester tester,
  ) async {
    // Simulate terms already accepted
    SharedPreferences.setMockInitialValues({
      'terms_accepted': true,
      'terms_accepted_date': DateTime.now().toIso8601String(),
      'organizer_name': 'Test Organizer',
    });

    // Build our app and trigger a frame.
    await tester.pumpWidget(const DerbyApp());
    await tester.pumpAndSettle();

    // Verify that the app loads with Dashboard
    expect(find.text('Dashboard'), findsWidgets);
  });

  testWidgets('Terms screen shows required elements', (
    WidgetTester tester,
  ) async {
    // Reset for clean test
    SharedPreferences.setMockInitialValues({});

    // Set larger viewport to fit terms screen
    await tester.binding.setSurfaceSize(const Size(1400, 1000));

    await tester.pumpWidget(const DerbyApp());
    await tester.pumpAndSettle();

    // Verify terms screen elements
    expect(find.text('HOJA DE DESCARGO DE RESPONSABILIDAD'), findsOneWidget);
    expect(find.text('USO DE SOFTWARE DE GESTIÓN DE DERBY'), findsOneWidget);
    
    // Verify there's a name input field
    expect(find.byType(TextField), findsOneWidget);
    
    // Verify checkbox exists
    expect(find.byType(CheckboxListTile), findsOneWidget);
  });
}
