import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class FavoritesProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _favorites = [];
  List<TopFavoriteProduct> _topFavorites = [];
  CompanyFavoriteStats? _companyStats;
  Map<String, ProductFavoriteStats> _productStatsCache = {};
  
  bool _isLoading = false;
  String? _error;

  List<Product> get favorites => _favorites;
  List<TopFavoriteProduct> get topFavorites => _topFavorites;
  CompanyFavoriteStats? get companyStats => _companyStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool isFavorite(String productId) {
    return _favorites.any((p) => p.id == productId);
  }

  ProductFavoriteStats? getProductStats(String productId) {
    return _productStatsCache[productId];
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _favorites = await _apiService.getFavorites();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _favorites = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String productId) async {
    try {
      await _apiService.toggleFavorite(productId);
      // Reload favorites after toggle
      await loadFavorites();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadTopFavorites({int take = 10, bool onlyActive = true}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getTopFavoriteProducts(
        take: take,
        onlyActive: onlyActive,
      );
      _topFavorites = result;
      _error = null;
      if (kDebugMode) {
        print('Top favorites cargados: ${_topFavorites.length} productos');
      }
    } catch (e) {
      _error = 'Error al cargar ranking: ${e.toString()}';
      _topFavorites = [];
      if (kDebugMode) {
        print('Error en loadTopFavorites: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMyCompanyStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getMyCompanyFavoriteStats();
      _companyStats = result;
      _error = null;
      if (kDebugMode) {
        print('Estadísticas de empresa cargadas: ${result.companyName}');
      }
    } catch (e) {
      _error = 'Error al cargar estadísticas: ${e.toString()}';
      _companyStats = null;
      if (kDebugMode) {
        print('Error en loadMyCompanyStats: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ProductFavoriteStats?> loadProductStats(String productId) async {
    try {
      final stats = await _apiService.getProductFavoriteStats(productId);
      _productStatsCache[productId] = stats;
      notifyListeners();
      return stats;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
