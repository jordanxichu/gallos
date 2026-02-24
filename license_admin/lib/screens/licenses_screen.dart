import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../viewmodels/app_state.dart';
import '../data/models/license_record.dart';

class LicensesScreen extends StatefulWidget {
  const LicensesScreen({super.key});

  @override
  State<LicensesScreen> createState() => _LicensesScreenState();
}

class _LicensesScreenState extends State<LicensesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<LicenseRecord> _filterLicenses(List<LicenseRecord> licenses) {
    if (_searchQuery.isEmpty) return licenses;
    final query = _searchQuery.toLowerCase();
    return licenses.where((l) =>
      l.holderName.toLowerCase().contains(query) ||
      (l.holderEmail?.toLowerCase().contains(query) ?? false) ||
      l.licenseId.toLowerCase().contains(query)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Licencias'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'Todas (${state.licenses.length})'),
            Tab(text: 'Activas (${state.activeLicenses.length})'),
            Tab(text: 'Por Vencer (${state.expiringSoonLicenses.length})'),
            Tab(text: 'Expiradas (${state.expiredLicenses.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, email o ID...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLicenseList(context, _filterLicenses(state.licenses)),
                _buildLicenseList(context, _filterLicenses(state.activeLicenses)),
                _buildLicenseList(context, _filterLicenses(state.expiringSoonLicenses)),
                _buildLicenseList(context, _filterLicenses(state.expiredLicenses)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseList(BuildContext context, List<LicenseRecord> licenses) {
    if (licenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey.withAlpha(100)),
            const SizedBox(height: 16),
            const Text('No hay licencias'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<AppState>().refresh(),
      child: ListView.builder(
        itemCount: licenses.length,
        itemBuilder: (context, index) {
          final license = licenses[index];
          return _LicenseCard(license: license);
        },
      ),
    );
  }
}

class _LicenseCard extends StatelessWidget {
  final LicenseRecord license;

  const _LicenseCard({required this.license});

  Color _getStatusColor() {
    if (license.revoked) return Colors.grey;
    if (license.isExpired) return Colors.red;
    if (license.isExpiringSoon) return Colors.orange;
    return Colors.green;
  }

  IconData _getStatusIcon() {
    if (license.revoked) return Icons.block;
    if (license.isExpired) return Icons.cancel;
    if (license.isExpiringSoon) return Icons.warning;
    return Icons.check_circle;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final statusColor = _getStatusColor();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () => _showLicenseDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: statusColor.withAlpha(50),
                    child: Icon(_getStatusIcon(), color: statusColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          license.holderName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          license.holderEmail ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      license.statusName,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.category,
                    label: license.typeName,
                  ),
                  const SizedBox(width: 8),
                  if (license.expiresAt != null)
                    _InfoChip(
                      icon: Icons.calendar_today,
                      label: dateFormat.format(license.expiresAt!),
                    ),
                  if ((license.amount ?? 0) > 0) ...[
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: Icons.attach_money,
                      label: '\$${license.amount?.toStringAsFixed(0) ?? "0"}',
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!license.shared)
                    TextButton.icon(
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Compartir'),
                      onPressed: () => _shareLicense(context),
                    )
                  else
                    TextButton.icon(
                      icon: const Icon(Icons.check, size: 18, color: Colors.green),
                      label: const Text('Enviada', style: TextStyle(color: Colors.green)),
                      onPressed: () => _shareLicense(context),
                    ),
                  TextButton.icon(
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copiar'),
                    onPressed: () => _copyLicense(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareLicense(BuildContext context) async {
    final message = _buildLicenseMessage();
    await Share.share(message, subject: 'Licencia Derby Master');
    if (context.mounted) {
      context.read<AppState>().markAsShared(license.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Licencia compartida')),
      );
    }
  }

  void _copyLicense(BuildContext context) {
    Clipboard.setData(ClipboardData(text: license.licenseCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Código copiado al portapapeles')),
    );
  }

  String _buildLicenseMessage() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final expiresStr = license.expiresAt != null 
        ? dateFormat.format(license.expiresAt!) 
        : 'Sin expiración';
    return '''
🎮 *LICENCIA DERBY MASTER*
━━━━━━━━━━━━━━━━━━━━━

👤 *Titular:* ${license.holderName}
📧 *Email:* ${license.holderEmail ?? 'N/A'}
${(license.holderPhone?.isNotEmpty ?? false) ? '📱 *Teléfono:* ${license.holderPhone}\n' : ''}
📋 *Tipo:* ${license.typeName}
📅 *Válida hasta:* $expiresStr
🔑 *ID:* ${license.licenseId}

━━━━━━━━━━━━━━━━━━━━━
*CÓDIGO DE LICENCIA:*
━━━━━━━━━━━━━━━━━━━━━

${license.licenseCode}

━━━━━━━━━━━━━━━━━━━━━
⚠️ Este código es personal e intransferible.
''';
  }

  void _showLicenseDetails(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
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
                'Detalles de Licencia',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _DetailRow(label: 'ID', value: license.licenseId),
              _DetailRow(label: 'Titular', value: license.holderName),
              _DetailRow(label: 'Email', value: license.holderEmail ?? 'N/A'),
              if (license.holderPhone?.isNotEmpty ?? false)
                _DetailRow(label: 'Teléfono', value: license.holderPhone!),
              _DetailRow(label: 'Tipo', value: license.typeName),
              _DetailRow(label: 'Estado', value: license.statusName),
              _DetailRow(label: 'Emitida', value: dateFormat.format(license.issuedAt)),
              if (license.expiresAt != null)
                _DetailRow(label: 'Expira', value: dateFormat.format(license.expiresAt!)),
              if (license.devicePrefix?.isNotEmpty ?? false)
                _DetailRow(label: 'Dispositivo', value: license.devicePrefix!),
              if ((license.amount ?? 0) > 0)
                _DetailRow(label: 'Monto', value: '\$${license.amount} ${license.currency}'),
              if (license.notes?.isNotEmpty ?? false)
                _DetailRow(label: 'Notas', value: license.notes!),
              _DetailRow(label: 'Compartida', value: license.shared ? 'Sí' : 'No'),
              const SizedBox(height: 24),
              Text(
                'Código de Licencia',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(50),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  license.licenseCode,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.share),
                      label: const Text('Compartir'),
                      onPressed: () {
                        Navigator.pop(context);
                        _shareLicense(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.copy),
                      label: const Text('Copiar'),
                      onPressed: () {
                        _copyLicense(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (!license.revoked && !license.isExpired)
                OutlinedButton.icon(
                  icon: const Icon(Icons.block, color: Colors.orange),
                  label: const Text('Revocar', style: TextStyle(color: Colors.orange)),
                  onPressed: () => _confirmRevoke(context),
                ),
              OutlinedButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmRevoke(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revocar Licencia'),
        content: Text('¿Estás seguro de revocar la licencia de ${license.holderName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<AppState>().revokeLicense(license.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Licencia revocada')),
              );
            },
            child: const Text('Revocar', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Licencia'),
        content: Text('¿Estás seguro de eliminar la licencia de ${license.holderName}? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<AppState>().deleteLicense(license.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Licencia eliminada')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
