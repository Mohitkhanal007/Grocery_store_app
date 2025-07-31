import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/features/order/domain/entity/order_entity.dart';
import 'package:jerseyhub/features/order/domain/repository/order_repository.dart';

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