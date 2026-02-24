import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/asn1.dart';

/// ══════════════════════════════════════════════════════════════════════════
/// DERBY MASTER - LICENSE TOOL
/// ══════════════════════════════════════════════════════════════════════════
/// 
/// Herramienta de línea de comandos para:
/// 1. Generar par de claves RSA (pública/privada)
/// 2. Generar licencias firmadas
/// 3. Verificar licencias existentes
/// 
/// USO:
///   dart run license_tool generate-keys
///   dart run license_tool create --type monthly --holder "Cliente X" --device ABC12345
///   dart run license_tool verify --code "DERBY-xxxxx.xxxxx"
/// ══════════════════════════════════════════════════════════════════════════

void main(List<String> arguments) async {
  // Setup subcommand: create
  final createParser = ArgParser()
    ..addOption('type', 
        abbr: 't', 
        allowed: ['demo', 'monthly', 'annual', 'lifetime'],
        defaultsTo: 'monthly',
        help: 'Tipo de licencia')
    ..addOption('holder', abbr: 'n', help: 'Nombre del titular')
    ..addOption('email', abbr: 'e', help: 'Email del titular')
    ..addOption('device', abbr: 'd', help: 'Prefijo de dispositivo (8 chars, opcional)')
    ..addOption('days', help: 'Días de validez (para monthly/annual)', defaultsTo: '30')
    ..addOption('private-key', abbr: 'k', help: 'Ruta al archivo de clave privada', defaultsTo: 'private_key.pem');

  // Setup subcommand: verify
  final verifyParser = ArgParser()
    ..addOption('code', abbr: 'c', help: 'Código de licencia a verificar')
    ..addOption('public-key', abbr: 'k', help: 'Ruta al archivo de clave pública', defaultsTo: 'public_key.pem');

  final parser = ArgParser()
    ..addCommand('generate-keys')
    ..addCommand('create', createParser)
    ..addCommand('verify', verifyParser)
    ..addFlag('help', abbr: 'h', help: 'Muestra ayuda');

  try {
    final results = parser.parse(arguments);

    if (results['help'] == true || results.command == null) {
      _printUsage(parser);
      return;
    }

    switch (results.command!.name) {
      case 'generate-keys':
        await _generateKeys();
        break;
      case 'create':
        final createResults = results.command!;
        await _createLicense(
          type: createResults['type'] as String,
          holder: createResults['holder'] as String?,
          email: createResults['email'] as String?,
          devicePrefix: createResults['device'] as String?,
          days: int.parse(createResults['days'] as String),
          privateKeyPath: createResults['private-key'] as String,
        );
        break;
      case 'verify':
        final verifyResults = results.command!;
        await _verifyLicense(
          code: verifyResults['code'] as String,
          publicKeyPath: verifyResults['public-key'] as String,
        );
        break;
    }
  } catch (e) {
    print('❌ Error: $e');
    _printUsage(parser);
    exit(1);
  }
}

void _printUsage(ArgParser parser) {
  print('''
╔══════════════════════════════════════════════════════════════════╗
║               DERBY MASTER - LICENSE TOOL                       ║
╠══════════════════════════════════════════════════════════════════╣
║  Herramienta para generar y verificar licencias comerciales     ║
╚══════════════════════════════════════════════════════════════════╝

COMANDOS:

  generate-keys    Genera un nuevo par de claves RSA (2048 bits)
                   Crea: private_key.pem y public_key.pem
                   
  create           Genera una nueva licencia firmada
    -t, --type     Tipo: demo, monthly, annual, lifetime
    -n, --holder   Nombre del titular
    -e, --email    Email del titular  
    -d, --device   Prefijo de dispositivo (8 chars, para vincular)
    --days         Días de validez (default: 30)
    -k, --private-key  Archivo de clave privada (default: private_key.pem)
    
  verify           Verifica una licencia existente
    -c, --code     Código de licencia
    -k, --public-key   Archivo de clave pública (default: public_key.pem)

EJEMPLOS:

  # Generar claves (solo una vez)
  dart run license_tool generate-keys
  
  # Crear licencia mensual para un cliente
  dart run license_tool create -t monthly -n "Juan Pérez" --days 30
  
  # Crear licencia anual vinculada a dispositivo
  dart run license_tool create -t annual -n "Empresa X" -d ABC12345 --days 365
  
  # Crear licencia de por vida
  dart run license_tool create -t lifetime -n "VIP Client"
  
  # Verificar licencia
  dart run license_tool verify -c "DERBY-xxxxx.xxxxx"

IMPORTANTE:
  - La clave privada (private_key.pem) NUNCA debe compartirse
  - La clave pública debe copiarse a la app (license_manager.dart)
  - Los dispositivos obtienen su prefijo con: shortFingerprint()
''');
}

