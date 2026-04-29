class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final bool isVerified;
  final String? businessName;
  final String? businessType;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.isVerified,
    this.businessName,
    this.businessType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      isVerified: json['is_verified'] ?? false,
      businessName: json['business_name'],
      businessType: json['business_type'],
    );
  }

  bool get isVerifiedBusiness => role == 'business' && isVerified;
  bool get canAccessMedicines => isVerifiedBusiness;
}

class Product {
  final int id;
  final String name;
  final String? description;
  final String category;
  final double price;
  final int stock;
  final String? imageUrl;
  final bool requiresVerification;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.price,
    required this.stock,
    this.imageUrl,
    required this.requiresVerification,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      price: double.parse(json['price'].toString()),
      stock: json['stock'] ?? 0,
      imageUrl: json['image_url'],
      requiresVerification: json['requires_verification'] ?? false,
    );
  }

  bool get isMedicine => category == 'medicine' || requiresVerification;
  bool get isEquipment => category == 'equipment';
}

class Order {
  final int id;
  final String orderNumber;
  final String status;
  final double totalAmount;
  final String shippingAddress;
  final String? paymentMethod;
  final String paymentStatus;
  final List<OrderItem> items;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.shippingAddress,
    this.paymentMethod,
    required this.paymentStatus,
    required this.items,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNumber: json['order_number'],
      status: json['status'],
      totalAmount: double.parse(json['total_amount'].toString()),
      shippingAddress: json['shipping_address'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      items: (json['items'] as List?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class OrderItem {
  final int id;
  final Product product;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  OrderItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      unitPrice: double.parse(json['unit_price'].toString()),
      subtotal: double.parse(json['subtotal'].toString()),
    );
  }
}

class VerificationDocument {
  final int id;
  final String documentType;
  final String status;
  final String? reviewNotes;
  final DateTime? reviewedAt;
  final DateTime createdAt;

  VerificationDocument({
    required this.id,
    required this.documentType,
    required this.status,
    this.reviewNotes,
    this.reviewedAt,
    required this.createdAt,
  });

  factory VerificationDocument.fromJson(Map<String, dynamic> json) {
    return VerificationDocument(
      id: json['id'],
      documentType: json['document_type'],
      status: json['status'],
      reviewNotes: json['review_notes'],
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
