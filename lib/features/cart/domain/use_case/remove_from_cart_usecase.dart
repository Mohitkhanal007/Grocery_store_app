import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_entity.dart';
import 'package:jerseyhub/features/cart/domain/repository/cart_repository.dart';

class RemoveFromCartParams {
  final String itemId;
  RemoveFromCartParams({required this.itemId});
}

class RemoveFromCartUseCase
    implements UsecaseWithParams<CartEntity, RemoveFromCartParams> {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(RemoveFromCartParams params) async {
    return await repository.removeFromCart(params.itemId);
  }
}
