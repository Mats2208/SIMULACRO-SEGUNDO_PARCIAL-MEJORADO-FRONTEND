import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/models.dart';
import 'storage_service.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiService {
  final StorageService _storageService = StorageService();

  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (includeAuth) {
      final token = await _storageService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<dynamic> _handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      String errorMessage = 'Error en la solicitud';
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['message'] ?? errorData['title'] ?? errorMessage;
      } catch (e) {
        errorMessage = response.body.isNotEmpty ? response.body : errorMessage;
      }
      throw ApiException(errorMessage, response.statusCode);
    }
  }

  // Auth endpoints
  Future<AuthResponse> register({
    required String email,
    required String password,
    required Role role,
    String? companyName,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.authRegister}');
    final headers = await _getHeaders(includeAuth: false);
    
    final body = jsonEncode({
      'email': email,
      'password': password,
      'role': role.value,
      'companyName': companyName,
    });

    final response = await http.post(url, headers: headers, body: body);
    final data = await _handleResponse(response);
    
    return AuthResponse.fromJson(data);
  }

  // Admin crea usuarios (requiere JWT de admin)
  Future<AuthResponse> registerAsAdmin({
    required String email,
    required String password,
    required Role role,
    String? companyName,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.authRegister}');
    final headers = await _getHeaders(includeAuth: true); // Envía token JWT
    
    final body = jsonEncode({
      'email': email,
      'password': password,
      'role': role.value,
      'companyName': companyName,
    });

    final response = await http.post(url, headers: headers, body: body);
    final data = await _handleResponse(response);
    
    return AuthResponse.fromJson(data);
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.authLogin}');
    final headers = await _getHeaders(includeAuth: false);
    
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await http.post(url, headers: headers, body: body);
    final data = await _handleResponse(response);
    
    return AuthResponse.fromJson(data);
  }

  // Products endpoints
  Future<List<Product>> getProducts({bool onlyActive = true}) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.products}?onlyActive=$onlyActive'
    );
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);
    final data = await _handleResponse(response);
    
    return (data as List).map((item) => Product.fromJson(item)).toList();
  }

  Future<Product> getProduct(String id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}/$id');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);
    final data = await _handleResponse(response);
    
    return Product.fromJson(data);
  }

  Future<Product> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}');
    final headers = await _getHeaders();
    
    final body = jsonEncode({
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
    });

    final response = await http.post(url, headers: headers, body: body);
    final data = await _handleResponse(response);
    
    return Product.fromJson(data);
  }

  Future<Product> updateProduct(
    String id, {
    String? name,
    String? description,
    double? price,
    int? stock,
    bool? isActive,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}/$id');
    final headers = await _getHeaders();
    
    final bodyMap = <String, dynamic>{};
    if (name != null) bodyMap['name'] = name;
    if (description != null) bodyMap['description'] = description;
    if (price != null) bodyMap['price'] = price;
    if (stock != null) bodyMap['stock'] = stock;
    if (isActive != null) bodyMap['isActive'] = isActive;

    final response = await http.patch(
      url,
      headers: headers,
      body: jsonEncode(bodyMap),
    );
    final data = await _handleResponse(response);
    
    return Product.fromJson(data);
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}/$id');
    final headers = await _getHeaders();

    final response = await http.delete(url, headers: headers);
    await _handleResponse(response);
  }

  // Cart endpoints
  Future<Cart> getCart() async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.cart}');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);
    final data = await _handleResponse(response);
    
    return Cart.fromJson(data);
  }

  Future<Cart> addToCart(String productId, int quantity) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.cartAdd}');
    final headers = await _getHeaders();
    
    final body = jsonEncode({
      'productId': productId,
      'quantity': quantity,
    });

    final response = await http.post(url, headers: headers, body: body);
    final data = await _handleResponse(response);
    
    return Cart.fromJson(data);
  }

  Future<Cart> removeFromCart(String productId, int quantity) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.cartRemove}');
    final headers = await _getHeaders();
    
    final body = jsonEncode({
      'productId': productId,
      'quantity': quantity,
    });

    final response = await http.post(url, headers: headers, body: body);
    final data = await _handleResponse(response);
    
    return Cart.fromJson(data);
  }

  Future<void> checkout() async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.cartCheckout}');
    final headers = await _getHeaders();

    final response = await http.post(url, headers: headers);
    await _handleResponse(response);
  }

  Future<Cart> clearCart() async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.cartClear}');
    final headers = await _getHeaders();

    final response = await http.post(url, headers: headers);
    final data = await _handleResponse(response);
    
    return Cart.fromJson(data);
  }

  // Favorites endpoints
  Future<void> toggleFavorite(String productId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.favoritesToggle}');
    final headers = await _getHeaders();
    
    final body = jsonEncode({
      'productId': productId,
    });

    final response = await http.post(url, headers: headers, body: body);
    await _handleResponse(response);
  }

  Future<List<Product>> getFavorites() async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.favorites}');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);
    final data = await _handleResponse(response);
    
    return (data as List).map((item) => Product.fromJson(item)).toList();
  }
}
