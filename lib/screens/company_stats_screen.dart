import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/favorites_provider.dart';

class CompanyStatsScreen extends StatefulWidget {
  const CompanyStatsScreen({super.key});

  @override
  State<CompanyStatsScreen> createState() => _CompanyStatsScreenState();
}

class _CompanyStatsScreenState extends State<CompanyStatsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoritesProvider>(context, listen: false)
          .loadMyCompanyStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final stats = favoritesProvider.companyStats;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas de Favoritos'),
        backgroundColor: AppTheme.secondaryDark,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await favoritesProvider.loadMyCompanyStats();
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
                            favoritesProvider.loadMyCompanyStats();
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : stats == null
                    ? const Center(
                        child: Text('No hay estadísticas disponibles'),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card de resumen
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.favorite,
                                      size: 48,
                                      color: AppTheme.accentGreen,
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Total de Favoritos',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${stats.totalFavorites}',
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.accentGreen,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      stats.companyName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Lista de productos
                            const Text(
                              'Favoritos por Producto',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            if (stats.products.isEmpty)
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.inventory_2_outlined,
                                          size: 48,
                                          color: AppTheme.textSecondary.withOpacity(0.5),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Aún no tienes productos con favoritos',
                                          style: TextStyle(
                                            color: AppTheme.textSecondary.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            else
                              ...stats.products.map((productStat) {
                                final percentage = stats.totalFavorites > 0
                                    ? (productStat.favoriteCount / stats.totalFavorites * 100)
                                    : 0.0;
                                
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
                                              child: Text(
                                                productStat.productName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppTheme.accentGreen.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.favorite,
                                                    size: 16,
                                                    color: AppTheme.accentGreen,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${productStat.favoriteCount}',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: AppTheme.accentGreen,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        // Barra de progreso
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: LinearProgressIndicator(
                                            value: percentage / 100,
                                            minHeight: 8,
                                            backgroundColor: AppTheme.borderColor,
                                            valueColor: const AlwaysStoppedAnimation<Color>(
                                              AppTheme.accentGreen,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${percentage.toStringAsFixed(1)}% del total',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                          ],
                        ),
                      ),
      ),
    );
  }
}
