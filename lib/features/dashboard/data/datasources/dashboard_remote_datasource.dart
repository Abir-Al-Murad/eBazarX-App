import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/dashboard/data/models/dashboard_model.dart';


class DashboardRemoteDataSource {
  final ApiClient apiClient;

  DashboardRemoteDataSource(this.apiClient);

  Future<DashboardModel> getDashboard() async {
    final response = await apiClient.get("/seller/dashboard/");
    if(!response.isSuccess){
      throw response.failure ?? Exception(response.errorMessage ?? "Failed to fetch dashboard");
    }

    return DashboardModel.fromJson(response.body);
  }

  Future<Map<String, dynamic>> getOrderStatus() async {
    final response = await apiClient.get(
      "/seller/dashboard/order-status",
    );

    return response.body;
  }

  Future<List<Map<String, dynamic>>> getTopProducts({
    int limit = 5,
  }) async {
    final response = await apiClient.get(
      "/seller/dashboard/top-products",
      queryParameters: {
        "limit": limit,
      },
    );

    return List<Map<String, dynamic>>.from(response.body);
  }
}