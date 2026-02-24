import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/app_state.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const LicenseAdminApp());
}

class LicenseAdminApp extends StatelessWidget {
  const LicenseAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..initialize(),
      child: MaterialApp(
        title: 'Derby Master - Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
