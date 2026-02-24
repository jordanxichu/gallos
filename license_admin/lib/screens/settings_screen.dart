import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../viewmodels/app_state.dart';
import '../data/models/license_record.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Key Management Section
          Text(
            'Claves RSA',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.key, color: Colors.green),
                  title: const Text('Clave Pública'),
                  subtitle: const Text('Necesaria para verificar licencias en la app'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: state.publicKey != null 
                      ? () => _showPublicKey(context, state.publicKey!)
                      : null,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.vpn_key, color: Colors.orange),
                  title: const Text('Regenerar Par de Claves'),
                  subtitle: const Text('⚠️ Invalidará todas las licencias existentes'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _confirmRegenerateKeys(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Data Management Section
          Text(
            'Gestión de Datos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Exportar Licencias'),
                  subtitle: const Text('Descargar todas las licencias en CSV'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _exportLicenses(context, state),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_sweep, color: Colors.red),
                  title: const Text('Eliminar Expiradas'),
                  subtitle: Text('${state.expiredLicenses.length} licencias expiradas'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: state.expiredLicenses.isEmpty 
                      ? null 
                      : () => _confirmDeleteExpired(context, state),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stats Section
          Text(
            'Estadísticas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: state.stats != null ? Column(
                children: [
                  _StatRow(label: 'Total de licencias', value: '${state.stats!.totalLicenses}'),
                  _StatRow(label: 'Licencias activas', value: '${state.stats!.activeLicenses}'),
                  _StatRow(label: 'Licencias expiradas', value: '${state.stats!.expiredLicenses}'),
                  _StatRow(label: 'Licencias revocadas', value: '${state.stats!.revokedLicenses}'),
                  _StatRow(label: 'Generadas este mes', value: '${state.stats!.licensesThisMonth}'),
                  const Divider(height: 24),
                  _StatRow(
                    label: 'Ingresos totales', 
                    value: '\$${state.stats!.totalRevenue.toStringAsFixed(2)}',
                    valueColor: Colors.green,
                  ),
                  _StatRow(
                    label: 'Ingresos del mes', 
                    value: '\$${state.stats!.monthRevenue.toStringAsFixed(2)}',
                    valueColor: Colors.green,
                  ),
                ],
              ) : const Center(child: CircularProgressIndicator()),
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          Text(
            'Acerca de',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Derby License Admin'),
                  subtitle: const Text('Versión 1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Guía de Uso'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showUserGuide(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showPublicKey(BuildContext context, String publicKey) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(100),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Clave Pública RSA',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Esta clave debe configurarse en la app Derby Master para verificar las licencias.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: SelectableText(
                      publicKey,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.copy),
                      label: const Text('Copiar'),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: publicKey));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Clave copiada')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.share),
                      label: const Text('Compartir'),
                      onPressed: () {
                        Share.share(
                          publicKey,
                          subject: 'Clave Pública RSA - Derby Master',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmRegenerateKeys(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Regenerar Claves'),
          ],
        ),
        content: const Text(
          '¿Estás seguro de regenerar el par de claves RSA?\n\n'
          '⚠️ ADVERTENCIA: Todas las licencias generadas anteriormente '
          'dejarán de funcionar y no podrán ser verificadas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement key regeneration
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Función no implementada aún')),
              );
            },
            child: const Text('Regenerar', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _exportLicenses(BuildContext context, AppState state) async {
    final licenses = state.licenses;
    if (licenses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay licencias para exportar')),
      );
      return;
    }

    // Build CSV
    final buffer = StringBuffer();
    buffer.writeln('ID,Tipo,Titular,Email,Teléfono,Dispositivo,Emitida,Expira,Estado,Monto,Moneda');
    
    for (final l in licenses) {
      final expiresStr = l.expiresAt?.toIso8601String() ?? 'N/A';
      buffer.writeln(
        '"${l.licenseId}","${l.typeName}","${l.holderName}","${l.holderEmail ?? ''}",'
        '"${l.holderPhone ?? ''}","${l.devicePrefix ?? ''}","${l.issuedAt.toIso8601String()}",'
        '"$expiresStr","${l.statusName}","${l.amount ?? 0}","${l.currency}"'
      );
    }

    await Share.share(
      buffer.toString(),
      subject: 'Licencias Derby Master - Exportación',
    );
  }

  void _confirmDeleteExpired(BuildContext context, AppState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Expiradas'),
        content: Text(
          '¿Estás seguro de eliminar ${state.expiredLicenses.length} licencias expiradas?'
          '\n\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              for (final license in state.expiredLicenses) {
                await state.deleteLicense(license.id);
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Licencias expiradas eliminadas')),
                );
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showUserGuide(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Guía de Uso'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '1. Generar Licencias',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Ve a la pestaña "Generar", completa los datos del cliente '
                'y presiona "Generar Licencia".',
              ),
              SizedBox(height: 16),
              Text(
                '2. Compartir Licencias',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Después de generar, puedes compartir el código por WhatsApp, '
                'Email u otra app. También puedes hacerlo desde la lista de licencias.',
              ),
              SizedBox(height: 16),
              Text(
                '3. Configurar la App Derby',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Copia la Clave Pública desde Ajustes y configúrala en el código '
                'de tu app Derby Master para que pueda verificar las licencias.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Monitorear',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Usa el Dashboard para ver estadísticas y licencias por vencer. '
                'Filtra y busca en la pestaña "Licencias".',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
