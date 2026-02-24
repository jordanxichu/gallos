import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:pointycastle/export.dart';

import '../data/database_service.dart';
import '../data/models/license_record.dart';
import '../data/models/rsa_keys.dart';

/// Estadísticas del dashboard
class DashboardStats {
  final int totalLicenses;
  final int activeLicenses;
  final int expiredLicenses;
  final int expiringSoon;
  final int revokedLicenses;
  final int licensesThisMonth;
  final double totalRevenue;
  final double monthRevenue;
  final Map<LicenseType, int> byType;

  DashboardStats({
    required this.totalLicenses,
    required this.activeLicenses,
    required this.expiredLicenses,
    required this.expiringSoon,
    required this.revokedLicenses,
    required this.licensesThisMonth,
    required this.totalRevenue,
    required this.monthRevenue,
    required this.byType,
  });
}

/// Función top-level para generación de claves en isolate
Map<String, String> _generateKeyPairIsolate(void _) {
  final keyGen = RSAKeyGenerator()
    ..init(ParametersWithRandom(
      RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
      _secureRandomIsolate(),
    ));

  final pair = keyGen.generateKeyPair();
  final publicKey = pair.publicKey as RSAPublicKey;
  final privateKey = pair.privateKey as RSAPrivateKey;

  return {
    'private': _encodePrivateKeyToPemIsolate(privateKey),
    'public': _encodePublicKeyToPemIsolate(publicKey),
  };
}

SecureRandom _secureRandomIsolate() {
  final secureRandom = FortunaRandom();
  final seedSource = Random.secure();
  final seeds = List<int>.generate(32, (_) => seedSource.nextInt(255));
  secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
  return secureRandom;
}

String _encodePublicKeyToPemIsolate(RSAPublicKey publicKey) {
  // OID para rsaEncryption: 1.2.840.113549.1.1.1
  final algorithmSeq = ASN1Sequence()
    ..add(ASN1ObjectIdentifier.fromComponentString('1.2.840.113549.1.1.1'))
    ..add(ASN1Null());

  final publicKeySeq = ASN1Sequence()
    ..add(ASN1Integer(publicKey.modulus!))
    ..add(ASN1Integer(publicKey.exponent!));

  final publicKeyBitString = ASN1BitString(publicKeySeq.encodedBytes);

  final topLevelSeq = ASN1Sequence()
    ..add(algorithmSeq)
    ..add(publicKeyBitString);

  final dataBase64 = base64Encode(topLevelSeq.encodedBytes);
  final chunks = <String>[];
  for (var i = 0; i < dataBase64.length; i += 64) {
    chunks.add(dataBase64.substring(i, i + 64 > dataBase64.length ? dataBase64.length : i + 64));
  }

  return '-----BEGIN PUBLIC KEY-----\n${chunks.join('\n')}\n-----END PUBLIC KEY-----\n';
}

String _encodePrivateKeyToPemIsolate(RSAPrivateKey privateKey) {
  final topLevelSeq = ASN1Sequence()
    ..add(ASN1Integer(BigInt.zero))
    ..add(ASN1Integer(privateKey.n!))
    ..add(ASN1Integer(privateKey.publicExponent!))
    ..add(ASN1Integer(privateKey.privateExponent!))
    ..add(ASN1Integer(privateKey.p!))
    ..add(ASN1Integer(privateKey.q!))
    ..add(ASN1Integer(privateKey.privateExponent! % (privateKey.p! - BigInt.one)))
    ..add(ASN1Integer(privateKey.privateExponent! % (privateKey.q! - BigInt.one)))
    ..add(ASN1Integer(privateKey.q!.modInverse(privateKey.p!)));

  final dataBase64 = base64Encode(topLevelSeq.encodedBytes);
  final chunks = <String>[];
  for (var i = 0; i < dataBase64.length; i += 64) {
    chunks.add(dataBase64.substring(i, i + 64 > dataBase64.length ? dataBase64.length : i + 64));
  }

  return '-----BEGIN RSA PRIVATE KEY-----\n${chunks.join('\n')}\n-----END RSA PRIVATE KEY-----\n';
}

/// Servicio para generar y administrar licencias
class LicenseService {
  Isar? _isar;
  RsaKeys? _keys;

