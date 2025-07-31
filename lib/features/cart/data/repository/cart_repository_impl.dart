import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_entity.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_item_entity.dart';
import 'package:jerseyhub/features/cart/domain/repository/cart_repository.dart';
import 'package:jerseyhub/features/cart/data/data_source/local_datasource/cart_local_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      final cart = await localDataSource.getCart();
      return Right(cart);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> addToCart(CartItemEntity item) async {
    try {
      final cart = await localDataSource.addToCart(item);
      return Right(cart);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> removeFromCart(String itemId) async {
    try {
      final cart = await localDataSource.removeFromCart(itemId);
      return Right(cart);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> updateQuantity(
    String itemId,
    int quantity,
  ) async {
    try {
      final cart = await localDataSource.updateQuantity(itemId, quantity);
      return Right(cart);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> clearCart() async {
    try {
      final cart = await localDataSource.clearCart();
      return Right(cart);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }
}
