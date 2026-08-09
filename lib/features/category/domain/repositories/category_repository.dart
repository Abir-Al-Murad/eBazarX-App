import 'package:ebazarx/features/category/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  // ============================================================
  // Public
  // ============================================================

  /// Root categories
  Future<List<Category>> fetchCategories({
    int skip = 0,
    int limit = 100,
  });

  /// Single category
  Future<Category> getCategoryById(
      String categoryId,
      );

  /// Direct child categories
  Future<List<Category>> getChildren(
      String categoryId,
      );

  // ============================================================
  // Admin
  // ============================================================

  Future<Category> createCategory({
    required String name,
    required String slug,
    String? description,
    String? imageUrl,
    String? parentId,
  });

  Future<Category> updateCategory({
    required String id,
    String? name,
    String? slug,
    String? description,
    String? imageUrl,
    String? parentId,
  });

  Future<void> deleteCategory(
      String id,
      );
}