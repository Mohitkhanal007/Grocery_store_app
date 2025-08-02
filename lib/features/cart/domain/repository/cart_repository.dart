import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_entity.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_item_entity.dart';

abstract class CartRepository {
  // Local operations
  Future<Either<Failure, CartEntity>> getLocalCart();
  Future<Either<Failure, CartEntity>> addToLocalCart(CartItemEntity item);
  Future<Either<Failure, CartEntity>> removeFromLocalCart(String itemId);
  Future<Either<Failure, CartEntity>> updateLocalCartItem(
    String itemId,
    int quantity,
  );
  Future<Either<Failure, CartEntity>> clearLocalCart();

  // Remote operations
  Future<Either<Failure, CartEntity>> getRemoteCart(String userId);
  Future<Either<Failure, CartEntity>> addToRemoteCart(
    String userId,
    CartItemEntity item,
  );
  Future<Either<Failure, CartEntity>> removeFromRemoteCart(
    String userId,
    String itemId,
  );
  Future<Either<Failure, CartEntity>> updateRemoteCartItem(
    String userId,
    String itemId,
    int quantity,
  );
  Future<Either<Failure, CartEntity>> clearRemoteCart(String userId);

  // Synchronization
  Future<Either<Failure, CartEntity>> syncCartWithBackend(String userId);
  Future<Either<Failure, void>> syncLocalCartToBackend(String userId);

  // Hybrid operations (try remote first, fallback to local)
  Future<Either<Failure, CartEntity>> getCart(String userId);
  Future<Either<Failure, CartEntity>> addToCart(
    String userId,
    CartItemEntity item,
  );
  Future<Either<Failure, CartEntity>> removeFromCart(
    String userId,
    String itemId,
  );
  Future<Either<Failure, CartEntity>> updateCartItem(
    String userId,
    String itemId,
    int quantity,
  );
  Future<Either<Failure, CartEntity>> clearCart(String userId);
}
