import 'package:grocerystore/features/product/domain/entity/product_entity.dart';

abstract interface class IProductDataSource {
  /// Get all products
  Future<List<ProductEntity>> getAllProducts();

  /// Get products by category
  Future<List<ProductEntity>> getProductsByCategory(String categoryId);

  /// Get product by ID
  Future<ProductEntity> getProductById(String id);

  /// Search products by team name
  Future<List<ProductEntity>> searchProducts(String query);

  /// Get products by type (Home, Away, Third)
  Future<List<ProductEntity>> getProductsByType(String type);

  /// Get products by size
  Future<List<ProductEntity>> getProductsBySize(String size);

  /// Get products within price range
  Future<List<ProductEntity>> getProductsByPriceRange(
    double minPrice,
    double maxPrice,
  );
}
