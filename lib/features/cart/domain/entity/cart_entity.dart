import 'package:equatable/equatable.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_item_entity.dart';

class CartEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CartEntity({
    required this.id,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  @override
  List<Object?> get props => [id, items, createdAt, updatedAt];

  CartEntity copyWith({
    String? id,
    List<CartItemEntity>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