  // Clave privada RSA que corresponde a la pública de derby_app
  static const String _defaultPrivateKey = '''
-----BEGIN RSA PRIVATE KEY-----
MIIEpgIBAAKCAQEA+xS++0KCy1x0MYEBzhbOYaUrmqKdoNTdKxoQzlnxLUxBfmHE
+Str4LhgN5uDGQzyKsfANJjnhyvSki3esOJ+/bdHGLR/AK2K6waL211HYsC37Nco
W0R+D6q+3iFrR86n5G6vwXfLviscXfYhqDWA7YyrzAbgY5f+1uthx4Z0+VN0HpQ6
CXBIA8utgrCUL7vtBeNjjJkdT3qSYPsvQzqSyUgvJItUDiWejiq9LBkEwZBRYWVa
Cs0yLCSEGV7BwPmZUmFQF3TH8RbbIY8+MFCw/sZZuR+s5drAaE8vwDWNf81tH7d/
2pjwtGmqcnfDbZ882L9yiyctMXdH1/My+gs4TwIDAQABAoIBAQDQ9DIAjxikv5uf
ezqSVd6J2tjQB1dheuVZMoccBDQ3u4eh8yHnL+DGkwrYHF7dIS4EtlpaK4o7rxe+
OdhjowuGgNn1UHmFiefbsoYAGMAJClPHEkRuuDClPzc7S9qpVu3YqNkyDE2ORPiF
pgnaoDRc/b4XvP1PRTZ7jEbCsz50Iv62MuAoKPsnYT8B2v2haPayQqdin3UOG10D
d8aEvpWfmgSV8eQS4Whwq7vxfD4zmdJCGwHHX7+KFEwLNFHY3DlXqv6ozlp3C1ey
sNBVVCWA0Eoec3+IkxWhmTMWj3LG6GHhK907ew9wtWQEEYGkpXZrxXu9mf902J6s
Oj1jZ8fJAoGBAP/HWgAWv575KUndlATbLa9dwp4vYHlIdM66BNwHdI76zNqciKBN
xmJjHaTKV8L/k8Huhz0DNOQrk8O+gQ05IALHaEmxQpzVs+nVOVWQAWkRFFOWFxXB
mfOKVcW7ofQGzYYyzP+6ckgRReAMVlNZb7z563TiJ/+3ZeHD07rY1ESTAoGBAPtM
WqKCgA4vS4oiCh7lJvSCQekGlKc2Oaq0tNalTnk7rGIjeApQZX2BHBC4fnF6wS5I
z4kGjh6nHjgsfYt26PWC5xWF9oYolNjtofv956PKFwAOFSVqzmFsuZ5dA1da9FLa
2K5mOhFQG9c77oDBQaeLmXxoq65L7t1YvtdtjW7VAoGBAOWvO5em1e5I6pXFHx15
QL4goRpxit1+fj4Bd0mqfDXE695IALyK+uHxBXasqUCXRzU4IENetMlMhIWbdcHN
EXzNWk4KmrnBga0yZyj5hvq1dp5UwmgsETZMfBdzFczPqxGeXs4pvGQQ9sFp8r8o
Khn2B0VPrQGJzDh/JIu+GGd3AoGBAObYZi4A6XeeVKsox9lHsfhMrBVPGUFdm63H
4JOJOUQ+4AUrBfubjQ+0ib6GbIj8Nfe5pQQABI/9/tGldRKngir+PB9Wd3cYUlvQ
N8xPmvmoDGbdiOldawauJPloAki94dE2/nN+rvr2dwzKHjci0JgDslRJpuQvFtc4
zd8B4TmdAoGBAJIF57TapOWi44fE1V9V7IVprgS6dIpLF5CMcPgPEXSp6ch6Wh0v
FKZg0YQW0a2wM6rOVQmjjcYcLtpjRVi5VUhqTkrpmmPnpETgcaFKA9+CR7DaOA+c
fz1EwgT+rM0PyA5XkDZ6CdS9MeoapeQGFlulkaAMhTVEi7YHg8KPvibZ
-----END RSA PRIVATE KEY-----
''';

  static const String _defaultPublicKey = '''
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA+xS++0KCy1x0MYEBzhbO
YaUrmqKdoNTdKxoQzlnxLUxBfmHE+Str4LhgN5uDGQzyKsfANJjnhyvSki3esOJ+
/bdHGLR/AK2K6waL211HYsC37NcoW0R+D6q+3iFrR86n5G6vwXfLviscXfYhqDWA
7YyrzAbgY5f+1uthx4Z0+VN0HpQ6CXBIA8utgrCUL7vtBeNjjJkdT3qSYPsvQzqS
yUgvJItUDiWejiq9LBkEwZBRYWVaCs0yLCSEGV7BwPmZUmFQF3TH8RbbIY8+MFCw
/sZZuR+s5drAaE8vwDWNf81tH7d/2pjwtGmqcnfDbZ882L9yiyctMXdH1/My+gs4
TwIDAQAB
-----END PUBLIC KEY-----
''';

