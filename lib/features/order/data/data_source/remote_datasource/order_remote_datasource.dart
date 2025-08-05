import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/order/domain/entity/order_entity.dart';

abstract class OrderRemoteDataSource {
  Future<Either<Failure, List<OrderEntity>>> getAllOrders(String userId);
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order);
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String orderId,
    String status,
  );
  Future<Either<Failure, void>> deleteOrder(String orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio _dio;

  OrderRemoteDataSourceImpl(this._dio);

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllOrders(String userId) async {
    try {
      print('🔗 OrderRemoteDataSource: Fetching orders for userId: $userId');
      print('🔗 OrderRemoteDataSource: API URL: /orders/user/$userId');

      final response = await _dio.get('/orders/user/$userId');

      print(
        '✅ OrderRemoteDataSource: API response status: ${response.statusCode}',
      );
      print('📄 OrderRemoteDataSource: API response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> ordersData = response.data;
        print('📄 OrderRemoteDataSource: Raw orders data: $ordersData');

        final orders = ordersData.map((orderData) {
          try {
            print('🔍 OrderRemoteDataSource: Parsing order: $orderData');
            return OrderEntity.fromJson(orderData);
          } catch (e) {
            print('💥 OrderRemoteDataSource: Error parsing order: $e');
            rethrow;
          }
        }).toList();
        print(
          '🎉 OrderRemoteDataSource: Successfully parsed ${orders.length} orders',
        );
        return Right(orders);
      } else {
        print(
          '❌ OrderRemoteDataSource: API returned non-200 status: ${response.statusCode}',
        );
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to load orders'),
        );
      }
    } catch (e) {
      print('💥 OrderRemoteDataSource: Error fetching orders: $e');
      return Left(RemoteDatabaseFailure(message: 'Failed to load orders: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) async {
    try {
      final response = await _dio.get('/orders/$orderId');

      if (response.statusCode == 200) {
        final orderData = response.data;
        final order = OrderEntity.fromJson(orderData);
        return Right(order);
      } else {
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to load order'),
        );
      }
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: 'Failed to load order: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order) async {
    try {
      print('🔗 Creating order in backend...');
      print('📦 Order data: ${order.toJson()}');

      final response = await _dio.post('/orders', data: order.toJson());

      print('✅ Backend response status: ${response.statusCode}');
      print('📄 Backend response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final orderData = response.data;
        final createdOrder = OrderEntity.fromJson(orderData);
        print('🎉 Order created successfully in backend: ${createdOrder.id}');
        return Right(createdOrder);
      } else {
        print('❌ Failed to create order in backend');
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to create order'),
        );
      }
    } catch (e) {
      print('💥 Error creating order in backend: $e');
      return Left(RemoteDatabaseFailure(message: 'Failed to create order: $e'));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    try {
      final response = await _dio.put(
        '/orders/$orderId/status',
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        final orderData = response.data;
        final updatedOrder = OrderEntity.fromJson(orderData);
        return Right(updatedOrder);
      } else {
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to update order status'),
        );
      }
    } catch (e) {
      return Left(
        RemoteDatabaseFailure(message: 'Failed to update order status: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrder(String orderId) async {
    try {
      final response = await _dio.delete('/orders/$orderId');

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to delete order'),
        );
      }
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: 'Failed to delete order: $e'));
    }
  }
}
