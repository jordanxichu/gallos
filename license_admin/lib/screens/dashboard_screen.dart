import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../viewmodels/app_state.dart';
import '../data/models/license_record.dart';
import '../services/license_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final stats = state.stats;

    if (stats == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Derby License Admin'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => state.refresh(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => state.refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Cards
              _buildStatsGrid(context, stats),
              const SizedBox(height: 24),
              
              // Revenue Card
              _buildRevenueCard(context, stats),
              const SizedBox(height: 24),
              
              // License Type Distribution
              if (stats.byType.isNotEmpty) ...[
                Text(
                  'Distribución por Tipo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _buildTypeChart(context, stats.byType),
                const SizedBox(height: 24),
              ],
              
              // Expiring Soon List
              if (state.expiringSoonLicenses.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Por Vencer (7 días)',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to licenses tab
                      },
                      child: const Text('Ver todas'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildExpiringSoonList(context, state.expiringSoonLicenses),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, DashboardStats stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _StatCard(
          title: 'Activas',
          value: stats.activeLicenses.toString(),
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        _StatCard(
          title: 'Por Vencer',
          value: stats.expiringSoon.toString(),
          icon: Icons.warning,
          color: Colors.orange,
        ),
        _StatCard(
          title: 'Expiradas',
          value: stats.expiredLicenses.toString(),
          icon: Icons.cancel,
          color: Colors.red,
        ),
        _StatCard(
          title: 'Revocadas',
          value: stats.revokedLicenses.toString(),
          icon: Icons.block,
          color: Colors.grey,
        ),
        _StatCard(
          title: 'Este Mes',
          value: stats.licensesThisMonth.toString(),
          icon: Icons.calendar_today,
          color: Colors.blue,
        ),
        _StatCard(
          title: 'Total',
          value: stats.totalLicenses.toString(),
          icon: Icons.inventory_2,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildRevenueCard(BuildContext context, DashboardStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingresos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Este Mes',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${stats.monthRevenue.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.withAlpha(50),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${stats.totalRevenue.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChart(BuildContext context, Map<LicenseType, int> byType) {
    final colors = {
      LicenseType.demo: Colors.grey,
      LicenseType.monthly: Colors.blue,
      LicenseType.annual: Colors.green,
      LicenseType.lifetime: Colors.purple,
    };

    final typeNames = {
      LicenseType.demo: 'Demo',
      LicenseType.monthly: 'Mensual',
      LicenseType.annual: 'Anual',
      LicenseType.lifetime: 'Permanente',
    };

    final nonZeroEntries = byType.entries.where((e) => e.value > 0).toList();
    if (nonZeroEntries.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('Sin datos')));
    }

    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: nonZeroEntries.map((entry) {
                  return PieChartSectionData(
                    value: entry.value.toDouble(),
                    color: colors[entry.key] ?? Colors.grey,
                    title: entry.value.toString(),
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    radius: 50,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: nonZeroEntries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colors[entry.key] ?? Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        typeNames[entry.key] ?? 'Tipo ${entry.key}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiringSoonList(BuildContext context, List<LicenseRecord> licenses) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: licenses.take(5).length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final license = licenses[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange.withAlpha(50),
              child: const Icon(Icons.warning, color: Colors.orange),
            ),
            title: Text(license.holderName),
            subtitle: Text(
              '${license.typeName} - Vence en ${license.daysRemaining} días',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // Share license
              },
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
