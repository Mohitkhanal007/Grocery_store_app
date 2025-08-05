import 'package:grocerystore/features/product/domain/entity/product_entity.dart';

class ProductApiModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stockQuantity;
  final String unit;
  final String? image;
  final DateTime? expiryDate;
  final String brand;
  final bool isOrganic;
  final bool isAvailable;
  final Map<String, dynamic>? nutritionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductApiModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stockQuantity,
    required this.unit,
    this.image,
    this.expiryDate,
    required this.brand,
    required this.isOrganic,
    required this.isAvailable,
    this.nutritionalInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) {
    return ProductApiModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stockQuantity: json['stockQuantity'] ?? 0,
      unit: json['unit'] ?? '',
      image: json['image'],
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      brand: json['brand'] ?? '',
      isOrganic: json['isOrganic'] ?? false,
      isAvailable: json['isAvailable'] ?? true,
      nutritionalInfo: json['nutritionalInfo'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'stockQuantity': stockQuantity,
      'unit': unit,
      'image': image,
      'expiryDate': expiryDate?.toIso8601String(),
      'brand': brand,
      'isOrganic': isOrganic,
      'isAvailable': isAvailable,
      'nutritionalInfo': nutritionalInfo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      team: name, // Map name to team for compatibility
      type: category, // Map category to type for compatibility
      size: unit, // Map unit to size for compatibility
      price: price,
      quantity: stockQuantity,
      categoryId: category,
      productImage: image ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ProductApiModel.fromEntity(ProductEntity entity) {
    return ProductApiModel(
      id: entity.id,
      name: entity.team, // Map team to name
      description: entity.type, // Map type to description
      category: entity.categoryId,
      price: entity.price,
      stockQuantity: entity.quantity,
      unit: entity.size, // Map size to unit
      image: entity.productImage.isNotEmpty ? entity.productImage : null,
      brand: 'Grocery Store',
      isOrganic: false,
      isAvailable: true,
      nutritionalInfo: null,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
