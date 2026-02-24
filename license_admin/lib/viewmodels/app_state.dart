import 'package:flutter/foundation.dart';
import '../data/models/license_record.dart';
import '../services/license_service.dart';

/// Estado global de la aplicación
class AppState extends ChangeNotifier {
  final LicenseService _service = LicenseService();
  
  bool _initialized = false;
  bool _loading = false;
  String? _error;
  
  List<LicenseRecord> _licenses = [];
  DashboardStats? _stats;
  String? _publicKey;

  // Getters
  bool get initialized => _initialized;
  bool get loading => _loading;
  String? get error => _error;
  List<LicenseRecord> get licenses => List.unmodifiable(_licenses);
  DashboardStats? get stats => _stats;
  String? get publicKey => _publicKey;
  
  List<LicenseRecord> get activeLicenses => 
      _licenses.where((l) => l.isActive).toList();
  
  List<LicenseRecord> get expiredLicenses => 
      _licenses.where((l) => l.isExpired && !l.revoked).toList();
  
  List<LicenseRecord> get expiringSoonLicenses => 
      _licenses.where((l) => l.isExpiringSoon).toList();
  
  List<LicenseRecord> get revokedLicenses => 
      _licenses.where((l) => l.revoked).toList();

  /// Inicializa la app
  Future<void> initialize() async {
    if (_initialized) return;
    
    _loading = true;
    notifyListeners();

    try {
      print('🔧 AppState: Starting initialization...');
      await _service.initialize();
      print('🔧 AppState: Service initialized');
      await refresh();
      print('🔧 AppState: Data refreshed');
      _publicKey = _service.publicKey;
      _initialized = true;
      _error = null;
      print('✅ AppState: Fully initialized');
    } catch (e, stack) {
      _error = 'Error inicializando: $e';
      print('❌ AppState: Error initializing: $e');
      print('❌ Stack: $stack');
    }

    _loading = false;
    notifyListeners();
  }

  /// Refresca datos
  Future<void> refresh() async {
    _licenses = await _service.getAllLicenses();
    _stats = await _service.getStats();
    notifyListeners();
  }

  /// Genera una nueva licencia
  Future<LicenseRecord?> generateLicense({
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
    _loading = true;
    notifyListeners();

    try {
      final license = await _service.generateLicense(
        type: type,
        holderName: holderName,
        holderEmail: holderEmail,
        holderPhone: holderPhone,
        devicePrefix: devicePrefix,
        notes: notes,
        days: days,
        amount: amount,
        currency: currency,
      );
      
      await refresh();
      _error = null;
      return license;
    } catch (e) {
      _error = 'Error generando licencia: $e';
      return null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Revoca una licencia
  Future<void> revokeLicense(int id) async {
    await _service.revokeLicense(id);
    await refresh();
  }

  /// Marca como compartida
  Future<void> markAsShared(int id) async {
    await _service.markAsShared(id);
    await refresh();
  }

  /// Elimina una licencia
  Future<void> deleteLicense(int id) async {
    await _service.deleteLicense(id);
    await refresh();
  }
}
