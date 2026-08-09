import 'package:ebazarx/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  const ProductRepositoryImpl(this.remoteDataSource);

  // ===================================================
  // Public
  // ===================================================

  @override
  Future<List<Product>> fetchProducts({
    int skip = 0,
    int limit = 20,
    String? categoryId,
    String? search,
  }) async {
    final result = await remoteDataSource.fetchProducts(
      skip: skip,
      limit: limit,
      categoryId: categoryId,
      search: search,
    );

    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Product> getProduct(String productId) async {
    final product = await remoteDataSource.getProduct(productId);
    return product.toEntity();
  }

  // ===================================================
  // Seller
  // ===================================================

  @override
  Future<Product> createProduct(
      Map<String, dynamic> data,
      ) async {
    final product = await remoteDataSource.createProduct(data);
    return product.toEntity();
  }

  @override
  Future<List<Product>> fetchSellerProducts({
    int skip = 0,
    int limit = 20,
  }) async {
    final result = await remoteDataSource.fetchSellerProducts(
      skip: skip,
      limit: limit,
    );

    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Product> getSellerProduct(String productId) async {
    final product = await remoteDataSource.getSellerProduct(productId);
    return product.toEntity();
  }

  @override
  Future<Product> updateProduct({
    required String productId,
    required Map<String, dynamic> data,
  }) async {
    final product = await remoteDataSource.updateProduct(
      productId: productId,
      data: data,
    );

    return product.toEntity();
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await remoteDataSource.deleteProduct(productId);
  }

  // ===================================================
  // Admin
  // ===================================================

  @override
  Future<List<Product>> fetchAllProducts({
    int skip = 0,
    int limit = 20,
    String? approvalStatus,
  }) async {
    final result = await remoteDataSource.fetchAllProducts(
      skip: skip,
      limit: limit,
      approvalStatus: approvalStatus,
    );

    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Product>> fetchPendingProducts({
    int skip = 0,
    int limit = 20,
  }) async {
    final result = await remoteDataSource.fetchPendingProducts(
      skip: skip,
      limit: limit,
    );

    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Product> updateApproval({
    required String productId,
    required String approvalStatus,
    String? notes,
  }) async {
    final product = await remoteDataSource.updateApproval(
      productId: productId,
      approvalStatus: approvalStatus,
      notes: notes,
    );

    return product.toEntity();
  }
}