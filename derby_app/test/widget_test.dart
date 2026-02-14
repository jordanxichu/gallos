// Basic widget test for Derby App

import 'package:flutter_test/flutter_test.dart';

import 'package:derby_app/app.dart';

void main() {
  testWidgets('Derby app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DerbyApp());

    // Verify that the app loads with Dashboard
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
