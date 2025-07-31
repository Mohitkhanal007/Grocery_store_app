import 'package:jerseyhub/features/product/domain/entity/product_entity.dart';

class ProductApiModel {
  final String id;
  final String team;
  final String type;
  final String size;
  final double price;
  final int quantity;
  final String categoryId;
  final String? sellerId;
  final String productImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductApiModel({
    required this.id,
    required this.team,
    required this.type,
    required this.size,
    required this.price,
    required this.quantity,
    required this.categoryId,
    this.sellerId,
    required this.productImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) {
    return ProductApiModel(
      id: json['_id'] ?? json['id'] ?? '',
      team: json['team'] ?? '',
      type: json['type'] ?? '',
      size: json['size'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      categoryId: json['categoryId'] ?? '',
      sellerId: json['sellerId'],
      productImage: json['productImage'] ?? '',
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
      'team': team,
      'type': type,
      'size': size,
      'price': price,
      'quantity': quantity,
      'categoryId': categoryId,
      'sellerId': sellerId,
      'productImage': productImage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      team: team,
      type: type,
      size: size,
      price: price,
      quantity: quantity,
      categoryId: categoryId,
      sellerId: sellerId,
      productImage: productImage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ProductApiModel.fromEntity(ProductEntity entity) {
    return ProductApiModel(
      id: entity.id,
      team: entity.team,
      type: entity.type,
      size: entity.size,
      price: entity.price,
      quantity: entity.quantity,
      categoryId: entity.categoryId,
      sellerId: entity.sellerId,
      productImage: entity.productImage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
