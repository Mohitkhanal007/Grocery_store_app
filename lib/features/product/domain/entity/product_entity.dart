import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
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

  const ProductEntity({
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

  @override
  List<Object?> get props => [
    id,
    team,
    type,
    size,
    price,
    quantity,
    categoryId,
    sellerId,
    productImage,
    createdAt,
    updatedAt,
  ];

  ProductEntity copyWith({
    String? id,
    String? team,
    String? type,
    String? size,
    double? price,
    int? quantity,
    String? categoryId,
    String? sellerId,
    String? productImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      team: team ?? this.team,
      type: type ?? this.type,
      size: size ?? this.size,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      categoryId: categoryId ?? this.categoryId,
      sellerId: sellerId ?? this.sellerId,
      productImage: productImage ?? this.productImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
