# Derby Engine - API Pública

## Resumen

El `derby_engine` es el motor matemático puro (Dart, sin Flutter).
La UI **SOLO** debe consumir esta API, nunca asumir campos adicionales.

---

## 📦 Modelos de Datos

### `Gallo`
```dart
class Gallo {
  final String id;                    // ID único
  final String participanteId;        // Dueño
  final double peso;                  // En gramos (e.g., 2100.0)
  final String anillo;                // Identificador físico (REQUERIDO)
  final EstadoGallo estado;           // activo | finalizado | retirado | descalificado
  
  // Métodos
  Gallo copyWith({...});
}
```

**❌ NO TIENE:** `color`, `raza`, `edad`

---

### `Participante`
```dart
class Participante {
  final String id;
  final String nombre;
  final String? telefono;
  final String? equipo;
  final List<String> compadres;       // IDs de compadres
  
  // MUTABLES (se actualizan durante el torneo)
  int puntosTotales;
  int peleasGanadas;
  int peleasEmpatadas;
  int peleasPerdidas;
  
  // Getters
  int get totalPeleas;                // ganadas + empatadas + perdidas
  
  // Métodos
  bool esCompadreDe(String otroId);
  Participante copyWith({...});
}
```

**❌ NO TIENE:** `victorias`, `derrotas` (usar `peleasGanadas`, `peleasPerdidas`)

---

### `Pelea`
```dart
class Pelea {
  final String id;                    // e.g., "r1_p3" (ronda 1, pelea 3)
  final int numero;                   // Número dentro de la ronda
  final String galloRojoId;
  final String galloVerdeId;
  final String? ganadorId;            // null si no ha terminado
  final bool empate;
  final EstadoPelea estado;           // pendiente | enCurso | finalizada | cancelada
  final int? duracionSegundos;
  final String? notas;
  
  // Getters
  bool get tieneResultado;
  
  // Métodos
  bool participoGallo(String galloId);
  String? obtenerOponente(String galloId);
  Pelea conResultado({ganadorId, empate, duracion, notas});
  Pelea copyWith({...});
}
```

**❌ NO TIENE:** `rondaNumero` (está en Ronda.numero)

---

### `Ronda`
```dart
class Ronda {
  final String id;                    // e.g., "ronda_1"
  final int numero;                   // 1, 2, 3...
  final List<Pelea> peleas;
  final List<String> sinCotejo;       // IDs de gallos sin pelea
  final EstadoRonda estado;           // generada | enProgreso | finalizada
  final DateTime? fechaGeneracion;
  final bool bloqueada;
  
  // Getters
  int get totalPeleas;
  int get peleasFinalizadas;
  bool get todasFinalizadas;
  
  // Métodos
  Pelea? obtenerPeleaDeGallo(String galloId);
  bool galloParticipo(String galloId);
  bool galloSinCotejo(String galloId);
  Ronda conPeleasActualizadas(List<Pelea> nuevas);
  Ronda bloquear();
  Ronda copyWith({...});
}
```

---

### `ConfiguracionDerby`
```dart
class ConfiguracionDerby {
  final double toleranciaPeso;        // Default: 80.0
  final double pesoMinimo;            // Default: 1800.0
  final double pesoMaximo;            // Default: 2500.0
  final int numeroRondas;             // Default: 3
  final int puntosVictoria;           // Default: 3
  final int puntosEmpate;             // Default: 1
  final int puntosDerrota;            // Default: 0
  final bool evitarCompadres;         // Default: true
  final bool balancearLados;          // Default: false
  final int gallosPorParticipante;    // Default: 5
  final String prefijoAnillo;
  final int digitosAnillo;
  
  // Factories
  ConfiguracionDerby.standard();
  ConfiguracionDerby.estricta();      // tolerancia 50, compadres true
  
  // Métodos
  bool pesoEnRango(double peso);
  bool pesosCompatibles(double p1, double p2);
  ConfiguracionDerby copyWith({...});
}
```

**❌ NO TIENE:** `rondasTotales` (usar `numeroRondas`)

---

