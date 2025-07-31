import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_entity.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_item_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, CartEntity>> addToCart(CartItemEntity item);
  Future<Either<Failure, CartEntity>> removeFromCart(String itemId);
  Future<Either<Failure, CartEntity>> updateQuantity(
    String itemId,
    int quantity,
  );
  Future<Either<Failure, CartEntity>> clearCart();
}
