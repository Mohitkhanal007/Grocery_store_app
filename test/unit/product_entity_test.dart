import 'package:flutter_test/flutter_test.dart';
import 'package:jerseyhub/features/product/domain/entity/product_entity.dart';

void main() {
  group('ProductEntity Tests', () {
    late ProductEntity testProduct;

    setUp(() {
      testProduct = ProductEntity(
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
    });

    test('should create ProductEntity with correct properties', () {
      // Assert
      expect(testProduct.id, equals('product_1'));
      expect(testProduct.team, equals('Manchester United'));
      expect(testProduct.type, equals('Home'));
      expect(testProduct.size, equals('M'));
      expect(testProduct.price, equals(2500.0));
      expect(testProduct.quantity, equals(10));
      expect(testProduct.categoryId, equals('category_1'));
      expect(testProduct.sellerId, equals('seller_1'));
      expect(testProduct.productImage, equals('man_utd_home.jpg'));
    });

    test('should create copy with updated properties', () {
      // Act
      final updatedProduct = testProduct.copyWith(
        price: 3000.0,
        quantity: 5,
        type: 'Away',
      );

      // Assert
      expect(updatedProduct.id, equals(testProduct.id));
      expect(updatedProduct.price, equals(3000.0));
      expect(updatedProduct.quantity, equals(5));
      expect(updatedProduct.type, equals('Away'));
      expect(updatedProduct.team, equals(testProduct.team));
    });

    test('should convert to JSON correctly', () {
      // Act
      final json = testProduct.toJson();

      // Assert
      expect(json['id'], equals('product_1'));
      expect(json['team'], equals('Manchester United'));
      expect(json['type'], equals('Home'));
      expect(json['size'], equals('M'));
      expect(json['price'], equals(2500.0));
      expect(json['quantity'], equals(10));
      expect(json['categoryId'], equals('category_1'));
      expect(json['sellerId'], equals('seller_1'));
      expect(json['productImage'], equals('man_utd_home.jpg'));
    });

    test('should create from JSON correctly', () {
      // Arrange
      final json = {
        'id': 'product_2',
        'team': 'Barcelona',
        'type': 'Away',
        'size': 'L',
        'price': 3000.0,
        'quantity': 5,
        'categoryId': 'category_1',
        'sellerId': 'seller_1',
        'productImage': 'barca_away.jpg',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-01T00:00:00.000Z',
      };

      // Act
      final product = ProductEntity.fromJson(json);

      // Assert
      expect(product.id, equals('product_2'));
      expect(product.team, equals('Barcelona'));
      expect(product.type, equals('Away'));
      expect(product.size, equals('L'));
      expect(product.price, equals(3000.0));
      expect(product.quantity, equals(5));
    });

    test('should be equal when properties are the same', () {
      // Arrange
      final identicalProduct = ProductEntity(
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

      // Assert
      expect(testProduct, equals(identicalProduct));
    });

    test('should not be equal when properties are different', () {
      // Arrange
      final differentProduct = ProductEntity(
        id: 'product_2',
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

      // Assert
      expect(testProduct, isNot(equals(differentProduct)));
    });

    test('should handle zero quantity', () {
      // Arrange
      final zeroQuantityProduct = testProduct.copyWith(quantity: 0);

      // Assert
      expect(zeroQuantityProduct.quantity, equals(0));
    });

    test('should handle zero price', () {
      // Arrange
      final zeroPriceProduct = testProduct.copyWith(price: 0.0);

      // Assert
      expect(zeroPriceProduct.price, equals(0.0));
    });

    test('should handle empty strings', () {
      // Arrange
      final emptyStringProduct = testProduct.copyWith(
        team: '',
        type: '',
        size: '',
        productImage: '',
      );

      // Assert
      expect(emptyStringProduct.team, equals(''));
      expect(emptyStringProduct.type, equals(''));
      expect(emptyStringProduct.size, equals(''));
      expect(emptyStringProduct.productImage, equals(''));
    });

    test('should handle null values in copyWith', () {
      // Act
      final copiedProduct = testProduct.copyWith();

      // Assert
      expect(copiedProduct, equals(testProduct));
    });
  });
} 