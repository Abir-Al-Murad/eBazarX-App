import 'package:ebazarx/core/network/api_client.dart';

import '../models/seller_model.dart';

class SellerRemoteDataSource {
  final ApiClient _apiClient;

  const SellerRemoteDataSource(this._apiClient);

  // ============================================================
  // GET ALL SELLERS
  // GET /admin/sellers/
  // ============================================================

  Future<List<SellerModel>> getAllSellers({
    String? status,
    int skip = 0,
    int limit = 20,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'skip': skip,
      'limit': limit,
    };

    if (status != null) {
      queryParameters['status'] = status;
    }

    final response = await _apiClient.get(
      '/admin/sellers/',
      queryParameters: queryParameters,
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(
            response.errorMessage ?? 'Failed to fetch sellers',
          );
    }

    final List<dynamic> data = response.body as List<dynamic>;

    return data
        .map(
          (json) => SellerModel.fromJson(
        json as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  // ============================================================
  // GET PENDING SELLERS
  // GET /admin/sellers/pending
  // ============================================================

  Future<List<SellerModel>> getPendingSellers({
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/admin/sellers/pending',
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(
            response.errorMessage ?? 'Failed to fetch pending sellers',
          );
    }

    final List<dynamic> data = response.body as List<dynamic>;

    return data
        .map(
          (json) => SellerModel.fromJson(
        json as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  // ============================================================
  // UPDATE SELLER STATUS
  // PUT /admin/sellers/{seller_id}/status
  // ============================================================

  Future<SellerModel> updateSellerStatus({
    required String sellerId,
    required String status,
    String? adminNotes,
  }) async {
    final response = await _apiClient.put(
      '/admin/sellers/$sellerId/status',
      data: {
        'status': status,
        'admin_notes': adminNotes,
      },
    );

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(
            response.errorMessage ?? 'Failed to update seller status',
          );
    }

    return SellerModel.fromJson(
      response.body as Map<String, dynamic>,
    );
  }
}