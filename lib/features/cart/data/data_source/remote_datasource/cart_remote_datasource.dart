import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_entity.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_item_entity.dart';

abstract class CartRemoteDataSource {
  Future<Either<Failure, CartEntity>> getCart(String userId);
  Future<Either<Failure, CartEntity>> addToCart(
    String userId,
    CartItemEntity item,
  );
  Future<Either<Failure, CartEntity>> updateCartItem(
    String userId,
    String itemId,
    int quantity,
  );
  Future<Either<Failure, CartEntity>> removeFromCart(
    String userId,
    String itemId,
  );
  Future<Either<Failure, CartEntity>> clearCart(String userId);
  Future<Either<Failure, void>> syncCart(String userId, CartEntity cart);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio _dio;

  CartRemoteDataSourceImpl(this._dio);

  @override
  Future<Either<Failure, CartEntity>> getCart(String userId) async {
    try {
      final response = await _dio.get('/cart/user/$userId');

      if (response.statusCode == 200) {
        final cartData = response.data;
        final cart = CartEntity.fromJson(cartData);
        return Right(cart);
      } else {
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to load cart'),
        );
      }
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: 'Failed to load cart: $e'));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> addToCart(
    String userId,
    CartItemEntity item,
  ) async {
    try {
      final response = await _dio.post(
        '/cart/add-item',
        data: {'userId': userId, 'item': item.toJson()},
      );

      if (response.statusCode == 200) {
        final cartData = response.data;
        final cart = CartEntity.fromJson(cartData);
        return Right(cart);
      } else {
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to add item to cart'),
        );
      }
    } catch (e) {
      return Left(
        RemoteDatabaseFailure(message: 'Failed to add item to cart: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, CartEntity>> updateCartItem(
    String userId,
    String itemId,
    int quantity,
  ) async {
    try {
      final response = await _dio.put(
        '/cart/update-item',
        data: {'userId': userId, 'itemId': itemId, 'quantity': quantity},
      );

      if (response.statusCode == 200) {
        final cartData = response.data;
        final cart = CartEntity.fromJson(cartData);
        return Right(cart);
      } else {
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to update cart item'),
        );
      }
    } catch (e) {
      return Left(
        RemoteDatabaseFailure(message: 'Failed to update cart item: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, CartEntity>> removeFromCart(
    String userId,
    String itemId,
  ) async {
    try {
      final response = await _dio.delete(
        '/cart/remove-item/$itemId',
        data: {'userId': userId},
      );

      if (response.statusCode == 200) {
        final cartData = response.data;
        final cart = CartEntity.fromJson(cartData);
        return Right(cart);
      } else {
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to remove item from cart'),
        );
      }
    } catch (e) {
      return Left(
        RemoteDatabaseFailure(message: 'Failed to remove item from cart: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, CartEntity>> clearCart(String userId) async {
    try {
      final response = await _dio.delete('/cart/clear/$userId');

      if (response.statusCode == 200) {
        final cartData = response.data;
        final cart = CartEntity.fromJson(cartData);
        return Right(cart);
      } else {
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to clear cart'),
        );
      }
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: 'Failed to clear cart: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncCart(String userId, CartEntity cart) async {
    try {
      final response = await _dio.post(
        '/cart/sync',
        data: {'userId': userId, 'cart': cart.toJson()},
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return const Left(
          RemoteDatabaseFailure(message: 'Failed to sync cart'),
        );
      }
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: 'Failed to sync cart: $e'));
    }
  }
}
