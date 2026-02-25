import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/derby_state.dart';
import '../services/history_service.dart';

/// Pantalla que muestra el historial completo de modificaciones del torneo.
class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Modificaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Información',
            onPressed: () => _mostrarInfo(context),
          ),
        ],
      ),
      body: Consumer<DerbyState>(
        builder: (context, state, child) {
          final eventos = state.historialEventos;

          if (eventos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Sin cambios registrados',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Las modificaciones del torneo aparecerán aquí',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Agrupar por fecha
          final eventosPorFecha = _agruparPorFecha(eventos);

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: eventosPorFecha.length,
            itemBuilder: (context, index) {
              final fecha = eventosPorFecha.keys.elementAt(index);
              final eventosDelDia = eventosPorFecha[fecha]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado de fecha
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _formatearFecha(fecha),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${eventosDelDia.length} cambios',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Eventos del día
                  Card(
                    child: Column(
                      children: eventosDelDia.map((evento) {
                        return ListTile(
                          leading: _iconoPorTipo(evento.tipo),
                          title: Text(evento.descripcion),
                          subtitle: Text(
                            _formatearHora(evento.timestamp),
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: _chipTipo(evento.tipo),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Map<DateTime, List<HistorialEvento>> _agruparPorFecha(
    List<HistorialEvento> eventos,
  ) {
    final mapa = <DateTime, List<HistorialEvento>>{};

    for (final evento in eventos) {
      final fechaSolo = DateTime(
        evento.timestamp.year,
        evento.timestamp.month,
        evento.timestamp.day,
      );
      mapa.putIfAbsent(fechaSolo, () => []);
      mapa[fechaSolo]!.add(evento);
    }

    return mapa;
  }

  String _formatearFecha(DateTime fecha) {
    final hoy = DateTime.now();
    final ayer = hoy.subtract(const Duration(days: 1));

    if (fecha.year == hoy.year &&
        fecha.month == hoy.month &&
        fecha.day == hoy.day) {
      return 'Hoy';
    }

    if (fecha.year == ayer.year &&
        fecha.month == ayer.month &&
        fecha.day == ayer.day) {
      return 'Ayer';
    }

    final meses = [
      '',
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return '${fecha.day} ${meses[fecha.month]} ${fecha.year}';
  }

  String _formatearHora(DateTime timestamp) {
    final hora = timestamp.hour.toString().padLeft(2, '0');
    final minuto = timestamp.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  Widget _iconoPorTipo(String tipo) {
    IconData icono;
    Color color;

    switch (tipo.toLowerCase()) {
      case 'participante':
        icono = Icons.person;
        color = Colors.blue;
        break;
      case 'gallo':
        icono = Icons.pets;
        color = Colors.orange;
        break;
      case 'sorteo':
        icono = Icons.shuffle;
        color = Colors.purple;
        break;
      case 'pelea':
        icono = Icons.sports_mma;
        color = Colors.red;
        break;
      case 'ronda':
        icono = Icons.layers;
        color = Colors.teal;
        break;
      case 'configuracion':
        icono = Icons.settings;
        color = Colors.grey;
        break;
      case 'licencia':
        icono = Icons.verified;
        color = Colors.green;
        break;
      case 'backup':
        icono = Icons.backup;
        color = Colors.indigo;
        break;
      default:
        icono = Icons.history;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withAlpha(30),
      child: Icon(icono, color: color, size: 20),
    );
  }

  Widget _chipTipo(String tipo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _colorPorTipo(tipo).withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tipo.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: _colorPorTipo(tipo),
        ),
      ),
    );
  }

  Color _colorPorTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'participante':
        return Colors.blue;
      case 'gallo':
        return Colors.orange;
      case 'sorteo':
        return Colors.purple;
      case 'pelea':
        return Colors.red;
      case 'ronda':
        return Colors.teal;
      case 'configuracion':
        return Colors.grey;
      case 'licencia':
        return Colors.green;
      case 'backup':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  void _mostrarInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline),
            SizedBox(width: 8),
            Text('Historial'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'El historial registra todas las modificaciones realizadas en el torneo:',
            ),
            SizedBox(height: 12),
            Text('• Agregado/actualización de participantes'),
            Text('• Agregado/retiro de gallos'),
            Text('• Generación y aprobación de sorteos'),
            Text('• Registro de resultados de peleas'),
            Text('• Bloqueo/desbloqueo de rondas'),
            Text('• Cambios de configuración'),
            Text('• Activaciones de licencia'),
            Text('• Exportaciones de backup'),
            SizedBox(height: 12),
            Text(
              'Se conservan los últimos 500 eventos.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
