import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import 'product_form_screen.dart';
import 'profile_screen.dart';

class CompanyHomeScreen extends StatefulWidget {
  const CompanyHomeScreen({super.key});

  @override
  State<CompanyHomeScreen> createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
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
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Productos - ${authProvider.user?.companyName ?? ""}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded),
            tooltip: 'Mi Perfil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductForm(),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
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
                        Text(
                          'Error: ${productProvider.error}',
                          textAlign: TextAlign.center,
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
                    ? const Center(
                        child: Text('No tienes productos. ¡Crea uno!'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: productProvider.products.length,
                        itemBuilder: (context, index) {
                          final product = productProvider.products[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              title: Text(product.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('\$${product.price.toStringAsFixed(2)}'),
                                  Text('Stock: ${product.stock}'),
                                  Text(
                                    product.isActive ? 'Activo' : 'Inactivo',
                                    style: TextStyle(
                                      color: product.isActive
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Editar'),
                                  ),
                                  PopupMenuItem(
                                    value: 'toggle',
                                    child: Text(
                                      product.isActive
                                          ? 'Desactivar'
                                          : 'Activar',
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Eliminar'),
                                  ),
                                ],
                                onSelected: (value) async {
                                  switch (value) {
                                    case 'edit':
                                      _showProductForm(product);
                                      break;
                                    case 'toggle':
                                      final success =
                                          await productProvider.updateProduct(
                                        product.id,
                                        isActive: !product.isActive,
                                      );
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              success
                                                  ? 'Producto actualizado'
                                                  : 'Error al actualizar',
                                            ),
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
                                              child: const Text('Eliminar'),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        final success = await productProvider
                                            .deleteProduct(product.id);
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                success
                                                    ? 'Producto eliminado'
                                                    : 'Error al eliminar',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                      break;
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
