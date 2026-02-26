import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:derby_engine/derby_engine.dart';
import '../viewmodels/viewmodels.dart';
import '../core/test_keys.dart';

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
            key: ParticipantesKeys.fabAgregarParticipante,
            onPressed: () {
              if (!state.puedeAgregarParticipante) {
                _mostrarMensajeLicencia(context, state.maxParticipantesDemo);
                return;
              }
              _mostrarFormulario(context, state);
            },
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
            onPressed: () {
              if (!state.puedeAgregarParticipante) {
                _mostrarMensajeLicencia(context, state.maxParticipantesDemo);
                return;
              }
              _mostrarFormulario(context, state);
            },
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
                  onPressed: participantesVM.isEmpty
                      ? null
                      : () => _exportarParticipantes(context, state),
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
                      DataColumn(label: Text('Compadres')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    rows: participantesVM.asMap().entries.map((entry) {
                      final index = entry.key;
                      final vm = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(vm.nombre),
                                if (vm.estadoBadge.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: vm.todosDescalificados
                                          ? Colors.red
                                          : Colors.orange,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      vm.estadoBadge,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          DataCell(Text(vm.equipo ?? '-')),
                          DataCell(Text(vm.telefono ?? '-')),
                          DataCell(Text('${vm.totalGallos}')),
                          DataCell(Text('${vm.puntosTotales}')),
                          DataCell(
                            vm.compadres.isEmpty
                                ? const Text(
                                    '-',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                : Tooltip(
                                    message: vm.compadres
                                        .map(
                                          (id) =>
                                              participantesVM
                                                  .where((p) => p.id == id)
                                                  .map((p) => p.nombre)
                                                  .firstOrNull ??
                                              id,
                                        )
                                        .join(', '),
                                    child: Chip(
                                      label: Text('${vm.compadres.length}'),
                                      avatar: const Icon(
                                        Icons.handshake,
                                        size: 14,
                                      ),
                                      visualDensity: VisualDensity.compact,
                                      backgroundColor: Colors.orange.withAlpha(
                                        40,
                                      ),
                                    ),
                                  ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.handshake, size: 20),
                                  tooltip: 'Gestionar compadres',
                                  color: vm.compadres.isEmpty
                                      ? null
                                      : Colors.orange,
                                  onPressed: () => _gestionarCompadres(
                                    context,
                                    state,
                                    vm.participante,
                                    participantesVM,
                                  ),
                                ),
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
                    // Preservar compadres existentes al editar nombre/equipo/teléfono
                    compadres: List<String>.from(participante.compadres),
                  ),
                );
              } else {
                if (!state.puedeAgregarParticipante) {
                  Navigator.pop(dialogContext);
                  _mostrarMensajeLicencia(context, state.maxParticipantesDemo);
                  return;
                }

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

  void _mostrarMensajeLicencia(BuildContext context, int maxParticipantesDemo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Modo demo: máximo $maxParticipantesDemo participantes. Activa licencia Pro.',
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _gestionarCompadres(
    BuildContext context,
    DerbyState state,
    Participante participante,
    List<ParticipanteVM> todos,
  ) {
    // Lista mutable de IDs seleccionados (copia de los actuales)
    final seleccionados = Set<String>.from(participante.compadres);

    // Candidatos: todos excepto el propio participante
    final candidatos = todos.where((vm) => vm.id != participante.id).toList();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.handshake, color: Colors.orange),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Compadres de ${participante.nombre}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withAlpha(80)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Los compadres no podrán enfrentarse en ninguna ronda del derby. '
                          'La relación se asigna automáticamente en ambas direcciones.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (candidatos.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No hay otros participantes registrados.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 320),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: candidatos.map((vm) {
                          final isSelected = seleccionados.contains(vm.id);
                          return CheckboxListTile(
                            value: isSelected,
                            title: Text(vm.nombre),
                            subtitle: vm.equipo != null && vm.equipo!.isNotEmpty
                                ? Text(
                                    vm.equipo!,
                                    style: const TextStyle(fontSize: 12),
                                  )
                                : null,
                            secondary: CircleAvatar(
                              radius: 16,
                              backgroundColor: isSelected
                                  ? Colors.orange.withAlpha(80)
                                  : Colors.grey.withAlpha(50),
                              child: Text(
                                vm.nombre.substring(0, 1).toUpperCase(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            activeColor: Colors.orange,
                            dense: true,
                            onChanged: (val) {
                              setDialogState(() {
                                if (val == true) {
                                  seleccionados.add(vm.id);
                                } else {
                                  seleccionados.remove(vm.id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  '${seleccionados.length} compadre(s) seleccionado(s)',
                  style: TextStyle(
                    fontSize: 12,
                    color: seleccionados.isEmpty
                        ? Colors.grey
                        : Colors.orange.shade700,
                    fontWeight: FontWeight.w500,
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
            ElevatedButton.icon(
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Guardar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await state.actualizarCompadres(
                  participante.id,
                  seleccionados.toList(),
                );
                if (context.mounted) {
                  final n = seleccionados.length;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        n == 0
                            ? 'Compadres eliminados de ${participante.nombre}'
                            : '$n compadre(s) asignado(s) a ${participante.nombre}',
                      ),
                      backgroundColor: n == 0 ? Colors.grey : Colors.orange,
                    ),
                  );
                }
              },
            ),
          ],
        ),
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

  Future<void> _exportarParticipantes(
    BuildContext context,
    DerbyState state,
  ) async {
    try {
      final path = await state.exportarParticipantesCsv();
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('CSV exportado: $path')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al exportar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
