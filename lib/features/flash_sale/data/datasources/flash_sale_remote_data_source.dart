import 'package:ebazarx/core/network/api_client.dart';
import '../models/flash_sale_model.dart';

class FlashSaleRemoteDataSource {
  final ApiClient _apiClient;

  const FlashSaleRemoteDataSource(this._apiClient);

  Future<List<FlashSaleModel>> fetchFlashSales() async {
    final response = await _apiClient.get('/flash-sales');

    if (response.isSuccess) {
      return (response.body as List)
          .map((e) => FlashSaleModel.fromJson(e))
          .toList();
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch flash sales');
  }
}