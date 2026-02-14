import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/viewmodels.dart';
import '../services/pdf_service.dart';

/// Vista tipo hoja física tradicional de derby.
///
/// Muestra las peleas en formato Rojo vs Verde,
/// simulando la hoja de papel usada en derbys reales.
class HojaFisicaScreen extends StatelessWidget {
  final int? rondaIndex;

  const HojaFisicaScreen({super.key, this.rondaIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<DerbyState>(
      builder: (context, state, _) {
        if (!state.sorteoRealizado) {
          return _buildSinDatos(context);
        }

        final indice = rondaIndex ?? state.rondaSeleccionada;
        final rondaVM = state.rondasVM.length > indice
            ? state.rondasVM[indice]
            : null;

        if (rondaVM == null) {
          return _buildSinDatos(context);
        }

        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Text('Hoja Ronda ${rondaVM.numero}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.print),
                tooltip: 'Exportar/Imprimir',
                onPressed: () => _mostrarOpcionesExportar(context, state, rondaVM),
              ),
              PopupMenuButton<int>(
                icon: const Icon(Icons.layers),
                tooltip: 'Seleccionar ronda',
                onSelected: (i) => _navegarRonda(context, i),
                itemBuilder: (_) => List.generate(
                  state.totalRondas,
                  (i) => PopupMenuItem(value: i, child: Text('Ronda ${i + 1}')),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(child: _buildHoja(context, state, rondaVM)),
          ),
        );
      },
    );
  }

  Widget _buildSinDatos(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hoja Física')),
      body: const Center(child: Text('No hay rondas generadas')),
    );
  }

