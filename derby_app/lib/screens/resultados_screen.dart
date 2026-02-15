import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/viewmodels.dart';
import '../services/pdf_service.dart';

/// Pantalla de resultados - tablero de posiciones y estadísticas.
class ResultadosScreen extends StatefulWidget {
  const ResultadosScreen({super.key});

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DerbyState>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Resultados'),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'pdf',
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf),
                        SizedBox(width: 8),
                        Text('Exportar PDF'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'excel',
                    child: Row(
                      children: [
                        Icon(Icons.table_chart),
                        SizedBox(width: 8),
                        Text('Exportar Excel'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'print',
                    child: Row(
                      children: [
                        Icon(Icons.print),
                        SizedBox(width: 8),
                        Text('Imprimir'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) async {
                  switch (value) {
                    case 'pdf':
                      if (!state.permitePdf) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Exportar PDF requiere licencia Pro activa.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        break;
                      }

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
                      break;
                    case 'excel':
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Excel no implementado aún'),
                        ),
                      );
                      break;
                    case 'print':
                      if (!state.permitePdf) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Imprimir requiere licencia Pro activa.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        break;
                      }

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
                      break;
                  }
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.leaderboard), text: 'Posiciones'),
                Tab(icon: Icon(Icons.pets), text: 'Gallos'),
                Tab(icon: Icon(Icons.analytics), text: 'Estadísticas'),
              ],
            ),
          ),
          body: !state.sorteoRealizado
              ? _buildSinDatos(context)
              : _buildContenido(context, state),
        );
      },
    );
  }

  Widget _buildSinDatos(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay resultados disponibles',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Los resultados aparecerán cuando se registren peleas',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildContenido(BuildContext context, DerbyState state) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildTabPosiciones(context, state),
        _buildTabGallos(context, state),
        _buildTabEstadisticas(context, state),
      ],
    );
  }

  Widget _buildTabPosiciones(BuildContext context, DerbyState state) {
    // participantesVM already sorted by points
    final tablaPosiciones = state.participantesVM;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Podio (top 3)
          if (tablaPosiciones.length >= 3)
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 2do lugar
                  _buildPodioItem(
                    tablaPosiciones[1],
                    2,
                    Colors.grey.shade400,
                    120,
                  ),
                  const SizedBox(width: 8),
                  // 1er lugar
                  _buildPodioItem(tablaPosiciones[0], 1, Colors.amber, 160),
                  const SizedBox(width: 8),
                  // 3er lugar
                  _buildPodioItem(
                    tablaPosiciones[2],
                    3,
                    Colors.brown.shade300,
                    100,
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Tabla completa
          Expanded(
            child: Card(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Pos')),
                      DataColumn(label: Text('Participante')),
                      DataColumn(label: Text('Equipo')),
                      DataColumn(label: Text('Gallos')),
                      DataColumn(label: Text('Victorias')),
                      DataColumn(label: Text('Derrotas')),
                      DataColumn(label: Text('Puntos')),
                    ],
                    rows: tablaPosiciones.asMap().entries.map((entry) {
                      final index = entry.key;
                      final vm = entry.value;
                      return DataRow(
                        color: WidgetStateProperty.resolveWith((states) {
                          if (index == 0) return Colors.amber.withOpacity(0.1);
                          if (index == 1) return Colors.grey.withOpacity(0.1);
                          if (index == 2) return Colors.brown.withOpacity(0.1);
                          return null;
                        }),
                        cells: [
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (index < 3)
                                  Icon(
                                    Icons.emoji_events,
                                    size: 18,
                                    color: index == 0
                                        ? Colors.amber
                                        : index == 1
                                        ? Colors.grey
                                        : Colors.brown,
                                  )
                                else
                                  const SizedBox(width: 18),
                                const SizedBox(width: 4),
                                Text('${index + 1}'),
                              ],
                            ),
                          ),
                          DataCell(Text(vm.nombre)),
                          DataCell(Text(vm.equipo ?? '-')),
                          DataCell(Text('${vm.totalGallos}')),
                          DataCell(
                            Text(
                              '${vm.victorias}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${vm.derrotas}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${vm.puntosTotales}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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

  Widget _buildPodioItem(
    ParticipanteVM vm,
    int posicion,
    Color color,
    double altura,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: posicion == 1 ? 30 : 24,
          backgroundColor: color,
          child: Text(
            vm.nombre.isNotEmpty
                ? vm.nombre.substring(0, 1).toUpperCase()
                : '?',
            style: TextStyle(
              fontSize: posicion == 1 ? 24 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          vm.nombre,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: posicion == 1 ? 14 : 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${vm.puntosTotales} pts',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Container(
          width: 80,
          height: altura,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              '$posicion°',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabGallos(BuildContext context, DerbyState state) {
    final tablaGallos = state.gallosVM;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('#')),
                DataColumn(label: Text('Anillo')),
                DataColumn(label: Text('Peso')),
                DataColumn(label: Text('Participante')),
                DataColumn(label: Text('Peleas')),
                DataColumn(label: Text('V')),
                DataColumn(label: Text('D')),
                DataColumn(label: Text('%')),
              ],
              rows: tablaGallos.asMap().entries.map((entry) {
                final index = entry.key;
                final vm = entry.value;
                final porcentaje = vm.totalPeleas > 0
                    ? (vm.victorias / vm.totalPeleas * 100).toInt()
                    : 0;

                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(Text(vm.anillo)),
                    DataCell(Text(vm.pesoFormateado)),
                    DataCell(Text(vm.nombreParticipante)),
                    DataCell(Text('${vm.totalPeleas}')),
                    DataCell(
                      Text(
                        '${vm.victorias}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${vm.derrotas}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: porcentaje >= 50
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$porcentaje%',
                          style: TextStyle(
                            color: porcentaje >= 50 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabEstadisticas(BuildContext context, DerbyState state) {
    final rondasCompletadas = state.rondasVM
        .where((r) => r.todasFinalizadas)
        .length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Resumen general
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Participantes',
                  '${state.totalParticipantes}',
                  Icons.people,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Gallos',
                  '${state.totalGallos}',
                  Icons.pets,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Rondas',
                  '$rondasCompletadas/${state.totalRondas}',
                  Icons.repeat,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Peleas',
                  '${state.peleasCompletadas}/${state.totalPeleas}',
                  Icons.sports_kabaddi,
                  Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Progreso del torneo
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progreso del Torneo',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Completado: '),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: state.totalPeleas > 0
                              ? state.peleasCompletadas / state.totalPeleas
                              : 0,
                          minHeight: 20,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${state.porcentajeProgreso}%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Estadísticas adicionales
          Expanded(
            child: Row(
              children: [
                // Por ronda
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Peleas por Ronda',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.rondasVM.length,
                              itemBuilder: (context, index) {
                                final rondaVM = state.rondasVM[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    radius: 16,
                                    child: Text('${index + 1}'),
                                  ),
                                  title: Text('Ronda ${index + 1}'),
                                  trailing: Text(
                                    '${rondaVM.peleasFinalizadas}/${rondaVM.totalPeleas}',
                                    style: TextStyle(
                                      color: rondaVM.todasFinalizadas
                                          ? Colors.green
                                          : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Distribución de pesos
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Distribución de Pesos',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          if (state.gallosVM.isNotEmpty) ...[
                            _buildPesoRow(
                              'Mínimo',
                              '${state.gallosVM.map((g) => g.peso).reduce((a, b) => a < b ? a : b).toStringAsFixed(0)}g',
                            ),
                            _buildPesoRow(
                              'Máximo',
                              '${state.gallosVM.map((g) => g.peso).reduce((a, b) => a > b ? a : b).toStringAsFixed(0)}g',
                            ),
                            _buildPesoRow(
                              'Promedio',
                              '${(state.gallosVM.map((g) => g.peso).reduce((a, b) => a + b) / state.gallosVM.length).toStringAsFixed(0)}g',
                            ),
                          ] else
                            const Text('Sin datos'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(label, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildPesoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
