import 'package:dartz/dartz.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_entity.dart';
import 'package:grocerystore/features/cart/domain/repository/cart_repository.dart';

class GetCartParams {
  final String userId;
  GetCartParams({required this.userId});
}

class GetCartUseCase implements UsecaseWithParams<CartEntity, GetCartParams> {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(GetCartParams params) async {
    return await repository.getCart(params.userId);
  }
}
