import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/viewmodels.dart';
import '../services/pdf_service.dart';
import 'hoja_fisica_screen.dart';

/// Pantalla de peleas en tiempo real - para registrar ganadores.
class PeleasScreen extends StatelessWidget {
  const PeleasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DerbyState>(
      builder: (context, state, _) {
        if (!state.sorteoRealizado) {
          return _buildSinSorteo(context);
        }

        final rondaVM = state.rondaActualVM;
        if (rondaVM == null) {
          return _buildSinSorteo(context);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Peleas - Ronda ${state.rondaSeleccionada + 1} de ${state.totalRondas}',
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.picture_as_pdf),
                tooltip: 'Exportar ronda a PDF',
                onPressed: () {
                  if (!state.permitePdf) {
                    _mostrarMensajePdfBloqueado(context);
                    return;
                  }
                  _exportarRondaPdf(context, state);
                },
              ),
              IconButton(
                icon: const Icon(Icons.description_outlined),
                tooltip: 'Ver hoja física',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          HojaFisicaScreen(rondaIndex: state.rondaSeleccionada),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_previous),
                tooltip: 'Ronda anterior',
                onPressed: state.rondaSeleccionada > 0
                    ? () => state.rondaAnterior()
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                tooltip: 'Siguiente ronda',
                // Solo permitir avanzar si la ronda actual está bloqueada (completada)
                onPressed:
                    state.rondaSeleccionada < state.totalRondas - 1 &&
                        rondaVM.bloqueada
                    ? () => state.siguienteRonda()
                    : null,
              ),
            ],
          ),
          body: _buildPeleasRonda(context, state, rondaVM),
        );
      },
    );
  }

  Widget _buildSinSorteo(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peleas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_kabaddi, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No hay peleas programadas',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Realiza el sorteo primero',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeleasRonda(
    BuildContext context,
    DerbyState state,
    RondaVM rondaVM,
  ) {
    final rondaBloqueada = rondaVM.bloqueada;

    return Column(
      children: [
        // P0-2: Banner de ronda bloqueada
        if (rondaBloqueada)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.orange.shade100,
            child: Row(
              children: [
                Icon(Icons.lock, color: Colors.orange.shade800),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ronda bloqueada - No se pueden modificar resultados',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _confirmarDesbloqueo(context, state),
                  icon: Icon(Icons.lock_open, color: Colors.orange.shade800),
                  label: Text(
                    'Desbloquear',
                    style: TextStyle(color: Colors.orange.shade800),
                  ),
                ),
              ],
            ),
          ),

        // Barra de progreso
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Progreso de la ronda',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (rondaBloqueada) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.lock,
                            size: 16,
                            color: Colors.orange.shade700,
                          ),
                        ],
                        const Spacer(),
                        Text(
                          '${rondaVM.peleasTerminadas} / ${rondaVM.totalPeleas}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: rondaVM.totalPeleas == 0
                          ? 0
                          : rondaVM.peleasTerminadas / rondaVM.totalPeleas,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (rondaVM.todasFinalizadas) ...[
                if (state.rondaSeleccionada < state.totalRondas - 1)
                  ElevatedButton.icon(
                    onPressed: () => state.siguienteRonda(),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Siguiente Ronda'),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade400),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.emoji_events, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Derby Finalizado ✅',
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),

        // Resumen de la ronda (si hay canceladas)
        if (rondaVM.peleasCanceladas > 0)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey.shade200,
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    rondaVM.resumenDetallado,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          ),

        // Lista de peleas
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 500,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: rondaVM.peleasVM.length,
              itemBuilder: (context, index) {
                return _buildPeleaCard(
                  context,
                  state,
                  rondaVM.peleasVM[index],
                  index,
                  rondaBloqueada: rondaBloqueada,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeleaCard(
    BuildContext context,
    DerbyState state,
    PeleaVM peleaVM,
    int index, {
    bool rondaBloqueada = false,
  }) {
    // Card distinta para peleas canceladas
    if (peleaVM.cancelada) {
      return _buildPeleaCanceladaCard(context, peleaVM, index);
    }

    return Card(
      elevation: peleaVM.completada ? 1 : 4,
      color: peleaVM.completada ? Colors.grey.shade100 : null,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: rondaBloqueada
            ? null
            : () => peleaVM.completada
                ? _deshacerResultado(context, state, peleaVM)
                : _iniciarPeleaEnVivo(context, state, peleaVM),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(radius: 16, child: Text('${index + 1}')),
                  const SizedBox(width: 8),
                  Text(
                    'Pelea ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (rondaBloqueada)
                    Icon(Icons.lock, size: 18, color: Colors.orange.shade700)
                  else if (peleaVM.completada)
                    const Icon(Icons.check_circle, size: 20, color: Colors.green)
                  else
                    Icon(Icons.touch_app, size: 18, color: Colors.grey.shade500),
                ],
              ),

              const SizedBox(height: 12),

              // Competidores
              Row(
                children: [
                  // Lado Rojo
                  Expanded(
                    child: _buildLadoCompetidor(
                      context: context,
                      anillo: peleaVM.anilloRojo,
                      peso: peleaVM.pesoRojoFormateado,
                      nombreParticipante: peleaVM.nombreParticipanteRojo,
                      color: const Color(0xFF8B0000), // Rojo oscuro
                      esGanador: peleaVM.ganoRojo,
                      completada: peleaVM.completada,
                    ),
                  ),

                  // VS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const Text(
                          'VS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        if (peleaVM.completada &&
                            peleaVM.duracionSegundos != null)
                          Text(
                            peleaVM.duracionFormateada,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Lado Verde
                  Expanded(
                    child: _buildLadoCompetidor(
                      context: context,
                      anillo: peleaVM.anilloVerde,
                      peso: peleaVM.pesoVerdeFormateado,
                      nombreParticipante: peleaVM.nombreParticipanteVerde,
                      color: const Color(0xFF2E7D32), // Verde oscuro
                      esGanador: peleaVM.ganoVerde,
                      completada: peleaVM.completada,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Card gris/apagada para pelea cancelada — muestra motivo explícitamente.
  Widget _buildPeleaCanceladaCard(
    BuildContext context,
    PeleaVM peleaVM,
    int index,
  ) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade400,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Pelea ${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cancel, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'CANCELADA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Competidores (apagados)
            Row(
              children: [
                Expanded(
                  child: _buildLadoCanceladoCompetidor(
                    anillo: peleaVM.anilloRojo,
                    peso: peleaVM.pesoRojoFormateado,
                    nombreParticipante: peleaVM.nombreParticipanteRojo,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                Expanded(
                  child: _buildLadoCanceladoCompetidor(
                    anillo: peleaVM.anilloVerde,
                    peso: peleaVM.pesoVerdeFormateado,
                    nombreParticipante: peleaVM.nombreParticipanteVerde,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Motivo de cancelación
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      peleaVM.motivoCancelacion.isNotEmpty
                          ? peleaVM.motivoCancelacion
                          : 'Pelea cancelada',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Lado competidor para pelea cancelada (apagado, sin colores)
  Widget _buildLadoCanceladoCompetidor({
    required String anillo,
    required String peso,
    required String nombreParticipante,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.pets, color: Colors.grey.shade500, size: 24),
          const SizedBox(height: 8),
          Text(
            anillo,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            peso,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          Text(
            nombreParticipante,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLadoCompetidor({
    required BuildContext context,
    required String anillo,
    required String peso,
    required String nombreParticipante,
    required Color color,
    required bool esGanador,
    required bool completada,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: esGanador ? color.withOpacity(0.2) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: esGanador ? color : Colors.transparent,
          width: 3,
        ),
      ),
      child: Column(
        children: [
          if (esGanador)
            Icon(Icons.emoji_events, color: color, size: 24)
          else
            Icon(Icons.pets, color: color.withOpacity(0.5), size: 24),
          const SizedBox(height: 8),
          Text(
            anillo,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          Text(peso, style: const TextStyle(fontSize: 16)),
          Text(
            nombreParticipante,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (!completada) ...[
            const SizedBox(height: 8),
            Text(
              'Listo para iniciar',
              style: TextStyle(fontSize: 10, color: color.withOpacity(0.7)),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _iniciarPeleaEnVivo(
    BuildContext context,
    DerbyState state,
    PeleaVM peleaVM,
  ) async {
    final resultado = await Navigator.push<_ResultadoPeleaEnVivo>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _PeleaEnVivoScreen(
          peleaVM: peleaVM,
          rondaIndex: state.rondaSeleccionada,
          totalRondas: state.totalRondas,
        ),
      ),
    );

    if (resultado == null) return;

    await state.registrarResultado(
      indexRonda: state.rondaSeleccionada,
      peleaId: peleaVM.id,
      ganadorId: resultado.ganadorId,
      empate: resultado.empate,
      duracionSegundos: resultado.duracionSegundos,
      notas: resultado.notas,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resultado.empate
                ? 'Pelea finalizada en empate (${_formatearDuracion(resultado.duracionSegundos)})'
                : 'Resultado guardado (${_formatearDuracion(resultado.duracionSegundos)})',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _mostrarRegistroRapido(
    BuildContext context,
    DerbyState state,
    PeleaVM peleaVM,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Registro rápido - Pelea ${peleaVM.numero}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(
                  Icons.sports_martial_arts,
                  color: Color(0xFF8B0000),
                ),
                title: Text('Ganó Rojo (${peleaVM.anilloRojo})'),
                onTap: () {
                  Navigator.pop(context);
                  _registrarGanador(
                    context,
                    state,
                    peleaVM,
                    peleaVM.galloRojoId,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.handshake),
                title: const Text('Empate'),
                onTap: () {
                  Navigator.pop(context);
                  _registrarEmpate(context, state, peleaVM);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.sports_martial_arts,
                  color: Color(0xFF2E7D32),
                ),
                title: Text('Ganó Verde (${peleaVM.anilloVerde})'),
                onTap: () {
                  Navigator.pop(context);
                  _registrarGanador(
                    context,
                    state,
                    peleaVM,
                    peleaVM.galloVerdeId,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // P0-3: Registrar ganador con CONFIRMACIÓN obligatoria
  Future<void> _registrarGanador(
    BuildContext context,
    DerbyState state,
    PeleaVM peleaVM,
    String ganadorId,
  ) async {
    final esRojo = ganadorId == peleaVM.galloRojoId;
    final anilloGanador = esRojo ? peleaVM.anilloRojo : peleaVM.anilloVerde;
    final nombreGanador = esRojo
        ? peleaVM.nombreParticipanteRojo
        : peleaVM.nombreParticipanteVerde;
    final colorGanador = esRojo ? 'ROJO' : 'VERDE';

    // P0-3: Diálogo de confirmación obligatorio
    final confirmar = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar resultado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Confirmar que GANÓ $colorGanador?',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: esRojo
                      ? const Color(0xFF8B0000)
                      : const Color(0xFF2E7D32),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anillo: $anilloGanador',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Dueño: $nombreGanador'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Ronda ${state.rondaSeleccionada + 1} · Pelea ${peleaVM.numero}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: esRojo
                  ? const Color(0xFF8B0000)
                  : const Color(0xFF2E7D32),
            ),
            child: Text('Confirmar $colorGanador'),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) return;

    try {
      await state.registrarResultado(
        indexRonda: state.rondaSeleccionada,
        peleaId: peleaVM.id,
        ganadorId: ganadorId,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✓ Ganador registrado: $anilloGanador ($colorGanador)',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } on StateError catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    }
  }

  // P0-3: Registrar empate con CONFIRMACIÓN obligatoria
  Future<void> _registrarEmpate(
    BuildContext context,
    DerbyState state,
    PeleaVM peleaVM,
  ) async {
    // P0-3: Diálogo de confirmación obligatorio
    final confirmar = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar resultado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Confirmar EMPATE?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.handshake, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${peleaVM.anilloRojo} vs ${peleaVM.anilloVerde}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${peleaVM.nombreParticipanteRojo} vs ${peleaVM.nombreParticipanteVerde}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Text(
              'Ronda ${state.rondaSeleccionada + 1} · Pelea ${peleaVM.numero}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Confirmar Empate'),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) return;

    try {
      await state.registrarResultado(
        indexRonda: state.rondaSeleccionada,
        peleaId: peleaVM.id,
        empate: true,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Empate registrado'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } on StateError catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    }
  }

  // P0-1: Deshacer resultado con manejo de errores
  Future<void> _deshacerResultado(
    BuildContext context,
    DerbyState state,
    PeleaVM peleaVM,
  ) async {
    // Confirmación simple para deshacer
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Deshacer resultado'),
        content: Text(
          '¿Deshacer el resultado de la pelea ${peleaVM.numero}?\n\n'
          'Los puntos serán revertidos automáticamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Deshacer'),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) return;

    try {
      await state.deshacerResultado(
        indexRonda: state.rondaSeleccionada,
        peleaId: peleaVM.id,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Resultado deshecho y puntos revertidos'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } on StateError catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    }
  }

  // P0-2: Desbloquear ronda con DOBLE confirmación
  Future<void> _confirmarDesbloqueo(
    BuildContext context,
    DerbyState state,
  ) async {
    // Primera confirmación
    final primera = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange.shade700),
            const SizedBox(width: 8),
            const Text('Desbloquear Ronda'),
          ],
        ),
        content: const Text(
          'La ronda está bloqueada porque todas las peleas fueron finalizadas.\n\n'
          '¿Desea desbloquearla para hacer correcciones?\n\n'
          'ADVERTENCIA: Esto permitirá modificar resultados ya registrados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );

    if (primera != true || !context.mounted) return;

    // Segunda confirmación (más estricta)
    final segunda = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            const Text('¿Está seguro?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CONFIRMAR DESBLOQUEO',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 12),
            const Text(
              'Al desbloquear la ronda:\n'
              '• Podrá modificar resultados\n'
              '• Los puntos pueden cambiar\n'
              '• Esta acción quedará registrada\n\n'
              '¿Confirma que desea desbloquear?',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No, mantener bloqueada'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sí, desbloquear'),
          ),
        ],
      ),
    );

    if (segunda != true || !context.mounted) return;

    await state.desbloquearRonda(state.rondaSeleccionada);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Ronda desbloqueada - Puede modificar resultados'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _exportarRondaPdf(BuildContext context, DerbyState state) async {
    if (!state.permitePdf) {
      _mostrarMensajePdfBloqueado(context);
      return;
    }

    try {
      await PdfService.exportarBrackets(
        state,
        rondaIndex: state.rondaSeleccionada,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ PDF de ronda guardado y abierto'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al exportar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _mostrarMensajePdfBloqueado(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exportar PDF requiere licencia Pro activa.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  String _formatearDuracion(int segundos) {
    final mins = segundos ~/ 60;
    final secs = segundos % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

class _ResultadoPeleaEnVivo {
  final String? ganadorId;
  final bool empate;
  final int duracionSegundos;
  final String? notas;

  const _ResultadoPeleaEnVivo({
    this.ganadorId,
    required this.empate,
    required this.duracionSegundos,
    this.notas,
  });
}

class _PeleaEnVivoScreen extends StatefulWidget {
  final PeleaVM peleaVM;
  final int rondaIndex;
  final int totalRondas;

  const _PeleaEnVivoScreen({
    required this.peleaVM,
    required this.rondaIndex,
    required this.totalRondas,
  });

  @override
  State<_PeleaEnVivoScreen> createState() => _PeleaEnVivoScreenState();
}

class _PeleaEnVivoScreenState extends State<_PeleaEnVivoScreen> {
  Timer? _timer;
  int _segundos = 0;
  bool _corriendo = true;
  final TextEditingController _notasController = TextEditingController();
  final List<_EventoPeleaEnVivo> _historial = [];

  @override
  void initState() {
    super.initState();
    _agregarEvento('Inicio de pelea');
    _iniciarTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notasController.dispose();
    super.dispose();
  }

  void _iniciarTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_corriendo) return;
      setState(() => _segundos++);
    });
  }

  void _togglePausa() {
    setState(() {
      _corriendo = !_corriendo;
      _agregarEvento(_corriendo ? 'Pelea reanudada' : 'Pelea pausada');
    });
  }

  void _reiniciarTiempo() {
    setState(() {
      final tiempoAnterior = _tiempoFormateado;
      _segundos = 0;
      _corriendo = true;
      _agregarEvento('Tiempo reiniciado (antes: $tiempoAnterior)');
    });
  }

  Future<void> _finalizar({String? ganadorId, bool empate = false}) async {
    final etiquetaResultado = empate
        ? 'Resultado final: Empate'
        : ganadorId == widget.peleaVM.galloRojoId
        ? 'Resultado final: Ganó Rojo'
        : 'Resultado final: Ganó Verde';
    _agregarEvento(etiquetaResultado);

    final notas = _notasController.text.trim();
    Navigator.pop(
      context,
      _ResultadoPeleaEnVivo(
        ganadorId: ganadorId,
        empate: empate,
        duracionSegundos: _segundos,
        notas: notas.isEmpty ? null : notas,
      ),
    );
  }

  String get _tiempoFormateado {
    final mins = _segundos ~/ 60;
    final secs = _segundos % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _agregarEvento(String descripcion) {
    _historial.insert(
      0,
      _EventoPeleaEnVivo(tiempoSegundos: _segundos, descripcion: descripcion),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pelea = widget.peleaVM;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pelea ${pelea.numero} · Ronda ${widget.rondaIndex + 1}/${widget.totalRondas}',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                children: [
                  Text(
                    _tiempoFormateado,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(_corriendo ? 'EN CURSO' : 'PAUSADA'),
                    backgroundColor: _corriendo
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _CompetidorEnVivoCard(
                      color: const Color(0xFF8B0000),
                      lado: 'ROJO',
                      anillo: pelea.anilloRojo,
                      peso: pelea.pesoRojoFormateado,
                      participante: pelea.nombreParticipanteRojo,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _CompetidorEnVivoCard(
                      color: const Color(0xFF2E7D32),
                      lado: 'VERDE',
                      anillo: pelea.anilloVerde,
                      peso: pelea.pesoVerdeFormateado,
                      participante: pelea.nombreParticipanteVerde,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notasController,
              maxLines: 2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Notas de la pelea (opcional)',
                hintText: 'Incidencias, observaciones, etc.',
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 160),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.grey.shade50,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                    child: Row(
                      children: [
                        const Icon(Icons.history, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Historial en vivo',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _historial.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final evento = _historial[index];
                        return ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          leading: Text(
                            _formatearSegundos(evento.tiempoSegundos),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          title: Text(evento.descripcion),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _togglePausa,
                  icon: Icon(_corriendo ? Icons.pause : Icons.play_arrow),
                  label: Text(_corriendo ? 'Pausar' : 'Reanudar'),
                ),
                OutlinedButton.icon(
                  onPressed: _reiniciarTiempo,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reiniciar tiempo'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _finalizar(ganadorId: pelea.galloRojoId),
                  icon: const Icon(Icons.emoji_events),
                  label: const Text('Ganó Rojo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _finalizar(empate: true),
                  icon: const Icon(Icons.handshake),
                  label: const Text('Empate'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _finalizar(ganadorId: pelea.galloVerdeId),
                  icon: const Icon(Icons.emoji_events),
                  label: const Text('Ganó Verde'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatearSegundos(int segundos) {
    final mins = segundos ~/ 60;
    final secs = segundos % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

class _EventoPeleaEnVivo {
  final int tiempoSegundos;
  final String descripcion;

  const _EventoPeleaEnVivo({
    required this.tiempoSegundos,
    required this.descripcion,
  });
}

class _CompetidorEnVivoCard extends StatelessWidget {
  final Color color;
  final String lado;
  final String anillo;
  final String peso;
  final String participante;

  const _CompetidorEnVivoCard({
    required this.color,
    required this.lado,
    required this.anillo,
    required this.peso,
    required this.participante,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color, width: 2),
        color: color.withOpacity(0.08),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            lado,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Icon(Icons.pets, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            anillo,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(peso, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            participante,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
