import 'package:jerseyhub/features/category/domain/entity/category_entity.dart';

abstract interface class ICategoryDataSource {
  /// Get all categories
  Future<List<CategoryEntity>> getAllCategories();

  /// Get category by ID
  Future<CategoryEntity> getCategoryById(String id);

  /// Create a new category
  Future<CategoryEntity> createCategory(CategoryEntity category);

  /// Update an existing category
  Future<CategoryEntity> updateCategory(CategoryEntity category);

  /// Delete a category
  Future<void> deleteCategory(String id);
}
