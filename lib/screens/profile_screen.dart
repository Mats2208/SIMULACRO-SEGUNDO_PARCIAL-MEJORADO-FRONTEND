import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
          backgroundColor: AppTheme.primaryDark,
        ),
        body: const Center(
          child: Text('No hay usuario autenticado'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: AppTheme.primaryDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Cerrar Sesión',
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Card con Avatar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentGreen.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForRole(user.role),
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Nombre/Email
                  Text(
                    user.companyName ?? user.email.split('@').first.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Email
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Badge de Rol
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getBadgeIconForRole(user.role),
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          user.roleDisplay,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Información de la cuenta
            _buildInfoSection(
              title: 'Información de la Cuenta',
              items: [
                _InfoItem(
                  icon: Icons.email_rounded,
                  label: 'Correo Electrónico',
                  value: user.email,
                ),
                _InfoItem(
                  icon: Icons.badge_rounded,
                  label: 'Tipo de Cuenta',
                  value: user.roleDisplay,
                ),
                if (user.companyName != null)
                  _InfoItem(
                    icon: Icons.business_rounded,
                    label: 'Nombre de la Empresa',
                    value: user.companyName!,
                  ),
                _InfoItem(
                  icon: Icons.verified_user_rounded,
                  label: 'Estado',
                  value: 'Cuenta Activa',
                  valueColor: AppTheme.successColor,
                ),
                if (user.isRoot)
                  _InfoItem(
                    icon: Icons.admin_panel_settings_rounded,
                    label: 'Permisos',
                    value: 'Administrador Root',
                    valueColor: AppTheme.accentGreen,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Estadísticas según rol
            if (user.role == Role.client) ...[
              _buildStatsSection(
                title: 'Actividad de Compras',
                items: [
                  _StatItem(
                    icon: Icons.shopping_bag_rounded,
                    label: 'Pedidos Totales',
                    value: '0', // TODO: Implementar cuando haya endpoint
                  ),
                  _StatItem(
                    icon: Icons.favorite_rounded,
                    label: 'Favoritos',
                    value: '0', // TODO: Conectar con API
                  ),
                ],
              ),
            ] else if (user.role == Role.company) ...[
              _buildStatsSection(
                title: 'Estadísticas de Empresa',
                items: [
                  _StatItem(
                    icon: Icons.inventory_2_rounded,
                    label: 'Productos',
                    value: '0', // TODO: Conectar con API
                  ),
                  _StatItem(
                    icon: Icons.trending_up_rounded,
                    label: 'Ventas',
                    value: '0',
                  ),
                ],
              ),
            ] else if (user.role == Role.adminRoot) ...[
              _buildStatsSection(
                title: 'Panel de Administración',
                items: [
                  _StatItem(
                    icon: Icons.people_rounded,
                    label: 'Usuarios Totales',
                    value: '0', // TODO: Conectar con API
                  ),
                  _StatItem(
                    icon: Icons.store_rounded,
                    label: 'Empresas',
                    value: '0',
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),

            // Botón de cerrar sesión
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cerrar Sesión'),
                      content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.errorColor,
                          ),
                          child: const Text('Cerrar Sesión'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  }
                },
                icon: const Icon(Icons.logout_rounded, color: AppTheme.errorColor),
                label: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.errorColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.errorColor, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // App Info
            Text(
              'Ecommerce-UPSA v1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForRole(Role role) {
    switch (role) {
      case Role.adminRoot:
        return Icons.admin_panel_settings_rounded;
      case Role.company:
        return Icons.business_rounded;
      case Role.client:
        return Icons.person_rounded;
    }
  }

  IconData _getBadgeIconForRole(Role role) {
    switch (role) {
      case Role.adminRoot:
        return Icons.verified_rounded;
      case Role.company:
        return Icons.store_rounded;
      case Role.client:
        return Icons.shopping_bag_rounded;
    }
  }

  Widget _buildInfoSection({
    required String title,
    required List<_InfoItem> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.accentGreen,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        item.icon,
                        size: 20,
                        color: AppTheme.accentGreen,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.value,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: item.valueColor ?? AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStatsSection({
    required String title,
    required List<_StatItem> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.accentGreen,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: items
                .map((item) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              item.icon,
                              size: 28,
                              color: AppTheme.accentGreen,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.value,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentGreen,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });
}

class _StatItem {
  final IconData icon;
  final String label;
  final String value;

  _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}
