import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_entity.dart';
import 'package:jerseyhub/features/cart/domain/repository/cart_repository.dart';

class UpdateQuantityParams {
  final String itemId;
  final int quantity;
  UpdateQuantityParams({required this.itemId, required this.quantity});
}

class UpdateQuantityUseCase
    implements UsecaseWithParams<CartEntity, UpdateQuantityParams> {
  final CartRepository repository;

  UpdateQuantityUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(UpdateQuantityParams params) async {
    return await repository.updateQuantity(params.itemId, params.quantity);
  }
}
