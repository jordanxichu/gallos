import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../viewmodels/app_state.dart';
import '../data/models/license_record.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _deviceController = TextEditingController();
  final _notesController = TextEditingController();
  final _amountController = TextEditingController(text: '0');
  
  LicenseType _selectedType = LicenseType.monthly;
  int _days = 30;
  String _currency = 'USD';
  bool _isGenerating = false;

  final List<Map<String, dynamic>> _licenseTypes = [
    {'type': LicenseType.demo, 'name': 'Demo', 'days': 7, 'icon': Icons.hourglass_empty},
    {'type': LicenseType.monthly, 'name': 'Mensual', 'days': 30, 'icon': Icons.calendar_month},
    {'type': LicenseType.annual, 'name': 'Anual', 'days': 365, 'icon': Icons.calendar_today},
    {'type': LicenseType.lifetime, 'name': 'Permanente', 'days': 36500, 'icon': Icons.all_inclusive},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _deviceController.dispose();
    _notesController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onTypeChanged(LicenseType type) {
    setState(() {
      _selectedType = type;
      _days = _licenseTypes.firstWhere((t) => t['type'] == type)['days'];
    });
  }

  Future<void> _generateLicense() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isGenerating = true);

    try {
      final state = context.read<AppState>();
      final license = await state.generateLicense(
        type: _selectedType,
        holderName: _nameController.text.trim(),
        holderEmail: _emailController.text.trim(),
        holderPhone: _phoneController.text.trim(),
        devicePrefix: _deviceController.text.trim(),
        days: _days,
        notes: _notesController.text.trim(),
        amount: double.tryParse(_amountController.text) ?? 0,
        currency: _currency,
      );

      if (mounted) {
        if (license != null) {
          _showSuccessDialog(license);
          _clearForm();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al generar licencia'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _deviceController.clear();
    _notesController.clear();
    _amountController.text = '0';
    setState(() {
      _selectedType = LicenseType.monthly;
      _days = 30;
    });
  }

  void _showSuccessDialog(LicenseRecord license) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            const Text('Licencia Generada'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SuccessRow(label: 'Titular', value: license.holderName),
              _SuccessRow(label: 'Tipo', value: license.typeName),
              _SuccessRow(label: 'Válida hasta', value: license.expiresAt != null ? dateFormat.format(license.expiresAt!) : 'Sin expiración'),
              _SuccessRow(label: 'ID', value: license.licenseId),
              const SizedBox(height: 16),
              const Text(
                'Código generado correctamente.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          TextButton.icon(
            icon: const Icon(Icons.copy),
            label: const Text('Copiar'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: license.licenseCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Código copiado')),
              );
            },
          ),
          FilledButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('Compartir'),
            onPressed: () {
              _shareLicense(license);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _shareLicense(LicenseRecord license) async {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final expiresStr = license.expiresAt != null 
        ? dateFormat.format(license.expiresAt!) 
        : 'Sin expiración';
    final message = '''
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

    await Share.share(message, subject: 'Licencia Derby Master');
    if (mounted) {
      context.read<AppState>().markAsShared(license.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Licencia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearForm,
            tooltip: 'Limpiar formulario',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // License Type Selection
              Text(
                'Tipo de Licencia',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _licenseTypes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final type = _licenseTypes[index];
                    final isSelected = _selectedType == type['type'];
                    return GestureDetector(
                      onTap: () => _onTypeChanged(type['type']),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 100,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.withAlpha(50),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              type['icon'],
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              type['name'],
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                            ),
                            Text(
                              '${type['days']} días',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Custom Days (for advanced users)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _days.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Días de validez',
                        prefixIcon: Icon(Icons.timer),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        final days = int.tryParse(value);
                        if (days != null && days > 0) {
                          setState(() => _days = days);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Holder Information
              Text(
                'Datos del Titular',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo *',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El email es requerido';
                  }
                  if (!value.contains('@')) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono (opcional)',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),

              // Device Binding (optional)
              Text(
                'Vinculación (Opcional)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Prefijo del ID de dispositivo para vincular la licencia',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _deviceController,
                decoration: const InputDecoration(
                  labelText: 'Prefijo de dispositivo',
                  prefixIcon: Icon(Icons.devices),
                  border: OutlineInputBorder(),
                  hintText: 'Ej: ABC123',
                ),
              ),
              const SizedBox(height: 24),

              // Payment Information
              Text(
                'Información de Pago',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Monto',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _currency,
                      decoration: const InputDecoration(
                        labelText: 'Moneda',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'USD', child: Text('USD')),
                        DropdownMenuItem(value: 'MXN', child: Text('MXN')),
                        DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                        DropdownMenuItem(value: 'COP', child: Text('COP')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _currency = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Generate Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _isGenerating ? null : _generateLicense,
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.key),
                  label: Text(_isGenerating ? 'Generando...' : 'Generar Licencia'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessRow extends StatelessWidget {
  final String label;
  final String value;

  const _SuccessRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600]),
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
