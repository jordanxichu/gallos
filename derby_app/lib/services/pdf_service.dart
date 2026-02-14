import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../viewmodels/viewmodels.dart';

/// Servicio para generar y exportar PDFs del derby.
class PdfService {
  /// Genera PDF con las peleas de las rondas.
  /// Si se especifica [rondaIndex], solo exporta esa ronda.
  /// Retorna la ruta del archivo guardado.
  static Future<String> exportarBrackets(
    DerbyState state, {
    String? titulo,
    int? rondaIndex,
  }) async {
    final pdf = pw.Document();
    final nombreDerby = titulo ?? state.derbyNombre;

    final rondas = rondaIndex != null
        ? [state.rondasVM[rondaIndex]]
        : state.rondasVM;

    for (final rondaVM in rondas) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.letter,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => _buildPaginaRonda(rondaVM, nombreDerby),
        ),
      );
    }

    return await _guardarPdf(pdf, 'brackets_derby.pdf');
  }

  /// Genera PDF con la tabla de posiciones.
  /// Retorna la ruta del archivo guardado.
  static Future<String> exportarPosiciones(
    DerbyState state, {
    String titulo = 'Tabla de Posiciones',
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => _buildPaginaPosiciones(state, titulo),
      ),
    );

    return await _guardarPdf(pdf, 'posiciones_derby.pdf');
  }

  /// Genera PDF completo con todo el derby.
  /// Retorna la ruta del archivo guardado.
  static Future<String> exportarDerbyCompleto(
    DerbyState state, {
    String? titulo,
  }) async {
    final pdf = pw.Document();
    final nombreDerby = titulo ?? state.derbyNombre;

    // Página de portada / resumen
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => _buildPaginaResumen(state, nombreDerby),
      ),
    );

    // Tabla de posiciones
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(32),
        build: (context) =>
            _buildPaginaPosiciones(state, 'Tabla de Posiciones'),
      ),
    );

    // Cada ronda
    for (final rondaVM in state.rondasVM) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.letter,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => _buildPaginaRonda(rondaVM, nombreDerby),
        ),
      );
    }

    return await _guardarPdf(pdf, 'derby_completo.pdf');
  }

  /// Exporta la hoja física de una ronda - formato tradicional de derby.
  /// Si [mostrarResultados] es false, exporta la hoja vacía para anotar a mano.
  static Future<String> exportarHojaFisica(
    DerbyState state, {
    required int rondaIndex,
    bool mostrarResultados = true,
  }) async {
    final pdf = pw.Document();
    final rondaVM = state.rondasVM[rondaIndex];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => _buildHojaFisica(
          rondaVM,
          mostrarResultados,
          state.derbyNombre,
        ),
      ),
    );

    final suffix = mostrarResultados ? 'resultados' : 'vacia';
    return await _guardarPdf(pdf, 'hoja_ronda_${rondaVM.numero}_$suffix.pdf');
  }

  /// Construye la hoja física exactamente como se ve en pantalla.
  static pw.Widget _buildHojaFisica(
    RondaVM rondaVM,
    bool mostrarResultados,
    String titulo,
  ) {
    return pw.Column(
      children: [
        // Encabezado
        pw.Center(
          child: pw.Text(
            titulo.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 2),
          ),
          child: pw.Text(
            'RONDA ${rondaVM.numero}',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            pw.Text(
              '${rondaVM.fechaGeneracion?.day ?? '-'}/${rondaVM.fechaGeneracion?.month ?? '-'}/${rondaVM.fechaGeneracion?.year ?? '-'}',
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.Text('${rondaVM.totalPeleas} Peleas', style: const pw.TextStyle(fontSize: 10)),
            pw.Text(
              mostrarResultados
                  ? '${rondaVM.peleasFinalizadas} Finalizadas'
                  : 'Para anotar resultados',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
        pw.SizedBox(height: 12),

        // Tabla de peleas
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: {
            0: const pw.FixedColumnWidth(25), // #
            1: const pw.FlexColumnWidth(2), // Participante Rojo
            2: const pw.FlexColumnWidth(1), // Anillo Rojo
            3: const pw.FixedColumnWidth(45), // Peso Rojo
            4: const pw.FixedColumnWidth(25), // VS
            5: const pw.FixedColumnWidth(45), // Peso Verde
            6: const pw.FlexColumnWidth(1), // Anillo Verde
            7: const pw.FlexColumnWidth(2), // Participante Verde
            8: const pw.FixedColumnWidth(55), // Resultado
          },
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildPdfHeaderCell('#'),
                _buildPdfHeaderCell('ROJO', color: PdfColors.red700),
                _buildPdfHeaderCell('Anillo'),
                _buildPdfHeaderCell('Peso'),
                _buildPdfHeaderCell(''),
                _buildPdfHeaderCell('Peso'),
                _buildPdfHeaderCell('Anillo'),
                _buildPdfHeaderCell('VERDE', color: PdfColors.green700),
                _buildPdfHeaderCell('Resultado/Tiempo'),
              ],
            ),
            // Filas de peleas
            ...rondaVM.peleasVM.map(
              (pelea) => _buildPdfFilaPelea(pelea, mostrarResultados),
            ),
          ],
        ),

        pw.SizedBox(height: 16),

        // Gallos sin cotejo
        if (rondaVM.sinCotejoVM.isNotEmpty) ...[
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.orange300),
              color: PdfColors.orange50,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Gallos sin cotejo (${rondaVM.sinCotejoVM.length})',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  rondaVM.sinCotejoVM.map((g) => '${g.anillo} (${g.pesoFormateado})').join(', '),
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
        ],

        // Pie de página con firmas
        pw.Spacer(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Firma del Juez:', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
                pw.SizedBox(height: 4),
                pw.Container(width: 120, height: 1, color: PdfColors.black),
              ],
            ),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: pw.BoxDecoration(
                color: mostrarResultados
                    ? (rondaVM.todasFinalizadas ? PdfColors.green : PdfColors.blue)
                    : PdfColors.grey,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                mostrarResultados ? rondaVM.estadoLabel.toUpperCase() : 'PENDIENTE',
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.white),
              ),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Firma Validador:', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
                pw.SizedBox(height: 4),
                pw.Container(width: 120, height: 1, color: PdfColors.black),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildPdfHeaderCell(String text, {PdfColor? color}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 8,
          color: color ?? PdfColors.black,
        ),
      ),
    );
  }

  static pw.TableRow _buildPdfFilaPelea(PeleaVM pelea, bool mostrarResultados) {
    final ganoRojo = mostrarResultados && pelea.tieneResultado && pelea.ganoRojo;
    final ganoVerde = mostrarResultados && pelea.tieneResultado && pelea.ganoVerde;
    final esEmpate = mostrarResultados && pelea.tieneResultado && pelea.empate;

    return pw.TableRow(
      children: [
        _buildPdfCell('${pelea.numero}', bold: true),
        _buildPdfCell(
          pelea.nombreParticipanteRojo,
          color: PdfColors.red700,
          bold: ganoRojo,
          bgColor: ganoRojo ? PdfColors.red50 : null,
        ),
        _buildPdfCell(pelea.anilloRojo),
        _buildPdfCell(pelea.pesoRojoFormateado, mono: true),
        pw.Container(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Center(
            child: pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey800,
                borderRadius: pw.BorderRadius.circular(2),
              ),
              child: pw.Text(
                'VS',
                style: const pw.TextStyle(color: PdfColors.white, fontSize: 6),
              ),
            ),
          ),
        ),
        _buildPdfCell(pelea.pesoVerdeFormateado, mono: true),
        _buildPdfCell(pelea.anilloVerde),
        _buildPdfCell(
          pelea.nombreParticipanteVerde,
          color: PdfColors.green700,
          bold: ganoVerde,
          bgColor: ganoVerde ? PdfColors.green50 : null,
        ),
        _buildPdfResultadoCell(pelea, mostrarResultados, ganoRojo, ganoVerde, esEmpate),
      ],
    );
  }

  static pw.Widget _buildPdfCell(
    String text, {
    PdfColor? color,
    bool bold = false,
    bool mono = false,
    PdfColor? bgColor,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      color: bgColor,
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          color: color,
          fontWeight: bold ? pw.FontWeight.bold : null,
          fontSize: 8,
        ),
      ),
    );
  }

  static pw.Widget _buildPdfResultadoCell(
    PeleaVM pelea,
    bool mostrarResultados,
    bool ganoRojo,
    bool ganoVerde,
    bool esEmpate,
  ) {
    if (!mostrarResultados || !pelea.tieneResultado) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Container(
          height: 16,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
          ),
        ),
      );
    }

    PdfColor bgColor;
    PdfColor textColor;
    String texto;

    if (esEmpate) {
      bgColor = PdfColors.orange100;
      textColor = PdfColors.orange800;
      texto = 'EMPATE';
    } else if (ganoRojo) {
      bgColor = PdfColors.red100;
      textColor = PdfColors.red800;
      texto = 'ROJO';
    } else {
      bgColor = PdfColors.green100;
      textColor = PdfColors.green800;
      texto = 'VERDE';
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(3),
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            decoration: pw.BoxDecoration(
              color: bgColor,
              borderRadius: pw.BorderRadius.circular(3),
            ),
            child: pw.Text(
              texto,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 7,
                fontWeight: pw.FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          if (pelea.duracionSegundos != null)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Text(
                _formatearDuracionPelea(pelea.duracionSegundos!),
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey700),
              ),
            ),
        ],
      ),
    );
  }

  static String _formatearDuracionPelea(int segundos) {
    final mins = segundos ~/ 60;
    final secs = segundos % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// Guarda el PDF en Desktop y retorna la ruta.
  static Future<String> _guardarPdf(pw.Document pdf, String filename) async {
    final bytes = await pdf.save();
    
    // Obtener directorio de escritorio o documentos
    final dir = await getApplicationDocumentsDirectory();
    
    // Crear nombre único con timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uniqueFilename = '${filename.replaceAll('.pdf', '')}_$timestamp.pdf';
    final file = File('${dir.path}/$uniqueFilename');
    
    await file.writeAsBytes(bytes);
    
    // Intentar abrir el archivo con la app predeterminada del sistema
    // (si falla, igual retornamos la ruta para no romper la exportación)
    await _abrirArchivo(file.path);
    
    return file.path;
  }

  static Future<void> _abrirArchivo(String filePath) async {
    try {
      if (Platform.isMacOS) {
        await Process.run('open', [filePath]);
        return;
      }

      if (Platform.isWindows) {
        await Process.run(
          'cmd',
          ['/c', 'start', '', filePath],
          runInShell: true,
        );
        return;
      }

      if (Platform.isLinux) {
        await Process.run('xdg-open', [filePath]);
      }
    } catch (_) {
      // No bloquear la exportación si la apertura automática falla.
    }
  }

  // === BUILDERS PRIVADOS ===

  static pw.Widget _buildPaginaResumen(DerbyState state, String titulo) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Text(
            titulo,
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 32),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            _buildStatBox('Participantes', '${state.totalParticipantes}'),
            _buildStatBox('Gallos', '${state.totalGallos}'),
            _buildStatBox('Rondas', '${state.totalRondas}'),
            _buildStatBox('Peleas', '${state.totalPeleas}'),
          ],
        ),
        pw.SizedBox(height: 32),
        pw.Text(
          'Progreso: ${state.peleasCompletadas} / ${state.totalPeleas} peleas (${state.porcentajeProgreso}%)',
          style: const pw.TextStyle(fontSize: 14),
        ),
        pw.SizedBox(height: 16),
        pw.Text(
          'Fecha: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
          style: const pw.TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  static pw.Widget _buildStatBox(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(label, style: const pw.TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  static pw.Widget _buildPaginaPosiciones(DerbyState state, String titulo) {
    final participantes = state.participantesVM;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          titulo,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 16),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: {
            0: const pw.FixedColumnWidth(40),
            1: const pw.FlexColumnWidth(3),
            2: const pw.FlexColumnWidth(2),
            3: const pw.FixedColumnWidth(50),
            4: const pw.FixedColumnWidth(50),
            5: const pw.FixedColumnWidth(50),
            6: const pw.FixedColumnWidth(60),
          },
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                _cellHeader('Pos'),
                _cellHeader('Participante'),
                _cellHeader('Equipo'),
                _cellHeader('V'),
                _cellHeader('D'),
                _cellHeader('E'),
                _cellHeader('Puntos'),
              ],
            ),
            // Filas
            ...participantes.asMap().entries.map((entry) {
              final i = entry.key;
              final p = entry.value;
              final isPodio = i < 3;
              return pw.TableRow(
                decoration: isPodio
                    ? const pw.BoxDecoration(color: PdfColors.amber50)
                    : null,
                children: [
                  _cell('${i + 1}'),
                  _cell(p.nombre, align: pw.TextAlign.left),
                  _cell(p.equipo ?? '-', align: pw.TextAlign.left),
                  _cell('${p.victorias}'),
                  _cell('${p.derrotas}'),
                  _cell('${p.empates}'),
                  _cellBold('${p.puntosTotales}'),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildPaginaRonda(RondaVM rondaVM, String titulo) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Ronda ${rondaVM.numero}',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '${rondaVM.peleasFinalizadas}/${rondaVM.totalPeleas} peleas',
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: {
            0: const pw.FixedColumnWidth(40),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FixedColumnWidth(60),
            3: const pw.FixedColumnWidth(40),
            4: const pw.FlexColumnWidth(2),
            5: const pw.FixedColumnWidth(60),
            6: const pw.FlexColumnWidth(1.5),
          },
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                _cellHeader('#'),
                _cellHeader('Gallo Rojo'),
                _cellHeader('Peso'),
                _cellHeader('VS'),
                _cellHeader('Gallo Verde'),
                _cellHeader('Peso'),
                _cellHeader('Resultado'),
              ],
            ),
            // Peleas
            ...rondaVM.peleasVM.map((pelea) {
              return pw.TableRow(
                children: [
                  _cell('${pelea.numero}'),
                  _cell(pelea.anilloRojo, align: pw.TextAlign.left),
                  _cell(pelea.pesoRojoFormateado),
                  _cell('vs'),
                  _cell(pelea.anilloVerde, align: pw.TextAlign.left),
                  _cell(pelea.pesoVerdeFormateado),
                  _cell(
                    pelea.completada
                        ? (pelea.empate
                              ? 'Empate'
                              : (pelea.ganoRojo ? 'ROJO' : 'VERDE'))
                        : '-',
                  ),
                ],
              );
            }),
          ],
        ),
        if (rondaVM.sinCotejoVM.isNotEmpty) ...[
          pw.SizedBox(height: 16),
          pw.Text(
            'Sin cotejo: ${rondaVM.sinCotejoVM.map((g) => g.anillo).join(", ")}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ],
    );
  }

  static pw.Widget _cellHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _cell(
    String text, {
    pw.TextAlign align = pw.TextAlign.center,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 10),
        textAlign: align,
      ),
    );
  }

  static pw.Widget _cellBold(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
        textAlign: pw.TextAlign.center,
      ),
    );
  }
}
