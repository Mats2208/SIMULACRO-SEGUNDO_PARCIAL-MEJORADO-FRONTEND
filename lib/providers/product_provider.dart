import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  List<Product> _favorites = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  List<Product> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts({bool onlyActive = true}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _apiService.getProducts(onlyActive: onlyActive);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Product?> getProduct(String id) async {
    try {
      return await _apiService.getProduct(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final product = await _apiService.createProduct(
        name: name,
        description: description,
        price: price,
        stock: stock,
      );

      _products.add(product);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
    String id, {
    String? name,
    String? description,
    double? price,
    int? stock,
    bool? isActive,
  }) async {
    _error = null;
    notifyListeners();

    try {
      final updatedProduct = await _apiService.updateProduct(
        id,
        name: name,
        description: description,
        price: price,
        stock: stock,
        isActive: isActive,
      );

      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> loadFavorites() async {
    try {
      _favorites = await _apiService.getFavorites();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> toggleFavorite(String productId) async {
    try {
      await _apiService.toggleFavorite(productId);
      await loadFavorites();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  bool isFavorite(String productId) {
    return _favorites.any((p) => p.id == productId);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
