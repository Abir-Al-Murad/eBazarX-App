import 'package:ebazarx/features/product/domain/usecases/get_seller_product_usecase.dart';
import 'package:ebazarx/features/product/presentation/providers/product_providers.dart';
import 'package:ebazarx/seller/products/notifiers/seller_product_details_notifier.dart';
import 'package:ebazarx/seller/products/notifiers/seller_product_list_notifier.dart';
import 'package:ebazarx/seller/products/notifiers/seller_product_notifier.dart';
import 'package:ebazarx/seller/products/states/seller_product_details_state.dart';
import 'package:ebazarx/seller/products/states/seller_product_list_state.dart';
import 'package:ebazarx/seller/products/states/seller_product_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sellerProductListNotifierProvider = StateNotifierProvider<SellerProductListNotifier, SellerProductListState>((ref){
  return SellerProductListNotifier(ref.read(fetchSellerProductsUseCaseProvider));
});
final getSellerProductUseCaseProvider = Provider((ref){return GetSellerProductUseCase(ref.read(productRepositoryProvider));});


final sellerProductProvider = StateNotifierProvider<SellerProductNotifier, SellerProductState>((ref){
  return SellerProductNotifier(ref.read(createProductUseCaseProvider), ref.read(updateProductUseCaseProvider), ref.read(deleteProductUseCaseProvider), ref.read(getProductUseCaseProvider));
});

final sellerProductDetailsNotifierProvider = StateNotifierProvider<SellerProductDetailsNotifier, SellerProductDetailsState>((ref){
  return SellerProductDetailsNotifier(ref.read(getSellerProductUseCaseProvider));
});