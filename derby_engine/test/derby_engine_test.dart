import 'package:derby_engine/derby_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Modelos', () {
    test('Gallo se crea correctamente', () {
      final gallo = Gallo(
        id: 'g1',
        participanteId: 'p1',
        peso: 2100,
        anillo: '001',
      );

      expect(gallo.id, equals('g1'));
      expect(gallo.peso, equals(2100));
      expect(gallo.estado, equals(EstadoGallo.activo));
    });

    test('Participante detecta compadres', () {
      final participante = Participante(
        id: 'p1',
        nombre: 'Rancho A',
        compadres: ['p2', 'p3'],
      );

      expect(participante.esCompadreDe('p2'), isTrue);
      expect(participante.esCompadreDe('p4'), isFalse);
    });

    test('ConfiguracionDerby valida pesos compatibles', () {
      final config = ConfiguracionDerby(toleranciaPeso: 80);

      expect(config.pesosCompatibles(2100, 2150), isTrue);
      expect(config.pesosCompatibles(2100, 2200), isFalse);
    });
  });
}
