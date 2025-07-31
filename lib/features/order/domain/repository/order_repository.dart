import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/order/domain/entity/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getAllOrders();
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order);
  Future<Either<Failure, OrderEntity>> updateOrderStatus(String orderId, String status);
  Future<Either<Failure, void>> deleteOrder(String orderId);
} 