// ══════════════════════════════════════════════════════════════════════════
// GENERACIÓN DE CLAVES RSA
// ══════════════════════════════════════════════════════════════════════════

Future<void> _generateKeys() async {
  print('🔐 Generando par de claves RSA-2048...\n');
  
  // Generar claves RSA de 2048 bits
  final keyGen = RSAKeyGenerator()
    ..init(ParametersWithRandom(
      RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
      _secureRandom(),
    ));

  final pair = keyGen.generateKeyPair();
  final publicKey = pair.publicKey as RSAPublicKey;
  final privateKey = pair.privateKey as RSAPrivateKey;

  // Guardar clave privada
  final privatePem = _encodePrivateKeyToPem(privateKey);
  await File('private_key.pem').writeAsString(privatePem);
  print('✅ Clave PRIVADA guardada en: private_key.pem');
  print('   ⚠️  MANTENER EN SECRETO - NO compartir ni incluir en la app\n');

  // Guardar clave pública
  final publicPem = _encodePublicKeyToPem(publicKey);
  await File('public_key.pem').writeAsString(publicPem);
  print('✅ Clave PÚBLICA guardada en: public_key.pem');
  print('   📋 Copiar esta clave a license_manager.dart en la app\n');
  
  print('═══════════════════════════════════════════════════════════════');
  print('CLAVE PÚBLICA (para incluir en la app):');
  print('═══════════════════════════════════════════════════════════════');
  print(publicPem);
}

SecureRandom _secureRandom() {
  final secureRandom = FortunaRandom();
  final seedSource = Random.secure();
  final seeds = List<int>.generate(32, (_) => seedSource.nextInt(255));
  secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
  return secureRandom;
}

String _encodePublicKeyToPem(RSAPublicKey publicKey) {
  final algorithmSeq = ASN1Sequence()
    ..add(ASN1ObjectIdentifier.fromName('rsaEncryption'))
    ..add(ASN1Null());

  final publicKeySeq = ASN1Sequence()
    ..add(ASN1Integer(publicKey.modulus!))
    ..add(ASN1Integer(publicKey.exponent!));

  final publicKeyBitString = ASN1BitString(stringValues: publicKeySeq.encode());

  final topLevelSeq = ASN1Sequence()
    ..add(algorithmSeq)
    ..add(publicKeyBitString);

  final dataBase64 = base64Encode(topLevelSeq.encode());
  final chunks = <String>[];
  for (var i = 0; i < dataBase64.length; i += 64) {
    chunks.add(dataBase64.substring(i, i + 64 > dataBase64.length ? dataBase64.length : i + 64));
  }

  return '-----BEGIN PUBLIC KEY-----\n${chunks.join('\n')}\n-----END PUBLIC KEY-----\n';
}

