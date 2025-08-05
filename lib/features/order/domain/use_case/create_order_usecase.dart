import 'package:dartz/dartz.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/features/order/domain/entity/order_entity.dart';
import 'package:grocerystore/features/order/domain/repository/order_repository.dart';

class CreateOrderParams {
  final OrderEntity order;
  CreateOrderParams({required this.order});
}

class CreateOrderUseCase implements UsecaseWithParams<OrderEntity, CreateOrderParams> {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) async {
    return await repository.createOrder(params.order);
  }
} 