import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:grocerystore/features/order/presentation/viewmodel/order_viewmodel.dart';
import 'package:grocerystore/features/order/domain/entity/order_entity.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_item_entity.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';

void main() {
  group('OrderViewModel Bloc Tests', () {
    late OrderViewModel orderViewModel;
    late MockGetAllOrdersUseCase mockGetAllOrdersUseCase;
    late MockGetOrderByIdUseCase mockGetOrderByIdUseCase;
    late MockCreateOrderUseCase mockCreateOrderUseCase;
    late MockUpdateOrderStatusUseCase mockUpdateOrderStatusUseCase;
    late MockDeleteOrderUseCase mockDeleteOrderUseCase;
    late MockUserSharedPrefs mockUserSharedPrefs;

    setUp(() {
      mockGetAllOrdersUseCase = MockGetAllOrdersUseCase();
      mockGetOrderByIdUseCase = MockGetOrderByIdUseCase();
      mockCreateOrderUseCase = MockCreateOrderUseCase();
      mockUpdateOrderStatusUseCase = MockUpdateOrderStatusUseCase();
      mockDeleteOrderUseCase = MockDeleteOrderUseCase();
      mockUserSharedPrefs = MockUserSharedPrefs();

      orderViewModel = OrderViewModel(
        getAllOrdersUseCase: mockGetAllOrdersUseCase,
        getOrderByIdUseCase: mockGetOrderByIdUseCase,
        createOrderUseCase: mockCreateOrderUseCase,
        updateOrderStatusUseCase: mockUpdateOrderStatusUseCase,
        deleteOrderUseCase: mockDeleteOrderUseCase,
        userSharedPrefs: mockUserSharedPrefs,
      );
    });

    tearDown(() {
      orderViewModel.close();
    });

    test('initial state should be OrderInitial', () {
      expect(orderViewModel.state, isA<OrderInitial>());
    });

    blocTest<OrderViewModel, OrderState>(
      'should emit [OrderLoading, OrdersLoaded] when LoadAllOrdersEvent is added',
      build: () {
        when(mockUserSharedPrefs.getCurrentUserId()).thenReturn('test_user_id');
        when(
          mockGetAllOrdersUseCase.call(any),
        ).thenAnswer((_) async => const Right([]));
        return orderViewModel;
      },
      act: (bloc) => bloc.add(const LoadAllOrdersEvent(userId: 'test_user_id')),
      expect: () => [isA<OrderLoading>(), isA<OrdersLoaded>()],
    );

    blocTest<OrderViewModel, OrderState>(
      'should emit [OrderLoading, OrderError] when LoadAllOrdersEvent fails',
      build: () {
        when(mockUserSharedPrefs.getCurrentUserId()).thenReturn('test_user_id');
        when(
          mockGetAllOrdersUseCase.call(any),
        ).thenAnswer((_) async => const Left(ServerFailure('Error')));
        return orderViewModel;
      },
      act: (bloc) => bloc.add(const LoadAllOrdersEvent(userId: 'test_user_id')),
      expect: () => [isA<OrderLoading>(), isA<OrderError>()],
    );

    blocTest<OrderViewModel, OrderState>(
      'should emit [OrderLoading, OrderCreated] when CreateOrderEvent is added',
      build: () {
        when(mockUserSharedPrefs.getCurrentUserId()).thenReturn('test_user_id');
        when(
          mockCreateOrderUseCase.call(any),
        ).thenAnswer((_) async => const Right(testOrder));
        return orderViewModel;
      },
      act: (bloc) => bloc.add(CreateOrderEvent(order: testOrder)),
      expect: () => [isA<OrderLoading>(), isA<OrderCreated>()],
    );

    blocTest<OrderViewModel, OrderState>(
      'should emit [OrderLoading, OrderDeleted] when DeleteOrderEvent is added',
      build: () {
        when(mockUserSharedPrefs.getCurrentUserId()).thenReturn('test_user_id');
        when(
          mockDeleteOrderUseCase.call(any),
        ).thenAnswer((_) async => const Right(null));
        return orderViewModel;
      },
      act: (bloc) => bloc.add(const DeleteOrderEvent(orderId: 'test_order_id')),
      expect: () => [isA<OrderLoading>(), isA<OrderDeleted>()],
    );
  });
}

// Mock classes
class MockGetAllOrdersUseCase {
  Future<dynamic> call(dynamic params) async => const Right([]);
}

class MockGetOrderByIdUseCase {
  Future<dynamic> call(dynamic params) async => const Right(null);
}

class MockCreateOrderUseCase {
  Future<dynamic> call(dynamic params) async => const Right(testOrder);
}

class MockUpdateOrderStatusUseCase {
  Future<dynamic> call(dynamic params) async => const Right(null);
}

class MockDeleteOrderUseCase {
  Future<dynamic> call(dynamic params) async => const Right(null);
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

// Test data
final testOrder = OrderEntity(
  id: 'test_order_123',
  userId: 'test_user_456',
  items: [],
  subtotal: 59.98,
  shippingCost: 5.99,
  totalAmount: 65.97,
  status: OrderStatus.confirmed,
  customerName: 'Test Customer',
  customerEmail: 'test@example.com',
  customerPhone: '123-456-7890',
  shippingAddress: '123 Test Street',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// Mock functions
void when(Future<dynamic> Function() function) {}
void when(Future<dynamic> Function(dynamic) function) {}
