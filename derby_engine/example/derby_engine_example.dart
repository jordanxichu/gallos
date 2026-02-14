import 'package:derby_engine/derby_engine.dart';

void main() {
  // Ejemplo de uso del motor de derbys
  final config = ConfiguracionDerby(toleranciaPeso: 80, numeroRondas: 3);

  final participante = Participante(id: 'p1', nombre: 'Rancho El Dorado');

  final gallo = Gallo(
    id: 'g1',
    participanteId: participante.id,
    peso: 2100,
    anillo: '001',
  );

  print('Configuración: $config');
  print('Participante: $participante');
  print('Gallo: $gallo');
}
