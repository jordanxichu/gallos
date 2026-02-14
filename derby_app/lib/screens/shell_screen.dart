import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'participantes_screen.dart';
import 'gallos_screen.dart';
import 'sorteo_screen.dart';
import 'peleas_screen.dart';
import 'resultados_screen.dart';
import 'configuracion_screen.dart';

/// Shell de navegación principal con NavigationRail para desktop.
class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _selectedIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
    _NavItem(
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      label: 'Participantes',
    ),
    _NavItem(
      icon: Icons.pets_outlined,
      selectedIcon: Icons.pets,
      label: 'Gallos',
    ),
    _NavItem(
      icon: Icons.shuffle_outlined,
      selectedIcon: Icons.shuffle,
      label: 'Sorteo',
    ),
    _NavItem(
      icon: Icons.sports_mma_outlined,
      selectedIcon: Icons.sports_mma,
      label: 'Peleas',
    ),
    _NavItem(
      icon: Icons.leaderboard_outlined,
      selectedIcon: Icons.leaderboard,
      label: 'Resultados',
    ),
    _NavItem(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Config',
    ),
  ];

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const ParticipantesScreen();
      case 2:
        return const GallosScreen();
      case 3:
        return const SorteoScreen();
      case 4:
        return const PeleasScreen();
      case 5:
        return const ResultadosScreen();
      case 6:
        return const ConfiguracionScreen();
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: Row(
        children: [
          // Navigation Rail
          NavigationRail(
            extended: isWide,
            minExtendedWidth: 180,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            labelType: isWide
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.selected,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  if (isWide) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Derby',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            destinations: _navItems
                .map(
                  (item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: Text(item.label),
                  ),
                )
                .toList(),
          ),

          // Divisor
          const VerticalDivider(thickness: 1, width: 1),

          // Contenido principal
          Expanded(child: _buildScreen(_selectedIndex)),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