String _encodePrivateKeyToPem(RSAPrivateKey privateKey) {
  final topLevelSeq = ASN1Sequence()
    ..add(ASN1Integer(BigInt.zero)) // version
    ..add(ASN1Integer(privateKey.n!))
    ..add(ASN1Integer(privateKey.publicExponent!))
    ..add(ASN1Integer(privateKey.privateExponent!))
    ..add(ASN1Integer(privateKey.p!))
    ..add(ASN1Integer(privateKey.q!))
    ..add(ASN1Integer(privateKey.privateExponent! % (privateKey.p! - BigInt.one)))
    ..add(ASN1Integer(privateKey.privateExponent! % (privateKey.q! - BigInt.one)))
    ..add(ASN1Integer(privateKey.q!.modInverse(privateKey.p!)));

  final dataBase64 = base64Encode(topLevelSeq.encode());
  final chunks = <String>[];
  for (var i = 0; i < dataBase64.length; i += 64) {
    chunks.add(dataBase64.substring(i, i + 64 > dataBase64.length ? dataBase64.length : i + 64));
  }

  return '-----BEGIN RSA PRIVATE KEY-----\n${chunks.join('\n')}\n-----END RSA PRIVATE KEY-----\n';
}

// ══════════════════════════════════════════════════════════════════════════
// CREACIÓN DE LICENCIA
// ══════════════════════════════════════════════════════════════════════════

Future<void> _createLicense({
  required String type,
  String? holder,
  String? email,
  String? devicePrefix,
  required int days,
  required String privateKeyPath,
}) async {
  print('📝 Creando licencia...\n');

  // Cargar clave privada
  final privateKeyFile = File(privateKeyPath);
  if (!privateKeyFile.existsSync()) {
    throw Exception('No se encontró archivo de clave privada: $privateKeyPath\n'
        'Ejecuta primero: dart run license_tool generate-keys');
  }
  final privateKeyPem = await privateKeyFile.readAsString();
  final privateKey = _parsePrivateKey(privateKeyPem);

  // Generar ID único
  final licenseId = _generateLicenseId();

  // Calcular fecha de expiración
  DateTime? expiresAt;
  if (type != 'lifetime') {
    expiresAt = DateTime.now().add(Duration(days: days));
  }

  // Crear payload
  final payload = <String, dynamic>{
    'licenseId': licenseId,
    'type': type,
    'issuedAt': DateTime.now().toIso8601String(),
    if (expiresAt != null) 'expiresAt': expiresAt.toIso8601String(),
    if (holder != null) 'holderName': holder,
    if (email != null) 'holderEmail': email,
    if (devicePrefix != null) 'devicePrefix': devicePrefix.toUpperCase().substring(0, 8),
  };

  // Serializar y codificar payload
  final payloadJson = jsonEncode(payload);
  final payloadBase64 = base64Encode(utf8.encode(payloadJson));

  // Firmar con RSA
  final signature = _signData(payloadBase64, privateKey);
  final signatureBase64 = base64Encode(signature);

  // Generar código final
  final licenseCode = 'DERBY-$payloadBase64.$signatureBase64';

  // Mostrar resultado
  print('═══════════════════════════════════════════════════════════════');
  print('LICENCIA GENERADA');
  print('═══════════════════════════════════════════════════════════════');
  print('ID:           $licenseId');
  print('Tipo:         ${_typeLabel(type)}');
  print('Titular:      ${holder ?? "(no especificado)"}');
  print('Email:        ${email ?? "(no especificado)"}');
  print('Dispositivo:  ${devicePrefix?.toUpperCase() ?? "(cualquiera)"}');
  print('Emitida:      ${DateTime.now().toLocal()}');
  print('Expira:       ${expiresAt?.toLocal() ?? "Nunca (lifetime)"}');
  print('═══════════════════════════════════════════════════════════════');
  print('\nCÓDIGO DE LICENCIA (copiar completo):');
  print('───────────────────────────────────────────────────────────────');
  print(licenseCode);
  print('───────────────────────────────────────────────────────────────');

  // Guardar también en archivo
  final filename = 'license_${licenseId.substring(0, 8)}.txt';
  await File(filename).writeAsString('''
DERBY MASTER - LICENCIA COMERCIAL
==================================
ID: $licenseId
Tipo: ${_typeLabel(type)}
Titular: ${holder ?? "(no especificado)"}
Dispositivo: ${devicePrefix?.toUpperCase() ?? "(cualquiera)"}
Emitida: ${DateTime.now().toLocal()}
Expira: ${expiresAt?.toLocal() ?? "Nunca"}

CÓDIGO:
$licenseCode
''');
  print('\n✅ Licencia guardada en: $filename');
}

