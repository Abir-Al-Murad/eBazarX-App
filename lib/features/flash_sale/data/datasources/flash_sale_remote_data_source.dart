import 'package:ebazarx/core/network/api_client.dart';
import '../models/flash_sale_model.dart';

class FlashSaleRemoteDataSource {
  final ApiClient _apiClient;

  const FlashSaleRemoteDataSource(this._apiClient);

  // ============================================================
  // GET ALL FLASH SALES
  // GET /flash-sales
  // ============================================================

  Future<List<FlashSaleModel>> fetchFlashSales({
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/flash-sales',
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(
            response.errorMessage ?? 'Failed to fetch flash sales',
          );
    }

    final List<dynamic> data = response.body as List<dynamic>;

    return data
        .map(
          (e) => FlashSaleModel.fromJson(
        e as Map<String, dynamic>,
      ),
    )
        .toList();
  }
  Future<List<FlashSaleModel>> fetchAdminFlashSales({
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/admin/flash-sales/',
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(
            response.errorMessage ?? 'Failed to fetch flash sales',
          );
    }

    final List<dynamic> data = response.body as List<dynamic>;

    return data
        .map(
          (e) => FlashSaleModel.fromJson(
        e as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  // ============================================================
  // GET SINGLE FLASH SALE
  // GET /flash-sales/{flash_sale_id}
  // ============================================================

  Future<FlashSaleModel> fetchFlashSaleById(
      String flashSaleId,
      ) async {
    final response = await _apiClient.get(
      '/flash-sales/$flashSaleId',
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(
            response.errorMessage ?? 'Failed to fetch flash sale',
          );
    }

    return FlashSaleModel.fromJson(
      response.body as Map<String, dynamic>,
    );
  }

  // ============================================================
  // CREATE FLASH SALE
  // POST /admin/flash-sales/
  // ============================================================

  Future<FlashSaleModel> createFlashSale({
    required String name,
    String? description,
    required DateTime startDate,
    required DateTime endDate,
    bool isActive = true,
    List<Map<String, dynamic>> products = const [],
  }) async {
    final response = await _apiClient.post(
      '/admin/flash-sales/',
      data: {
        'name': name,
        'description': description,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'is_active': isActive,
        'products': products,
      },
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(
            response.errorMessage ?? 'Failed to create flash sale',
          );
    }

    return FlashSaleModel.fromJson(
      response.body as Map<String, dynamic>,
    );
  }

  // ============================================================
  // UPDATE FLASH SALE
  // PUT /admin/flash-sales/{flash_sale_id}
  // ============================================================

  Future<FlashSaleModel> updateFlashSale({
    required String flashSaleId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    List<Map<String, dynamic>>? products,
  }) async {
    final Map<String, dynamic> data = {};

    if (name != null) {
      data['name'] = name;
    }

    if (description != null) {
      data['description'] = description;
    }

    if (startDate != null) {
      data['start_date'] = startDate.toIso8601String();
    }

    if (endDate != null) {
      data['end_date'] = endDate.toIso8601String();
    }

    if (isActive != null) {
      data['is_active'] = isActive;
    }

    if (products != null) {
      data['products'] = products;
    }

    final response = await _apiClient.put(
      '/admin/flash-sales/$flashSaleId',
      data: data,
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(
            response.errorMessage ?? 'Failed to update flash sale',
          );
    }

    return FlashSaleModel.fromJson(
      response.body as Map<String, dynamic>,
    );
  }

  // ============================================================
  // DELETE FLASH SALE
  // DELETE /admin/flash-sales/{flash_sale_id}
  // ============================================================

  Future<void> deleteFlashSale(
      String flashSaleId,
      ) async {
    final response = await _apiClient.delete(
      '/admin/flash-sales/$flashSaleId',
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(
            response.errorMessage ?? 'Failed to delete flash sale',
          );
    }
  }
}