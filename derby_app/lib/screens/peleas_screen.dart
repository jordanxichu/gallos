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
                onPressed: () => _exportarRondaPdf(context, state),
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
                onPressed: state.rondaSeleccionada < state.totalRondas - 1
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
    return Column(
      children: [
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
                        const Spacer(),
                        Text(
                          '${rondaVM.peleasFinalizadas} / ${rondaVM.totalPeleas}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: rondaVM.totalPeleas == 0
                          ? 0
                          : rondaVM.peleasFinalizadas / rondaVM.totalPeleas,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (rondaVM.todasFinalizadas)
                ElevatedButton.icon(
                  onPressed: state.rondaSeleccionada < state.totalRondas - 1
                      ? () => state.siguienteRonda()
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Siguiente Ronda'),
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
    int index,
  ) {
    return Card(
      elevation: peleaVM.completada ? 1 : 4,
      color: peleaVM.completada ? Colors.grey.shade100 : null,
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
                if (peleaVM.completada)
                  Chip(
                    label: const Text('Finalizada'),
                    backgroundColor: Colors.green,
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),

            const Spacer(),

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
                    onTap: () => _registrarGanador(
                      context,
                      state,
                      peleaVM,
                      peleaVM.galloRojoId,
                    ),
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
                      if (!peleaVM.completada)
                        TextButton(
                          onPressed: () =>
                              _registrarEmpate(context, state, peleaVM),
                          child: const Text('Empate'),
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
                    onTap: () => _registrarGanador(
                      context,
                      state,
                      peleaVM,
                      peleaVM.galloVerdeId,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Acciones
            if (peleaVM.completada)
              TextButton.icon(
                onPressed: () => _deshacerResultado(context, state, peleaVM),
                icon: const Icon(Icons.undo, size: 18),
                label: const Text('Deshacer'),
              ),
          ],
        ),
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
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: completada ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
                'Tap para ganar',
                style: TextStyle(fontSize: 10, color: color.withOpacity(0.7)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _registrarGanador(
    BuildContext context,
    DerbyState state,
    PeleaVM peleaVM,
    String ganadorId,
  ) {
    state.registrarResultado(
      indexRonda: state.rondaSeleccionada,
      peleaId: peleaVM.id,
      ganadorId: ganadorId,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ganador registrado'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _registrarEmpate(
    BuildContext context,
    DerbyState state,
    PeleaVM peleaVM,
  ) {
    state.registrarResultado(
      indexRonda: state.rondaSeleccionada,
      peleaId: peleaVM.id,
      empate: true,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Empate registrado'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _deshacerResultado(
    BuildContext context,
    DerbyState state,
    PeleaVM peleaVM,
  ) {
    state.deshacerResultado(
      indexRonda: state.rondaSeleccionada,
      peleaId: peleaVM.id,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resultado deshecho'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _exportarRondaPdf(BuildContext context, DerbyState state) async {
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
}
