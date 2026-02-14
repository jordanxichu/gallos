import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:derby_engine/derby_engine.dart';
import '../viewmodels/viewmodels.dart';

/// Pantalla de gestión de gallos.
class GallosScreen extends StatelessWidget {
  const GallosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DerbyState>(
      builder: (context, state, _) {
        final gallosVM = state.gallosVM;
        final hayParticipantes = state.participantesVM.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Gallos'),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filtrar',
                onPressed: () => _mostrarFiltros(context),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: hayParticipantes
                ? () => _mostrarFormulario(context, state)
                : null,
            icon: const Icon(Icons.add),
            label: const Text('Agregar Gallo'),
          ),
          body: gallosVM.isEmpty
              ? _buildEmptyState(context, state, hayParticipantes)
              : _buildListaGallos(context, state, gallosVM),
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    DerbyState state,
    bool hayParticipantes,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay gallos registrados',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          if (!hayParticipantes)
            Text(
              'Primero registra participantes',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.orange.shade700),
            )
          else
            Text(
              'Agrega gallos para el derby',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
            ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: hayParticipantes
                ? () => _mostrarFormulario(context, state)
                : null,
            icon: const Icon(Icons.add),
            label: const Text('Agregar Gallo'),
          ),
        ],
      ),
    );
  }

  Widget _buildListaGallos(
    BuildContext context,
    DerbyState state,
    List<GalloVM> gallosVM,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con estadísticas
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStat('Total', '${gallosVM.length}', Icons.pets),
                  const SizedBox(width: 32),
                  _buildStat(
                    'Peso Promedio',
                    gallosVM.isEmpty
                        ? '-'
                        : '${(gallosVM.map((g) => g.peso).reduce((a, b) => a + b) / gallosVM.length).toStringAsFixed(0)}g',
                    Icons.scale,
                  ),
                  const SizedBox(width: 32),
                  _buildStat(
                    'Rango',
                    gallosVM.isEmpty
                        ? '-'
                        : '${gallosVM.map((g) => g.peso).reduce((a, b) => a < b ? a : b).toStringAsFixed(0)}g - ${gallosVM.map((g) => g.peso).reduce((a, b) => a > b ? a : b).toStringAsFixed(0)}g',
                    Icons.straighten,
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                    label: const Text('Exportar'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Grid de gallos
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 280,
                childAspectRatio: 1.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: gallosVM.length,
              itemBuilder: (context, index) {
                final galloVM = gallosVM[index];
                return _buildGalloCard(context, state, galloVM, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildGalloCard(
    BuildContext context,
    DerbyState state,
    GalloVM galloVM,
    int index,
  ) {
    return Card(
      child: InkWell(
        onTap: () => _mostrarFormulario(context, state, galloVM.gallo),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withOpacity(0.1),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'editar',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'eliminar',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Eliminar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'editar') {
                        _mostrarFormulario(context, state, galloVM.gallo);
                      } else if (value == 'eliminar') {
                        _confirmarEliminar(context, state, galloVM);
                      }
                    },
                  ),
                ],
              ),
              const Spacer(),
              Text(
                galloVM.anillo,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.scale, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    galloVM.pesoFormateado,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                galloVM.nombreParticipante,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarFormulario(
    BuildContext context,
    DerbyState state, [
    Gallo? gallo,
  ]) {
    if (state.participantesVM.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero debes registrar al menos un participante'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final esEdicion = gallo != null;
    final anilloController = TextEditingController(text: gallo?.anillo ?? '');
    final pesoController = TextEditingController(
      text: gallo != null ? gallo.peso.toStringAsFixed(0) : '',
    );
    String? participanteSeleccionado =
        gallo?.participanteId ?? state.participantes.first.id;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(esEdicion ? 'Editar Gallo' : 'Nuevo Gallo'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: participanteSeleccionado,
                  decoration: const InputDecoration(
                    labelText: 'Participante *',
                    prefixIcon: Icon(Icons.person),
                  ),
                  items: state.participantes.map((p) {
                    return DropdownMenuItem(value: p.id, child: Text(p.nombre));
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      participanteSeleccionado = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: pesoController,
                  decoration: const InputDecoration(
                    labelText: 'Peso (gramos) *',
                    hintText: 'Ej: 2100',
                    prefixIcon: Icon(Icons.scale),
                    suffixText: 'g',
                  ),
                  keyboardType: TextInputType.number,
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: anilloController,
                  decoration: const InputDecoration(
                    labelText: 'Anillo / Identificador',
                    hintText: 'Ej: A-001',
                    prefixIcon: Icon(Icons.tag),
                  ),
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
                final pesoText = pesoController.text.trim();
                if (pesoText.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('El peso es requerido')),
                  );
                  return;
                }

                final peso = double.tryParse(pesoText);
                if (peso == null || peso < 1000 || peso > 4000) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('El peso debe ser entre 1000g y 4000g'),
                    ),
                  );
                  return;
                }

                final anillo = anilloController.text.trim().isEmpty
                    ? 'G${DateTime.now().millisecondsSinceEpoch}'
                    : anilloController.text.trim();

                if (esEdicion) {
                  state.actualizarGallo(
                    Gallo(
                      id: gallo.id,
                      participanteId: participanteSeleccionado!,
                      peso: peso,
                      anillo: anillo,
                    ),
                  );
                } else {
                  state.agregarGallo(
                    Gallo(
                      id: 'g${DateTime.now().millisecondsSinceEpoch}',
                      participanteId: participanteSeleccionado!,
                      peso: peso,
                      anillo: anillo,
                    ),
                  );
                }

                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      esEdicion ? 'Gallo actualizado' : 'Gallo agregado',
                    ),
                  ),
                );
              },
              child: Text(esEdicion ? 'Guardar' : 'Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarEliminar(
    BuildContext context,
    DerbyState state,
    GalloVM galloVM,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Gallo'),
        content: Text(
          '¿Estás seguro de eliminar el gallo "${galloVM.anillo}"?\n'
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              state.eliminarGallo(galloVM.id);
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Gallo eliminado')));
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _mostrarFiltros(BuildContext context) {
    // TODO: Implementar diálogo de filtros
  }
}