  /// Inicializa el servicio
  Future<void> initialize() async {
    print('🔑 LicenseService: Getting Isar instance...');
    _isar = await DatabaseService.instance;
    print('🔑 LicenseService: Got Isar, loading keys...');
    _keys = await _loadOrCreateKeys();
    print('🔑 LicenseService: Keys loaded');
  }

  /// Carga o crea las claves RSA
  Future<RsaKeys> _loadOrCreateKeys() async {
    print('🔐 _loadOrCreateKeys: Checking for existing keys...');
    final existing = await _isar!.rsaKeys.where().findFirst();
    
    // Siempre verificar que las claves sean las correctas
    if (existing != null && existing.privateKeyPem == _defaultPrivateKey) {
      print('🔐 _loadOrCreateKeys: Found correct keys');
      return existing;
    }

    // Borrar claves incorrectas si existen
    if (existing != null) {
      print('🔐 _loadOrCreateKeys: Removing old keys...');
      await _isar!.writeTxn(() async {
        await _isar!.rsaKeys.clear();
      });
    }

    // Usar la clave predeterminada (la misma que usa derby_app)
    print('🔐 _loadOrCreateKeys: Installing default keys...');
    
    final keys = RsaKeys()
      ..privateKeyPem = _defaultPrivateKey
      ..publicKeyPem = _defaultPublicKey
      ..label = 'Claves Derby Master';

    await _isar!.writeTxn(() async {
      await _isar!.rsaKeys.put(keys);
    });
    print('🔐 _loadOrCreateKeys: Keys saved');

    return keys;
  }

  /// Obtiene la clave pública actual
  String? get publicKey => _keys?.publicKeyPem;

  // ══════════════════════════════════════════════════════════════════════════
  // GENERACIÓN DE LICENCIAS
  // ══════════════════════════════════════════════════════════════════════════

  /// Genera una nueva licencia
  Future<LicenseRecord> generateLicense({
    required LicenseType type,
    required String holderName,
    String? holderEmail,
    String? holderPhone,
    String? devicePrefix,
    String? notes,
    int days = 30,
    double? amount,
    String currency = 'MXN',
  }) async {
    final licenseId = _generateLicenseId();
    
    // Calcular expiración
    DateTime? expiresAt;
    if (type != LicenseType.lifetime) {
      expiresAt = DateTime.now().add(Duration(days: days));
    }

    // Crear payload
    final payload = <String, dynamic>{
      'licenseId': licenseId,
      'type': type.name,
      'issuedAt': DateTime.now().toIso8601String(),
      if (expiresAt != null) 'expiresAt': expiresAt.toIso8601String(),
      'holderName': holderName,
      if (holderEmail != null) 'holderEmail': holderEmail,
      if (devicePrefix != null && devicePrefix.isNotEmpty) 
        'devicePrefix': devicePrefix.toUpperCase().substring(0, devicePrefix.length.clamp(0, 8)),
    };

    // Codificar y firmar
    final payloadJson = jsonEncode(payload);
    final payloadBase64 = base64Encode(utf8.encode(payloadJson));
    final signature = _signData(payloadBase64);
    final signatureBase64 = base64Encode(signature);

    // Código final
    final licenseCode = 'DERBY-$payloadBase64.$signatureBase64';

    // Crear registro
    final record = LicenseRecord()
      ..licenseId = licenseId
      ..type = type
      ..holderName = holderName
      ..holderEmail = holderEmail
      ..holderPhone = holderPhone
      ..devicePrefix = devicePrefix
      ..notes = notes
      ..issuedAt = DateTime.now()
      ..expiresAt = expiresAt
      ..licenseCode = licenseCode
      ..amount = amount
      ..currency = currency;

    // Guardar
    await _isar!.writeTxn(() async {
      await _isar!.licenseRecords.put(record);
    });

    return record;
  }

