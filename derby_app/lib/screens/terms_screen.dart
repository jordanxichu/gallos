import 'package:flutter/material.dart';
import '../services/terms_service.dart';

/// Pantalla de aceptación de términos y condiciones.
/// Se muestra al primer uso de la aplicación.
class TermsScreen extends StatefulWidget {
  final VoidCallback onAccepted;

  const TermsScreen({super.key, required this.onAccepted});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  final _nameController = TextEditingController();
  final _scrollController = ScrollController();
  bool _hasScrolledToEnd = false;
  bool _hasAccepted = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkScrollPosition);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _checkScrollPosition() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      if (!_hasScrolledToEnd) {
        setState(() => _hasScrolledToEnd = true);
      }
    }
  }

  Future<void> _acceptTerms() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa tu nombre para continuar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    await TermsService.acceptTerms(organizerName: _nameController.text.trim());
    widget.onAccepted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Theme.of(context).primaryColor,
              child: Column(
                children: [
                  const Icon(Icons.gavel, size: 48, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    'HOJA DE DESCARGO DE RESPONSABILIDAD',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'USO DE SOFTWARE DE GESTIÓN DE DERBY',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Contenido scrolleable
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection('I. IDENTIFICACIÓN DE LAS PARTES', '''
Proveedor del Software:
Nombre: Derby Manager App
Domicilio: México
Contacto: soporte@derbymanager.app

Organizador / Responsable del Evento:
El organizador que acepta estos términos al usar la aplicación.'''),

                      _buildSection(
                        'II. OBJETO DEL DOCUMENTO',
                        '''
El presente documento tiene por objeto deslindar de responsabilidad civil, penal, administrativa y de cualquier otra índole al Proveedor del Software, respecto del uso del sistema informático de gestión de derby (en adelante, la Aplicación), por parte del Organizador.''',
                      ),

                      _buildSection('III. ALCANCE DEL SOFTWARE', '''
El Organizador reconoce y acepta expresamente que:

La Aplicación es una herramienta de apoyo administrativo y organizativo, destinada a:
• Programación de peleas
• Registro de resultados
• Cálculo de puntuaciones
• Generación de reportes

La Aplicación NO toma decisiones físicas, humanas, legales ni operativas, y NO sustituye:
• El criterio de jueces
• La supervisión humana
• Las decisiones del organizador
• La normativa interna del evento

La Aplicación no interviene ni influye en:
• El desarrollo físico de las peleas
• La integridad de los animales
• Las condiciones del evento
• El comportamiento de participantes o asistentes'''),

                      _buildSection(
                        'IV. RESPONSABILIDAD DEL ORGANIZADOR',
                        '''
El Organizador asume total y exclusivamente la responsabilidad por:
• La veracidad de los datos ingresados
• La correcta clasificación de gallos (activos, retirados, descalificados o muertos)
• La aplicación de reglas tradicionales del derby
• El uso o interpretación de los reportes generados
• Cualquier conflicto entre participantes

Asimismo, el Organizador reconoce que errores derivados de datos incorrectos, omisiones o decisiones humanas no son atribuibles al Proveedor del Software.''',
                      ),

                      _buildSection(
                        'V. EVENTOS DE FUERZA MAYOR Y CASOS FORTUITOS',
                        '''
El Proveedor del Software no será responsable por daños, pérdidas o controversias derivadas de:
• Fallas eléctricas
• Fallas de hardware
• Uso indebido del sistema
• Interrupciones externas
• Decisiones tomadas por terceros con base en los reportes''',
                      ),

                      _buildSection(
                        'VI. ACEPTACIÓN DE RIESGO Y LIMITACIÓN DE RESPONSABILIDAD',
                        '''
El Organizador acepta que el uso de la Aplicación se realiza bajo su propio riesgo, liberando expresamente al Proveedor del Software de cualquier reclamación presente o futura relacionada con:
• Resultados del evento
• Inconformidades de participantes
• Interpretaciones de puntuación
• Suspensión o cancelación del evento''',
                      ),

                      _buildSection(
                        'VII. JURISDICCIÓN Y LEGISLACIÓN APLICABLE',
                        '''
Para la interpretación y cumplimiento del presente documento, las partes se someten expresamente a las leyes vigentes del Estado de Guanajuato, renunciando a cualquier otro fuero que pudiera corresponderles por razón de domicilio presente o futuro.''',
                      ),

                      _buildSection(
                        'VIII. ACEPTACIÓN',
                        '''
Al ingresar su nombre y aceptar estos términos, el Organizador confirma haber leído y comprendido el presente documento, aceptando todas sus cláusulas y condiciones.''',
                      ),

                      const SizedBox(height: 24),

                      // Campo de nombre
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ORGANIZADOR',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre completo del organizador',
                                  hintText: 'Ingresa tu nombre completo',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Fecha: ${_formatDate(DateTime.now())}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Checkbox de aceptación
                      CheckboxListTile(
                        value: _hasAccepted,
                        onChanged: _hasScrolledToEnd
                            ? (value) =>
                                  setState(() => _hasAccepted = value ?? false)
                            : null,
                        title: const Text(
                          'He leído y acepto los términos y condiciones',
                        ),
                        subtitle: !_hasScrolledToEnd
                            ? const Text(
                                'Desplázate hasta el final para habilitar',
                                style: TextStyle(color: Colors.orange),
                              )
                            : null,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Botón de aceptar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000), // black with 10% opacity
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed:
                    _hasAccepted && _nameController.text.trim().isNotEmpty
                    ? _acceptTerms
                    : null,
                icon: const Icon(Icons.check_circle),
                label: const Text('ACEPTAR Y CONTINUAR'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}
