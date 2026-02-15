import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/derby_state.dart';
import '../services/pdf_service.dart';

/// Pantalla de sorteo - genera las rondas usando el motor de matching.
class SorteoScreen extends StatelessWidget {
  const SorteoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DerbyState>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sorteo de Peleas'),
            actions: [
              if (state.sorteoRealizado)
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  tooltip: 'Exportar PDF',
                  onPressed: () {
                    if (!state.permitePdf) {
                      _mostrarMensajePdfBloqueado(context);
                      return;
                    }
                    _exportarPdf(context, state);
                  },
                ),
              if (state.sorteoRealizado || state.tienePreview)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Nuevo Sorteo',
                  onPressed: () => _confirmarNuevoSorteo(context, state),
                ),
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Configuración',
                onPressed: () => _mostrarConfiguracion(context, state),
              ),
            ],
          ),
          body: state.cargando
              ? _buildProcesando()
              : (state.sorteoRealizado || state.tienePreview)
              ? _buildResultados(context, state)
              : _buildPreSorteo(context, state),
        );
      },
    );
  }

  Widget _buildProcesando() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 24),
          Text('Generando peleas óptimas...', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Text(
            'Ejecutando múltiples iteraciones',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPreSorteo(BuildContext context, DerbyState state) {
    final puedeIniciar = state.totalGallos >= 2;
    final config = state.config;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Card de resumen
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.casino,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sorteo de Peleas',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'El sistema generará automáticamente los emparejamientos '
                    'óptimos considerando peso, compadres y participantes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Estadísticas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(
                        'Participantes',
                        '${state.totalParticipantes}',
                        Icons.people,
                      ),
                      _buildStatCard(
                        'Gallos',
                        '${state.totalGallos}',
                        Icons.pets,
                      ),
                      _buildStatCard(
                        'Rondas',
                        '${config.numeroRondas}',
                        Icons.repeat,
                      ),
                      _buildStatCard(
                        'Tolerancia',
                        '${config.toleranciaPeso.toStringAsFixed(0)}g',
                        Icons.scale,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Validaciones
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Validaciones',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildValidacion(
                    'Mínimo 2 gallos registrados',
                    state.totalGallos >= 2,
                  ),
                  _buildValidacion(
                    'Al menos 2 participantes diferentes',
                    state.totalParticipantes >= 2,
                  ),
                  _buildValidacion(
                    'Configuración de rondas definida',
                    config.numeroRondas > 0,
                  ),
                  _buildValidacion(
                    'Tolerancia de peso configurada',
                    config.toleranciaPeso > 0,
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Botón de iniciar
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: puedeIniciar ? () => state.generarPreviewSorteo() : null,
              icon: const Icon(Icons.visibility, size: 28),
              label: const Text(
                'GENERAR PREVIEW',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),

          if (!puedeIniciar) ...[
            const SizedBox(height: 8),
            const Text(
              'Registra al menos 2 gallos para iniciar',
              style: TextStyle(color: Colors.orange),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.grey),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildValidacion(String texto, bool cumple) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            cumple ? Icons.check_circle : Icons.cancel,
            color: cumple ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(texto),
        ],
      ),
    );
  }

  Widget _buildResultados(BuildContext context, DerbyState state) {
    final rondasVM = state.rondasMostradasVM;
    final enPreview = !state.sorteoRealizado && state.tienePreview;

    return Row(
      children: [
        // Lista de rondas (sidebar)
        SizedBox(
          width: 200,
          child: Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Rondas',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: rondasVM.length,
                    itemBuilder: (context, index) {
                      final rondaVM = rondasVM[index];
                      final isSelected = index == state.rondaSeleccionada;
                      return ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text('Ronda ${index + 1}'),
                        subtitle: Text(rondaVM.resumenLabel),
                        selected: isSelected,
                        onTap: () => state.seleccionarRonda(index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Detalle de peleas
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumen
                Card(
                  color: enPreview ? Colors.amber.shade50 : Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          enPreview ? Icons.visibility : Icons.check_circle,
                          color: enPreview ? Colors.amber.shade700 : Colors.green,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              enPreview ? 'Preview de Sorteo' : 'Sorteo Completado',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              enPreview
                                  ? '${state.totalRondasMostradas} rondas generadas (sin confirmar)'
                                  : '${state.totalRondas} rondas, ${state.totalPeleas} peleas generadas',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                        const Spacer(),
                        if (!enPreview)
                          ElevatedButton.icon(
                            onPressed: () {
                              if (!state.permitePdf) {
                                _mostrarMensajePdfBloqueado(context);
                                return;
                              }
                              _exportarPdf(context, state);
                            },
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text('Exportar PDF'),
                          ),
                      ],
                    ),
                  ),
                ),

                if (enPreview) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => state.descartarPreviewSorteo(),
                        icon: const Icon(Icons.close),
                        label: const Text('Descartar Preview'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => state.aprobarPreviewSorteo(),
                        icon: const Icon(Icons.check),
                        label: const Text('Aprobar Rondas'),
                      ),
                      const SizedBox(width: 12),
                      if (state.previewGeneradoEn != null)
                        Text(
                          'Generado: '
                          '${state.previewGeneradoEn!.day.toString().padLeft(2, '0')}/'
                          '${state.previewGeneradoEn!.month.toString().padLeft(2, '0')} '
                          '${state.previewGeneradoEn!.hour.toString().padLeft(2, '0')}:'
                          '${state.previewGeneradoEn!.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                    ],
                  ),
                ],

                const SizedBox(height: 16),

                // Tabla de peleas de la ronda seleccionada
                Expanded(
                  child: Card(
                    child: state.rondaActualVM == null
                        ? const Center(child: Text('No hay peleas'))
                        : _buildTablaPeleas(context, state),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTablaPeleas(BuildContext context, DerbyState state) {
    final rondaVM = state.rondaMostradaVM!;
    final config = state.config;

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('#')),
            DataColumn(label: Text('Lado Rojo')),
            DataColumn(label: Text('Peso')),
            DataColumn(label: Text('VS')),
            DataColumn(label: Text('Peso')),
            DataColumn(label: Text('Lado Verde')),
            DataColumn(label: Text('Diferencia')),
          ],
          rows: rondaVM.peleasVM.asMap().entries.map((entry) {
            final index = entry.key;
            final peleaVM = entry.value;
            final diff = peleaVM.diferenciaPeso;

            return DataRow(
              cells: [
                DataCell(Text('${index + 1}')),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        peleaVM.anilloRojo,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        peleaVM.nombreParticipanteRojo,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(Text(peleaVM.pesoRojoFormateado)),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('VS'),
                  ),
                ),
                DataCell(Text(peleaVM.pesoVerdeFormateado)),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        peleaVM.anilloVerde,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        peleaVM.nombreParticipanteVerde,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Text(
                    peleaVM.diferenciaPesoFormateada,
                    style: TextStyle(
                      color: diff > config.toleranciaPeso * 0.8
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _mostrarConfiguracion(BuildContext context, DerbyState state) {
    final config = state.config;
    final rondasController = TextEditingController(
      text: config.numeroRondas.toString(),
    );
    final toleranciaController = TextEditingController(
      text: config.toleranciaPeso.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Configuración del Derby'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: rondasController,
                decoration: const InputDecoration(
                  labelText: 'Número de Rondas',
                  prefixIcon: Icon(Icons.repeat),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: toleranciaController,
                decoration: const InputDecoration(
                  labelText: 'Tolerancia de Peso (gramos)',
                  prefixIcon: Icon(Icons.scale),
                  suffixText: 'g',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final rondas = int.tryParse(rondasController.text) ?? 10;
              final tolerancia =
                  double.tryParse(toleranciaController.text) ?? 50.0;

              state.actualizarConfiguracion(
                config.copyWith(
                  numeroRondas: rondas,
                  toleranciaPeso: tolerancia,
                ),
              );

              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configuración guardada')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmarNuevoSorteo(BuildContext context, DerbyState state) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nuevo Sorteo'),
        content: Text(
          state.tienePreview && !state.sorteoRealizado
              ? '¿Deseas descartar el preview actual?'
              : '¿Estás seguro de realizar un nuevo sorteo?\nSe descartará el sorteo actual.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (state.tienePreview && !state.sorteoRealizado) {
                state.descartarPreviewSorteo();
              } else {
                state.limpiarSorteo();
              }
            },
            child: Text(state.tienePreview && !state.sorteoRealizado ? 'Descartar' : 'Nuevo Sorteo'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportarPdf(BuildContext context, DerbyState state) async {
    if (!state.permitePdf) {
      _mostrarMensajePdfBloqueado(context);
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Reporte Completo'),
              subtitle: const Text('Resumen + posiciones + todas las rondas'),
              onTap: () async {
                Navigator.pop(ctx);
                try {
                  await PdfService.exportarDerbyCompleto(state);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ PDF guardado y abierto'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_view),
              title: const Text('Brackets de Peleas'),
              subtitle: const Text('Todas las rondas con peleas'),
              onTap: () async {
                Navigator.pop(ctx);
                try {
                  await PdfService.exportarBrackets(state);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ PDF guardado y abierto'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _mostrarMensajePdfBloqueado(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exportar PDF requiere licencia Pro activa.'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
