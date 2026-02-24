import 'package:derby_engine/derby_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:derby_app/services/retiro_backup_utils.dart';
import 'package:derby_app/viewmodels/gallo_vm.dart';
import 'package:derby_app/viewmodels/info_retiro.dart';

void main() {
  group('🧪 Backup', () {
    test(
      'Exporta gallo retirado con motivo controlado y campos opcionales',
      () {
        final gallo = Gallo(
          id: 'g1',
          participanteId: 'p1',
          peso: 2100,
          anillo: 'A-01',
          estado: EstadoGallo.retirado,
        );
        final info = InfoRetiro(
          ronda: 1,
          motivo: 'Muerte en combate',
          anillo: 'A-01',
          timestamp: DateTime.parse('2026-02-24T10:00:00Z'),
        );

        final campos = RetiroBackupUtils.camposRetiroParaJson(
          gallo: gallo,
          info: info,
        );

        expect(campos['retirado'], isTrue);
        expect(campos['motivoRetiro'], 'MUERTE');
        expect(campos['rondaRetiro'], 1);
        expect(campos['fechaRetiro'], isNotNull);
        expect(campos['observacionesRetiro'], contains('Muerte'));
      },
    );

    test('Importa backup con retiro (campos nuevos) correctamente', () {
      final galloJson = <String, dynamic>{
        'id': 'g1',
        'anillo': 'A-01',
        'estado': 'retirado',
        'retirado': true,
        'motivoRetiro': 'ABANDONO',
        'rondaRetiro': 2,
        'fechaRetiro': '2026-02-24T12:00:00Z',
        'observacionesRetiro': 'Abandono por decisión del dueño',
      };

      final info = RetiroBackupUtils.infoRetiroDesdeGalloJson(
        galloJson: galloJson,
        anillo: 'A-01',
        estado: EstadoGallo.retirado,
      );

      expect(info, isNotNull);
      expect(info!.ronda, 2);
      expect(info.motivo, contains('Abandono'));
    });

    test('Si observacionesRetiro == MURIO, se clasifica como MUERTE', () {
      final galloJson = <String, dynamic>{
        'id': 'g1',
        'anillo': 'A-01',
        'estado': 'retirado',
        'retirado': true,
        'motivoRetiro': 'ABANDONO',
        'rondaRetiro': 1,
        'observacionesRetiro': 'MURIO',
      };

      final info = RetiroBackupUtils.infoRetiroDesdeGalloJson(
        galloJson: galloJson,
        anillo: 'A-01',
        estado: EstadoGallo.retirado,
      );

      expect(info, isNotNull);
      expect(info!.esMuerte, isTrue);

      final motivo = RetiroBackupUtils.motivoControlado(
        estado: EstadoGallo.retirado,
        motivoLibre: info.motivo,
      );
      expect(motivo, 'MUERTE');
    });

    test('Importa backup antiguo sin fallo (sin campos nuevos)', () {
      final galloJsonViejo = <String, dynamic>{
        'id': 'g1',
        'anillo': 'A-01',
        'estado': 'retirado',
      };

      final info = RetiroBackupUtils.infoRetiroDesdeGalloJson(
        galloJson: galloJsonViejo,
        anillo: 'A-01',
        estado: EstadoGallo.retirado,
      );

      expect(info, isNull);
    });
  });

  group('🧪 Reportes', () {
    test('Gallo retirado genera texto explícito auditable para PDF/UI', () {
      final participante = Participante(id: 'p1', nombre: 'Criador');
      final gallo = Gallo(
        id: 'g1',
        participanteId: 'p1',
        peso: 2200,
        anillo: 'A-01',
        estado: EstadoGallo.retirado,
      );
      final info = InfoRetiro(
        ronda: 1,
        motivo: 'Muerte',
        anillo: 'A-01',
        timestamp: DateTime.now(),
      );

      final vm = GalloVM.fromGallo(
        gallo,
        participantes: [participante],
        infoRetiros: {'g1': info},
      );

      expect(vm.estadoDetalleVisible, 'RETIRADO – MUERTE (Ronda 1)');
    });

    test(
      'No debe existir pelea finalizada posterior al retiro (regla de reporte)',
      () {
        final rondas = [
          Ronda(id: 'r1', numero: 1, peleas: const []),
          Ronda(id: 'r2', numero: 2, peleas: const []),
        ];

        final warnings = RetiroBackupUtils.validarCoherenciaRetiro(
          galloId: 'g1',
          rondaRetiro: 1,
          anillo: 'A-01',
          rondas: rondas,
        );

        expect(
          warnings
              .where((w) => w.contains('aparece finalizado en ronda'))
              .isEmpty,
          isTrue,
        );
      },
    );
  });

  group('🧪 Integridad', () {
    test('Detecta pelea posterior a retiro (warning, no crash)', () {
      final rondas = [
        Ronda(id: 'r1', numero: 1, peleas: const []),
        Ronda(
          id: 'r2',
          numero: 2,
          peleas: const [
            Pelea(
              id: 'p1',
              numero: 1,
              galloRojoId: 'g1',
              galloVerdeId: 'g2',
              estado: EstadoPelea.finalizada,
              ganadorId: 'g1',
            ),
          ],
        ),
      ];

      final warnings = RetiroBackupUtils.validarCoherenciaRetiro(
        galloId: 'g1',
        rondaRetiro: 1,
        anillo: 'A-01',
        rondas: rondas,
      );

      expect(warnings, isNotEmpty);
      expect(warnings.first, contains('retirado en ronda 1'));
    });
  });
}
