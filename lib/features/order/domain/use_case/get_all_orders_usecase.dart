import 'package:dartz/dartz.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/features/order/domain/entity/order_entity.dart';
import 'package:grocerystore/features/order/domain/repository/order_repository.dart';

class GetAllOrdersParams {
  final String userId;
  GetAllOrdersParams({required this.userId});
}

class GetAllOrdersUseCase
    implements UsecaseWithParams<List<OrderEntity>, GetAllOrdersParams> {
  final OrderRepository repository;

  GetAllOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(
    GetAllOrdersParams params,
  ) async {
    return await repository.getAllOrders(params.userId);
  }
}
