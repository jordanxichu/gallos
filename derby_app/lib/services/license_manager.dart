import 'dart:convert';
import 'dart:typed_data';

import 'package:isar/isar.dart';
import 'package:pointycastle/export.dart';

import '../data/models/license_db.dart';
import 'device_fingerprint.dart';

/// Resultado de la activación de licencia
enum ActivationResult {
  success,           // Activación exitosa
  invalidFormat,     // Formato del código inválido
  invalidSignature,  // Firma RSA no válida
  expired,           // Licencia ya expiró
  deviceMismatch,    // No coincide con el dispositivo autorizado
  alreadyActivated,  // Ya hay una licencia activa
  revoked,           // Licencia fue revocada
  parseError,        // Error al parsear datos
}

/// Información de la licencia activa (inmutable, para UI)
class LicenseStatus {
  final bool isActive;
  final bool isDemo;
  final bool isPro;
  final bool isExpired;
  final LicenseType type;
  final int daysRemaining;
  final String? holderName;
  final DateTime? expiresAt;

  const LicenseStatus({
    required this.isActive,
    required this.isDemo,
    required this.isPro,
    required this.isExpired,
    required this.type,
    required this.daysRemaining,
    this.holderName,
    this.expiresAt,
  });

  /// Nombre legible del tipo de licencia
  String get typeName {
    switch (type) {
      case LicenseType.demo:
        return 'Demo';
      case LicenseType.monthly:
        return 'Mensual';
      case LicenseType.annual:
        return 'Anual';
      case LicenseType.lifetime:
        return 'De por vida';
    }
  }

  /// Estado de demo por defecto
  static const demo = LicenseStatus(
    isActive: true,
    isDemo: true,
    isPro: false,
    isExpired: false,
    type: LicenseType.demo,
    daysRemaining: 999999,
    holderName: null,
    expiresAt: null,
  );
}

/// Gestor central del sistema de licencias comerciales.
/// 
/// Responsabilidades:
/// - Verificar firmas RSA de licencias
/// - Validar vinculación a dispositivo
/// - Gestionar estado de licencia (demo, pro, expirada)
/// - Persistir en Isar de forma segura
class LicenseManager {
  final Isar _isar;
  LicenseDb? _currentLicense;
  String? _deviceFingerprint;

  LicenseManager(this._isar);

  // ══════════════════════════════════════════════════════════════════════════
  // CLAVE PÚBLICA RSA (2048 bits)
  // 
  // La clave privada correspondiente está en el admin tool externo.
  // NO incluir nunca la clave privada en el código de la app.
  // ══════════════════════════════════════════════════════════════════════════
  
