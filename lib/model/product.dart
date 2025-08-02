class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stockQuantity;
  final String unit;
  final String? image;
  final DateTime expiryDate;
  final String brand;
  final bool isOrganic;
  final bool isAvailable;
  final Map<String, dynamic>? nutritionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stockQuantity,
    required this.unit,
    this.image,
    required this.expiryDate,
    required this.brand,
    required this.isOrganic,
    required this.isAvailable,
    this.nutritionalInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      price: json['price'].toDouble(),
      stockQuantity: json['stockQuantity'],
      unit: json['unit'],
      image: json['image'],
      expiryDate: DateTime.parse(json['expiryDate']),
      brand: json['brand'],
      isOrganic: json['isOrganic'] ?? false,
      isAvailable: json['isAvailable'] ?? true,
      nutritionalInfo: json['nutritionalInfo'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'stockQuantity': stockQuantity,
      'unit': unit,
      'image': image,
      'expiryDate': expiryDate.toIso8601String(),
      'brand': brand,
      'isOrganic': isOrganic,
      'isAvailable': isAvailable,
      'nutritionalInfo': nutritionalInfo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
