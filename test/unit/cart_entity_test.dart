import 'package:flutter_test/flutter_test.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_entity.dart';
import 'package:jerseyhub/features/cart/domain/entity/cart_item_entity.dart';
import 'package:jerseyhub/features/product/domain/entity/product_entity.dart';

void main() {
  group('CartEntity Tests', () {
    late ProductEntity testProduct1;
    late ProductEntity testProduct2;
    late CartItemEntity testCartItem1;
    late CartItemEntity testCartItem2;
    late CartEntity testCart;

    setUp(() {
      testProduct1 = ProductEntity(
        id: 'product_1',
        team: 'Manchester United',
        type: 'Home',
        size: 'M',
        price: 2500.0,
        quantity: 10,
        categoryId: 'category_1',
        sellerId: 'seller_1',
        productImage: 'man_utd_home.jpg',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      testProduct2 = ProductEntity(
        id: 'product_2',
        team: 'Barcelona',
        type: 'Away',
        size: 'L',
        price: 3000.0,
        quantity: 5,
        categoryId: 'category_1',
        sellerId: 'seller_1',
        productImage: 'barca_away.jpg',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      testCartItem1 = CartItemEntity(
        id: 'cart_item_1',
        product: testProduct1,
        quantity: 2,
        selectedSize: 'M',
        addedAt: DateTime(2024, 1, 1),
      );

      testCartItem2 = CartItemEntity(
        id: 'cart_item_2',
        product: testProduct2,
        quantity: 1,
        selectedSize: 'L',
        addedAt: DateTime(2024, 1, 1),
      );

      testCart = CartEntity(
        id: 'cart_1',
        userId: 'user_1',
        items: [testCartItem1, testCartItem2],
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );
    });

    test('should create CartEntity with correct properties', () {
      // Assert
      expect(testCart.id, equals('cart_1'));
      expect(testCart.userId, equals('user_1'));
      expect(testCart.items.length, equals(2));
      expect(testCart.items[0], equals(testCartItem1));
      expect(testCart.items[1], equals(testCartItem2));
    });

    test('should calculate total price correctly', () {
      // Calculate expected total: (2500 * 2) + (3000 * 1) = 8000
      expect(testCart.totalPrice, equals(8000.0));
    });

    test('should calculate item count correctly', () {
      // Total items: 2 + 1 = 3
      expect(testCart.itemCount, equals(3));
    });

    test('should create copy with updated properties', () {
      // Arrange
      final newCartItem = CartItemEntity(
        id: 'cart_item_3',
        product: testProduct1,
        quantity: 1,
        selectedSize: 'S',
        addedAt: DateTime(2024, 1, 1),
      );

      // Act
      final updatedCart = testCart.copyWith(
        items: [testCartItem1, testCartItem2, newCartItem],
      );

      // Assert
      expect(updatedCart.id, equals(testCart.id));
      expect(updatedCart.userId, equals(testCart.userId));
      expect(updatedCart.items.length, equals(3));
      expect(updatedCart.itemCount, equals(4)); // 2 + 1 + 1
      expect(updatedCart.totalPrice, equals(10500.0)); // (2500 * 2) + (3000 * 1) + (2500 * 1)
    });

    test('should handle empty cart', () {
      // Arrange
      final emptyCart = CartEntity(
        id: 'empty_cart',
        userId: 'user_1',
        items: [],
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // Assert
      expect(emptyCart.items.length, equals(0));
      expect(emptyCart.itemCount, equals(0));
      expect(emptyCart.totalPrice, equals(0.0));
    });

    test('should convert to JSON correctly', () {
      // Act
      final json = testCart.toJson();

      // Assert
      expect(json['id'], equals('cart_1'));
      expect(json['userId'], equals('user_1'));
      expect(json['items'], isA<List>());
      expect(json['items'].length, equals(2));
      expect(json['createdAt'], isA<String>());
      expect(json['updatedAt'], isA<String>());
    });

    test('should create from JSON correctly', () {
      // Arrange
      final json = {
        'id': 'cart_2',
        'userId': 'user_2',
        'items': [
          {
            'id': 'cart_item_3',
            'product': {
              'id': 'product_3',
              'team': 'Liverpool',
              'type': 'Home',
              'size': 'M',
              'price': 2800.0,
              'quantity': 8,
              'categoryId': 'category_1',
              'sellerId': 'seller_1',
              'productImage': 'liverpool_home.jpg',
              'createdAt': '2024-01-01T00:00:00.000Z',
              'updatedAt': '2024-01-01T00:00:00.000Z',
            },
            'quantity': 1,
            'selectedSize': 'M',
            'addedAt': '2024-01-01T00:00:00.000Z',
          }
        ],
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-01T00:00:00.000Z',
      };

      // Act
      final cart = CartEntity.fromJson(json);

      // Assert
      expect(cart.id, equals('cart_2'));
      expect(cart.userId, equals('user_2'));
      expect(cart.items.length, equals(1));
      expect(cart.itemCount, equals(1));
      expect(cart.totalPrice, equals(2800.0));
    });

    test('should be equal when properties are the same', () {
      // Arrange
      final identicalCart = CartEntity(
        id: 'cart_1',
        userId: 'user_1',
        items: [testCartItem1, testCartItem2],
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // Assert
      expect(testCart, equals(identicalCart));
    });

    test('should not be equal when properties are different', () {
      // Arrange
      final differentCart = CartEntity(
        id: 'cart_2',
        userId: 'user_1',
        items: [testCartItem1, testCartItem2],
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // Assert
      expect(testCart, isNot(equals(differentCart)));
    });

    test('should handle cart with single item', () {
      // Arrange
      final singleItemCart = CartEntity(
        id: 'single_cart',
        userId: 'user_1',
        items: [testCartItem1],
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // Assert
      expect(singleItemCart.items.length, equals(1));
      expect(singleItemCart.itemCount, equals(2));
      expect(singleItemCart.totalPrice, equals(5000.0)); // 2500 * 2
    });
  });
} 