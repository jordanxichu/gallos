import 'configuracion_derby.dart';
import 'gallo.dart';
import 'participante.dart';
import 'ronda.dart';

/// Representa un torneo de derbi completo.
///
/// Contiene todos los participantes, gallos, rondas y configuración
/// del evento.
class Derby {
  /// Identificador único del derbi.
  final String id;

  /// Nombre del evento.
  final String nombre;

  /// Fecha del evento.
  final DateTime fecha;

  /// Lugar del evento.
  final String? lugar;

  /// Configuración del derbi.
  final ConfiguracionDerby configuracion;

  /// Lista de participantes inscritos.
  final List<Participante> participantes;

  /// Lista de gallos inscritos.
  final List<Gallo> gallos;

  /// Lista de rondas generadas.
  final List<Ronda> rondas;

  /// Estado actual del derbi.
  final EstadoDerby estado;

  /// Fecha y hora de creación.
  final DateTime fechaCreacion;

  /// Notas adicionales del evento.
  final String? notas;

  Derby({
    required this.id,
    required this.nombre,
    required this.fecha,
    this.lugar,
    ConfiguracionDerby? configuracion,
    List<Participante>? participantes,
    List<Gallo>? gallos,
    List<Ronda>? rondas,
    this.estado = EstadoDerby.registroAbierto,
    DateTime? fechaCreacion,
    this.notas,
  }) : configuracion = configuracion ?? ConfiguracionDerby.standard(),
       participantes = participantes ?? [],
       gallos = gallos ?? [],
       rondas = rondas ?? [],
       fechaCreacion = fechaCreacion ?? DateTime.now();

  /// Número total de participantes.
  int get totalParticipantes => participantes.length;

  /// Número total de gallos inscritos.
  int get totalGallos => gallos.length;

  /// Número de rondas generadas.
  int get rondasGeneradas => rondas.length;

  /// Verifica si el registro está abierto.
  bool get registroAbierto => estado == EstadoDerby.registroAbierto;

  /// Verifica si el derbi ya inició.
  bool get enCurso => estado == EstadoDerby.enCurso;

  /// Obtiene un participante por su ID.
  Participante? obtenerParticipante(String id) {
    try {
      return participantes.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Obtiene un gallo por su ID.
  Gallo? obtenerGallo(String id) {
    try {
      return gallos.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Obtiene todos los gallos de un participante.
  List<Gallo> gallosDeParticipante(String participanteId) {
    return gallos.where((g) => g.participanteId == participanteId).toList();
  }

  /// Obtiene la tabla de posiciones ordenada por puntos.
  List<Participante> obtenerTablaPosiciones() {
    final lista = List<Participante>.from(participantes);
    lista.sort((a, b) {
      // Primero por puntos (descendente)
      final puntos = b.puntosTotales.compareTo(a.puntosTotales);
      if (puntos != 0) return puntos;

      // Luego por victorias (descendente)
      final victorias = b.peleasGanadas.compareTo(a.peleasGanadas);
      if (victorias != 0) return victorias;

      // Finalmente por nombre (ascendente)
      return a.nombre.compareTo(b.nombre);
    });
    return lista;
  }

  /// Crea una copia del derbi con los campos especificados modificados.
  Derby copyWith({
    String? id,
    String? nombre,
    DateTime? fecha,
    String? lugar,
    ConfiguracionDerby? configuracion,
    List<Participante>? participantes,
    List<Gallo>? gallos,
    List<Ronda>? rondas,
    EstadoDerby? estado,
    DateTime? fechaCreacion,
    String? notas,
  }) {
    return Derby(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      fecha: fecha ?? this.fecha,
      lugar: lugar ?? this.lugar,
      configuracion: configuracion ?? this.configuracion,
      participantes: participantes ?? this.participantes,
      gallos: gallos ?? this.gallos,
      rondas: rondas ?? this.rondas,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      notas: notas ?? this.notas,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Derby && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Derby(nombre: $nombre, participantes: $totalParticipantes, gallos: $totalGallos)';
}

/// Estados posibles de un derbi.
enum EstadoDerby {
  /// Registro de participantes y gallos abierto.
  registroAbierto,

  /// Registro cerrado, listo para generar rondas.
  registroCerrado,

  /// Derbi en curso (rondas generadas, peleas en progreso).
  enCurso,

  /// Derbi finalizado.
  finalizado,

  /// Derbi cancelado.
  cancelado,
}
