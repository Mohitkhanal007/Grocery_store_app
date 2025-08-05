import 'package:dartz/dartz.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_entity.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_item_entity.dart';
import 'package:grocerystore/features/cart/domain/repository/cart_repository.dart';

class AddToCartParams {
  final String userId;
  final CartItemEntity item;
  AddToCartParams({required this.userId, required this.item});
}

class AddToCartUseCase
    implements UsecaseWithParams<CartEntity, AddToCartParams> {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(AddToCartParams params) async {
    return await repository.addToCart(params.userId, params.item);
  }
}
