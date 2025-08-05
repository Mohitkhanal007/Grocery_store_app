import 'package:dartz/dartz.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/features/order/domain/entity/order_entity.dart';
import 'package:grocerystore/features/order/domain/repository/order_repository.dart';

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