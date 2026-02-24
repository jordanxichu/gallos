import 'package:isar/isar.dart';

part 'license_record.g.dart';

/// Tipo de licencia
enum LicenseType {
  demo,
  monthly,
  annual,
  lifetime,
}

/// Estado de la licencia
enum LicenseStatus {
  active,    // Vigente
  expired,   // Expirada
  revoked,   // Revocada manualmente
}

/// Registro de una licencia generada
@collection
class LicenseRecord {
  Id id = Isar.autoIncrement;

  /// ID único de la licencia
  @Index(unique: true)
  late String licenseId;

  /// Tipo de licencia
  @enumerated
  LicenseType type = LicenseType.monthly;

  /// Nombre del cliente
  late String holderName;

  /// Email del cliente (opcional)
  String? holderEmail;

  /// Teléfono del cliente (opcional)
  String? holderPhone;

  /// Prefijo de dispositivo vinculado (opcional)
  String? devicePrefix;

  /// Notas adicionales
  String? notes;

  /// Fecha de emisión
  DateTime issuedAt = DateTime.now();

  /// Fecha de expiración
  DateTime? expiresAt;

  /// Código de licencia completo
  late String licenseCode;

  /// ¿Fue revocada manualmente?
  bool revoked = false;

  /// ¿Ya se compartió con el cliente?
  bool shared = false;

  /// Monto cobrado (opcional)
  double? amount;

  /// Moneda del monto
  String currency = 'MXN';
}

/// Extensiones útiles
extension LicenseRecordExtensions on LicenseRecord {
  /// Estado actual de la licencia
  LicenseStatus get status {
    if (revoked) return LicenseStatus.revoked;
    if (isExpired) return LicenseStatus.expired;
    return LicenseStatus.active;
  }

  /// ¿Está expirada?
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// ¿Está activa?
  bool get isActive => status == LicenseStatus.active;

  /// Días restantes
  int get daysRemaining {
    if (expiresAt == null) return 999999;
    final now = DateTime.now();
    if (now.isAfter(expiresAt!)) return 0;
    return expiresAt!.difference(now).inDays;
  }

  /// ¿Próxima a expirar? (menos de 7 días)
  bool get isExpiringSoon => daysRemaining > 0 && daysRemaining <= 7;

  /// Nombre del tipo
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

  /// Nombre del estado
  String get statusName {
    switch (status) {
      case LicenseStatus.active:
        return 'Activa';
      case LicenseStatus.expired:
        return 'Expirada';
      case LicenseStatus.revoked:
        return 'Revocada';
    }
  }
}
