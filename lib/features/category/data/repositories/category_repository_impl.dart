import 'package:ebazarx/features/category/data/datasources/category_remote_data_source.dart';
import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:ebazarx/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  const CategoryRepositoryImpl(this.remoteDataSource);

  // ============================================================
  // Public
  // ============================================================

  @override
  Future<List<Category>> fetchCategories({
    int skip = 0,
    int limit = 100,
  }) async {
    final result = await remoteDataSource.fetchRootCategories(
      skip: skip,
      limit: limit,
    );

    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Category> getCategoryById(String categoryId) async {
    final result = await remoteDataSource.getCategoryById(categoryId);

    return result.toEntity();
  }

  @override
  Future<List<Category>> getChildren(String categoryId) async {
    final result = await remoteDataSource.getChildren(categoryId);

    return result.map((e) => e.toEntity()).toList();
  }

  // ============================================================
  // Admin - GET ALL
  // ============================================================

  @override
  Future<List<Category>> fetchAdminCategories({
    int skip = 0,
    int limit = 20,
    String? name,
    String? slug,
    String? parentId,
    bool? isActive,
    bool includeDeleted = false,
  }) async {
    final result = await remoteDataSource.fetchAdminCategories(
      skip: skip,
      limit: limit,
      name: name,
      slug: slug,
      parentId: parentId,
      isActive: isActive,
      includeDeleted: includeDeleted,
    );

    return result.map((e) => e.toEntity()).toList();
  }

  // ============================================================
  // Admin - GET SINGLE
  // ============================================================

  @override
  Future<Category> getAdminCategoryById(
    String categoryId, {
    bool includeDeleted = false,
  }) async {
    final result = await remoteDataSource.getAdminCategoryById(
      categoryId,
      includeDeleted: includeDeleted,
    );

    return result.toEntity();
  }

  // ============================================================
  // Admin - CREATE
  // ============================================================

  @override
  Future<Category> createCategory({
    required String name,
    required String slug,
    String? description,
    String? imageUrl,
    String? parentId,
  }) async {
    final result = await remoteDataSource.createCategory(
      name: name,
      slug: slug,
      description: description,
      imageUrl: imageUrl,
      parentId: parentId,
    );

    return result.toEntity();
  }

  // ============================================================
  // Admin - UPDATE
  // ============================================================

  @override
  Future<Category> updateCategory({
    required String id,
    String? name,
    String? slug,
    String? description,
    String? imageUrl,
    String? parentId,
    bool? isActive,
    bool clearParent = false,
  }) async {
    final result = await remoteDataSource.updateCategory(
      id: id,
      name: name,
      slug: slug,
      description: description,
      imageUrl: imageUrl,
      parentId: parentId,
      isActive: isActive,
    );

    return result.toEntity();
  }

  // ============================================================
  // Admin - DELETE
  // ============================================================

  @override
  Future<void> deleteCategory(String id) async {
    await remoteDataSource.deleteCategory(id);
  }
}