  String _generateLicenseId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
  }

  Uint8List _signData(String payloadBase64) {
    final privateKey = _parsePrivateKey(_keys!.privateKeyPem);
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    
    final dataBytes = Uint8List.fromList(base64Decode(payloadBase64));
    final signature = signer.generateSignature(dataBytes);
    
    return signature.bytes;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CONSULTAS
  // ══════════════════════════════════════════════════════════════════════════

  /// Obtiene todas las licencias
  Future<List<LicenseRecord>> getAllLicenses() async {
    return await _isar!.licenseRecords.where().sortByIssuedAtDesc().findAll();
  }

  /// Obtiene licencias activas
  Future<List<LicenseRecord>> getActiveLicenses() async {
    final all = await getAllLicenses();
    return all.where((l) => l.isActive).toList();
  }

  /// Obtiene licencias expiradas
  Future<List<LicenseRecord>> getExpiredLicenses() async {
    final all = await getAllLicenses();
    return all.where((l) => l.isExpired && !l.revoked).toList();
  }

  /// Obtiene licencias próximas a expirar
  Future<List<LicenseRecord>> getExpiringSoonLicenses() async {
    final all = await getAllLicenses();
    return all.where((l) => l.isExpiringSoon).toList();
  }

  /// Obtiene licencias revocadas
  Future<List<LicenseRecord>> getRevokedLicenses() async {
    return await _isar!.licenseRecords
        .filter()
        .revokedEqualTo(true)
        .sortByIssuedAtDesc()
        .findAll();
  }

  /// Estadísticas del dashboard
  Future<DashboardStats> getStats() async {
    final all = await getAllLicenses();
    final now = DateTime.now();
    final thisMonth = all.where((l) => 
      l.issuedAt.year == now.year && l.issuedAt.month == now.month
    ).toList();

    double totalRevenue = 0;
    double monthRevenue = 0;

    for (final l in all) {
      if (l.amount != null) totalRevenue += l.amount!;
    }
    for (final l in thisMonth) {
      if (l.amount != null) monthRevenue += l.amount!;
    }

    return DashboardStats(
      totalLicenses: all.length,
      activeLicenses: all.where((l) => l.isActive).length,
      expiredLicenses: all.where((l) => l.isExpired).length,
      expiringSoon: all.where((l) => l.isExpiringSoon).length,
      revokedLicenses: all.where((l) => l.revoked).length,
      licensesThisMonth: thisMonth.length,
      totalRevenue: totalRevenue,
      monthRevenue: monthRevenue,
      byType: {
        LicenseType.demo: all.where((l) => l.type == LicenseType.demo).length,
        LicenseType.monthly: all.where((l) => l.type == LicenseType.monthly).length,
        LicenseType.annual: all.where((l) => l.type == LicenseType.annual).length,
        LicenseType.lifetime: all.where((l) => l.type == LicenseType.lifetime).length,
      },
    );
  }

  /// Revocar licencia
  Future<void> revokeLicense(int id) async {
    final license = await _isar!.licenseRecords.get(id);
    if (license != null) {
      license.revoked = true;
      await _isar!.writeTxn(() async {
        await _isar!.licenseRecords.put(license);
      });
    }
  }

  /// Marcar como compartida
  Future<void> markAsShared(int id) async {
    final license = await _isar!.licenseRecords.get(id);
    if (license != null) {
      license.shared = true;
      await _isar!.writeTxn(() async {
        await _isar!.licenseRecords.put(license);
      });
    }
  }

  /// Eliminar licencia
  Future<void> deleteLicense(int id) async {
    await _isar!.writeTxn(() async {
      await _isar!.licenseRecords.delete(id);
    });
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PRIVATE KEY PARSING
  // ══════════════════════════════════════════════════════════════════════════

  RSAPrivateKey _parsePrivateKey(String pem) {
    final lines = pem.split('\n')
        .where((line) => !line.startsWith('-----') && line.trim().isNotEmpty)
        .join();
    
    final keyBytes = base64Decode(lines);
    
    int offset = 0;
    
    // Skip outer SEQUENCE
    offset++; // tag
    offset = _skipLength(keyBytes, offset);
    
    // Skip version INTEGER
    offset++; // tag
    final versionLen = _readLength(keyBytes, offset);
    offset = _skipLength(keyBytes, offset);
    offset += versionLen;
    
    // Read modulus
    offset++;
    final modLen = _readLength(keyBytes, offset);
    offset = _skipLength(keyBytes, offset);
    final modulus = _bytesToBigInt(keyBytes.sublist(offset, offset + modLen));
    offset += modLen;
    
    // Skip public exponent
    offset++;
    final pubExpLen = _readLength(keyBytes, offset);
    offset = _skipLength(keyBytes, offset);
    offset += pubExpLen;
    
    // Read private exponent
    offset++;
    final privExpLen = _readLength(keyBytes, offset);
    offset = _skipLength(keyBytes, offset);
    final privateExponent = _bytesToBigInt(keyBytes.sublist(offset, offset + privExpLen));
    offset += privExpLen;
    
    // Read p
    offset++;
    final pLen = _readLength(keyBytes, offset);
    offset = _skipLength(keyBytes, offset);
    final p = _bytesToBigInt(keyBytes.sublist(offset, offset + pLen));
    offset += pLen;
    
    // Read q
    offset++;
    final qLen = _readLength(keyBytes, offset);
    offset = _skipLength(keyBytes, offset);
    final q = _bytesToBigInt(keyBytes.sublist(offset, offset + qLen));
    
    return RSAPrivateKey(modulus, privateExponent, p, q);
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
}
