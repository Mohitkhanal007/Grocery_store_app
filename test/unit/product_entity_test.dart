import 'package:flutter_test/flutter_test.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';

void main() {
  group('ProductEntity Unit Tests', () {
    late ProductEntity testProduct;
    late DateTime now;

    setUp(() {
      now = DateTime.now();
      testProduct = ProductEntity(
        id: 'product_1',
        team: 'Manchester United',
        type: 'Home Jersey',
        size: 'L',
        price: 79.99,
        quantity: 15,
        categoryId: 'jerseys',
        productImage: 'assets/images/man_utd.png',
        createdAt: now,
        updatedAt: now,
      );
    });

    test('should create ProductEntity with correct properties', () {
      expect(testProduct.id, 'product_1');
      expect(testProduct.team, 'Manchester United');
      expect(testProduct.type, 'Home Jersey');
      expect(testProduct.size, 'L');
      expect(testProduct.price, 79.99);
      expect(testProduct.quantity, 15);
      expect(testProduct.categoryId, 'jerseys');
      expect(testProduct.productImage, 'assets/images/man_utd.png');
    });

    test('should have valid price', () {
      expect(testProduct.price, greaterThan(0));
      expect(testProduct.price, isA<double>());
    });

    test('should have valid quantity', () {
      expect(testProduct.quantity, greaterThan(0));
      expect(testProduct.quantity, isA<int>());
    });

    test('should have valid team name', () {
      expect(testProduct.team, isNotEmpty);
      expect(testProduct.team.length, greaterThan(0));
    });

    test('should have valid product type', () {
      expect(testProduct.type, isNotEmpty);
      expect(testProduct.type, contains('Jersey'));
    });
  });
}
