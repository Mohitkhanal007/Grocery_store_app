import 'package:flutter_test/flutter_test.dart';
import 'package:grocerystore/features/order/domain/entity/order_entity.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_item_entity.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';

void main() {
  group('OrderEntity Unit Tests', () {
    late OrderEntity testOrder;
    late DateTime now;

    setUp(() {
      now = DateTime.now();
      testOrder = OrderEntity(
        id: 'test_order_123',
        userId: 'test_user_456',
        items: [
          CartItemEntity(
            id: 'item_1',
            product: ProductEntity(
              id: 'product_1',
              team: 'Barcelona',
              type: 'Home Jersey',
              size: 'M',
              price: 29.99,
              quantity: 10,
              categoryId: 'jerseys',
              productImage: 'assets/images/barcelona.png',
              createdAt: now,
              updatedAt: now,
            ),
            quantity: 2,
            selectedSize: 'M',
            addedAt: now,
          ),
        ],
        subtotal: 59.98,
        shippingCost: 5.99,
        totalAmount: 65.97,
        status: OrderStatus.confirmed,
        customerName: 'Test Customer',
        customerEmail: 'test@example.com',
        customerPhone: '123-456-7890',
        shippingAddress: '123 Test Street',
        createdAt: now,
        updatedAt: now,
      );
    });

    test('should create OrderEntity with correct properties', () {
      expect(testOrder.id, 'test_order_123');
      expect(testOrder.userId, 'test_user_456');
      expect(testOrder.items.length, 1);
      expect(testOrder.subtotal, 59.98);
      expect(testOrder.shippingCost, 5.99);
      expect(testOrder.totalAmount, 65.97);
      expect(testOrder.status, OrderStatus.confirmed);
      expect(testOrder.customerName, 'Test Customer');
      expect(testOrder.customerEmail, 'test@example.com');
    });

    test('should calculate total amount correctly', () {
      expect(
        testOrder.totalAmount,
        testOrder.subtotal + testOrder.shippingCost,
      );
    });

    test('should have correct order status', () {
      expect(testOrder.status, OrderStatus.confirmed);
      expect(testOrder.status.toString(), 'OrderStatus.confirmed');
    });

    test('should contain correct cart items', () {
      expect(testOrder.items.length, 1);
      expect(testOrder.items.first.product.team, 'Barcelona');
      expect(testOrder.items.first.quantity, 2);
      expect(testOrder.items.first.selectedSize, 'M');
    });

    test('should have valid customer information', () {
      expect(testOrder.customerName, isNotEmpty);
      expect(testOrder.customerEmail, contains('@'));
      expect(testOrder.customerPhone, isNotEmpty);
      expect(testOrder.shippingAddress, isNotEmpty);
    });
  });
}
