import 'package:isar/isar.dart';

part 'license_db.g.dart';

/// Tipos de licencia disponibles
enum LicenseType {
  demo,    // Modo demo con limitaciones
  monthly, // Licencia mensual
  annual,  // Licencia anual
  lifetime // Licencia de por vida
}

/// Modelo Isar para persistir licencia comercial con firma criptográfica.
@collection
class LicenseDb {
  Id id = Isar.autoIncrement;

  /// Identificador único de la licencia emitida
  @Index(unique: true)
  late String licenseId;

  /// Tipo de licencia (índice del enum)
  @enumerated
  LicenseType type = LicenseType.demo;

  /// Nombre del titular (opcional, para mostrar)
  String? holderName;

  /// Email de contacto (opcional)
  String? holderEmail;

  /// Fecha de emisión de la licencia
  DateTime issuedAt = DateTime.now();

  /// Fecha de expiración (null = nunca expira para lifetime)
  DateTime? expiresAt;

  /// Huella digital del dispositivo donde se activó
  late String deviceFingerprint;

  /// Datos originales de la licencia (JSON serializado)
  /// Contiene: licenseId, type, issuedAt, expiresAt, maxDeviceHash (primeros 8 chars para validación)
  late String licensePayload;

  /// Firma RSA (Base64) del licensePayload
  /// Generada con la clave privada del admin tool
  late String signature;

  /// Cuándo se activó en este dispositivo
  DateTime activatedAt = DateTime.now();

  /// Número máximo de reactivaciones permitidas (0 = ilimitado)
  int maxReactivations = 3;

  /// Contador de reactivaciones usadas
  int reactivationCount = 0;

  /// ¿Está revocada manualmente?
  bool revoked = false;
}

/// Extensión con getters de utilidad
extension LicenseDbExtensions on LicenseDb {
  /// ¿La licencia ha expirado?
  bool get isExpired {
    if (expiresAt == null) return false; // lifetime nunca expira
    return DateTime.now().isAfter(expiresAt!);
  }

  /// ¿La licencia está activa? (no expirada, no revocada)
  bool get isActive => !isExpired && !revoked;

  /// ¿Es modo demo?
  bool get isDemo => type == LicenseType.demo;

  /// ¿Es licencia Pro? (cualquier tipo no-demo)
  bool get isPro => type != LicenseType.demo;

  /// Días restantes hasta expiración
  int get daysRemaining {
    if (expiresAt == null) return 999999; // lifetime
    final now = DateTime.now();
    if (now.isAfter(expiresAt!)) return 0;
    return expiresAt!.difference(now).inDays;
  }

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
}
