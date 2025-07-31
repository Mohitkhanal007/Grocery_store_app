import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/product/domain/entity/product_entity.dart';

abstract interface class IProductRepository {
  /// Get all products
  Future<Either<Failure, List<ProductEntity>>> getAllProducts();

  /// Get products by category
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  );

  /// Get product by ID
  Future<Either<Failure, ProductEntity>> getProductById(String id);

  /// Search products by team name
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);

  /// Get products by type (Home, Away, Third)
  Future<Either<Failure, List<ProductEntity>>> getProductsByType(String type);

  /// Get products by size
  Future<Either<Failure, List<ProductEntity>>> getProductsBySize(String size);

  /// Get products within price range
  Future<Either<Failure, List<ProductEntity>>> getProductsByPriceRange(
    double minPrice,
    double maxPrice,
  );
}
