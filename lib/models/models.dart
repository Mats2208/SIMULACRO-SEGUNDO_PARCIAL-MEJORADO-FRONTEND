enum Role {
  adminRoot(0), // Cambiado de 'admin' a 'adminRoot' para coincidir con backend
  company(1),
  client(2);

  final int value;
  const Role(this.value);

  static Role fromInt(int value) {
    return Role.values.firstWhere((e) => e.value == value);
  }
}

enum CartStatus {
  active(0),
  checkedOut(1),
  cancelled(2);

  final int value;
  const CartStatus(this.value);

  static CartStatus fromInt(int value) {
    return CartStatus.values.firstWhere((e) => e.value == value);
  }
}

class User {
  final String id;
  final String email;
  final Role role;
  final bool isRoot;
  final String? companyName;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.isRoot,
    this.companyName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'],
      email: json['email'] ?? '',
      role: Role.fromInt(json['role']),
      isRoot: json['isRoot'] ?? false,
      companyName: json['companyName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'email': email,
      'role': role.value,
      'isRoot': isRoot,
      'companyName': companyName,
    };
  }

  String get roleDisplay {
    switch (role) {
      case Role.adminRoot:
        return 'Administrador';
      case Role.company:
        return 'Empresa';
      case Role.client:
        return 'Cliente';
    }
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final bool isActive;
  final String ownerCompanyUserId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.isActive,
    required this.ownerCompanyUserId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      isActive: json['isActive'] ?? true,
      ownerCompanyUserId: json['ownerCompanyUserId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'isActive': isActive,
      'ownerCompanyUserId': ownerCompanyUserId,
    };
  }
}

class CartItem {
  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      productName: json['productName'] ?? '',
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
    );
  }

  double get total => unitPrice * quantity;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'unitPrice': unitPrice,
      'quantity': quantity,
    };
  }
}

class Cart {
  final String id;
  final String clientUserId;
  final List<CartItem> items;
  final double total;
  final CartStatus status;

  Cart({
    required this.id,
    required this.clientUserId,
    required this.items,
    required this.total,
    required this.status,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      clientUserId: json['clientUserId'],
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      total: (json['total'] ?? 0).toDouble(),
      status: CartStatus.fromInt(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientUserId': clientUserId,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'status': status.value,
    };
  }
}

class AuthResponse {
  final String token;
  final String userId;
  final Role role;
  final bool isRoot;

  AuthResponse({
    required this.token,
    required this.userId,
    required this.role,
    required this.isRoot,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      userId: json['userId'],
      role: Role.fromInt(json['role']),
      isRoot: json['isRoot'] ?? false,
    );
  }
}

// Modelo para representar usuarios en el sistema (para admin)
class UserAccount {
  final String id;
  final String email;
  final Role role;
  final bool isRoot;
  final String? companyName;
  final DateTime? createdAt;

  UserAccount({
    required this.id,
    required this.email,
    required this.role,
    required this.isRoot,
    this.companyName,
    this.createdAt,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      id: json['id'] ?? json['userId'],
      email: json['email'] ?? '',
      role: Role.fromInt(json['role']),
      isRoot: json['isRoot'] ?? false,
      companyName: json['companyName'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }

  String get roleDisplay {
    switch (role) {
      case Role.adminRoot:
        return 'Administrador';
      case Role.company:
        return 'Empresa';
      case Role.client:
        return 'Cliente';
    }
  }
}

// Modelo para representar empresas
class Company {
  final String id;
  final String name;
  final String email;
  final int productCount;
  final bool isActive;

  Company({
    required this.id,
    required this.name,
    required this.email,
    required this.productCount,
    this.isActive = true,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] ?? json['userId'] ?? '',
      name: json['companyName'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      productCount: json['productCount'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }
}

// Modelos para Favoritos
class Favorite {
  final String productId;
  final Product? product;

  Favorite({
    required this.productId,
    this.product,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      productId: json['productId'] ?? '',
      product: json['product'] != null 
          ? Product.fromJson(json['product']) 
          : null,
    );
  }
}

// Estadísticas de favoritos por producto
class ProductFavoriteStats {
  final String productId;
  final String productName;
  final int favoriteCount;
  final Product? product;

  ProductFavoriteStats({
    required this.productId,
    required this.productName,
    required this.favoriteCount,
    this.product,
  });

  factory ProductFavoriteStats.fromJson(Map<String, dynamic> json) {
    return ProductFavoriteStats(
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? json['name']?.toString() ?? '',
      favoriteCount: _parseIntValue(json['favoriteCount'] ?? json['count']),
      product: json['product'] != null 
          ? Product.fromJson(json['product']) 
          : null,
    );
  }

  static int _parseIntValue(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

// Top productos más favoritos
class TopFavoriteProduct {
  final String productId;
  final String productName;
  final int favoriteCount;
  final Product? product;

  TopFavoriteProduct({
    required this.productId,
    required this.productName,
    required this.favoriteCount,
    this.product,
  });

  factory TopFavoriteProduct.fromJson(Map<String, dynamic> json) {
    return TopFavoriteProduct(
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? json['name']?.toString() ?? '',
      favoriteCount: _parseIntValue(json['favoriteCount'] ?? json['count']),
      product: json['product'] != null 
          ? Product.fromJson(json['product']) 
          : null,
    );
  }

  static int _parseIntValue(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

// Estadísticas de favoritos de empresa
class CompanyFavoriteStats {
  final String companyUserId;
  final String companyName;
  final int totalFavorites;
  final List<ProductFavoriteStats> products;

  CompanyFavoriteStats({
    required this.companyUserId,
    required this.companyName,
    required this.totalFavorites,
    required this.products,
  });

  factory CompanyFavoriteStats.fromJson(Map<String, dynamic> json) {
    return CompanyFavoriteStats(
      companyUserId: json['companyUserId']?.toString() ?? json['userId']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? json['name']?.toString() ?? '',
      totalFavorites: _parseIntValue(json['totalFavorites'] ?? json['total']),
      products: _parseProductsList(json['products']),
    );
  }

  static int _parseIntValue(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static List<ProductFavoriteStats> _parseProductsList(dynamic value) {
    if (value == null) return [];
    if (value is! List) return [];
    return value
        .map((item) {
          try {
            return ProductFavoriteStats.fromJson(item as Map<String, dynamic>);
          } catch (e) {
            print('Error parsing product stats: $e');
            return null;
          }
        })
        .whereType<ProductFavoriteStats>()
        .toList();
  }
}