  // Clave pública RSA-2048 generada por license_tool
  static const String _publicKeyPem = '''
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

  // ══════════════════════════════════════════════════════════════════════════
  // INICIALIZACIÓN
  // ══════════════════════════════════════════════════════════════════════════

  /// Inicializa el manager cargando licencia existente y fingerprint.
  Future<void> initialize() async {
    _deviceFingerprint = await DeviceFingerprint.generate();
    _currentLicense = await _loadActiveLicense();
  }

  /// Carga la licencia activa desde Isar (si existe).
  Future<LicenseDb?> _loadActiveLicense() async {
    final licenses = await _isar.licenseDbs.where().findAll();
    if (licenses.isEmpty) return null;

    // Buscar la última licencia válida (no revocada)
    final valid = licenses.where((l) => !l.revoked).toList();
    if (valid.isEmpty) return null;

    // Ordenar por fecha de activación (más reciente primero)
    valid.sort((a, b) => b.activatedAt.compareTo(a.activatedAt));
    return valid.first;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ESTADO ACTUAL
  // ══════════════════════════════════════════════════════════════════════════

  /// Obtiene el estado actual de la licencia.
  LicenseStatus get status {
    if (_currentLicense == null) {
      return LicenseStatus.demo;
    }

    final lic = _currentLicense!;
    return LicenseStatus(
      isActive: lic.isActive,
      isDemo: lic.isDemo,
      isPro: lic.isPro,
      isExpired: lic.isExpired,
      type: lic.type,
      daysRemaining: lic.daysRemaining,
      holderName: lic.holderName,
      expiresAt: lic.expiresAt,
    );
  }

  /// ¿Hay licencia Pro activa?
  bool get isPro => _currentLicense?.isPro ?? false;

  /// ¿Está en modo demo?
  bool get isDemo => _currentLicense?.isDemo ?? true;

  /// ¿La licencia actual ha expirado?
  bool get isExpired => _currentLicense?.isExpired ?? false;

  /// Licencia actual (puede ser null si es demo puro).
  LicenseDb? get currentLicense => _currentLicense;

  /// Huella digital del dispositivo actual.
  String get deviceFingerprint => _deviceFingerprint ?? '';

  // ══════════════════════════════════════════════════════════════════════════
  // ACTIVACIÓN DE LICENCIA
  // ══════════════════════════════════════════════════════════════════════════

  /// Activa una licencia a partir del código proporcionado.
  /// 
  /// El código de licencia tiene el formato:
  /// ```
  /// DERBY-{base64_payload}.{base64_signature}
  /// ```
  /// 
  /// Donde payload es JSON con:
  /// - licenseId: ID único
  /// - type: demo/monthly/annual/lifetime
  /// - issuedAt: fecha ISO8601
  /// - expiresAt: fecha ISO8601 o null
  /// - devicePrefix: primeros 8 chars del fingerprint autorizado
  /// - holderName: nombre del titular (opcional)
  /// - holderEmail: email (opcional)
  Future<ActivationResult> activate(String licenseCode) async {
    try {
      // 1. Parsear el código de licencia
      final parsed = _parseLicenseCode(licenseCode);
      if (parsed == null) return ActivationResult.invalidFormat;

      final payload = parsed['payload'] as String;
      final signature = parsed['signature'] as String;

      // 2. Verificar firma RSA
      if (!_verifySignature(payload, signature)) {
        return ActivationResult.invalidSignature;
      }

      // 3. Decodificar payload
      final payloadJson = utf8.decode(base64Decode(payload));
      final data = jsonDecode(payloadJson) as Map<String, dynamic>;

      // 4. Validar dispositivo
      final devicePrefix = data['devicePrefix'] as String?;
      if (devicePrefix != null && devicePrefix.isNotEmpty) {
        final currentPrefix = await DeviceFingerprint.shortFingerprint(8);
        if (devicePrefix.toUpperCase() != currentPrefix) {
          return ActivationResult.deviceMismatch;
        }
      }

      // 5. Validar fecha de expiración
      DateTime? expiresAt;
      if (data['expiresAt'] != null) {
        expiresAt = DateTime.parse(data['expiresAt'] as String);
        if (DateTime.now().isAfter(expiresAt)) {
          return ActivationResult.expired;
        }
      }

      // 6. Crear registro de licencia
      final license = LicenseDb()
        ..licenseId = data['licenseId'] as String
        ..type = _parseLicenseType(data['type'] as String)
        ..holderName = data['holderName'] as String?
        ..holderEmail = data['holderEmail'] as String?
        ..issuedAt = DateTime.parse(data['issuedAt'] as String)
        ..expiresAt = expiresAt
        ..deviceFingerprint = _deviceFingerprint!
        ..licensePayload = payload
        ..signature = signature
        ..activatedAt = DateTime.now();

      // 7. Guardar en Isar (reemplazar licencia anterior)
      await _isar.writeTxn(() async {
        // Marcar licencias anteriores como no activas (opcional: eliminar)
        await _isar.licenseDbs.clear();
        await _isar.licenseDbs.put(license);
      });

      _currentLicense = license;
      return ActivationResult.success;

    } catch (e) {
      return ActivationResult.parseError;
    }
  }

  /// Parsea el código de licencia en payload y signature.
  Map<String, String>? _parseLicenseCode(String code) {
    final normalized = code.trim();
    
    // Formato: DERBY-{payload}.{signature}
    if (!normalized.startsWith('DERBY-')) return null;
    
    final content = normalized.substring(6); // Quitar "DERBY-"
    final parts = content.split('.');
    if (parts.length != 2) return null;

    return {
      'payload': parts[0],
      'signature': parts[1],
    };
  }

  /// Verifica la firma RSA del payload.
  bool _verifySignature(String payloadBase64, String signatureBase64) {
    try {
      final publicKey = _parsePublicKey(_publicKeyPem);
      if (publicKey == null) return false;

      final payloadBytes = base64Decode(payloadBase64);
      final signatureBytes = base64Decode(signatureBase64);

      // Usar SHA-256 con RSA PKCS#1 v1.5
      final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
      signer.init(false, PublicKeyParameter<RSAPublicKey>(publicKey));

      return signer.verifySignature(
        Uint8List.fromList(payloadBytes),
        RSASignature(Uint8List.fromList(signatureBytes)),
      );
    } catch (e) {
      return false;
    }
  }

  /// Parsea la clave pública PEM a RSAPublicKey.
  RSAPublicKey? _parsePublicKey(String pem) {
    try {
      // Remover headers PEM
      final lines = pem.split('\n')
          .where((line) => !line.startsWith('-----') && line.trim().isNotEmpty)
          .join();
      
      final keyBytes = base64Decode(lines);
      
      // Parse SubjectPublicKeyInfo manually to extract RSAPublicKey
      int offset = 0;
      
      // Skip outer SEQUENCE tag and length
      if (keyBytes[offset] != 0x30) return null;
      offset++;
      offset = _skipLength(keyBytes, offset);
      
      // Skip algorithm SEQUENCE
      if (keyBytes[offset] != 0x30) return null;
      offset++;
      final algLen = _readLength(keyBytes, offset);
      offset = _skipLength(keyBytes, offset);
      offset += algLen;
      
      // Now we're at BIT STRING
      if (keyBytes[offset] != 0x03) return null;
      offset++;
      offset = _skipLength(keyBytes, offset);
      
      // Skip unused bits byte
      offset++;
      
      // Now parse RSAPublicKey SEQUENCE
      if (keyBytes[offset] != 0x30) return null;
      offset++;
      offset = _skipLength(keyBytes, offset);
      
      // Read modulus (INTEGER)
      if (keyBytes[offset] != 0x02) return null;
      offset++;
      final modLen = _readLength(keyBytes, offset);
      offset = _skipLength(keyBytes, offset);
      final modBytes = keyBytes.sublist(offset, offset + modLen);
      final modulus = _bytesToBigInt(modBytes);
      offset += modLen;
      
      // Read exponent (INTEGER)
      if (keyBytes[offset] != 0x02) return null;
      offset++;
      final expLen = _readLength(keyBytes, offset);
      offset = _skipLength(keyBytes, offset);
      final expBytes = keyBytes.sublist(offset, offset + expLen);
      final exponent = _bytesToBigInt(expBytes);
      
      return RSAPublicKey(modulus, exponent);
    } catch (e) {
      return null;
    }
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

  /// Convierte string a LicenseType.
  LicenseType _parseLicenseType(String type) {
    switch (type.toLowerCase()) {
      case 'monthly':
        return LicenseType.monthly;
      case 'annual':
        return LicenseType.annual;
      case 'lifetime':
        return LicenseType.lifetime;
      default:
        return LicenseType.demo;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // GESTIÓN DE LICENCIA
  // ══════════════════════════════════════════════════════════════════════════

  /// Revoca la licencia actual (mantiene registro pero marca como no válida).
  Future<void> revoke() async {
    if (_currentLicense == null) return;

    await _isar.writeTxn(() async {
      _currentLicense!.revoked = true;
      await _isar.licenseDbs.put(_currentLicense!);
    });

    _currentLicense = null;
  }

  /// Elimina completamente la licencia (reset a demo).
  Future<void> reset() async {
    await _isar.writeTxn(() async {
      await _isar.licenseDbs.clear();
    });
    _currentLicense = null;
  }

  /// Obtiene mensaje legible del resultado de activación.
  String getActivationMessage(ActivationResult result) {
    switch (result) {
      case ActivationResult.success:
        return '¡Licencia activada correctamente!';
      case ActivationResult.invalidFormat:
        return 'El formato del código de licencia no es válido.';
      case ActivationResult.invalidSignature:
        return 'La firma del código no es válida. Verifique que el código sea correcto.';
      case ActivationResult.expired:
        return 'Esta licencia ya ha expirado.';
      case ActivationResult.deviceMismatch:
        return 'Esta licencia no está autorizada para este dispositivo.';
      case ActivationResult.alreadyActivated:
        return 'Ya existe una licencia activa.';
      case ActivationResult.revoked:
        return 'Esta licencia ha sido revocada.';
      case ActivationResult.parseError:
        return 'Error al procesar el código de licencia.';
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LIMITACIONES DEL MODO DEMO
  // ══════════════════════════════════════════════════════════════════════════

  /// Número máximo de participantes en modo demo.
  int get maxParticipantesDemo => 2;

  /// Número máximo de rondas en modo demo.
  int get maxRondasDemo => 1;

  /// ¿Se permite exportar PDF en modo demo?
  bool get allowPdfExport => isPro;

  /// ¿Se permite hacer backup completo en modo demo?
  bool get allowBackup => isPro;

  /// Verifica si se puede agregar más participantes.
  bool canAddParticipante(int currentCount) {
    if (isPro) return true;
    return currentCount < maxParticipantesDemo;
  }

  /// Verifica si se puede crear más rondas.
  bool canCreateRonda(int currentCount) {
    if (isPro) return true;
    return currentCount < maxRondasDemo;
  }
}
