import 'package:derby_engine/derby_engine.dart';
import '../viewmodels/info_retiro.dart';

/// Utilidades puras para hardening de respaldo de retiros.
///
/// No modifica lógica de negocio del torneo: solo normaliza/valida
/// metadata de trazabilidad para JSON y reportes.
class RetiroBackupUtils {
  /// Normaliza el motivo de retiro en catálogo controlado.
  /// Valores de salida: MUERTE | DESCALIFICACION | ABANDONO
  static String motivoControlado({
    required EstadoGallo estado,
    String? motivoLibre,
  }) {
    if (estado == EstadoGallo.descalificado) return 'DESCALIFICACION';

    final m = (motivoLibre ?? '').toLowerCase();
    if (m.contains('muert') ||
        m.contains('murio') ||
        m.contains('murió') ||
        m.contains('fallec')) {
      return 'MUERTE';
    }
    if (m.contains('abandon')) return 'ABANDONO';

    // Retiro sin clasificación explícita -> ABANDONO por defecto
    return 'ABANDONO';
  }

  /// Construye campos opcionales de retiro para embebidos en `gallos` del JSON.
  /// Si el gallo no está fuera del torneo, retorna mapa vacío.
  static Map<String, dynamic> camposRetiroParaJson({
    required Gallo gallo,
    required InfoRetiro? info,
  }) {
    final fuera =
        gallo.estado == EstadoGallo.retirado ||
        gallo.estado == EstadoGallo.descalificado;
    if (!fuera) return const <String, dynamic>{};

    final motivo = motivoControlado(
      estado: gallo.estado,
      motivoLibre: info?.motivo,
    );

    final ronda = info?.ronda;
    final fecha = info?.timestamp.toIso8601String();

    return {
      'retirado': true,
      'motivoRetiro': motivo,
      if (ronda != null) 'rondaRetiro': ronda,
      if (fecha != null) 'fechaRetiro': fecha,
      if (info?.motivo != null && info!.motivo!.trim().isNotEmpty)
        'observacionesRetiro': info.motivo,
    };
  }

  /// Reconstruye InfoRetiro desde campos opcionales de `gallo` en JSON.
  /// Retorna null cuando el backup es antiguo y no trae esos campos.
  static InfoRetiro? infoRetiroDesdeGalloJson({
    required Map<String, dynamic> galloJson,
    required String anillo,
    required EstadoGallo estado,
  }) {
    final retirado = galloJson['retirado'] as bool?;
    if (retirado != true) return null;

    final ronda = galloJson['rondaRetiro'] as int?;
    if (ronda == null) return null;

    final motivoControladoStr = (galloJson['motivoRetiro'] as String?)
        ?.toUpperCase();
    final observaciones = galloJson['observacionesRetiro'] as String?;

    String motivoLibre;
    switch (motivoControladoStr) {
      case 'MUERTE':
      case 'MURIO':
        motivoLibre = observaciones?.isNotEmpty == true
            ? observaciones!
            : 'Muerte';
        break;
      case 'DESCALIFICACION':
        motivoLibre = observaciones?.isNotEmpty == true
            ? observaciones!
            : 'Descalificación';
        break;
      case 'ABANDONO':
      default:
        if (estado == EstadoGallo.descalificado) {
          motivoLibre = observaciones?.isNotEmpty == true
              ? observaciones!
              : 'Descalificación';
        } else {
          motivoLibre = observaciones?.isNotEmpty == true
              ? observaciones!
              : 'Abandono';
        }
        break;
    }

    final fechaStr = galloJson['fechaRetiro'] as String?;
    final fecha = fechaStr != null
        ? DateTime.tryParse(fechaStr) ?? DateTime.now()
        : DateTime.now();

    return InfoRetiro(
      ronda: ronda,
      motivo: motivoLibre,
      anillo: anillo,
      timestamp: fecha,
    );
  }

  /// Valida coherencia de retiro sin bloquear flujo.
  ///
  /// Reglas:
  /// - rondaRetiro debe existir
  /// - no debe haber peleas FINALIZADAS del gallo en rondas posteriores
  static List<String> validarCoherenciaRetiro({
    required String galloId,
    required int rondaRetiro,
    required String anillo,
    required List<Ronda> rondas,
  }) {
    final warnings = <String>[];

    if (rondaRetiro < 1 || rondaRetiro > rondas.length) {
      warnings.add(
        'Gallo $anillo: rondaRetiro=$rondaRetiro fuera de rango (1-${rondas.length})',
      );
      return warnings;
    }

    for (final ronda in rondas) {
      if (ronda.numero <= rondaRetiro) continue;

      final peleaPosterior = ronda.peleas.where((p) {
        return p.participoGallo(galloId) && p.estado == EstadoPelea.finalizada;
      }).firstOrNull;

      if (peleaPosterior != null) {
        warnings.add(
          'Gallo $anillo retirado en ronda $rondaRetiro pero aparece finalizado en ronda ${ronda.numero} (pelea ${peleaPosterior.numero})',
        );
      }
    }

    return warnings;
  }
}