String _generateLicenseId() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
}

String _typeLabel(String type) {
  switch (type) {
    case 'demo': return 'Demo (limitada)';
    case 'monthly': return 'Mensual';
    case 'annual': return 'Anual';
    case 'lifetime': return 'De por vida';
    default: return type;
  }
}

Uint8List _signData(String data, RSAPrivateKey privateKey) {
  final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
  signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));
  
  final dataBytes = Uint8List.fromList(base64Decode(data));
  final signature = signer.generateSignature(dataBytes);
  
  return signature.bytes;
}

RSAPrivateKey _parsePrivateKey(String pem) {
  final lines = pem.split('\n')
      .where((line) => !line.startsWith('-----'))
      .join();
  
  final keyBytes = base64Decode(lines);
  final asn1Parser = ASN1Parser(Uint8List.fromList(keyBytes));
  final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
  
  final modulus = (topLevelSeq.elements![1] as ASN1Integer).integer!;
  // elements[2] es publicExponent, no lo necesitamos para la clave privada
  final privateExponent = (topLevelSeq.elements![3] as ASN1Integer).integer!;
  final p = (topLevelSeq.elements![4] as ASN1Integer).integer!;
  final q = (topLevelSeq.elements![5] as ASN1Integer).integer!;
  
  return RSAPrivateKey(modulus, privateExponent, p, q);
}

// ══════════════════════════════════════════════════════════════════════════
// VERIFICACIÓN DE LICENCIA
// ══════════════════════════════════════════════════════════════════════════

Future<void> _verifyLicense({
  required String code,
  required String publicKeyPath,
}) async {
  print('🔍 Verificando licencia...\n');

  // Cargar clave pública
  final publicKeyFile = File(publicKeyPath);
  if (!publicKeyFile.existsSync()) {
    throw Exception('No se encontró archivo de clave pública: $publicKeyPath');
  }
  final publicKeyPem = await publicKeyFile.readAsString();
  final publicKey = _parsePublicKey(publicKeyPem);

  // Parsear código
  if (!code.startsWith('DERBY-')) {
    print('❌ Formato inválido: debe comenzar con "DERBY-"');
    return;
  }

  final content = code.substring(6);
  final parts = content.split('.');
  if (parts.length != 2) {
    print('❌ Formato inválido: debe tener formato "DERBY-payload.signature"');
    return;
  }

  final payloadBase64 = parts[0];
  final signatureBase64 = parts[1];

  // Verificar firma
  final isValid = _verifySignature(payloadBase64, signatureBase64, publicKey);

  if (!isValid) {
    print('❌ FIRMA INVÁLIDA - Esta licencia no es auténtica');
    return;
  }

  print('✅ FIRMA VÁLIDA\n');

  // Decodificar payload
  final payloadJson = utf8.decode(base64Decode(payloadBase64));
  final payload = jsonDecode(payloadJson) as Map<String, dynamic>;

  print('═══════════════════════════════════════════════════════════════');
  print('INFORMACIÓN DE LA LICENCIA');
  print('═══════════════════════════════════════════════════════════════');
  print('ID:           ${payload['licenseId']}');
  print('Tipo:         ${_typeLabel(payload['type'] as String)}');
  print('Titular:      ${payload['holderName'] ?? "(no especificado)"}');
  print('Email:        ${payload['holderEmail'] ?? "(no especificado)"}');
  print('Dispositivo:  ${payload['devicePrefix'] ?? "(cualquiera)"}');
  print('Emitida:      ${payload['issuedAt']}');
  
  if (payload['expiresAt'] != null) {
    final expiresAt = DateTime.parse(payload['expiresAt'] as String);
    final isExpired = DateTime.now().isAfter(expiresAt);
    print('Expira:       ${payload['expiresAt']} ${isExpired ? "⚠️ EXPIRADA" : "✅ Vigente"}');
  } else {
    print('Expira:       Nunca (lifetime)');
  }
  print('═══════════════════════════════════════════════════════════════');
}

