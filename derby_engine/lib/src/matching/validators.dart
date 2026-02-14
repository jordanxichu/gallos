import '../models/models.dart';

/// Validadores para el algoritmo de emparejamiento.
///
/// Estas funciones verifican si dos gallos pueden enfrentarse
/// según las restricciones del derbi.
class MatchingValidators {
  final ConfiguracionDerby configuracion;
  final Map<String, Participante> _participantesMap;

  MatchingValidators({
    required this.configuracion,
    required List<Participante> participantes,
  }) : _participantesMap = {for (var p in participantes) p.id: p};

  /// Verifica si la diferencia de peso está dentro de la tolerancia.
  bool cumplePeso(Gallo a, Gallo b) {
    return (a.peso - b.peso).abs() <= configuracion.toleranciaPeso;
  }

  /// Verifica si dos gallos pertenecen a participantes distintos.
  bool distintoParticipante(Gallo a, Gallo b) {
    return a.participanteId != b.participanteId;
  }

  /// Verifica si dos gallos pertenecen a participantes que son compadres.
  bool sonCompadres(Gallo a, Gallo b) {
    if (!configuracion.evitarCompadres) return false;

    final participanteA = _participantesMap[a.participanteId];
    final participanteB = _participantesMap[b.participanteId];

    if (participanteA == null || participanteB == null) return false;

    return participanteA.esCompadreDe(b.participanteId) ||
        participanteB.esCompadreDe(a.participanteId);
  }

  /// Verifica si dos gallos ya se enfrentaron en rondas anteriores.
  bool yaSeEnfrentaron(Gallo a, Gallo b, Set<String> historial) {
    final clave = _normalizarPar(a.id, b.id);
    return historial.contains(clave);
  }

  /// Verifica si un emparejamiento es válido considerando todas las restricciones.
  bool emparejamientoValido(Gallo a, Gallo b, Set<String> historial) {
    // Mismo gallo
    if (a.id == b.id) return false;

    // Verificar peso
    if (!cumplePeso(a, b)) return false;

    // Verificar distinto participante
    if (!distintoParticipante(a, b)) return false;

    // Verificar compadres
    if (sonCompadres(a, b)) return false;

    // Verificar historial
    if (yaSeEnfrentaron(a, b, historial)) return false;

    // Verificar estado activo
    if (a.estado != EstadoGallo.activo || b.estado != EstadoGallo.activo) {
      return false;
    }

    return true;
  }

  /// Normaliza un par de IDs para usar como clave en el historial.
  /// Siempre devuelve menorID-mayorID para evitar duplicados.
  static String normalizarPar(String idA, String idB) {
    return _normalizarPar(idA, idB);
  }

  static String _normalizarPar(String idA, String idB) {
    if (idA.compareTo(idB) < 0) {
      return '$idA-$idB';
    } else {
      return '$idB-$idA';
    }
  }
}

/// Resultado de validación con mensaje descriptivo.
class ResultadoValidacion {
  final bool esValido;
  final String? mensaje;

  const ResultadoValidacion.valido() : esValido = true, mensaje = null;

  const ResultadoValidacion.invalido(this.mensaje) : esValido = false;

  @override
  String toString() => esValido ? 'Válido' : 'Inválido: $mensaje';
}

/// Extensión para validación detallada con mensajes.
extension MatchingValidatorsDetallado on MatchingValidators {
  /// Valida un emparejamiento y devuelve resultado con mensaje.
  ResultadoValidacion validarEmparejamientoDetallado(
    Gallo a,
    Gallo b,
    Set<String> historial,
  ) {
    if (a.id == b.id) {
      return const ResultadoValidacion.invalido('Es el mismo gallo');
    }

    if (!cumplePeso(a, b)) {
      final diff = (a.peso - b.peso).abs();
      return ResultadoValidacion.invalido(
        'Diferencia de peso ($diff g) excede tolerancia (${configuracion.toleranciaPeso} g)',
      );
    }

    if (!distintoParticipante(a, b)) {
      return const ResultadoValidacion.invalido(
        'Ambos gallos pertenecen al mismo participante',
      );
    }

    if (sonCompadres(a, b)) {
      return const ResultadoValidacion.invalido(
        'Los participantes son compadres',
      );
    }

    if (yaSeEnfrentaron(a, b, historial)) {
      return const ResultadoValidacion.invalido(
        'Ya se enfrentaron en una ronda anterior',
      );
    }

    if (a.estado != EstadoGallo.activo) {
      return ResultadoValidacion.invalido('Gallo ${a.anillo} no está activo');
    }

    if (b.estado != EstadoGallo.activo) {
      return ResultadoValidacion.invalido('Gallo ${b.anillo} no está activo');
    }

    return const ResultadoValidacion.valido();
  }
}
