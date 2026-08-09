import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ebazarx/features/product/data/repositories/product_repository_impl.dart';
import 'package:ebazarx/features/product/domain/repositories/product_repository.dart';
import 'package:ebazarx/features/product/domain/usecases/create_product_use_case.dart';
import 'package:ebazarx/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:ebazarx/features/product/domain/usecases/fetch_all_product_usecase.dart';
import 'package:ebazarx/features/product/domain/usecases/fetch_pending_product_usecase.dart';
import 'package:ebazarx/features/product/domain/usecases/fetch_product_usecase.dart';
import 'package:ebazarx/features/product/domain/usecases/fetch_public_products.dart';
import 'package:ebazarx/features/product/domain/usecases/fetch_seller_product_usecase.dart';
import 'package:ebazarx/features/product/domain/usecases/get_product_usecase.dart';
import 'package:ebazarx/features/product/domain/usecases/get_seller_product_usecase.dart';
import 'package:ebazarx/features/product/domain/usecases/update_product_approval_usecase.dart';
import 'package:ebazarx/features/product/domain/usecases/update_product_usecase.dart';
import 'package:ebazarx/features/product/presentation/notifiers/user_product_list_notifier.dart';
import 'package:ebazarx/features/product/presentation/states/user_product_list_state.dart';
import 'package:ebazarx/features/product/presentation/notifiers/product_details_notifier.dart';
import 'package:ebazarx/features/product/presentation/states/product_details_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ======================================================
/// Data Source
/// ======================================================

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>(
  (ref) => ProductRemoteDataSource(ref.read(apiClientProvider)),
);

/// ======================================================
/// Repository
/// ======================================================

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(ref.read(productRemoteDataSourceProvider)),
);

/// ======================================================
/// Public UseCases
/// ======================================================

final fetchProductsUseCaseProvider = Provider<FetchProductsUseCase>(
  (ref) => FetchProductsUseCase(ref.read(productRepositoryProvider)),
);

final getProductUseCaseProvider = Provider<GetProductUseCase>(
  (ref) => GetProductUseCase(ref.read(productRepositoryProvider)),
);

/// ======================================================
/// Seller UseCases
/// ======================================================

final createProductUseCaseProvider = Provider<CreateProductUseCase>(
  (ref) => CreateProductUseCase(ref.read(productRepositoryProvider)),
);

final fetchSellerProductsUseCaseProvider = Provider<FetchSellerProductsUseCase>(
  (ref) => FetchSellerProductsUseCase(ref.read(productRepositoryProvider)),
);

final getSellerProductUseCaseProvider = Provider<GetSellerProductUseCase>(
  (ref) => GetSellerProductUseCase(ref.read(productRepositoryProvider)),
);

final updateProductUseCaseProvider = Provider<UpdateProductUseCase>(
  (ref) => UpdateProductUseCase(ref.read(productRepositoryProvider)),
);

final deleteProductUseCaseProvider = Provider<DeleteProductUseCase>(
  (ref) => DeleteProductUseCase(ref.read(productRepositoryProvider)),
);

/// ======================================================
/// Admin UseCases
/// ======================================================

final fetchAllProductsUseCaseProvider = Provider<FetchAllProductsUseCase>(
  (ref) => FetchAllProductsUseCase(ref.read(productRepositoryProvider)),
);

final fetchPendingProductsUseCaseProvider =
    Provider<FetchPendingProductsUseCase>(
      (ref) => FetchPendingProductsUseCase(ref.read(productRepositoryProvider)),
    );

final updateProductApprovalUseCaseProvider =
    Provider<UpdateProductApprovalUseCase>(
      (ref) =>
          UpdateProductApprovalUseCase(ref.read(productRepositoryProvider)),
    );

final userProductListUseCaseProvider = Provider((ref)=> FetchPublicProductsUseCase(ref.read(productRepositoryProvider)));

final userProductListNotifierProvider =
    StateNotifierProvider<UserProductListNotifier, UserProductListState>(
      (ref) =>
          UserProductListNotifier(ref.read(userProductListUseCaseProvider)),
    );

final productDetailsNotifierProvider = StateNotifierProvider<ProductDetailsNotifier, ProductDetailsState>((ref){

    return ProductDetailsNotifier(ref.read(getProductUseCaseProvider));
});