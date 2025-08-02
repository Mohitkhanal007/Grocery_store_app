import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_entity.dart';
import 'package:jerseyhub/features/cart/domain/repository/cart_repository.dart';

class ClearCartParams {
  final String userId;
  ClearCartParams({required this.userId});
}

class ClearCartUseCase
    implements UsecaseWithParams<CartEntity, ClearCartParams> {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(ClearCartParams params) async {
    return await repository.clearCart(params.userId);
  }
}
