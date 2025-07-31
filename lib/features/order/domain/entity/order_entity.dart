import 'package:equatable/equatable.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_item_entity.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

class OrderEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;
  final double subtotal;
  final double shippingCost;
  final double totalAmount;
  final OrderStatus status;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String shippingAddress;
  final String? trackingNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.totalAmount,
    required this.status,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.shippingAddress,
    this.trackingNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  OrderEntity copyWith({
    String? id,
    List<CartItemEntity>? items,
    double? subtotal,
    double? shippingCost,
    double? totalAmount,
    OrderStatus? status,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? shippingAddress,
    String? trackingNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        items,
        subtotal,
        shippingCost,
        totalAmount,
        status,
        customerName,
        customerEmail,
        customerPhone,
        shippingAddress,
        trackingNumber,
        createdAt,
        updatedAt,
      ];
} 