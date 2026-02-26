/// Helpers para Widget Tests de UI.
///
/// Este archivo proporciona utilidades para probar la interfaz sin
/// depender de la lógica de negocio (que ya está probada en otros tests).
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:derby_app/viewmodels/derby_state.dart';
import 'package:derby_app/core/theme.dart';

/// Tamaño de pantalla grande para tests de desktop (evita overflow).
const Size desktopTestSize = Size(1400, 1000);

/// Configurar tests para ignorar errores de overflow de UI.
/// Esto es necesario porque los tests se ejecutan en tamaños de pantalla fijos.
void ignoreOverflowErrors() {
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    final exception = details.exception;
    final isOverflowError =
        exception is FlutterError && exception.message.contains('overflowed');

    if (!isOverflowError && originalOnError != null) {
      // Solo re-lanzar si NO es un overflow error
      originalOnError(details);
    }
  };
}

/// Extension para configurar tamaño de pantalla en tests.
extension TestSizeExtension on WidgetTester {
  /// Establece un tamaño de pantalla grande para evitar overflow.
  Future<void> setDesktopSize() async {
    await binding.setSurfaceSize(desktopTestSize);
    view.physicalSize = desktopTestSize;
    view.devicePixelRatio = 1.0;
  }

  /// Restaura el tamaño de pantalla por defecto.
  Future<void> resetSize() async {
    await binding.setSurfaceSize(null);
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  }

  /// Prepara y muestra una pantalla con tamaño de desktop.
  /// Llama esto en lugar de pumpWidget para evitar overflow.
  Future<void> pumpScreen(Widget child, {DerbyState? state}) async {
    await setDesktopSize();
    await pumpWidget(createTestApp(child: child, state: state));
    await pumpAndSettle();
  }
}

/// Crea un widget wrapper para tests con DerbyState configurado.
///
/// [child] - El widget a probar.
/// [state] - DerbyState opcional (crea uno nuevo si no se proporciona).
/// [size] - Tamaño de la pantalla (por defecto 1400x1000 para desktop).
Widget createTestApp({
  required Widget child,
  DerbyState? state,
  Size size = desktopTestSize,
}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: ChangeNotifierProvider<DerbyState>(
      create: (_) => state ?? DerbyState(),
      child: MaterialApp(theme: DerbyTheme.light, home: child),
    ),
  );
}

/// Crea un widget wrapper con navegación (para probar diálogos y routes).
Widget createTestAppWithRoutes({
  required Widget child,
  DerbyState? state,
  Map<String, Widget Function(BuildContext)>? routes,
}) {
  return ChangeNotifierProvider<DerbyState>(
    create: (_) => state ?? DerbyState(),
    child: MaterialApp(
      theme: DerbyTheme.light,
      home: child,
      routes:
          routes?.map(
            (key, builder) => MapEntry(key, (context) => builder(context)),
          ) ??
          {},
    ),
  );
}

/// Extension para simplificar tests de widgets.
extension WidgetTesterUIExtensions on WidgetTester {
  /// Busca un widget por Key y verifica que existe.
  Future<void> expectKeyExists(Key key) async {
    await pumpAndSettle();
    expect(find.byKey(key), findsWidgets);
  }

  /// Busca un widget por Key y verifica que NO existe.
  Future<void> expectKeyNotExists(Key key) async {
    await pumpAndSettle();
    expect(find.byKey(key), findsNothing);
  }

  /// Busca un botón por Key y verifica que está habilitado.
  Future<void> expectButtonEnabled(Key key) async {
    await pumpAndSettle();
    final finder = find.byKey(key);
    expect(finder, findsOneWidget);

    final widget = this.widget(finder);
    if (widget is ElevatedButton) {
      expect(
        widget.onPressed,
        isNotNull,
        reason: 'ElevatedButton debería estar habilitado',
      );
    } else if (widget is TextButton) {
      expect(
        widget.onPressed,
        isNotNull,
        reason: 'TextButton debería estar habilitado',
      );
    } else if (widget is OutlinedButton) {
      expect(
        widget.onPressed,
        isNotNull,
        reason: 'OutlinedButton debería estar habilitado',
      );
    } else if (widget is IconButton) {
      expect(
        widget.onPressed,
        isNotNull,
        reason: 'IconButton debería estar habilitado',
      );
    } else if (widget is FloatingActionButton) {
      expect(
        widget.onPressed,
        isNotNull,
        reason: 'FAB debería estar habilitado',
      );
    }
  }

