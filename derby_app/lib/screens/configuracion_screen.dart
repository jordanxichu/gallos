import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:derby_engine/derby_engine.dart';
import '../viewmodels/viewmodels.dart';
import '../services/license_manager.dart';

/// Pantalla de configuración del derby.
class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  late TextEditingController _rondasController;
  late TextEditingController _toleranciaController;
  late TextEditingController _puntosVictoriaController;
  late TextEditingController _puntosDerrotaController;
  late TextEditingController _puntosEmpateController;
  late TextEditingController _codigoLicenciaController;

  @override
  void initState() {
    super.initState();
    final state = context.read<DerbyState>();
    final config = state.config;

    _rondasController = TextEditingController(text: '${config.numeroRondas}');
    _toleranciaController = TextEditingController(
      text: '${config.toleranciaPeso.toInt()}',
    );
    _puntosVictoriaController = TextEditingController(
      text: '${config.puntosVictoria}',
    );
    _puntosDerrotaController = TextEditingController(
      text: '${config.puntosDerrota}',
    );
    _puntosEmpateController = TextEditingController(
      text: '${config.puntosEmpate}',
    );
    _codigoLicenciaController = TextEditingController();
  }

  @override
  void dispose() {
    _rondasController.dispose();
    _toleranciaController.dispose();
    _puntosVictoriaController.dispose();
    _puntosDerrotaController.dispose();
    _puntosEmpateController.dispose();
    _codigoLicenciaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración del Derby'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Restaurar valores por defecto',
            onPressed: _restaurarDefaults,
          ),
        ],
      ),
      body: Consumer<DerbyState>(
        builder: (context, state, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección: Formato del torneo
                _buildSeccion('Formato del Torneo', [
                  _buildCampoNumerico(
                    label: 'Número de Rondas',
                    controller: _rondasController,
                    hint: '5',
                    suffix: 'rondas',
                    icon: Icons.repeat,
                    min: 1,
                    max: 20,
                  ),
                  const SizedBox(height: 16),
                  _buildCampoNumerico(
                    label: 'Tolerancia de Peso',
                    controller: _toleranciaController,
                    hint: '50',
                    suffix: 'gramos',
                    icon: Icons.scale,
                    min: 10,
                    max: 200,
                    ayuda: 'Diferencia máxima de peso permitida entre gallos',
                  ),
                ]),

                const SizedBox(height: 32),

                // Sección: Sistema de puntos
                _buildSeccion('Sistema de Puntos', [
                  Row(
                    children: [
                      Expanded(
                        child: _buildCampoNumerico(
                          label: 'Victoria',
                          controller: _puntosVictoriaController,
                          hint: '3',
                          suffix: 'pts',
                          icon: Icons.emoji_events,
                          min: 0,
                          max: 10,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCampoNumerico(
                          label: 'Derrota',
                          controller: _puntosDerrotaController,
                          hint: '0',
                          suffix: 'pts',
                          icon: Icons.remove_circle_outline,
                          min: -5,
                          max: 5,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCampoNumerico(
                          label: 'Empate',
                          controller: _puntosEmpateController,
                          hint: '1',
                          suffix: 'pts',
                          icon: Icons.handshake,
                          min: 0,
                          max: 5,
                        ),
                      ),
                    ],
                  ),
                ]),

                const SizedBox(height: 32),

                // Información actual
                _buildSeccion('Estado Actual', [
                  _buildInfoRow('Participantes', '${state.totalParticipantes}'),
                  _buildInfoRow('Gallos registrados', '${state.totalGallos}'),
                  _buildInfoRow(
                    'Sorteo realizado',
                    state.sorteoRealizado ? 'Sí' : 'No',
                  ),
                  if (state.sorteoRealizado) ...[
                    _buildInfoRow('Rondas generadas', '${state.totalRondas}'),
                    _buildInfoRow(
                      'Peleas completadas',
                      '${state.peleasCompletadas}/${state.totalPeleas}',
                    ),
                  ],
                ]),

                if (state.sorteoRealizado) ...[
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange.shade700),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'El sorteo ya fue realizado. Cambiar la configuración no afectará las rondas existentes.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                _buildSeccion('Licencia', [
                  Row(
                    children: [
                      Icon(
                        state.licenciaPro ? Icons.verified : Icons.warning_amber,
                        color: state.licenciaPro ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.licenciaPro
                                  ? '${state.licencia.typeName} - Activa'
                                  : 'Modo Demo (Limitado)',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (state.licenciaPro && state.licencia.expiresAt != null)
                              Text(
                                'Expira: ${_formatearFecha(state.licencia.expiresAt!)} (${state.diasLicenciaRestantes} días)',
                                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                              ),
                            if (state.licenciaDemo)
                              Text(
                                'Limitaciones: máx ${state.maxParticipantesDemo} participantes, ${state.maxRondasDemo} ronda, sin PDF',
                                style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Mostrar huella del dispositivo
                  if (state.huellaDispositivo.isNotEmpty)
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: state.huellaDispositivo.substring(0, 8).toUpperCase()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ID de dispositivo copiado')),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.fingerprint, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'ID Dispositivo: ${state.huellaDispositivo.substring(0, 8).toUpperCase()}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.copy, size: 14, color: Colors.grey.shade400),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _codigoLicenciaController,
                    decoration: const InputDecoration(
                      labelText: 'Código de activación',
                      hintText: 'DERBY-xxxxxxxx.xxxxxxxx',
                      prefixIcon: Icon(Icons.vpn_key),
                    ),
                    maxLines: 3,
                    minLines: 1,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _activarLicencia(context, state),
                        icon: const Icon(Icons.lock_open),
                        label: const Text('Activar licencia'),
                      ),
                      OutlinedButton.icon(
                        onPressed: state.licenciaDemo
                            ? null
                            : () => _desactivarLicencia(context, state),
                        icon: const Icon(Icons.lock_reset),
                        label: const Text('Desactivar'),
                      ),
                    ],
                  ),
                ]),

                const SizedBox(height: 32),

                _buildSeccion('Backup del Torneo', [
                  const Text(
                    'Exporta todos los datos del derby actual a un archivo JSON.',
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _exportarBackup(context, state),
                    icon: const Icon(Icons.backup),
                    label: const Text('Exportar backup JSON'),
                  ),
                ]),

                const SizedBox(height: 32),

                _buildSeccion('Historial de Modificaciones', [
                  if (state.historialEventos.isEmpty)
                    const Text('Sin cambios registrados todavía.'),
                  if (state.historialEventos.isNotEmpty)
                    ...state.historialEventos.take(20).map(
                      (evento) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.history, size: 18),
                        title: Text(evento.descripcion),
                        subtitle: Text(
                          '${evento.tipo.toUpperCase()} · ${_formatearFechaHora(evento.timestamp)}',
                        ),
                      ),
                    ),
                ]),

                const SizedBox(height: 32),

                // Botón guardar
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _guardarConfiguracion(context, state),
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar Configuración'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSeccion(String titulo, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildCampoNumerico({
    required String label,
    required TextEditingController controller,
    required String hint,
    required String suffix,
    required IconData icon,
    required int min,
    required int max,
    String? ayuda,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            suffixText: suffix,
            prefixIcon: Icon(icon),
            helperText: ayuda,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _restaurarDefaults() {
    final defaults = ConfiguracionDerby.standard();
    setState(() {
      _rondasController.text = '${defaults.numeroRondas}';
      _toleranciaController.text = '${defaults.toleranciaPeso.toInt()}';
      _puntosVictoriaController.text = '${defaults.puntosVictoria}';
      _puntosDerrotaController.text = '${defaults.puntosDerrota}';
      _puntosEmpateController.text = '${defaults.puntosEmpate}';
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Valores restaurados')));
  }

  Future<void> _guardarConfiguracion(
    BuildContext context,
    DerbyState state,
  ) async {
    final rondas = int.tryParse(_rondasController.text) ?? 5;
    final tolerancia = double.tryParse(_toleranciaController.text) ?? 50;
    final puntosVictoria = int.tryParse(_puntosVictoriaController.text) ?? 3;
    final puntosDerrota = int.tryParse(_puntosDerrotaController.text) ?? 0;
    final puntosEmpate = int.tryParse(_puntosEmpateController.text) ?? 1;

    final nuevaConfig = ConfiguracionDerby(
      numeroRondas: rondas.clamp(1, 20),
      toleranciaPeso: tolerancia.clamp(10, 200),
      puntosVictoria: puntosVictoria.clamp(0, 10),
      puntosDerrota: puntosDerrota.clamp(-5, 5),
      puntosEmpate: puntosEmpate.clamp(0, 5),
    );

    await state.actualizarConfiguracion(nuevaConfig);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Configuración guardada')));
    }
  }

  Future<void> _activarLicencia(BuildContext context, DerbyState state) async {
    final result = await state.activarLicencia(_codigoLicenciaController.text);
    if (!context.mounted) return;

    final isSuccess = result == ActivationResult.success;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.getMensajeActivacion(result)),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
    
    if (isSuccess) {
      _codigoLicenciaController.clear();
    }
  }

  Future<void> _desactivarLicencia(BuildContext context, DerbyState state) async {
    await state.desactivarLicencia();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Licencia desactivada')),
    );
  }

  Future<void> _exportarBackup(BuildContext context, DerbyState state) async {
    try {
      final path = await state.exportarTorneoJson();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup exportado: $path')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exportando backup: $e')),
      );
    }
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }

  String _formatearFechaHora(DateTime fecha) {
    return '${_formatearFecha(fecha)} '
        '${fecha.hour.toString().padLeft(2, '0')}:'
        '${fecha.minute.toString().padLeft(2, '0')}';
  }
}
