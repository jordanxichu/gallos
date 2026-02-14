import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Genera una huella digital única del dispositivo para vincular licencias.
/// 
/// La huella se basa en información de hardware y sistema operativo,
/// generando un hash SHA-256 que es difícil de falsificar.
class DeviceFingerprint {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static String? _cachedFingerprint;

  /// Genera u obtiene la huella digital del dispositivo actual.
  /// 
  /// Retorna un hash SHA-256 de 64 caracteres hexadecimales.
  static Future<String> generate() async {
    if (_cachedFingerprint != null) return _cachedFingerprint!;

    final components = <String>[];

    // Identificador de la app para evitar conflictos con otras apps
    components.add('derby_master_v1');

    if (Platform.isWindows) {
      final info = await _deviceInfo.windowsInfo;
      components.addAll([
        'windows',
        info.computerName,
        info.numberOfCores.toString(),
        info.systemMemoryInMegabytes.toString(),
        info.deviceId, // ID único del hardware
      ]);
    } else if (Platform.isMacOS) {
      final info = await _deviceInfo.macOsInfo;
      components.addAll([
        'macos',
        info.computerName,
        info.model,
        info.systemGUID ?? '', // ID único del hardware
        info.memorySize.toString(),
      ]);
    } else if (Platform.isLinux) {
      final info = await _deviceInfo.linuxInfo;
      components.addAll([
        'linux',
        info.name,
        info.machineId ?? '', // ID único de la máquina
        info.prettyName,
      ]);
    } else if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      components.addAll([
        'android',
        info.brand,
        info.model,
        info.id,
        info.fingerprint, // Huella del build
      ]);
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      components.addAll([
        'ios',
        info.name,
        info.model,
        info.identifierForVendor ?? '', // ID único para este vendor
      ]);
    }

    // Agregar salt adicional basado en características del sistema
    components.add(Platform.localHostname);
    components.add(Platform.numberOfProcessors.toString());

    // Generar hash SHA-256
    final data = components.join('|');
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);

    _cachedFingerprint = digest.toString();
    return _cachedFingerprint!;
  }

  /// Obtiene los primeros N caracteres de la huella (para mostrar al usuario).
  static Future<String> shortFingerprint([int length = 8]) async {
    final full = await generate();
    return full.substring(0, length).toUpperCase();
  }

  /// Limpia la caché de fingerprint (útil para testing).
  static void clearCache() {
    _cachedFingerprint = null;
  }

  /// Verifica si una huella coincide con la del dispositivo actual.
  static Future<bool> verify(String fingerprint) async {
    final current = await generate();
    return current == fingerprint;
  }

  /// Verifica si los primeros N caracteres coinciden (validación parcial).
  /// 
  /// Útil para verificar licencias que solo almacenan los primeros 8 caracteres.
  static Future<bool> verifyPartial(String partial, [int length = 8]) async {
    final short = await shortFingerprint(length);
    return short == partial.toUpperCase();
  }
}