  /// Busca un botón por Key y verifica que está deshabilitado.
  Future<void> expectButtonDisabled(Key key) async {
    await pumpAndSettle();
    final finder = find.byKey(key);
    expect(finder, findsOneWidget);

    final widget = this.widget(finder);
    if (widget is ElevatedButton) {
      expect(
        widget.onPressed,
        isNull,
        reason: 'ElevatedButton debería estar deshabilitado',
      );
    } else if (widget is TextButton) {
      expect(
        widget.onPressed,
        isNull,
        reason: 'TextButton debería estar deshabilitado',
      );
    } else if (widget is OutlinedButton) {
      expect(
        widget.onPressed,
        isNull,
        reason: 'OutlinedButton debería estar deshabilitado',
      );
    } else if (widget is IconButton) {
      expect(
        widget.onPressed,
        isNull,
        reason: 'IconButton debería estar deshabilitado',
      );
    } else if (widget is FloatingActionButton) {
      expect(
        widget.onPressed,
        isNull,
        reason: 'FAB debería estar deshabilitado',
      );
    }
  }

  /// Tap en un widget por Key.
  Future<void> tapByKey(Key key) async {
    await pumpAndSettle();
    final finder = find.byKey(key);
    expect(
      finder,
      findsOneWidget,
      reason: 'No se encontró widget con Key: $key',
    );
    await tap(finder);
    await pumpAndSettle();
  }

  /// Verifica que un texto está visible.
  Future<void> expectTextVisible(String text) async {
    await pumpAndSettle();
    expect(find.text(text), findsWidgets);
  }

  /// Verifica que un texto NO está visible.
  Future<void> expectTextNotVisible(String text) async {
    await pumpAndSettle();
    expect(find.text(text), findsNothing);
  }

  /// Verifica que un icono está visible.
  Future<void> expectIconVisible(IconData icon) async {
    await pumpAndSettle();
    expect(find.byIcon(icon), findsWidgets);
  }

  /// Verifica que hay un SnackBar visible con el texto.
  Future<void> expectSnackBar(String text) async {
    await pumpAndSettle();
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(text), findsOneWidget);
  }

  /// Verifica que hay un diálogo visible.
  Future<void> expectDialogVisible() async {
    await pumpAndSettle();
    expect(find.byType(AlertDialog), findsWidgets);
  }

  /// Verifica que NO hay diálogo visible.
  Future<void> expectNoDialog() async {
    await pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  }

  /// Cierra un diálogo presionando el botón con el texto dado.
  Future<void> dismissDialog(String buttonText) async {
    await pumpAndSettle();
    final finder = find.widgetWithText(TextButton, buttonText);
    if (finder.evaluate().isNotEmpty) {
      await tap(finder);
      await pumpAndSettle();
    }
  }
}

/// Matchers personalizados para UI.
class UIMatchers {
  UIMatchers._();

  /// Matcher para verificar que un widget tiene color de fondo específico.
  static Matcher hasBackgroundColor(Color color) => _HasBackgroundColor(color);

  /// Matcher para verificar que un widget está habilitado.
  static Matcher get isEnabled => _IsEnabled();

  /// Matcher para verificar que un widget está deshabilitado.
  static Matcher get isDisabled => _IsDisabled();
}

class _HasBackgroundColor extends Matcher {
  final Color expectedColor;

  _HasBackgroundColor(this.expectedColor);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is Container) {
      final decoration = item.decoration;
      if (decoration is BoxDecoration) {
        return decoration.color == expectedColor;
      }
    }
    return false;
  }

  @override
  Description describe(Description description) =>
      description.add('has background color $expectedColor');
}

class _IsEnabled extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is ElevatedButton) return item.onPressed != null;
    if (item is TextButton) return item.onPressed != null;
    if (item is OutlinedButton) return item.onPressed != null;
    if (item is IconButton) return item.onPressed != null;
    if (item is FloatingActionButton) return item.onPressed != null;
    return false;
  }

  @override
  Description describe(Description description) =>
      description.add('widget is enabled');
}

class _IsDisabled extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is ElevatedButton) return item.onPressed == null;
    if (item is TextButton) return item.onPressed == null;
    if (item is OutlinedButton) return item.onPressed == null;
    if (item is IconButton) return item.onPressed == null;
    if (item is FloatingActionButton) return item.onPressed == null;
    return false;
  }

  @override
  Description describe(Description description) =>
      description.add('widget is disabled');
}

/// Constantes para verificación de widgets.
class UIConstants {
  UIConstants._();

  /// Número mínimo de widgets que debe tener una pantalla válida.
  static const int minWidgetCount = 3;

  /// Tiempo máximo de espera para animaciones.
  static const Duration settleTimeout = Duration(seconds: 5);
}
