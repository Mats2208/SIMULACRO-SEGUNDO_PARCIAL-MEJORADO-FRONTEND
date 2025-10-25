import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/app_theme.dart';
import '../models/models.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final isFavorite = productProvider.isFavorite(product.id);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Container with Gradient
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.blueGradient,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.inventory_2_rounded,
                      size: 60,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? AppTheme.errorColor : AppTheme.textSecondary,
                        size: 20,
                      ),
                      onPressed: () async {
                        await productProvider.toggleFavorite(product.id);
                      },
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
                // Stock Badge
                if (product.stock <= 5)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: product.stock == 0
                            ? AppTheme.errorColor
                            : AppTheme.warningColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.stock == 0 ? 'Agotado' : 'Últimas unidades',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Product Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        formatter.format(product.price),
                        style: const TextStyle(
                          color: AppTheme.accentGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      if (product.stock > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentPurple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warehouse_rounded,
                                size: 12,
                                color: AppTheme.accentPurple,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${product.stock}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.accentPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Add to Cart Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: product.stock > 0
                    ? AppTheme.blueGradient
                    : null,
                color: product.stock > 0
                    ? null
                    : AppTheme.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                onPressed: product.stock > 0
                    ? () async {
                        final success = await cartProvider.addToCart(product.id, 1);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    success ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                                    color: success ? AppTheme.successColor : AppTheme.errorColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      success ? 'Agregado al carrito' : cartProvider.error ?? 'Error',
                                      style: const TextStyle(color: AppTheme.textPrimary),
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: AppTheme.cardDark,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: success ? AppTheme.successColor : AppTheme.errorColor,
                                ),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      product.stock > 0
                          ? Icons.add_shopping_cart_rounded
                          : Icons.remove_shopping_cart_rounded,
                      size: 16,
                      color: product.stock > 0
                          ? Colors.white
                          : AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      product.stock > 0 ? 'Agregar' : 'Sin stock',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: product.stock > 0
                            ? Colors.white
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
