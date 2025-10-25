import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Cart? _cart;
  bool _isLoading = false;
  String? _error;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _cart?.items.length ?? 0;
  double get total => _cart?.total ?? 0.0;

  Future<void> loadCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _apiService.getCart();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(String productId, int quantity) async {
    _error = null;
    notifyListeners();

    try {
      _cart = await _apiService.addToCart(productId, quantity);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFromCart(String productId, int quantity) async {
    _error = null;
    notifyListeners();

    try {
      _cart = await _apiService.removeFromCart(productId, quantity);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkout() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.checkout();
      _cart = null;
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

  Future<bool> clearCart() async {
    _error = null;
    notifyListeners();

    try {
      _cart = await _apiService.clearCart();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  int getProductQuantity(String productId) {
    if (_cart == null) return 0;
    final item = _cart!.items.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItem(
        productId: '',
        productName: '',
        unitPrice: 0,
        quantity: 0,
      ),
    );
    return item.quantity;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
