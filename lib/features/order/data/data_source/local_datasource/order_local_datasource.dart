import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocerystore/features/order/domain/entity/order_entity.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_item_entity.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderEntity>> getAllOrders([String? userId]);
  Future<OrderEntity?> getOrderById(String orderId);
  Future<OrderEntity> createOrder(OrderEntity order);
  Future<OrderEntity> updateOrderStatus(String orderId, String status);
  Future<void> deleteOrder(String orderId);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  static const String _ordersKey = 'orders';

  @override
  Future<List<OrderEntity>> getAllOrders([String? userId]) async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getStringList(_ordersKey) ?? [];

    print(
      '🔍 OrderLocalDataSource: Found ${ordersJson.length} orders in SharedPreferences',
    );

    final allOrders = ordersJson
        .map((json) => _orderFromJson(jsonDecode(json)))
        .toList();

    print('🔍 OrderLocalDataSource: Parsed ${allOrders.length} orders');

    // If userId is provided, filter orders by user ID
    if (userId != null && userId.isNotEmpty) {
      final filteredOrders = allOrders
          .where((order) => order.userId == userId)
          .toList();
      print(
        '🔍 OrderLocalDataSource: Filtered to ${filteredOrders.length} orders for userId: $userId',
      );
      for (var order in filteredOrders) {
        print(
          '🔍 OrderLocalDataSource: Order ID: ${order.id}, UserID: ${order.userId}, Status: ${order.status}',
        );
      }
      return filteredOrders;
    }

    return allOrders;
  }

  @override
  Future<OrderEntity?> getOrderById(String orderId) async {
    final orders = await getAllOrders();
    try {
      return orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<OrderEntity> createOrder(OrderEntity order) async {
    print(
      '🔍 OrderLocalDataSource: Creating order with ID: ${order.id}, UserID: ${order.userId}',
    );

    final prefs = await SharedPreferences.getInstance();
    final orders = await getAllOrders();

    orders.add(order);

    final ordersJson = orders
        .map((order) => jsonEncode(_orderToJson(order)))
        .toList();
    await prefs.setStringList(_ordersKey, ordersJson);

    print(
      '🔍 OrderLocalDataSource: Successfully saved order. Total orders now: ${orders.length}',
    );

    return order;
  }

  @override
  Future<OrderEntity> updateOrderStatus(String orderId, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final orders = await getAllOrders();

    final orderIndex = orders.indexWhere((order) => order.id == orderId);
    if (orderIndex == -1) {
      throw Exception('Order not found');
    }

    final order = orders[orderIndex];
    final updatedOrder = order.copyWith(
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == status,
        orElse: () => OrderStatus.pending,
      ),
      updatedAt: DateTime.now(),
    );

    orders[orderIndex] = updatedOrder;

    final ordersJson = orders
        .map((order) => jsonEncode(_orderToJson(order)))
        .toList();
    await prefs.setStringList(_ordersKey, ordersJson);

    return updatedOrder;
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final orders = await getAllOrders();

    orders.removeWhere((order) => order.id == orderId);

    final ordersJson = orders
        .map((order) => jsonEncode(_orderToJson(order)))
        .toList();
    await prefs.setStringList(_ordersKey, ordersJson);
  }

  Map<String, dynamic> _orderToJson(OrderEntity order) {
    return {
      'id': order.id,
      'userId': order.userId,
      'items': order.items.map((item) => _cartItemToJson(item)).toList(),
      'subtotal': order.subtotal,
      'shippingCost': order.shippingCost,
      'totalAmount': order.totalAmount,
      'status': order.status.toString().split('.').last,
      'customerName': order.customerName,
      'customerEmail': order.customerEmail,
      'customerPhone': order.customerPhone,
      'shippingAddress': order.shippingAddress,
      'trackingNumber': order.trackingNumber,
      'createdAt': order.createdAt.toIso8601String(),
      'updatedAt': order.updatedAt.toIso8601String(),
    };
  }

  OrderEntity _orderFromJson(Map<String, dynamic> json) {
    return OrderEntity(
      id: json['id'],
      userId: json['userId'] ?? '',
      items: (json['items'] as List)
          .map((item) => _cartItemFromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      shippingCost: json['shippingCost'].toDouble(),
      totalAmount: json['totalAmount'].toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      customerName: json['customerName'],
      customerEmail: json['customerEmail'],
      customerPhone: json['customerPhone'],
      shippingAddress: json['shippingAddress'],
      trackingNumber: json['trackingNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> _cartItemToJson(CartItemEntity item) {
    return {
      'id': item.id,
      'product': _productToJson(item.product),
      'quantity': item.quantity,
      'selectedSize': item.selectedSize,
      'addedAt': item.addedAt.toIso8601String(),
    };
  }

  CartItemEntity _cartItemFromJson(Map<String, dynamic> json) {
    return CartItemEntity(
      id: json['id'],
      product: _productFromJson(json['product']),
      quantity: json['quantity'],
      selectedSize: json['selectedSize'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  Map<String, dynamic> _productToJson(ProductEntity product) {
    return {
      'id': product.id,
      'team': product.team,
      'type': product.type,
      'size': product.size,
      'price': product.price,
      'quantity': product.quantity,
      'categoryId': product.categoryId,
      'sellerId': product.sellerId,
      'productImage': product.productImage,
      'createdAt': product.createdAt.toIso8601String(),
      'updatedAt': product.updatedAt.toIso8601String(),
    };
  }

  ProductEntity _productFromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'],
      team: json['team'],
      type: json['type'],
      size: json['size'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      categoryId: json['categoryId'],
      sellerId: json['sellerId'],
      productImage: json['productImage'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
