import 'package:dartz/dartz.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/features/order/domain/entity/order_entity.dart';
import 'package:grocerystore/features/order/domain/repository/order_repository.dart';

class UpdateOrderStatusParams {
  final String orderId;
  final String status;
  UpdateOrderStatusParams({required this.orderId, required this.status});
}

class UpdateOrderStatusUseCase implements UsecaseWithParams<OrderEntity, UpdateOrderStatusParams> {
  final OrderRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(UpdateOrderStatusParams params) async {
    return await repository.updateOrderStatus(params.orderId, params.status);
  }
} 