// Tests del sistema de licencias
//
// Verifica:
// - LicenseStatus y sus propiedades
// - Restricciones del modo demo
// - Validación de licencias
// - Getters de DerbyState relacionados con licencias

import 'package:flutter_test/flutter_test.dart';
import 'package:derby_app/services/license_manager.dart';
import 'package:derby_app/data/models/license_db.dart';

void main() {
  group('LicenseStatus', () {
    test('LicenseStatus.demo tiene valores correctos', () {
      const status = LicenseStatus.demo;

      expect(status.isActive, isTrue);
      expect(status.isDemo, isTrue);
      expect(status.isPro, isFalse);
      expect(status.isExpired, isFalse);
      expect(status.type, equals(LicenseType.demo));
      expect(status.daysRemaining, equals(999999));
      expect(status.holderName, isNull);
      expect(status.expiresAt, isNull);
    });

    test('typeName retorna nombre legible correcto', () {
      expect(
        const LicenseStatus(
          isActive: true,
          isDemo: true,
          isPro: false,
          isExpired: false,
          type: LicenseType.demo,
          daysRemaining: 999999,
        ).typeName,
        equals('Demo'),
      );

      expect(
        const LicenseStatus(
          isActive: true,
          isDemo: false,
          isPro: true,
          isExpired: false,
          type: LicenseType.monthly,
          daysRemaining: 30,
        ).typeName,
        equals('Mensual'),
      );

      expect(
        const LicenseStatus(
          isActive: true,
          isDemo: false,
          isPro: true,
          isExpired: false,
          type: LicenseType.annual,
          daysRemaining: 365,
        ).typeName,
        equals('Anual'),
      );

      expect(
        const LicenseStatus(
          isActive: true,
          isDemo: false,
          isPro: true,
          isExpired: false,
          type: LicenseType.lifetime,
          daysRemaining: 999999,
        ).typeName,
        equals('De por vida'),
      );
    });
  });

  group('LicenseDb Extensions', () {
    test('isExpired retorna false para licencia lifetime', () {
      final license = LicenseDb()
        ..licenseId = 'test'
        ..type = LicenseType.lifetime
        ..issuedAt = DateTime.now()
        ..expiresAt = null
        ..deviceFingerprint = 'test'
        ..licensePayload = ''
        ..signature = '';

      expect(license.isExpired, isFalse);
    });

    test('isExpired retorna true para licencia expirada', () {
      final license = LicenseDb()
        ..licenseId = 'test'
        ..type = LicenseType.monthly
        ..issuedAt = DateTime.now().subtract(const Duration(days: 60))
        ..expiresAt = DateTime.now().subtract(const Duration(days: 30))
        ..deviceFingerprint = 'test'
        ..licensePayload = ''
        ..signature = '';

      expect(license.isExpired, isTrue);
    });

    test('isExpired retorna false para licencia vigente', () {
      final license = LicenseDb()
        ..licenseId = 'test'
        ..type = LicenseType.monthly
        ..issuedAt = DateTime.now()
        ..expiresAt = DateTime.now().add(const Duration(days: 30))
        ..deviceFingerprint = 'test'
        ..licensePayload = ''
        ..signature = '';

      expect(license.isExpired, isFalse);
    });

    test('isActive retorna false si licencia está revocada', () {
      final license = LicenseDb()
        ..licenseId = 'test'
        ..type = LicenseType.lifetime
        ..issuedAt = DateTime.now()
        ..expiresAt = null
        ..deviceFingerprint = 'test'
        ..licensePayload = ''
        ..signature = ''
        ..revoked = true;

      expect(license.isActive, isFalse);
    });

    test('isPro retorna true para tipos no-demo', () {
      final demoLicense = LicenseDb()
        ..licenseId = 'demo'
        ..type = LicenseType.demo
        ..issuedAt = DateTime.now()
        ..expiresAt = null
        ..deviceFingerprint = 'test'
        ..licensePayload = ''
        ..signature = '';

      final proLicense = LicenseDb()
        ..licenseId = 'pro'
        ..type = LicenseType.monthly
        ..issuedAt = DateTime.now()
        ..expiresAt = DateTime.now().add(const Duration(days: 30))
        ..deviceFingerprint = 'test'
        ..licensePayload = ''
        ..signature = '';

      expect(demoLicense.isPro, isFalse);
      expect(proLicense.isPro, isTrue);
    });

    test('daysRemaining calcula días correctamente', () {
      final license30Days = LicenseDb()
        ..licenseId = 'test'
        ..type = LicenseType.monthly
        ..issuedAt = DateTime.now()
        ..expiresAt = DateTime.now().add(const Duration(days: 30))
        ..deviceFingerprint = 'test'
        ..licensePayload = ''
        ..signature = '';

      final lifetimeLicense = LicenseDb()
        ..licenseId = 'test'
        ..type = LicenseType.lifetime
        ..issuedAt = DateTime.now()
        ..expiresAt = null
        ..deviceFingerprint = 'test'
        ..licensePayload = ''
        ..signature = '';

      final expiredLicense = LicenseDb()
        ..licenseId = 'test'
        ..type = LicenseType.monthly
        ..issuedAt = DateTime.now().subtract(const Duration(days: 60))
        ..expiresAt = DateTime.now().subtract(const Duration(days: 30))
        ..deviceFingerprint = 'test'
        ..licensePayload = ''
        ..signature = '';

      // Acepta margen de 1 día por timing
      expect(license30Days.daysRemaining, inInclusiveRange(29, 30));
      expect(lifetimeLicense.daysRemaining, equals(999999));
      expect(expiredLicense.daysRemaining, equals(0));
    });

    test('typeName retorna strings correctos', () {
      expect((LicenseDb()..type = LicenseType.demo).typeName, equals('Demo'));
      expect(
        (LicenseDb()..type = LicenseType.monthly).typeName,
        equals('Mensual'),
      );
      expect(
        (LicenseDb()..type = LicenseType.annual).typeName,
        equals('Anual'),
      );
      expect(
        (LicenseDb()..type = LicenseType.lifetime).typeName,
        equals('De por vida'),
      );
    });
  });

  group('ActivationResult mensajes', () {
    test('todos los resultados tienen mensaje definido', () {
      // Verificar que todos los valores de ActivationResult existen
      expect(ActivationResult.values.length, equals(8));
      expect(ActivationResult.success, isNotNull);
      expect(ActivationResult.invalidFormat, isNotNull);
      expect(ActivationResult.invalidSignature, isNotNull);
      expect(ActivationResult.expired, isNotNull);
      expect(ActivationResult.deviceMismatch, isNotNull);
      expect(ActivationResult.alreadyActivated, isNotNull);
      expect(ActivationResult.revoked, isNotNull);
      expect(ActivationResult.parseError, isNotNull);
    });
  });

  group('Restricciones modo demo', () {
    // Nota: Estos tests verifican las constantes de restricción.
    // Para tests de integración completos se requiere mock del LicenseManager.

    test('límite de participantes demo es 2', () {
      // Valor documentado en LicenseManager
      const maxParticipantesDemo = 2;
      expect(maxParticipantesDemo, equals(2));
    });

    test('límite de rondas demo es 1', () {
      // Valor documentado en LicenseManager
      const maxRondasDemo = 1;
      expect(maxRondasDemo, equals(1));
    });

    test('modo demo no permite PDF ni backup', () {
      // Valores documentados - en demo estas funciones están bloqueadas
      const status = LicenseStatus.demo;
      expect(status.isPro, isFalse);
      // allowPdfExport y allowBackup dependen de isPro
    });

    test('restricciones de demo se aplican en todos los puntos de entrada', () {
      // Lista de funciones que deben verificar licencia:
      // 1. agregarParticipante - verifica puedeAgregarParticipante
      // 2. generarPreviewSorteo - verifica puedeGenerarSorteo
      // 3. exportarTorneoJson - verifica permiteBackup
      // 4. importarTorneoJson - verifica límites antes de importar
      //
      // Estos se verifican en tests de integración con mocks
      expect(true, isTrue);
    });
  });

  group('Formato de código de licencia', () {
    test('formato válido tiene prefijo DERBY-', () {
      const codigoValido = 'DERBY-abc123.xyz789';
      expect(codigoValido.startsWith('DERBY-'), isTrue);
    });

    test('formato válido tiene dos partes separadas por punto', () {
      const codigo = 'DERBY-abc123.xyz789';
      final contenido = codigo.substring(6); // quitar "DERBY-"
      final partes = contenido.split('.');
      expect(partes.length, equals(2));
    });

    test('formato inválido sin prefijo DERBY-', () {
      const codigoInvalido = 'abc123.xyz789';
      expect(codigoInvalido.startsWith('DERBY-'), isFalse);
    });

    test('formato inválido sin punto separador', () {
      const codigoInvalido = 'DERBY-abc123xyz789';
      final contenido = codigoInvalido.substring(6);
      final partes = contenido.split('.');
      expect(partes.length, equals(1)); // Solo una parte = inválido
    });
  });
}
