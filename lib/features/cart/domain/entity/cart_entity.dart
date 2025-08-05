import 'package:equatable/equatable.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_item_entity.dart';

class CartEntity extends Equatable {
  final String id;
  final String? userId; // Add user ID for backend sync
  final List<CartItemEntity> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced; // Track sync status with backend

  const CartEntity({
    required this.id,
    this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  // Calculate shipping cost based on total
  double get shippingCost {
    if (totalPrice >= 1000) return 0.0; // Free shipping above रू1000
    return 5.99; // Standard shipping cost
  }

  // Calculate final total including shipping
  double get finalTotal => totalPrice + shippingCost;

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    createdAt,
    updatedAt,
    isSynced,
  ];

  CartEntity copyWith({
    String? id,
    String? userId,
    List<CartItemEntity>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return CartEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  // Convert to JSON for backend API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  // Create from JSON from backend API
  factory CartEntity.fromJson(Map<String, dynamic> json) {
    return CartEntity(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List)
          .map((itemJson) => CartItemEntity.fromJson(itemJson))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isSynced: json['isSynced'] ?? true,
    );
  }
}