bool _verifySignature(String payloadBase64, String signatureBase64, RSAPublicKey publicKey) {
  try {
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
    signer.init(false, PublicKeyParameter<RSAPublicKey>(publicKey));
    
    final payloadBytes = Uint8List.fromList(base64Decode(payloadBase64));
    final signatureBytes = Uint8List.fromList(base64Decode(signatureBase64));
    
    return signer.verifySignature(payloadBytes, RSASignature(signatureBytes));
  } catch (e) {
    return false;
  }
}

RSAPublicKey _parsePublicKey(String pem) {
  final lines = pem.split('\n')
      .where((line) => !line.startsWith('-----') && line.trim().isNotEmpty)
      .join();
  
  final keyBytes = base64Decode(lines);
  
  // SubjectPublicKeyInfo structure:
  // SEQUENCE {
  //   SEQUENCE { algorithm, parameters }
  //   BIT STRING { RSAPublicKey }
  // }
  // 
  // We need to skip the outer structure and get to the RSAPublicKey
  
  // Simple approach: Find the RSAPublicKey sequence inside
  // The bit string starts after the algorithm identifier
  // For RSA, we look for the inner sequence starting around offset 24
  
  int offset = 0;
  
  // Skip outer SEQUENCE tag and length
  if (keyBytes[offset] != 0x30) throw Exception('Expected SEQUENCE');
  offset++;
  offset = _skipLength(keyBytes, offset);
  
  // Skip algorithm SEQUENCE
  if (keyBytes[offset] != 0x30) throw Exception('Expected algorithm SEQUENCE');
  offset++;
  final algLen = _readLength(keyBytes, offset);
  offset = _skipLength(keyBytes, offset);
  offset += algLen;
  
  // Now we're at BIT STRING
  if (keyBytes[offset] != 0x03) throw Exception('Expected BIT STRING');
  offset++;
  offset = _skipLength(keyBytes, offset);
  
  // Skip unused bits byte
  offset++;
  
  // Now parse RSAPublicKey SEQUENCE
  if (keyBytes[offset] != 0x30) throw Exception('Expected RSAPublicKey SEQUENCE');
  offset++;
  offset = _skipLength(keyBytes, offset);
  
  // Read modulus (INTEGER)
  if (keyBytes[offset] != 0x02) throw Exception('Expected INTEGER for modulus');
  offset++;
  final modLen = _readLength(keyBytes, offset);
  offset = _skipLength(keyBytes, offset);
  final modBytes = keyBytes.sublist(offset, offset + modLen);
  final modulus = _bytesToBigInt(modBytes);
  offset += modLen;
  
  // Read exponent (INTEGER)
  if (keyBytes[offset] != 0x02) throw Exception('Expected INTEGER for exponent');
  offset++;
  final expLen = _readLength(keyBytes, offset);
  offset = _skipLength(keyBytes, offset);
  final expBytes = keyBytes.sublist(offset, offset + expLen);
  final exponent = _bytesToBigInt(expBytes);
  
  return RSAPublicKey(modulus, exponent);
}

int _skipLength(List<int> bytes, int offset) {
  if (bytes[offset] < 0x80) {
    return offset + 1;
  } else {
    final numLengthBytes = bytes[offset] & 0x7f;
    return offset + 1 + numLengthBytes;
  }
}

int _readLength(List<int> bytes, int offset) {
  if (bytes[offset] < 0x80) {
    return bytes[offset];
  } else {
    final numLengthBytes = bytes[offset] & 0x7f;
    int length = 0;
    for (int i = 0; i < numLengthBytes; i++) {
      length = (length << 8) | bytes[offset + 1 + i];
    }
    return length;
  }
}

BigInt _bytesToBigInt(List<int> bytes) {
  BigInt result = BigInt.zero;
  for (int byte in bytes) {
    result = (result << 8) | BigInt.from(byte);
  }
  return result;
}