  Widget _buildHoja(BuildContext context, DerbyState state, RondaVM rondaVM) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Encabezado
          _buildEncabezado(context, state, rondaVM),
          // Tabla de peleas
          _buildTablaPeleas(context, rondaVM),
          // Gallos sin cotejo
          if (rondaVM.sinCotejoVM.isNotEmpty) _buildSinCotejo(context, rondaVM),
          // Pie
          _buildPie(context, rondaVM),
        ],
      ),
    );
  }

  Widget _buildEncabezado(
    BuildContext context,
    DerbyState state,
    RondaVM rondaVM,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400, width: 2),
        ),
      ),
      child: Column(
        children: [
          // Título principal
          Text(
            state.derbyNombre.toUpperCase(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          // Información de ronda
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Text(
              'RONDA ${rondaVM.numero}',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          // Fecha y estadísticas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoChip(
                Icons.calendar_today,
                _formatearFecha(rondaVM.fechaGeneracion),
              ),
              _buildInfoChip(Icons.sports_mma, '${rondaVM.totalPeleas} Peleas'),
              _buildInfoChip(
                Icons.check_circle_outline,
                '${rondaVM.peleasFinalizadas} Finalizadas',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildTablaPeleas(BuildContext context, RondaVM rondaVM) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade400),
        columnWidths: const {
          0: FixedColumnWidth(50), // #
          1: FlexColumnWidth(2), // Participante Rojo
          2: FlexColumnWidth(1), // Anillo Rojo
          3: FixedColumnWidth(80), // Peso Rojo
          4: FixedColumnWidth(40), // VS
          5: FixedColumnWidth(80), // Peso Verde
          6: FlexColumnWidth(1), // Anillo Verde
          7: FlexColumnWidth(2), // Participante Verde
          8: FixedColumnWidth(80), // Resultado
        },
        children: [
          // Header
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade200),
            children: [
              _buildHeaderCell('#'),
              _buildHeaderCell('ROJO', color: Colors.red.shade700),
              _buildHeaderCell('Anillo'),
              _buildHeaderCell('Peso'),
              _buildHeaderCell(''),
              _buildHeaderCell('Peso'),
              _buildHeaderCell('Anillo'),
              _buildHeaderCell('VERDE', color: Colors.green.shade700),
              _buildHeaderCell('Resultado'),
            ],
          ),
          // Filas de peleas
          ...rondaVM.peleasVM.map((pelea) => _buildFilaPelea(context, pelea)),
        ],
      ),
    );
  }

  TableRow _buildFilaPelea(BuildContext context, PeleaVM pelea) {
    final esGanadorRojo = pelea.tieneResultado && pelea.ganoRojo;
    final esGanadorVerde = pelea.tieneResultado && pelea.ganoVerde;
    final esEmpate = pelea.tieneResultado && pelea.empate;

    return TableRow(
      decoration: pelea.completada
          ? BoxDecoration(color: Colors.grey.shade100)
          : null,
      children: [
        // Número
        _buildCell('${pelea.numero}', fontWeight: FontWeight.bold),
        // Participante Rojo
        _buildCell(
          pelea.nombreParticipanteRojo,
          color: Colors.red.shade700,
          fontWeight: esGanadorRojo ? FontWeight.bold : null,
          backgroundColor: esGanadorRojo ? Colors.red.shade50 : null,
        ),
        // Anillo Rojo
        _buildCell(pelea.anilloRojo, fontWeight: FontWeight.w500),
        // Peso Rojo
        _buildCell(pelea.pesoRojoFormateado, fontFamily: 'monospace'),
        // VS
        Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'VS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
        // Peso Verde
        _buildCell(pelea.pesoVerdeFormateado, fontFamily: 'monospace'),
        // Anillo Verde
        _buildCell(pelea.anilloVerde, fontWeight: FontWeight.w500),
        // Participante Verde
        _buildCell(
          pelea.nombreParticipanteVerde,
          color: Colors.green.shade700,
          fontWeight: esGanadorVerde ? FontWeight.bold : null,
          backgroundColor: esGanadorVerde ? Colors.green.shade50 : null,
        ),
        // Resultado
        _buildResultadoCell(pelea, esGanadorRojo, esGanadorVerde, esEmpate),
      ],
    );
  }

  Widget _buildHeaderCell(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCell(
    String text, {
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    Color? backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      color: backgroundColor,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildResultadoCell(
    PeleaVM pelea,
    bool ganoRojo,
    bool ganoVerde,
    bool empate,
  ) {
    if (!pelea.tieneResultado) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Pendiente',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
      );
    }

    Color bgColor;
    Color textColor;
    String texto;
    IconData icon;

    if (empate) {
      bgColor = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
      texto = 'EMPATE';
      icon = Icons.handshake;
    } else if (ganoRojo) {
      bgColor = Colors.red.shade100;
      textColor = Colors.red.shade800;
      texto = 'ROJO';
      icon = Icons.emoji_events;
    } else {
      bgColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
      texto = 'VERDE';
      icon = Icons.emoji_events;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 2),
            Text(
              texto,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSinCotejo(BuildContext context, RondaVM rondaVM) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.shade300),
        borderRadius: BorderRadius.circular(4),
        color: Colors.orange.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.orange.shade700,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Gallos sin cotejo (${rondaVM.sinCotejoVM.length})',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: rondaVM.sinCotejoVM.map((gallo) {
              return Chip(
                avatar: const Icon(Icons.warning, size: 14),
                label: Text(
                  '${gallo.anillo} (${gallo.pesoFormateado})',
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.orange.shade300),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPie(BuildContext context, RondaVM rondaVM) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Firma juez
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Firma del Juez:',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Container(width: 150, height: 1, color: Colors.black),
            ],
          ),
          // Estado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _colorEstado(rondaVM),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              rondaVM.estadoLabel.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Firma participante
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Firma Validador:',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Container(width: 150, height: 1, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  Color _colorEstado(RondaVM ronda) {
    switch (ronda.estado.name) {
      case 'finalizada':
        return Colors.green;
      case 'enProgreso':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return '-';
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  void _navegarRonda(BuildContext context, int indice) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HojaFisicaScreen(rondaIndex: indice)),
    );
  }

  void _mostrarOpcionesExportar(
    BuildContext context,
    DerbyState state,
    RondaVM rondaVM,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Exportar Hoja Ronda ${rondaVM.numero}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.check_box_outline_blank, color: Colors.blue),
              title: const Text('Hoja Vacía'),
              subtitle: const Text('Sin resultados - para anotar a mano'),
              onTap: () {
                Navigator.pop(ctx);
                _exportarHoja(context, state, rondaVM, mostrarResultados: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_box, color: Colors.green),
              title: const Text('Hoja con Resultados'),
              subtitle: const Text('Con ganadores registrados'),
              onTap: () {
                Navigator.pop(ctx);
                _exportarHoja(context, state, rondaVM, mostrarResultados: true);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _exportarHoja(
    BuildContext context,
    DerbyState state,
    RondaVM rondaVM, {
    required bool mostrarResultados,
  }) async {
    try {
      await PdfService.exportarHojaFisica(
        state,
        rondaIndex: rondaVM.numero - 1,
        mostrarResultados: mostrarResultados,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              mostrarResultados
                  ? '✅ Hoja con resultados exportada'
                  : '✅ Hoja vacía exportada',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
