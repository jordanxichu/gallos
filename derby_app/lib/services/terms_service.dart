import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para gestionar la aceptación de términos y condiciones.
class TermsService {
  static const String _termsAcceptedKey = 'terms_accepted';
  static const String _termsAcceptedDateKey = 'terms_accepted_date';
  static const String _organizerNameKey = 'organizer_name';

  /// Verifica si los términos han sido aceptados.
  static Future<bool> hasAcceptedTerms() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_termsAcceptedKey) ?? false;
  }

  /// Registra la aceptación de términos.
  static Future<void> acceptTerms({required String organizerName}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_termsAcceptedKey, true);
    await prefs.setString(
      _termsAcceptedDateKey,
      DateTime.now().toIso8601String(),
    );
    await prefs.setString(_organizerNameKey, organizerName);
  }

  /// Obtiene el nombre del organizador que aceptó los términos.
  static Future<String?> getOrganizerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_organizerNameKey);
  }

  /// Obtiene la fecha de aceptación de términos.
  static Future<DateTime?> getAcceptedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString(_termsAcceptedDateKey);
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  /// Resetea la aceptación de términos (para testing).
  static Future<void> resetTerms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_termsAcceptedKey);
    await prefs.remove(_termsAcceptedDateKey);
    await prefs.remove(_organizerNameKey);
  }
}
