import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../data/seed_data.dart';
import '../services/pdf_service.dart';
import '../viewmodels/viewmodels.dart';

/// Pantalla principal del Dashboard.
/// Muestra resumen del derbi activo.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DerbyState>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Nuevo Derbi',
                onPressed: () => _mostrarDialogoNuevoDerbi(context, state),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mensaje de bienvenida
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          size: 64,
                          color: DerbyTheme.primaryColor,
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.derbyNombre,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Derby Manager - Sistema de Gestión',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () =>
                              _mostrarDialogoNuevoDerbi(context, state),
                          icon: const Icon(Icons.add),
                          label: const Text('Nuevo Derbi'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Estadísticas rápidas
                Text('Resumen', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.people,
                        label: 'Participantes',
                        value: '${state.totalParticipantes}',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.pets,
                        label: 'Gallos',
                        value: '${state.totalGallos}',
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.format_list_numbered,
                        label: 'Rondas',
                        value: '${state.totalRondas}',
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.sports_mma,
                        label: 'Peleas',
                        value:
                            '${state.peleasCompletadas}/${state.totalPeleas}',
                        color: DerbyTheme.primaryColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Progreso del torneo (si hay sorteo)
                if (state.sorteoRealizado) ...[
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
                                      ? state.peleasCompletadas /
                                            state.totalPeleas
                                      : 0,
                                  minHeight: 20,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${state.porcentajeProgreso}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Acciones rápidas
                Text(
                  'Acciones Rápidas',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _ActionButton(
                      icon: Icons.person_add,
                      label: 'Agregar Participante',
                      onPressed: () {
                        // Navigate to participantes would be handled by shell
                      },
                    ),
                    _ActionButton(
                      icon: Icons.pets,
                      label: 'Registrar Gallo',
                      onPressed: () {
                        // Navigate to gallos would be handled by shell
                      },
                    ),
                    _ActionButton(
                      icon: Icons.shuffle,
                      label: 'Generar Sorteo',
                      onPressed: state.totalGallos >= 2
                          ? () async {
                              await state.ejecutarSorteo();
                              if (context.mounted && state.error == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Sorteo generado exitosamente',
                                    ),
                                  ),
                                );
                              }
                            }
                          : null,
                    ),
                    _ActionButton(
                      icon: Icons.picture_as_pdf,
                      label: 'Exportar PDF',
                      onPressed: state.sorteoRealizado
                          ? () {
                              if (!state.permitePdf) {
                                _mostrarMensajePdfBloqueado(context);
                                return;
                              }
                              _mostrarOpcionesPdf(context, state);
                            }
                          : null,
                    ),
                    _ActionButton(
                      icon: Icons.science,
                      label: 'Datos de Prueba',
                      onPressed: () => _cargarDatosPrueba(context, state),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarDialogoNuevoDerbi(BuildContext context, DerbyState state) {
    final nombreController = TextEditingController();
    final lugarController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nuevo Derbi'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del evento',
                  hintText: 'Ej: Derbi de Primavera 2026',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: lugarController,
                decoration: const InputDecoration(
                  labelText: 'Lugar (opcional)',
                  hintText: 'Ej: Palenque Central',
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
              final nombre = nombreController.text.trim();
              final lugar = lugarController.text.trim();
              final nombreCompleto = lugar.isNotEmpty 
                  ? '$nombre - $lugar' 
                  : (nombre.isNotEmpty ? nombre : 'Derby Actual');
              state.resetear(nombre: nombreCompleto);
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Derbi "$nombreCompleto" creado')));
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  Future<void> _cargarDatosPrueba(BuildContext context, DerbyState state) async {
    final hayDatos = state.totalParticipantes > 0;
    
    // Mostrar diálogo de confirmación
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cargar Datos de Prueba'),
        content: Text(
          hayDatos
              ? '⚠️ Ya existen ${state.totalParticipantes} participantes y ${state.totalGallos} gallos.\n\n'
                'Se eliminarán los datos actuales y se crearán 8 participantes con 32 gallos nuevos.'
              : 'Se crearán 8 participantes con 4 gallos cada uno (32 gallos en total).\n\n'
                'Esto es útil para probar el sistema de sorteo y peleas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: Icon(hayDatos ? Icons.delete_forever : Icons.science),
            style: hayDatos 
                ? ElevatedButton.styleFrom(backgroundColor: Colors.orange)
                : null,
            label: Text(hayDatos ? 'Resetear y Cargar' : 'Cargar Datos'),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) return;

    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(hayDatos ? 'Limpiando y creando datos...' : 'Creando datos de prueba...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      if (hayDatos) {
        await SeedData.resetearYPoblar(state);
      } else {
        await SeedData.poblarDeterministico(state);
      }
      
      if (context.mounted) {
        Navigator.pop(context); // Cerrar loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ 8 participantes y 32 gallos creados'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Cerrar loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _mostrarOpcionesPdf(BuildContext context, DerbyState state) {
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
                await _exportarPdf(context, state, 'completo');
              },
            ),
            ListTile(
              leading: const Icon(Icons.leaderboard),
              title: const Text('Tabla de Posiciones'),
              subtitle: const Text('Ranking de participantes'),
              onTap: () async {
                Navigator.pop(ctx);
                await _exportarPdf(context, state, 'posiciones');
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_view),
              title: const Text('Brackets de Peleas'),
              subtitle: const Text('Todas las rondas con peleas'),
              onTap: () async {
                Navigator.pop(ctx);
                await _exportarPdf(context, state, 'brackets');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _exportarPdf(
    BuildContext context,
    DerbyState state,
    String tipo,
  ) async {
    if (!state.permitePdf) {
      _mostrarMensajePdfBloqueado(context);
      return;
    }

    try {
      switch (tipo) {
        case 'completo':
          await PdfService.exportarDerbyCompleto(state);
          break;
        case 'posiciones':
          await PdfService.exportarPosiciones(state);
          break;
        case 'brackets':
          await PdfService.exportarBrackets(state);
          break;
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ PDF guardado y abierto'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al exportar PDF: $e'),
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
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}
