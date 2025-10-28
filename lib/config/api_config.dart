class ApiConfig {
  // Cambia esta URL por la de tu backend
  static const String baseUrl = 'https://webappecommerce2.azurewebsites.net'; // o tu IP/dominio
  
  // Endpoints - Auth
  static const String authRegister = '/api/auth/register';
  static const String authLogin = '/api/auth/login';
  
  // Endpoints - Products
  static const String products = '/api/products';
  
  // Endpoints - Cart
  static const String cart = '/api/cart';
  static const String cartAdd = '/api/cart/add';
  static const String cartRemove = '/api/cart/remove';
  static const String cartCheckout = '/api/cart/checkout';
  static const String cartClear = '/api/cart/clear';
  
  // Endpoints - Favorites
  static const String favoritesToggle = '/api/favorites/toggle';
  static const String favorites = '/api/favorites';
  
  // Endpoints - Favorites Stats
  static const String favoritesStatsProduct = '/api/favorites/stats/product';
  static const String favoritesStatsTop = '/api/favorites/stats/top';
  static const String favoritesStatsMine = '/api/favorites/stats/mine';
  static const String favoritesStatsCompany = '/api/favorites/stats/company';
}
