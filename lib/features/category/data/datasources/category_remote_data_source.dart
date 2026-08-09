import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/category/data/models/category_model.dart';

class CategoryRemoteDataSource {
  final ApiClient _apiClient;

  const CategoryRemoteDataSource(this._apiClient);

  // ============================================================
  // Public
  // ============================================================

  /// Root Categories
  Future<List<CategoryModel>> fetchRootCategories({
    int skip = 0,
    int limit = 100,
  }) async {
    final response = await _apiClient.get(
      '/categories/',
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch categories');
  }

  /// Single Category
  Future<CategoryModel> getCategoryById(String categoryId) async {
    final response = await _apiClient.get('/categories/$categoryId');

    if (response.isSuccess) {
      return CategoryModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch category');
  }

  /// Child Categories
  Future<List<CategoryModel>> getChildren(
      String categoryId,
      ) async {
    final response = await _apiClient.get(
      '/categories/$categoryId/children',
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch child categories');
  }

  // ============================================================
  // Admin
  // ============================================================

  Future<CategoryModel> createCategory({
    required String name,
    required String slug,
    String? description,
    String? imageUrl,
    String? parentId,
  }) async {
    final response = await _apiClient.post(
      '/admin/categories/',
      data: {
        'name': name,
        'slug': slug,
        'description': description,
        'image_url': imageUrl,
        'parent_id': parentId,
      },
    );

    if (response.isSuccess) {
      return CategoryModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to create category');
  }

  Future<CategoryModel> updateCategory({
    required String id,
    String? name,
    String? slug,
    String? description,
    String? imageUrl,
    String? parentId,
  }) async {
    final response = await _apiClient.put(
      '/admin/categories/$id',
      data: {
        if (name != null) 'name': name,
        if (slug != null) 'slug': slug,
        if (description != null) 'description': description,
        if (imageUrl != null) 'image_url': imageUrl,
        if (parentId != null) 'parent_id': parentId,
      },
    );

    if (response.isSuccess) {
      return CategoryModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to update category');
  }

  Future<void> deleteCategory(String id) async {
    final response = await _apiClient.delete(
      '/admin/categories/$id',
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to delete category');
    }
  }
}