import 'dart:io';

void main(List<String> args) {
  final options = _parseArgs(args);

  final expiresRaw = options['expires'];
  if (expiresRaw == null) {
    _printUsage('Falta --expires=YYYY-MM-DD');
    exit(1);
  }

  final expiresAt = DateTime.tryParse(expiresRaw);
  if (expiresAt == null) {
    _printUsage('Fecha inválida: $expiresRaw');
    exit(1);
  }

  final salt = options['salt'] ?? Platform.environment['DERBY_LICENSE_SALT'];
  if (salt == null || salt.trim().isEmpty) {
    _printUsage('Falta secret. Usa --salt=TU_SECRET o env DERBY_LICENSE_SALT');
    exit(1);
  }

  final customer = (options['customer'] ?? 'CLIENTE').trim().toUpperCase();
  final code = _generateActivationCode(
    expiresAt: expiresAt,
    salt: salt,
    customer: customer,
  );

  stdout.writeln('=== DERBY LICENSE GENERATOR ===');
  stdout.writeln('Cliente : $customer');
  stdout.writeln('Expira  : ${_formatDate(expiresAt)}');
  stdout.writeln('Código  : $code');
  stdout.writeln('--------------------------------');
  stdout.writeln('Mensaje sugerido al cliente:');
  stdout.writeln(
    'Tu licencia Derby Manager vence el ${_formatDate(expiresAt)}.\\n'
    'Código de activación: $code\\n'
    'Ingresa en Configuración > Licencia Offline > Activar licencia.',
  );
}

String _generateActivationCode({
  required DateTime expiresAt,
  required String salt,
  required String customer,
}) {
  final datePart =
      '${expiresAt.year.toString().padLeft(4, '0')}${expiresAt.month.toString().padLeft(2, '0')}${expiresAt.day.toString().padLeft(2, '0')}';
  final randomSeed = '${customer}_${expiresAt.millisecondsSinceEpoch}';
  final randomPart = (_checksum(randomSeed) % 1679616)
      .toRadixString(36)
      .toUpperCase()
      .padLeft(4, '0');

  final checksum = _checksumHex('DM-$datePart-$randomPart-$salt');
  return 'DM-$datePart-$randomPart-$checksum';
}

int _checksum(String value) {
  var acc = 0;
  for (final codeUnit in value.codeUnits) {
    acc = ((acc * 31) + codeUnit) % 65535;
  }
  return acc;
}

String _checksumHex(String value) {
  return _checksum(value).toRadixString(16).toUpperCase().padLeft(4, '0');
}

Map<String, String> _parseArgs(List<String> args) {
  final result = <String, String>{};
  for (final arg in args) {
    if (!arg.startsWith('--')) continue;
    final eq = arg.indexOf('=');
    if (eq == -1) continue;
    final key = arg.substring(2, eq).trim();
    final value = arg.substring(eq + 1).trim();
    if (key.isNotEmpty) {
      result[key] = value;
    }
  }
  return result;
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

void _printUsage(String error) {
  stderr.writeln('Error: $error');
  stderr.writeln('');
  stderr.writeln('Uso:');
  stderr.writeln(
    'dart run tool/generate_license.dart --expires=2026-12-31 --customer="RANCHO EL GALLO" --salt="TU_SECRET"',
  );
  stderr.writeln('');
  stderr.writeln('Alternativa secret por entorno:');
  stderr.writeln('DERBY_LICENSE_SALT="TU_SECRET" dart run tool/generate_license.dart --expires=2026-12-31');
}
