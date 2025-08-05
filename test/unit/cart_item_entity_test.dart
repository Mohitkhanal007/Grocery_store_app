import 'package:flutter_test/flutter_test.dart';
import 'package:grocerystore/features/cart/domain/entity/cart_item_entity.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';

void main() {
  group('CartItemEntity Unit Tests', () {
    late CartItemEntity testCartItem;
    late ProductEntity testProduct;
    late DateTime now;

    setUp(() {
      now = DateTime.now();
      testProduct = ProductEntity(
        id: 'product_1',
        team: 'Real Madrid',
        type: 'Away Jersey',
        size: 'L',
        price: 45.50,
        quantity: 8,
        categoryId: 'jerseys',
        productImage: 'assets/images/real_madrid.png',
        createdAt: now,
        updatedAt: now,
      );

      testCartItem = CartItemEntity(
        id: 'cart_item_1',
        product: testProduct,
        quantity: 3,
        selectedSize: 'L',
        addedAt: now,
      );
    });

    test('should create CartItemEntity with correct properties', () {
      expect(testCartItem.id, 'cart_item_1');
      expect(testCartItem.product, testProduct);
      expect(testCartItem.quantity, 3);
      expect(testCartItem.selectedSize, 'L');
      expect(testCartItem.addedAt, now);
    });

    test('should calculate total price correctly', () {
      double expectedTotal = testProduct.price * testCartItem.quantity;
      expect(testCartItem.totalPrice, expectedTotal);
      expect(testCartItem.totalPrice, 45.50 * 3);
    });

    test('should have correct product information', () {
      expect(testCartItem.product.team, 'Real Madrid');
      expect(testCartItem.product.type, 'Away Jersey');
      expect(testCartItem.product.price, 45.50);
    });

    test('should have valid cart item properties', () {
      expect(testCartItem.quantity, greaterThan(0));
      expect(testCartItem.selectedSize, isNotEmpty);
      expect(testCartItem.addedAt, isA<DateTime>());
    });

    test('should calculate total price with different quantities', () {
      CartItemEntity itemWithQuantity1 = CartItemEntity(
        id: 'test_1',
        product: testProduct,
        quantity: 1,
        selectedSize: 'M',
        addedAt: now,
      );

      CartItemEntity itemWithQuantity5 = CartItemEntity(
        id: 'test_5',
        product: testProduct,
        quantity: 5,
        selectedSize: 'L',
        addedAt: now,
      );

      expect(itemWithQuantity1.totalPrice, 45.50);
      expect(itemWithQuantity5.totalPrice, 45.50 * 5);
    });
  });
}
