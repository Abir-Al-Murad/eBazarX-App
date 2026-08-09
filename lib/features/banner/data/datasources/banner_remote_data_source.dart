import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/banner/data/models/banner_model.dart';

class BannerRemoteDataSource {
  final ApiClient _apiClient;

  const BannerRemoteDataSource(this._apiClient);

  // ============================
  // Public Banners
  // ============================

  Future<List<BannerModel>> fetchBanners() async {
    final response = await _apiClient.get('/banners');

    if (response.isSuccess) {
      List<BannerModel> models =  (response.body as List)
          .map((e) => BannerModel.fromJson(e))
          .toList();
      print("Total Banners: ${models.length}");
      return models;
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch banners');
  }

  // ============================
  // Create
  // ============================

  Future<BannerModel> createBanner({
    required String title,
    String? description,
    required String imageUrl,
    String? linkUrl,
    String? productId,
    String? categoryId,
    int position = 0,
    bool isActive = true,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response = await _apiClient.post(
      '/admin/banners/',
      data: {
        "title": title,
        "description": description,
        "image_url": imageUrl,
        "link_url": linkUrl,
        "product_id": productId,
        "category_id": categoryId,
        "position": position,
        "is_active": isActive,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
      },
    );

    if (response.isSuccess) {
      return BannerModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to create banner');
  }

  // ============================
  // Admin List
  // ============================

  Future<List<BannerModel>> listOfBannersAdmin({
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/admin/banners/',
      queryParameters: {
        "skip": skip,
        "limit": limit,
      },
    );

    if (response.isSuccess) {
      return (response.body as List)
          .map((e) => BannerModel.fromJson(e))
          .toList();
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to fetch banners');
  }

  // ============================
  // Update
  // ============================

  Future<BannerModel> updateBanner({
    required String id,
    String? title,
    String? description,
    String? imageUrl,
    String? linkUrl,
    String? productId,
    String? categoryId,
    int? position,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final Map<String, dynamic> data = {};

    if (title != null) data["title"] = title;
    if (description != null) data["description"] = description;
    if (imageUrl != null) data["image_url"] = imageUrl;
    if (linkUrl != null) data["link_url"] = linkUrl;
    if (productId != null) data["product_id"] = productId;
    if (categoryId != null) data["category_id"] = categoryId;
    if (position != null) data["position"] = position;
    if (isActive != null) data["is_active"] = isActive;
    if (startDate != null) {
      data["start_date"] = startDate.toIso8601String();
    }
    if (endDate != null) {
      data["end_date"] = endDate.toIso8601String();
    }

    final response = await _apiClient.put(
      '/admin/banners/$id',
      data: data,
    );

    if (response.isSuccess) {
      return BannerModel.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to update banner');
  }

  // ============================
  // Delete
  // ============================

  Future<void> deleteBanner(String id) async {
    final response = await _apiClient.delete('/admin/banners/$id');

    if (!response.isSuccess) {
      throw response.failure ??
          Exception(response.errorMessage ?? 'Failed to delete banner');
    }
  }
}