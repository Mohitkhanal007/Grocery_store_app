import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/category/domain/entity/category_entity.dart';

abstract interface class ICategoryRepository {
  /// Get all categories
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();

  /// Get category by ID
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id);

  /// Create a new category
  Future<Either<Failure, CategoryEntity>> createCategory(
    CategoryEntity category,
  );

  /// Update an existing category
  Future<Either<Failure, CategoryEntity>> updateCategory(
    CategoryEntity category,
  );

  /// Delete a category
  Future<Either<Failure, void>> deleteCategory(String id);
}
