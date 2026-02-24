/// Información de retiro/descalificación de un gallo.
///
/// Se almacena en DerbyState y se persiste en JSON export/import.
/// Permite mostrar detalles como "Retirado en Ronda 3 – Muerte"
/// sin modificar el modelo del engine.
class InfoRetiro {
  /// Número de ronda (1-based) donde se retiró/descalificó el gallo
  final int ronda;

  /// Motivo proporcionado por el operador (puede ser null)
  final String? motivo;

  /// Anillo del gallo (para referencia rápida)
  final String anillo;

  /// Timestamp del evento
  final DateTime timestamp;

  const InfoRetiro({
    required this.ronda,
    this.motivo,
    required this.anillo,
    required this.timestamp,
  });

  /// Motivo controlado para respaldo/reportes:
  /// MUERTE | DESCALIFICACION | ABANDONO
  String motivoControlado({bool esDescalificado = false}) {
    if (esDescalificado) return 'DESCALIFICACION';
    if (esMuerte) return 'MUERTE';

    final m = (motivo ?? '').toLowerCase();
    if (m.contains('abandon')) return 'ABANDONO';

    return 'ABANDONO';
  }

  /// Indica si el motivo sugiere muerte del gallo
  bool get esMuerte {
    if (motivo == null) return false;
    final m = motivo!.toLowerCase();
    return m.contains('muert') ||
        m.contains('muerte') ||
        m.contains('murio') ||
        m.contains('murió') ||
        m.contains('fallec');
  }

  /// Badge resumido: ☠️ MUERTO, ⛔ RETIRADO, 🚫 DESCALIFICADO
  /// El estado real (retirado vs descalificado) se determina externamente.
  String badgeRetiro({bool esDescalificado = false}) {
    if (esDescalificado) return '🚫 DESCALIFICADO';
    if (esMuerte) return '☠️ MUERTO';
    return '⛔ RETIRADO';
  }

  /// Texto descriptivo: "Retirado en Ronda 3" / "Muerto en Ronda 2"
  String descripcion({bool esDescalificado = false}) {
    final accion = esDescalificado
        ? 'Descalificado'
        : (esMuerte ? 'Muerto' : 'Retirado');
    final textoMotivo = motivo != null && motivo!.isNotEmpty
        ? ' – $motivo'
        : '';
    return '$accion en Ronda $ronda$textoMotivo';
  }

  /// Texto auditable explícito para UI/PDF.
  /// Ejemplo: RETIRADO – MUERTE (Ronda 1)
  String descripcionAuditable({bool esDescalificado = false}) {
    final motivo = motivoControlado(esDescalificado: esDescalificado);
    return 'RETIRADO – $motivo (Ronda $ronda)';
  }

  /// Serializa a JSON
  Map<String, dynamic> toJson() => {
    'ronda': ronda,
    'motivo': motivo,
    'anillo': anillo,
    'timestamp': timestamp.toIso8601String(),
  };

  /// Deserializa desde JSON
  factory InfoRetiro.fromJson(Map<String, dynamic> json) => InfoRetiro(
    ronda: json['ronda'] as int,
    motivo: json['motivo'] as String?,
    anillo: json['anillo'] as String? ?? '',
    timestamp: json['timestamp'] != null
        ? DateTime.parse(json['timestamp'] as String)
        : DateTime.now(),
  );
}
