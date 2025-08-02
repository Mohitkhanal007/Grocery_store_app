import 'package:equatable/equatable.dart';
import 'package:jerseyhub/features/product/domain/entity/product_entity.dart';

class CartItemEntity extends Equatable {
  final String id;
  final ProductEntity product;
  final int quantity;
  final String selectedSize;
  final DateTime addedAt;

  const CartItemEntity({
    required this.id,
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.addedAt,
  });

  double get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [id, product, quantity, selectedSize, addedAt];

  CartItemEntity copyWith({
    String? id,
    ProductEntity? product,
    int? quantity,
    String? selectedSize,
    DateTime? addedAt,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  // Convert to JSON for backend API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'selectedSize': selectedSize,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  // Create from JSON from backend API
  factory CartItemEntity.fromJson(Map<String, dynamic> json) {
    return CartItemEntity(
      id: json['id'],
      product: ProductEntity.fromJson(json['product']),
      quantity: json['quantity'],
      selectedSize: json['selectedSize'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }
}
