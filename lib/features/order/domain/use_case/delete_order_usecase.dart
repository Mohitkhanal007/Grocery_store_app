import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/features/order/domain/repository/order_repository.dart';

class DeleteOrderParams {
  final String orderId;
  DeleteOrderParams({required this.orderId});
}

class DeleteOrderUseCase implements UsecaseWithParams<void, DeleteOrderParams> {
  final OrderRepository repository;

  DeleteOrderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteOrderParams params) async {
    return await repository.deleteOrder(params.orderId);
  }
} 