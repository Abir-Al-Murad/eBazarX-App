import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/wish/data/models/wish_list_model.dart';

class WishRemoteDataSource {
  final ApiClient _apiClient;
  WishRemoteDataSource(this._apiClient);

  Future<void> addToWishList(String variantId) async {
    final response = await _apiClient.post('/customer/wishlist/items', data: {'variant_id': variantId});

    if (!response.isSuccess) {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to add to wishlist');
    }
  }

  Future<void> removeFromWishList(String itemId) async {
    final response = await _apiClient.delete('/customer/wishlist/items/$itemId');

    if (!response.isSuccess) {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to remove from wishlist');
    }
  }

  Future<WishListModel> getWishList() async {
    final response = await _apiClient.get('/customer/wishlist');
    if (!response.isSuccess) {
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to fetch wishlist');
    }
    return WishListModel.fromJson(response.body);
  }

  Future<void> removeFromWishListByVariant(String variantId)async{
    final response = await _apiClient.delete('/customer/wishlist/variant/$variantId');
    if(!response.isSuccess){
      throw response.failure ?? Exception(response.errorMessage ?? 'Failed to remove from wishlist');
    }
  }
}