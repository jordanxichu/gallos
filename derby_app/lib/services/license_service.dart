import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LicenseInfo {
  final String code;
  final DateTime expiresAt;
  final DateTime activatedAt;

  const LicenseInfo({
    required this.code,
    required this.expiresAt,
    required this.activatedAt,
  });

  bool get isActive => DateTime.now().isBefore(expiresAt);

  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) return 0;
    return expiresAt.difference(now).inDays;
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'expiresAt': expiresAt.toIso8601String(),
        'activatedAt': activatedAt.toIso8601String(),
      };

  factory LicenseInfo.fromJson(Map<String, dynamic> json) => LicenseInfo(
        code: json['code'] as String,
        expiresAt: DateTime.parse(json['expiresAt'] as String),
        activatedAt: DateTime.parse(json['activatedAt'] as String),
      );
}

class LicenseService {
  static const String _fileName = 'license_state.json';
  static const String _salt = String.fromEnvironment(
    'DERBY_LICENSE_SALT',
    defaultValue: 'DEV_ONLY_CHANGE_THIS_SALT',
  );

  Future<LicenseInfo?> loadLicense() async {
    final file = await _licenseFile();
    if (!await file.exists()) return null;

    try {
      final raw = await file.readAsString();
      final data = jsonDecode(raw) as Map<String, dynamic>;
      return LicenseInfo.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLicense(LicenseInfo info) async {
    final file = await _licenseFile();
    await file.writeAsString(jsonEncode(info.toJson()));
  }

  Future<void> clearLicense() async {
    final file = await _licenseFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  LicenseInfo? validateActivationCode(String inputCode) {
    final normalized = inputCode.trim().toUpperCase();
    final parts = normalized.split('-');
    if (parts.length != 4 || parts[0] != 'DM') return null;

    final datePart = parts[1];
    final randomPart = parts[2];
    final checksumPart = parts[3];

    if (datePart.length != 8 || randomPart.isEmpty || checksumPart.length != 4) {
      return null;
    }

    final expiresAt = _parseDate(datePart);
    if (expiresAt == null) return null;

    final expected = _checksum('DM-$datePart-$randomPart-$_salt');
    if (expected != checksumPart) return null;

    return LicenseInfo(
      code: normalized,
      expiresAt: DateTime(expiresAt.year, expiresAt.month, expiresAt.day, 23, 59, 59),
      activatedAt: DateTime.now(),
    );
  }

  String generateActivationCode(DateTime expiresAt) {
    final datePart =
        '${expiresAt.year.toString().padLeft(4, '0')}${expiresAt.month.toString().padLeft(2, '0')}${expiresAt.day.toString().padLeft(2, '0')}';
    final randomPart = (expiresAt.millisecondsSinceEpoch % 1679616)
        .toRadixString(36)
        .toUpperCase()
        .padLeft(4, '0');
    final checksum = _checksum('DM-$datePart-$randomPart-$_salt');
    return 'DM-$datePart-$randomPart-$checksum';
  }

  bool get usandoSaltPorDefecto => _salt == 'DEV_ONLY_CHANGE_THIS_SALT';

  DateTime? _parseDate(String yyyymmdd) {
    try {
      final year = int.parse(yyyymmdd.substring(0, 4));
      final month = int.parse(yyyymmdd.substring(4, 6));
      final day = int.parse(yyyymmdd.substring(6, 8));
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  String _checksum(String value) {
    var acc = 0;
    for (final codeUnit in value.codeUnits) {
      acc = ((acc * 31) + codeUnit) % 65535;
    }
    return acc.toRadixString(16).toUpperCase().padLeft(4, '0');
  }

  Future<File> _licenseFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_fileName');
  }
}
