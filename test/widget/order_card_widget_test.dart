import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocerystore/features/order/presentation/widgets/order_card_widget.dart';
import 'package:grocerystore/features/order/domain/entity/order_entity.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_item_entity.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';
import 'package:grocerystore/features/order/presentation/viewmodel/order_viewmodel.dart';

void main() {
  group('OrderCardWidget Widget Tests', () {
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

    testWidgets('should render order card with correct information', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderCardWidget(
              order: testOrder,
              orderViewModel: MockOrderViewModel(),
            ),
          ),
        ),
      );

      // Check if order ID is displayed
      expect(find.textContaining('test_order_123'), findsOneWidget);

      // Check if total amount is displayed
      expect(find.textContaining('65.97'), findsOneWidget);

      // Check if status is displayed
      expect(find.textContaining('Confirmed'), findsOneWidget);
    });

    testWidgets('should display order details correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderCardWidget(
              order: testOrder,
              orderViewModel: MockOrderViewModel(),
            ),
          ),
        ),
      );

      // Check if customer name is displayed
      expect(find.textContaining('Test Customer'), findsOneWidget);

      // Check if order date is displayed
      expect(find.textContaining('Order Date:'), findsOneWidget);
    });

    testWidgets('should handle different order statuses', (
      WidgetTester tester,
    ) async {
      OrderEntity pendingOrder = testOrder.copyWith(
        status: OrderStatus.pending,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderCardWidget(
              order: pendingOrder,
              orderViewModel: MockOrderViewModel(),
            ),
          ),
        ),
      );

      expect(find.textContaining('Pending'), findsOneWidget);
    });

    testWidgets('should display order items count', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderCardWidget(
              order: testOrder,
              orderViewModel: MockOrderViewModel(),
            ),
          ),
        ),
      );

      // Check if items count is displayed
      expect(find.textContaining('Items:'), findsOneWidget);
    });

    testWidgets('should have proper card structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderCardWidget(
              order: testOrder,
              orderViewModel: MockOrderViewModel(),
            ),
          ),
        ),
      );

      // Check if card container exists
      expect(find.byType(Card), findsOneWidget);

      // Check if order information is displayed
      expect(find.textContaining('Order ID:'), findsOneWidget);
    });
  });
}

class MockOrderViewModel extends OrderViewModel {
  MockOrderViewModel()
    : super(
        getAllOrdersUseCase: MockGetAllOrdersUseCase(),
        getOrderByIdUseCase: MockGetOrderByIdUseCase(),
        createOrderUseCase: MockCreateOrderUseCase(),
        updateOrderStatusUseCase: MockUpdateOrderStatusUseCase(),
        deleteOrderUseCase: MockDeleteOrderUseCase(),
        userSharedPrefs: MockUserSharedPrefs(),
      );
}

// Simple mock classes
class MockGetAllOrdersUseCase {
  Future<dynamic> call(dynamic params) async => [];
}

class MockGetOrderByIdUseCase {
  Future<dynamic> call(dynamic params) async => null;
}

class MockCreateOrderUseCase {
  Future<dynamic> call(dynamic params) async => null;
}

class MockUpdateOrderStatusUseCase {
  Future<dynamic> call(dynamic params) async => null;
}

class MockDeleteOrderUseCase {
  Future<dynamic> call(dynamic params) async => null;
}

class MockUserSharedPrefs {
  String? getCurrentUserId() => 'test_user_id';
  String? getCurrentUserEmail() => 'test@example.com';
  String? getCurrentUsername() => 'Test User';
  Future<void> saveUserData(
    String userId,
    String email,
    String username,
  ) async {}
  Future<void> clearUserData() async {}
}
