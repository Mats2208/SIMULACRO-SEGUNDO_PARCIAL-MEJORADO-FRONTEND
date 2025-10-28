import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';

class TopProductsScreen extends StatefulWidget {
  const TopProductsScreen({super.key});

  @override
  State<TopProductsScreen> createState() => _TopProductsScreenState();
}

class _TopProductsScreenState extends State<TopProductsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoritesProvider>(context, listen: false)
          .loadTopFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Productos Populares'),
        backgroundColor: AppTheme.secondaryDark,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await favoritesProvider.loadTopFavorites();
        },
        child: favoritesProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : favoritesProvider.error != null
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
                          'Error: ${favoritesProvider.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            favoritesProvider.loadTopFavorites();
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : favoritesProvider.topFavorites.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star_border_outlined,
                              size: 64,
                              color: AppTheme.textSecondary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aún no hay productos populares',
                              style: TextStyle(
                                color: AppTheme.textSecondary.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: favoritesProvider.topFavorites.length,
                        itemBuilder: (context, index) {
                          final topProduct = favoritesProvider.topFavorites[index];
                          final product = topProduct.product;
                          final rank = index + 1;
                          
                          // Colores de medallas
                          Color? medalColor;
                          IconData? medalIcon;
                          if (rank == 1) {
                            medalColor = const Color(0xFFFFD700); // Oro
                            medalIcon = Icons.emoji_events;
                          } else if (rank == 2) {
                            medalColor = const Color(0xFFC0C0C0); // Plata
                            medalIcon = Icons.workspace_premium;
                          } else if (rank == 3) {
                            medalColor = const Color(0xFFCD7F32); // Bronce
                            medalIcon = Icons.military_tech;
                          }

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // Ranking badge
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: medalColor != null
                                              ? medalColor.withOpacity(0.2)
                                              : AppTheme.borderColor,
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: Center(
                                          child: medalIcon != null
                                              ? Icon(
                                                  medalIcon,
                                                  color: medalColor,
                                                  size: 28,
                                                )
                                              : Text(
                                                  '#$rank',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.textPrimary,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Product info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              topProduct.productName,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            if (product != null) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                '\$${product.price.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.accentGreen,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      // Favorites count
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.accentGreen.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.favorite,
                                              size: 18,
                                              color: AppTheme.accentGreen,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '${topProduct.favoriteCount}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: AppTheme.accentGreen,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  // Product description and actions
                                  if (product != null) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      product.description,
                                      style: const TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
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
                                        const Spacer(),
                                        // Add to cart button
                                        if (product.stock > 0)
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              try {
                                                await cartProvider.addToCart(
                                                  product.id,
                                                  1,
                                                );
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        '${product.name} agregado al carrito',
                                                      ),
                                                      backgroundColor: AppTheme.successColor,
                                                      duration: const Duration(seconds: 2),
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('Error: $e'),
                                                      backgroundColor: AppTheme.errorColor,
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.add_shopping_cart,
                                              size: 18,
                                            ),
                                            label: const Text('Agregar'),
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 8,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
