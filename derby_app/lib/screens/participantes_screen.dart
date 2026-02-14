import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:derby_engine/derby_engine.dart';
import '../viewmodels/viewmodels.dart';

/// Pantalla de gestión de participantes.
class ParticipantesScreen extends StatelessWidget {
  const ParticipantesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DerbyState>(
      builder: (context, state, _) {
        final participantesVM = state.participantesVM;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Participantes'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Buscar',
                onPressed: () {},
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _mostrarFormulario(context, state),
            icon: const Icon(Icons.person_add),
            label: const Text('Agregar'),
          ),
          body: participantesVM.isEmpty
              ? _buildEmptyState(context, state)
              : _buildListaParticipantes(context, state, participantesVM),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, DerbyState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay participantes registrados',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega el primer participante para comenzar',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _mostrarFormulario(context, state),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Participante'),
          ),
        ],
      ),
    );
  }

  Widget _buildListaParticipantes(
    BuildContext context,
    DerbyState state,
    List<ParticipanteVM> participantesVM,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con conteo
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Text(
                  '${participantesVM.length} participantes registrados',
                  style: Theme.of(context).textTheme.titleMedium,
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

          // Tabla de participantes
          Expanded(
            child: Card(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('#')),
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Equipo')),
                      DataColumn(label: Text('Teléfono')),
                      DataColumn(label: Text('Gallos')),
                      DataColumn(label: Text('Puntos')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    rows: participantesVM.asMap().entries.map((entry) {
                      final index = entry.key;
                      final vm = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(vm.nombre)),
                          DataCell(Text(vm.equipo ?? '-')),
                          DataCell(Text(vm.telefono ?? '-')),
                          DataCell(Text('${vm.totalGallos}')),
                          DataCell(Text('${vm.puntosTotales}')),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  tooltip: 'Editar',
                                  onPressed: () => _mostrarFormulario(
                                    context,
                                    state,
                                    vm.participante,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 20),
                                  tooltip: 'Eliminar',
                                  onPressed: () =>
                                      _confirmarEliminar(context, state, vm),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarFormulario(
    BuildContext context,
    DerbyState state, [
    Participante? participante,
  ]) {
    final esEdicion = participante != null;
    final nombreController = TextEditingController(
      text: participante?.nombre ?? '',
    );
    final equipoController = TextEditingController(
      text: participante?.equipo ?? '',
    );
    final telefonoController = TextEditingController(
      text: participante?.telefono ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(esEdicion ? 'Editar Participante' : 'Nuevo Participante'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre *',
                  hintText: 'Nombre del criador o equipo',
                  prefixIcon: Icon(Icons.person),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: equipoController,
                decoration: const InputDecoration(
                  labelText: 'Equipo / Rancho',
                  hintText: 'Nombre del rancho (opcional)',
                  prefixIcon: Icon(Icons.home),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  hintText: '10 dígitos (opcional)',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
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
              final nombre = nombreController.text.trim();
              if (nombre.isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('El nombre es requerido')),
                );
                return;
              }

              if (esEdicion) {
                state.actualizarParticipante(
                  Participante(
                    id: participante.id,
                    nombre: nombre,
                    equipo: equipoController.text.trim().isEmpty
                        ? null
                        : equipoController.text.trim(),
                    telefono: telefonoController.text.trim().isEmpty
                        ? null
                        : telefonoController.text.trim(),
                  ),
                );
              } else {
                state.agregarParticipante(
                  Participante(
                    id: 'p${DateTime.now().millisecondsSinceEpoch}',
                    nombre: nombre,
                    equipo: equipoController.text.trim().isEmpty
                        ? null
                        : equipoController.text.trim(),
                    telefono: telefonoController.text.trim().isEmpty
                        ? null
                        : telefonoController.text.trim(),
                  ),
                );
              }

              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    esEdicion
                        ? 'Participante actualizado'
                        : 'Participante agregado',
                  ),
                ),
              );
            },
            child: Text(esEdicion ? 'Guardar' : 'Agregar'),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminar(
    BuildContext context,
    DerbyState state,
    ParticipanteVM vm,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Participante'),
        content: Text(
          '¿Estás seguro de eliminar a "${vm.nombre}"?\n'
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
              state.eliminarParticipante(vm.id);
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Participante eliminado')),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
