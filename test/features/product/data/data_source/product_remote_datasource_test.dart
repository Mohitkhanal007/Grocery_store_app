import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jerseyhub/core/network/api_service.dart';
import 'package:jerseyhub/features/product/data/data_source/remote_datasource/product_remote_datasource.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;
  late ProductRemoteDataSource dataSource;

  setUp(() {
    mockApiService = MockApiService();
    dataSource = ProductRemoteDataSource(apiService: mockApiService);
  });

  test('should return mock products when getAllProducts is called', () async {
    // Act
    final products = await dataSource.getAllProducts();

    // Assert
    expect(products, isNotEmpty);
    expect(products.length, 4); // We have 4 mock products

    // Check first product
    final firstProduct = products.first;
    expect(firstProduct.id, '1');
    expect(firstProduct.team, 'Real Madrid');
    expect(firstProduct.type, 'Home');
    expect(firstProduct.size, 'M');
    expect(firstProduct.price, 89.99);
    expect(firstProduct.quantity, 50);
  });

  test('should return filtered products when searching', () async {
    // Act
    final products = await dataSource.searchProducts('Real Madrid');

    // Assert
    expect(products, isNotEmpty);
    expect(products.length, 1);
    expect(products.first.team, 'Real Madrid');
  });

  test('should return products by type', () async {
    // Act
    final products = await dataSource.getProductsByType('Home');

    // Assert
    expect(products, isNotEmpty);
    expect(products.every((product) => product.type == 'Home'), true);
  });
}
