import 'package:dartz/dartz.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_entity.dart';
import 'package:grocerystore/features/cart/domain/repository/cart_repository.dart';

class RemoveFromCartParams {
  final String userId;
  final String itemId;
  RemoveFromCartParams({required this.userId, required this.itemId});
}

class RemoveFromCartUseCase
    implements UsecaseWithParams<CartEntity, RemoveFromCartParams> {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(RemoveFromCartParams params) async {
    return await repository.removeFromCart(params.userId, params.itemId);
  }
}
