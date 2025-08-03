import 'package:flutter_test/flutter_test.dart';
import 'package:jerseyhub/features/order/domain/entity/order_entity.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_item_entity.dart';
import 'package:jerseyhub/features/product/domain/entity/product_entity.dart';

void main() {
  group('OrderEntity Tests', () {
    late ProductEntity testProduct;
    late CartItemEntity testCartItem;
    late OrderEntity testOrder;

    setUp(() {
      testProduct = ProductEntity(
        id: 'product_1',
        team: 'Manchester United',
        type: 'Home',
        size: 'M',
        price: 2500.0,
        quantity: 10,
        categoryId: 'category_1',
        sellerId: 'seller_1',
        productImage: 'man_utd_home.jpg',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      testCartItem = CartItemEntity(
        id: 'cart_item_1',
        product: testProduct,
        quantity: 2,
        selectedSize: 'M',
        addedAt: DateTime(2024, 1, 1),
      );

      testOrder = OrderEntity(
        id: 'order_1',
        userId: 'user_1',
        items: [testCartItem],
        subtotal: 5000.0,
        shippingCost: 500.0,
        totalAmount: 5500.0,
        status: OrderStatus.pending,
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        customerPhone: '1234567890',
        shippingAddress: '123 Main St',
        trackingNumber: 'TRK123456',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );
    });

    test('should create OrderEntity with correct properties', () {
      // Assert
      expect(testOrder.id, equals('order_1'));
      expect(testOrder.userId, equals('user_1'));
      expect(testOrder.items.length, equals(1));
      expect(testOrder.subtotal, equals(5000.0));
      expect(testOrder.shippingCost, equals(500.0));
      expect(testOrder.totalAmount, equals(5500.0));
      expect(testOrder.status, equals(OrderStatus.pending));
      expect(testOrder.customerName, equals('John Doe'));
      expect(testOrder.customerEmail, equals('john@example.com'));
      expect(testOrder.customerPhone, equals('1234567890'));
      expect(testOrder.shippingAddress, equals('123 Main St'));
      expect(testOrder.trackingNumber, equals('TRK123456'));
    });

    test('should calculate item count correctly', () {
      // Arrange
      final CartItemEntity secondItem = CartItemEntity(
        id: 'cart_item_2',
        product: testProduct,
        quantity: 3,
        selectedSize: 'L',
        addedAt: DateTime(2024, 1, 1),
      );

      final OrderEntity orderWithMultipleItems = OrderEntity(
        id: 'order_2',
        userId: 'user_1',
        items: [testCartItem, secondItem],
        subtotal: 12500.0,
        shippingCost: 500.0,
        totalAmount: 13000.0,
        status: OrderStatus.pending,
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        customerPhone: '1234567890',
        shippingAddress: '123 Main St',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // Assert
      expect(orderWithMultipleItems.itemCount, equals(5)); // 2 + 3
    });

    test('should create copy with updated properties', () {
      // Act
      final updatedOrder = testOrder.copyWith(
        status: OrderStatus.processing,
        trackingNumber: 'TRK789012',
      );

      // Assert
      expect(updatedOrder.id, equals(testOrder.id));
      expect(updatedOrder.status, equals(OrderStatus.processing));
      expect(updatedOrder.trackingNumber, equals('TRK789012'));
      expect(updatedOrder.customerName, equals(testOrder.customerName));
    });

    test('should convert to JSON correctly', () {
      // Act
      final json = testOrder.toJson();

      // Assert
      expect(json['id'], equals('order_1'));
      expect(json['userId'], equals('user_1'));
      expect(json['total'], equals(5500.0));
      expect(json['status'], equals('pending'));
      expect(json['customerInfo']['name'], equals('John Doe'));
      expect(json['customerInfo']['email'], equals('john@example.com'));
      expect(json['customerInfo']['phone'], equals('1234567890'));
      expect(json['customerInfo']['address'], equals('123 Main St'));
      expect(json['paymentMethod'], equals('esewa'));
    });

    test('should create from JSON with customerInfo object', () {
      // Arrange
      final json = {
        '_id': 'order_2',
        'userId': 'user_2',
        'products': [
          {
            '_id': 'product_2',
            'name': 'Barcelona Away',
            'quantity': 1,
            'price': 3000.0,
            'productImage': 'barca_away.jpg',
          }
        ],
        'total': 3000.0,
        'status': 'processing',
        'customerInfo': {
          'name': 'Jane Smith',
          'email': 'jane@example.com',
          'phone': '9876543210',
          'address': '456 Oak St',
        },
        'paymentMethod': 'cash_on_delivery',
        'date': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-01T00:00:00.000Z',
      };

      // Act
      final order = OrderEntity.fromJson(json);

      // Assert
      expect(order.id, equals('order_2'));
      expect(order.userId, equals('user_2'));
      expect(order.items.length, equals(1));
      expect(order.totalAmount, equals(3000.0));
      expect(order.status, equals(OrderStatus.processing));
      expect(order.customerName, equals('Jane Smith'));
      expect(order.customerEmail, equals('jane@example.com'));
      expect(order.customerPhone, equals('9876543210'));
      expect(order.shippingAddress, equals('456 Oak St'));
    });

    test('should create from JSON with old schema (direct fields)', () {
      // Arrange
      final json = {
        '_id': 'order_3',
        'userId': 'user_3',
        'products': [
          {
            '_id': 'product_3',
            'name': 'Liverpool Home',
            'quantity': 2,
            'price': 2800.0,
            'productImage': 'liverpool_home.jpg',
          }
        ],
        'total': 5600.0,
        'status': 'completed',
        'customerName': 'Bob Wilson',
        'customerEmail': 'bob@example.com',
        'customerPhone': '5551234567',
        'shippingAddress': '789 Pine St',
        'date': '2024-01-01T00:00:00.000Z',
      };

      // Act
      final order = OrderEntity.fromJson(json);

      // Assert
      expect(order.id, equals('order_3'));
      expect(order.userId, equals('user_3'));
      expect(order.items.length, equals(1));
      expect(order.totalAmount, equals(5600.0));
      expect(order.status, equals(OrderStatus.completed));
      expect(order.customerName, equals('Bob Wilson'));
      expect(order.customerEmail, equals('bob@example.com'));
      expect(order.customerPhone, equals('5551234567'));
      expect(order.shippingAddress, equals('789 Pine St'));
    });

    test('should handle status conversion correctly', () {
      // Test all status conversions
      expect(OrderEntity._getStatusString(OrderStatus.pending), equals('pending'));
      expect(OrderEntity._getStatusString(OrderStatus.confirmed), equals('confirmed'));
      expect(OrderEntity._getStatusString(OrderStatus.processing), equals('processing'));
      expect(OrderEntity._getStatusString(OrderStatus.shipped), equals('shipped'));
      expect(OrderEntity._getStatusString(OrderStatus.delivered), equals('delivered'));
      expect(OrderEntity._getStatusString(OrderStatus.cancelled), equals('cancelled'));
    });

    test('should handle status parsing correctly', () {
      // Test all status parsing
      expect(OrderEntity._getStatusFromString('pending'), equals(OrderStatus.pending));
      expect(OrderEntity._getStatusFromString('confirmed'), equals(OrderStatus.confirmed));
      expect(OrderEntity._getStatusFromString('processing'), equals(OrderStatus.processing));
      expect(OrderEntity._getStatusFromString('shipped'), equals(OrderStatus.shipped));
      expect(OrderEntity._getStatusFromString('delivered'), equals(OrderStatus.delivered));
      expect(OrderEntity._getStatusFromString('cancelled'), equals(OrderStatus.cancelled));
      expect(OrderEntity._getStatusFromString('unknown'), equals(OrderStatus.pending));
    });

    test('should handle empty products list', () {
      // Arrange
      final emptyOrder = OrderEntity(
        id: 'empty_order',
        userId: 'user_1',
        items: [],
        subtotal: 0.0,
        shippingCost: 0.0,
        totalAmount: 0.0,
        status: OrderStatus.pending,
        customerName: 'Test User',
        customerEmail: 'test@example.com',
        customerPhone: '1234567890',
        shippingAddress: 'Test Address',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // Assert
      expect(emptyOrder.items.length, equals(0));
      expect(emptyOrder.itemCount, equals(0));
    });

    test('should be equal when properties are the same', () {
      // Arrange
      final identicalOrder = OrderEntity(
        id: 'order_1',
        userId: 'user_1',
        items: [testCartItem],
        subtotal: 5000.0,
        shippingCost: 500.0,
        totalAmount: 5500.0,
        status: OrderStatus.pending,
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        customerPhone: '1234567890',
        shippingAddress: '123 Main St',
        trackingNumber: 'TRK123456',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // Assert
      expect(testOrder, equals(identicalOrder));
    });
  });
} 