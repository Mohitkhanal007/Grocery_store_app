import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/cart/data/data_source/local_datasource/cart_local_datasource.dart';
import 'package:jerseyhub/features/cart/data/data_source/remote_datasource/cart_remote_datasource.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_entity.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_item_entity.dart';
import 'package:jerseyhub/features/cart/domain/repository/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;
  final CartRemoteDataSource _remoteDataSource;

  CartRepositoryImpl(this._localDataSource, this._remoteDataSource);

  // Local operations
  @override
  Future<Either<Failure, CartEntity>> getLocalCart() async {
    try {
      final cart = await _localDataSource.getCart();
      return Right(cart);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> addToLocalCart(
    CartItemEntity item,
  ) async {
    try {
      final cart = await _localDataSource.addToCart(item);
      return Right(cart);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> removeFromLocalCart(String itemId) async {
    try {
      final cart = await _localDataSource.removeFromCart(itemId);
      return Right(cart);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> updateLocalCartItem(
    String itemId,
    int quantity,
  ) async {
    try {
      final cart = await _localDataSource.updateQuantity(itemId, quantity);
      return Right(cart);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> clearLocalCart() async {
    try {
      final cart = await _localDataSource.clearCart();
      return Right(cart);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  // Remote operations
  @override
  Future<Either<Failure, CartEntity>> getRemoteCart(String userId) async {
    return await _remoteDataSource.getCart(userId);
  }

  @override
  Future<Either<Failure, CartEntity>> addToRemoteCart(
    String userId,
    CartItemEntity item,
  ) async {
    return await _remoteDataSource.addToCart(userId, item);
  }

  @override
  Future<Either<Failure, CartEntity>> removeFromRemoteCart(
    String userId,
    String itemId,
  ) async {
    return await _remoteDataSource.removeFromCart(userId, itemId);
  }

  @override
  Future<Either<Failure, CartEntity>> updateRemoteCartItem(
    String userId,
    String itemId,
    int quantity,
  ) async {
    return await _remoteDataSource.updateCartItem(userId, itemId, quantity);
  }

  @override
  Future<Either<Failure, CartEntity>> clearRemoteCart(String userId) async {
    return await _remoteDataSource.clearCart(userId);
  }

  // Synchronization
  @override
  Future<Either<Failure, CartEntity>> syncCartWithBackend(String userId) async {
    try {
      // Try to get cart from backend
      final remoteResult = await _remoteDataSource.getCart(userId);

      return remoteResult.fold(
        (failure) {
          // If backend fails, return local cart
          return getLocalCart();
        },
        (remoteCart) async {
          // If backend succeeds, update local cart and return
          await _localDataSource.clearCart();
          for (final item in remoteCart.items) {
            await _localDataSource.addToCart(item);
          }
          return Right(remoteCart);
        },
      );
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncLocalCartToBackend(String userId) async {
    try {
      final localCart = await _localDataSource.getCart();
      return await _remoteDataSource.syncCart(userId, localCart);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  // Hybrid operations (try remote first, fallback to local)
  @override
  Future<Either<Failure, CartEntity>> getCart(String userId) async {
    // Try remote first, fallback to local
    final remoteResult = await _remoteDataSource.getCart(userId);

    return remoteResult.fold((failure) {
      // If remote fails, return local cart
      return getLocalCart();
    }, (remoteCart) => Right(remoteCart));
  }

  @override
  Future<Either<Failure, CartEntity>> addToCart(
    String userId,
    CartItemEntity item,
  ) async {
    // Add to local cart first for immediate response
    final localResult = await addToLocalCart(item);

    // Try to sync with backend
    final remoteResult = await _remoteDataSource.addToCart(userId, item);

    return remoteResult.fold((failure) {
      // If remote fails, return local result
      return localResult;
    }, (remoteCart) => Right(remoteCart));
  }

  @override
  Future<Either<Failure, CartEntity>> removeFromCart(
    String userId,
    String itemId,
  ) async {
    // Remove from local cart first for immediate response
    final localResult = await removeFromLocalCart(itemId);

    // Try to sync with backend
    final remoteResult = await _remoteDataSource.removeFromCart(userId, itemId);

    return remoteResult.fold((failure) {
      // If remote fails, return local result
      return localResult;
    }, (remoteCart) => Right(remoteCart));
  }

  @override
  Future<Either<Failure, CartEntity>> updateCartItem(
    String userId,
    String itemId,
    int quantity,
  ) async {
    // Update local cart first for immediate response
    final localResult = await updateLocalCartItem(itemId, quantity);

    // Try to sync with backend
    final remoteResult = await _remoteDataSource.updateCartItem(
      userId,
      itemId,
      quantity,
    );

    return remoteResult.fold((failure) {
      // If remote fails, return local result
      return localResult;
    }, (remoteCart) => Right(remoteCart));
  }

  @override
  Future<Either<Failure, CartEntity>> clearCart(String userId) async {
    // Clear local cart first for immediate response
    final localResult = await clearLocalCart();

    // Try to sync with backend
    final remoteResult = await _remoteDataSource.clearCart(userId);

    return remoteResult.fold((failure) {
      // If remote fails, return local result
      return localResult;
    }, (remoteCart) => Right(remoteCart));
  }
}
