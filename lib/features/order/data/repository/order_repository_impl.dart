import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/order/domain/entity/order_entity.dart';
import 'package:jerseyhub/features/order/domain/repository/order_repository.dart';
import 'package:jerseyhub/features/order/data/data_source/local_datasource/order_local_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllOrders() async {
    try {
      final orders = await localDataSource.getAllOrders();
      return Right(orders);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) async {
    try {
      final order = await localDataSource.getOrderById(orderId);
      if (order != null) {
        return Right(order);
      } else {
        return Left(SharedPreferencesFailure(message: 'Order not found'));
      }
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order) async {
    try {
      final createdOrder = await localDataSource.createOrder(order);
      return Right(createdOrder);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrderStatus(String orderId, String status) async {
    try {
      final updatedOrder = await localDataSource.updateOrderStatus(orderId, status);
      return Right(updatedOrder);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrder(String orderId) async {
    try {
      await localDataSource.deleteOrder(orderId);
      return const Right(null);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }
} 