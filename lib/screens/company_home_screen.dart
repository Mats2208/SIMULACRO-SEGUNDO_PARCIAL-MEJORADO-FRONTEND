import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import 'product_form_screen.dart';
import 'profile_screen.dart';
import 'company_stats_screen.dart';

class CompanyHomeScreen extends StatefulWidget {
  const CompanyHomeScreen({super.key});

  @override
  State<CompanyHomeScreen> createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .loadProducts(onlyActive: false);
    });
  }

  void _showProductForm([Product? product]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: product),
      ),
    ).then((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .loadProducts(onlyActive: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final List<Widget> screens = [
      _ProductsTab(onShowProductForm: _showProductForm),
      const CompanyStatsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 
            ? 'Mis Productos - ${authProvider.user?.companyName ?? ""}' 
            : _selectedIndex == 1
                ? 'Estadísticas'
                : 'Mi Perfil'),
        backgroundColor: AppTheme.secondaryDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => _showProductForm(),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: AppTheme.cardDark,
        selectedItemColor: AppTheme.accentGreen,
        unselectedItemColor: AppTheme.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Estadísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class _ProductsTab extends StatelessWidget {
  final Function(Product?) onShowProductForm;

  const _ProductsTab({required this.onShowProductForm});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        await productProvider.loadProducts(onlyActive: false);
      },
      child: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productProvider.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppTheme.errorColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${productProvider.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          productProvider.loadProducts(onlyActive: false);
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : productProvider.products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 80,
                            color: AppTheme.textSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tienes productos',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.textSecondary.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '¡Crea uno con el botón +!',
                            style: TextStyle(
                              color: AppTheme.textSecondary.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: productProvider.products.length,
                      itemBuilder: (context, index) {
                        final product = productProvider.products[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.description,
                                            style: const TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 14,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton(
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit, size: 20),
                                              SizedBox(width: 8),
                                              Text('Editar'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'toggle',
                                          child: Row(
                                            children: [
                                              Icon(
                                                product.isActive
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                product.isActive
                                                    ? 'Desactivar'
                                                    : 'Activar',
                                              ),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete, size: 20, color: AppTheme.errorColor),
                                              SizedBox(width: 8),
                                              Text('Eliminar', style: TextStyle(color: AppTheme.errorColor)),
                                            ],
                                          ),
                                        ),
                                      ],
                                      onSelected: (value) async {
                                        switch (value) {
                                          case 'edit':
                                            onShowProductForm(product);
                                            break;
                                          case 'toggle':
                                            final success =
                                                await productProvider.updateProduct(
                                              product.id,
                                              isActive: !product.isActive,
                                            );
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    success
                                                        ? 'Producto actualizado'
                                                        : 'Error al actualizar',
                                                  ),
                                                  backgroundColor: success
                                                      ? AppTheme.successColor
                                                      : AppTheme.errorColor,
                                                ),
                                              );
                                            }
                                            break;
                                          case 'delete':
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Confirmar'),
                                                content: const Text(
                                                  '¿Eliminar este producto?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context, false),
                                                    child: const Text('Cancelar'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context, true),
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: AppTheme.errorColor,
                                                    ),
                                                    child: const Text('Eliminar'),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (confirm == true) {
                                              final success = await productProvider
                                                  .deleteProduct(product.id);
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      success
                                                          ? 'Producto eliminado'
                                                          : 'Error al eliminar',
                                                    ),
                                                    backgroundColor: success
                                                        ? AppTheme.successColor
                                                        : AppTheme.errorColor,
                                                  ),
                                                );
                                              }
                                            }
                                            break;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentGreen.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.accentGreen,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: Text(
                                        'Stock: ${product.stock}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      backgroundColor: product.stock > 0
                                          ? AppTheme.successColor.withOpacity(0.2)
                                          : AppTheme.errorColor.withOpacity(0.2),
                                      side: BorderSide.none,
                                    ),
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: Text(
                                        product.isActive ? 'Activo' : 'Inactivo',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      backgroundColor: product.isActive
                                          ? AppTheme.accentGreen.withOpacity(0.2)
                                          : AppTheme.textSecondary.withOpacity(0.2),
                                      side: BorderSide.none,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
