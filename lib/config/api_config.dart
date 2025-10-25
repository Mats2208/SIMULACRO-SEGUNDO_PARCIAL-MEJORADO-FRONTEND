class ApiConfig {
  // Cambia esta URL por la de tu backend
  static const String baseUrl = 'https://ecommerce-upsa.azurewebsites.net/'; // o tu IP/dominio
  
  // Endpoints
  static const String authRegister = '/api/auth/register';
  static const String authLogin = '/api/auth/login';
  static const String products = '/api/products';
  static const String cart = '/api/cart';
  static const String cartAdd = '/api/cart/add';
  static const String cartRemove = '/api/cart/remove';
  static const String cartCheckout = '/api/cart/checkout';
  static const String cartClear = '/api/cart/clear';
  static const String favoritesToggle = '/api/favorites/toggle';
  static const String favorites = '/api/favorites';
}
