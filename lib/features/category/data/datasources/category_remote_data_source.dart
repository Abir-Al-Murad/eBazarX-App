import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/category/data/models/category_model.dart';

class CategoryRemoteDataSource {
  final ApiClient _apiClient;

  const CategoryRemoteDataSource(this._apiClient);

  // ============================================================
  // Public
  // ============================================================

  /// Get root categories
  Future<List<CategoryModel>> fetchRootCategories({
    int skip = 0,
    int limit = 100,
  }) async {
    final response = await _apiClient.get(
      '/categories/',
      queryParameters: {'skip': skip, 'limit': limit},
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch categories');
  }

  /// Get single category
  Future<CategoryModel> getCategoryById(String categoryId) async {
    final response = await _apiClient.get('/categories/$categoryId');

    if (response.isSuccess) {
      return CategoryModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch category');
  }

  /// Get child categories
  Future<List<CategoryModel>> getChildren(String categoryId) async {
    final response = await _apiClient.get('/categories/$categoryId/children');

    if (response.isSuccess) {
      return (response.body as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch child categories');
  }

  // ============================================================
  // Admin - GET ALL
  // ============================================================

  /// Admin: Get all categories with filters
  ///
  /// Backend:
  /// GET /admin/categories/
  ///
  /// Supports:
  /// - skip
  /// - limit
  /// - name
  /// - slug
  /// - parent_id
  /// - is_active
  /// - include_deleted
  Future<List<CategoryModel>> fetchAdminCategories({
    int skip = 0,
    int limit = 20,
    String? name,
    String? slug,
    String? parentId,
    bool? isActive,
    bool includeDeleted = false,
  }) async {
    final response = await _apiClient.get(
      '/admin/categories/',
      queryParameters: {
        'skip': skip,
        'limit': limit,

        if (name != null && name.trim().isNotEmpty) 'name': name.trim(),

        if (slug != null && slug.trim().isNotEmpty) 'slug': slug.trim(),

        if (parentId != null) 'parent_id': parentId,

        if (isActive != null) 'is_active': isActive,

        'include_deleted': includeDeleted,
      },
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch admin categories');
  }

  // ============================================================
  // Admin - GET SINGLE
  // ============================================================

  /// Admin: Get category by ID
  ///
  /// GET /admin/categories/{category_id}
  Future<CategoryModel> getAdminCategoryById(
    String categoryId, {
    bool includeDeleted = false,
  }) async {
    final response = await _apiClient.get(
      '/admin/categories/$categoryId',
      queryParameters: {'include_deleted': includeDeleted},
    );

    if (response.isSuccess) {
      return CategoryModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch admin category');
  }

  // ============================================================
  // Admin - CREATE
  // ============================================================

  /// Admin: Create category
  ///
  /// POST /admin/categories/
  Future<CategoryModel> createCategory({
    required String name,
    required String slug,
    String? description,
    String? imageUrl,
    String? parentId,
    bool isActive = true,
  }) async {
    final response = await _apiClient.post(
      '/admin/categories/',
      data: {
        'name': name,
        'slug': slug,
        'description': description,
        'image_url': imageUrl,
        'parent_id': parentId,
        'is_active': isActive,
      },
    );

    if (response.isSuccess) {
      return CategoryModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to create category');
  }

  // ============================================================
  // Admin - UPDATE
  // ============================================================

  /// Admin: Update category
  ///
  /// PUT /admin/categories/{category_id}
  Future<CategoryModel> updateCategory({
    required String id,
    String? name,
    String? slug,
    String? description,
    String? imageUrl,
    String? parentId,
    bool? isActive,
  }) async {
    final response = await _apiClient.put(
      '/admin/categories/$id',
      data: {
        if (name != null) 'name': name,

        if (slug != null) 'slug': slug,

        if (description != null) 'description': description,

        if (imageUrl != null) 'image_url': imageUrl,

        if (parentId != null) 'parent_id': parentId,

        if (isActive != null) 'is_active': isActive,
      },
    );

    if (response.isSuccess) {
      return CategoryModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to update category');
  }

  // ============================================================
  // Admin - DELETE
  // ============================================================

  /// Admin: Soft delete category
  ///
  /// DELETE /admin/categories/{category_id}
  Future<void> deleteCategory(String id) async {
    final response = await _apiClient.delete('/admin/categories/$id');

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to delete category');
    }
  }
}
