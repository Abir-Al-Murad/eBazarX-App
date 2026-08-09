import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/product/data/models/product_model.dart';

class ProductRemoteDataSource {
  final ApiClient _apiClient;

  const ProductRemoteDataSource(this._apiClient);

  // ===========================================================
  // PUBLIC
  // ===========================================================

  Future<List<ProductModel>> fetchProducts({
    int skip = 0,
    int limit = 20,
    String? categoryId,
    String? search,
  }) async {
    final response = await _apiClient.get(
      '/public/products',
      queryParameters: {
        'skip': skip,
        'limit': limit,
        if (categoryId != null) 'category_id': categoryId,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch products');
  }

  Future<ProductModel> getProduct(String productId) async {
    final response = await _apiClient.get('/products/$productId');

    if (response.isSuccess) {
      return ProductModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to load product');
  }

  // ===========================================================
  // SELLER
  // ===========================================================

  Future<ProductModel> createProduct(
      Map<String, dynamic> data,
      ) async {
    final response = await _apiClient.post(
      '/seller/products/',
      data: data,
    );

    if (response.isSuccess) {
      return ProductModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to create product');
  }

  Future<List<ProductModel>> fetchSellerProducts({
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/seller/products/',
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch seller products');
  }

  Future<ProductModel> getSellerProduct(String id) async {
    final response = await _apiClient.get('/seller/products/$id');

    if (response.isSuccess) {
      return ProductModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to load product');
  }

  Future<ProductModel> updateProduct({
    required String productId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _apiClient.put(
      '/seller/products/$productId',
      data: data,
    );

    if (response.isSuccess) {
      return ProductModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to update product');
  }

  Future<void> deleteProduct(String productId) async {
    final response = await _apiClient.delete(
      '/seller/products/$productId',
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to delete product');
    }
  }

  // ===========================================================
  // ADMIN
  // ===========================================================

  Future<List<ProductModel>> fetchAllProducts({
    int skip = 0,
    int limit = 20,
    String? approvalStatus,
  }) async {
    final response = await _apiClient.get(
      '/admin/products/',
      queryParameters: {
        'skip': skip,
        'limit': limit,
        if (approvalStatus != null)
          'approval_status': approvalStatus,
      },
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch products');
  }

  Future<List<ProductModel>> fetchPendingProducts({
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/admin/products/pending',
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch pending products');
  }

  Future<ProductModel> updateApproval({
    required String productId,
    required String approvalStatus,
    String? notes,
  }) async {
    final response = await _apiClient.put(
      '/admin/products/$productId/approval',
      data: {
        'approval_status': approvalStatus,
        if (notes != null) 'notes': notes,
      },
    );

    if (response.isSuccess) {
      return ProductModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to update approval');
  }
}