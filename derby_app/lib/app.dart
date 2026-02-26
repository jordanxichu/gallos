import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'screens/shell_screen.dart';
import 'screens/terms_screen.dart';
import 'services/terms_service.dart';
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
        home: const _AppHome(),
      ),
    );
  }
}

/// Widget que maneja la verificación de términos aceptados.
class _AppHome extends StatefulWidget {
  const _AppHome();

  @override
  State<_AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<_AppHome> {
  bool _isLoading = true;
  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    _checkTerms();
  }

  Future<void> _checkTerms() async {
    final accepted = await TermsService.hasAcceptedTerms();
    setState(() {
      _termsAccepted = accepted;
      _isLoading = false;
    });
  }

  void _onTermsAccepted() {
    setState(() => _termsAccepted = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_termsAccepted) {
      return TermsScreen(onAccepted: _onTermsAccepted);
    }

    return const ShellScreen();
  }
}
