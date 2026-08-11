import 'package:ebazarx/features/category/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  // ============================================================
  // Public
  // ============================================================

  /// Root categories
  Future<List<Category>> fetchCategories({int skip = 0, int limit = 100});

  /// Single category
  Future<Category> getCategoryById(String categoryId);

  /// Direct child categories
  Future<List<Category>> getChildren(String categoryId);

  // ============================================================
  // Admin
  // ============================================================

  /// Get categories for admin
  Future<List<Category>> fetchAdminCategories({
    int skip = 0,
    int limit = 20,
    String? name,
    String? slug,
    String? parentId,
    bool? isActive,
    bool includeDeleted = false,
  });

  /// Get single category for admin
  Future<Category> getAdminCategoryById(
    String categoryId, {
    bool includeDeleted = false,
  });

  /// Create category
  ///
  /// Backend automatically sets is_active = true.
  Future<Category> createCategory({
    required String name,
    required String slug,
    String? description,
    String? imageUrl,
    String? parentId,
  });

  /// Update category
  Future<Category> updateCategory({
    required String id,
    String? name,
    String? slug,
    String? description,
    String? imageUrl,
    String? parentId,
    bool? isActive,
    bool clearParent = false,
  });

  /// Soft delete category
  Future<void> deleteCategory(String id);
}
