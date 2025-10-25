import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null && _token != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _storageService.getUser();
      _token = await _storageService.getToken();
    } catch (e) {
      _error = 'Error cargando usuario';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );

      _token = response.token;
      _user = User(
        id: response.userId,
        email: email,
        role: response.role,
        isRoot: response.isRoot,
      );

      await _storageService.saveToken(response.token);
      await _storageService.saveUser(_user!);

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

  Future<bool> register({
    required String email,
    required String password,
    required Role role,
    String? companyName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.register(
        email: email,
        password: password,
        role: role,
        companyName: companyName,
      );

      _token = response.token;
      _user = User(
        id: response.userId,
        email: email,
        role: response.role,
        isRoot: response.isRoot,
        companyName: companyName,
      );

      await _storageService.saveToken(response.token);
      await _storageService.saveUser(_user!);

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

  // Admin creates user without logging in as them
  Future<bool> createUserAsAdmin({
    required String email,
    required String password,
    required Role role,
    String? companyName,
  }) async {
    _error = null;
    notifyListeners();

    try {
      // Usa registerAsAdmin que envía el token JWT
      await _apiService.registerAsAdmin(
        email: email,
        password: password,
        role: role,
        companyName: companyName,
      );
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    await _storageService.clearAll();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
