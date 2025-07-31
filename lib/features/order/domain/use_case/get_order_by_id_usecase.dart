import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/features/order/domain/entity/order_entity.dart';
import 'package:jerseyhub/features/order/domain/repository/order_repository.dart';

class GetOrderByIdParams {
  final String orderId;
  GetOrderByIdParams({required this.orderId});
}

class GetOrderByIdUseCase implements UsecaseWithParams<OrderEntity, GetOrderByIdParams> {
  final OrderRepository repository;

  GetOrderByIdUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(GetOrderByIdParams params) async {
    return await repository.getOrderById(params.orderId);
  }
} 