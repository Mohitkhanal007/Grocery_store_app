import 'package:dartz/dartz.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_entity.dart';
import 'package:grocerystore/features/cart/domain/repository/cart_repository.dart';

class UpdateQuantityParams {
  final String userId;
  final String itemId;
  final int quantity;
  UpdateQuantityParams({
    required this.userId,
    required this.itemId,
    required this.quantity,
  });
}

class UpdateQuantityUseCase
    implements UsecaseWithParams<CartEntity, UpdateQuantityParams> {
  final CartRepository repository;

  UpdateQuantityUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(UpdateQuantityParams params) async {
    return await repository.updateCartItem(
      params.userId,
      params.itemId,
      params.quantity,
    );
  }
}
