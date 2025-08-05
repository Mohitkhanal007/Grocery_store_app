import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_entity.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_item_entity.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';

abstract class CartLocalDataSource {
  Future<CartEntity> getCart();
  Future<CartEntity> addToCart(CartItemEntity item);
  Future<CartEntity> removeFromCart(String itemId);
  Future<CartEntity> updateQuantity(String itemId, int quantity);
  Future<CartEntity> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _cartKey = 'cart_data';

  @override
  Future<CartEntity> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(_cartKey);

    if (cartJson != null) {
      final cartMap = json.decode(cartJson) as Map<String, dynamic>;
      return _cartFromJson(cartMap);
    }

    // Return empty cart if no data exists
    return CartEntity(
      id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
      items: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<CartEntity> addToCart(CartItemEntity item) async {
    final cart = await getCart();
    final existingItemIndex = cart.items.indexWhere(
      (cartItem) =>
          cartItem.product.id == item.product.id &&
          cartItem.selectedSize == item.selectedSize,
    );

    List<CartItemEntity> updatedItems;
    if (existingItemIndex != -1) {
      // Update existing item quantity
      updatedItems = List.from(cart.items);
      final existingItem = updatedItems[existingItemIndex];
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
    } else {
      // Add new item
      updatedItems = [...cart.items, item];
    }

    final updatedCart = cart.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    await _saveCart(updatedCart);
    return updatedCart;
  }

  @override
  Future<CartEntity> removeFromCart(String itemId) async {
    print('🛒 CartLocalDataSource: Attempting to remove item with ID: $itemId');
    final cart = await getCart();
    print(
      '🛒 CartLocalDataSource: Current cart has ${cart.items.length} items',
    );
    print(
      '🛒 CartLocalDataSource: Current item IDs: ${cart.items.map((item) => item.id).toList()}',
    );

    final updatedItems = cart.items.where((item) => item.id != itemId).toList();
    print(
      '🛒 CartLocalDataSource: After filtering, cart has ${updatedItems.length} items',
    );
    print(
      '🛒 CartLocalDataSource: Removed items: ${cart.items.where((item) => item.id == itemId).length}',
    );

    final updatedCart = cart.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    await _saveCart(updatedCart);
    print('🛒 CartLocalDataSource: Cart saved successfully');
    return updatedCart;
  }

  @override
  Future<CartEntity> updateQuantity(String itemId, int quantity) async {
    final cart = await getCart();
    final updatedItems = cart.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    final updatedCart = cart.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    await _saveCart(updatedCart);
    return updatedCart;
  }

  @override
  Future<CartEntity> clearCart() async {
    final cart = await getCart();
    final emptyCart = cart.copyWith(items: [], updatedAt: DateTime.now());

    await _saveCart(emptyCart);
    return emptyCart;
  }

  Future<void> _saveCart(CartEntity cart) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = json.encode(_cartToJson(cart));
    await prefs.setString(_cartKey, cartJson);
  }

  Map<String, dynamic> _cartToJson(CartEntity cart) {
    return {
      'id': cart.id,
      'items': cart.items.map((item) => _cartItemToJson(item)).toList(),
      'createdAt': cart.createdAt.toIso8601String(),
      'updatedAt': cart.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _cartItemToJson(CartItemEntity item) {
    return {
      'id': item.id,
      'product': {
        'id': item.product.id,
        'team': item.product.team,
        'type': item.product.type,
        'size': item.product.size,
        'price': item.product.price,
        'quantity': item.product.quantity,
        'categoryId': item.product.categoryId,
        'sellerId': item.product.sellerId,
        'productImage': item.product.productImage,
        'createdAt': item.product.createdAt.toIso8601String(),
        'updatedAt': item.product.updatedAt.toIso8601String(),
      },
      'quantity': item.quantity,
      'selectedSize': item.selectedSize,
      'addedAt': item.addedAt.toIso8601String(),
    };
  }

  CartEntity _cartFromJson(Map<String, dynamic> json) {
    return CartEntity(
      id: json['id'],
      items: (json['items'] as List)
          .map((itemJson) => _cartItemFromJson(itemJson))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  CartItemEntity _cartItemFromJson(Map<String, dynamic> json) {
    final productJson = json['product'] as Map<String, dynamic>;
    return CartItemEntity(
      id: json['id'],
      product: _productFromJson(productJson),
      quantity: json['quantity'],
      selectedSize: json['selectedSize'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  ProductEntity _productFromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'],
      team: json['team'],
      type: json['type'],
      size: json['size'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      categoryId: json['categoryId'],
      sellerId: json['sellerId'],
      productImage: json['productImage'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
