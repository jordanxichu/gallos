import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'screens/shell_screen.dart';
import 'viewmodels/derby_state.dart';

/// Aplicación principal de Derby Manager.
class DerbyApp extends StatelessWidget {
  const DerbyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final state = DerbyState();
        // Cargar datos persistidos al iniciar
        state.cargarDatos();
        return state;
      },
      child: MaterialApp(
        title: 'Derby Manager',
        debugShowCheckedModeBanner: false,
        theme: DerbyTheme.light,
        darkTheme: DerbyTheme.dark,
        themeMode: ThemeMode.light,
        home: const ShellScreen(),
      ),
    );
  }
}