### `Derby`
```dart
class Derby {
  final String id;
  final String nombre;
  final DateTime fecha;
  final String? lugar;
  final ConfiguracionDerby configuracion;
  final List<Participante> participantes;
  final List<Gallo> gallos;
  final List<Ronda> rondas;
  final EstadoDerby estado;           // registroAbierto | enCurso | finalizado | cancelado
  final DateTime fechaCreacion;
  final String? notas;
  
  // Getters
  int get totalParticipantes;
  int get totalGallos;
  int get rondasGeneradas;
  bool get registroAbierto;
  bool get enCurso;
  
  // Métodos
  Participante? obtenerParticipante(String id);
  Gallo? obtenerGallo(String id);
  List<Gallo> gallosDeParticipante(String participanteId);
  List<Participante> obtenerTablaPosiciones();  // Ordenada por puntos
  Derby copyWith({...});
}
```

---

## 🔧 API de Emparejamiento

### `RoundGenerator` (PUNTO DE ENTRADA PRINCIPAL)
```dart
class RoundGenerator {
  RoundGenerator({
    required ConfiguracionDerby configuracion,
    required List<Participante> participantes,
  });
  
  /// Genera todas las rondas del torneo
  ResultadoGeneracion generarRondas({
    required List<Gallo> gallos,
    int? numeroRondas,     // Override de configuracion.numeroRondas
    bool optimizar = true, // Usar MultiRunOptimizer internamente
  });
  
  /// Genera una ronda adicional dado historial previo
  Ronda generarRondaAdicional({
    required List<Gallo> gallos,
    required List<Ronda> rondasPrevias,
    bool optimizar = true,
  });
  
  /// Valida que las rondas no tengan conflictos
  ResultadoValidacionRondas validarRondas(List<Ronda> rondas);
}
```

---

### `ResultadoGeneracion`
```dart
class ResultadoGeneracion {
  final List<Ronda> rondas;
  final List<EstadisticasRonda> estadisticas;
  final int totalGallos;
  final ConfiguracionDerby configuracion;
  
  int get totalRondas;
  int get totalPeleas;
}
```

---

### `EstadisticasRonda`
```dart
class EstadisticasRonda {
  final int numeroRonda;
  final int totalPeleas;
  final int sinCotejo;
  final double porcentajeExito;
}
```

---

## ✅ Uso Correcto desde UI

```dart
// 1. Crear generador
final generator = RoundGenerator(
  configuracion: ConfiguracionDerby(
    toleranciaPeso: 50.0,
    numeroRondas: 10,
  ),
  participantes: listaParticipantes,
);

// 2. Generar rondas
final resultado = generator.generarRondas(
  gallos: listaGallos,
  optimizar: true,
);

// 3. Acceder a resultados
final rondas = resultado.rondas;           // List<Ronda>
final stats = resultado.estadisticas;      // List<EstadisticasRonda>
final totalPeleas = resultado.totalPeleas;
```

---

## ⚠️ Errores Comunes (NO HACER)

| ❌ Incorrecto | ✅ Correcto |
|--------------|-------------|
| `gallo.color` | No existe, usar ViewModel |
| `participante.victorias` | `participante.peleasGanadas` |
| `participante.derrotas` | `participante.peleasPerdidas` |
| `pelea.rondaNumero` | `ronda.numero` (de la Ronda contenedora) |
| `config.rondasTotales` | `config.numeroRondas` |
| `MultiRunOptimizer.optimizarSorteo()` | `RoundGenerator.generarRondas(optimizar: true)` |

---

## 📁 Estructura de Exports

```
derby_engine
├── lib/derby_engine.dart (barrel)
│   ├── export models/models.dart
│   └── export matching/matching.dart
│
├── models/
│   ├── gallo.dart
│   ├── participante.dart
│   ├── pelea.dart
│   ├── ronda.dart
│   ├── derby.dart
│   └── configuracion_derby.dart
│
└── matching/
    ├── matching_algorithm.dart
    ├── round_generator.dart
    ├── multi_run_optimizer.dart
    ├── round_score.dart
    └── validators.dart
```

---

## 🔒 Regla de Oro

> **El engine NUNCA cambia para satisfacer la UI.**
> **La UI crea ViewModels que adaptan los modelos del engine.**
