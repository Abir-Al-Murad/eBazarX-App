import 'package:ebazarx/admin/sellers/data/datasources/seller_remote_data_source.dart';
import 'package:ebazarx/admin/sellers/data/repositories/seller_repository_impl.dart';
import 'package:ebazarx/admin/sellers/domain/repositories/seller_repository.dart';
import 'package:ebazarx/admin/sellers/domain/usecases/get_all_seller_usecase.dart';
import 'package:ebazarx/admin/sellers/domain/usecases/get_pending_sellers_usecase.dart';
import 'package:ebazarx/admin/sellers/domain/usecases/update_seller_status_usecase.dart';
import 'package:ebazarx/admin/sellers/presentation/notifiers/seller_crud_notifier.dart';
import 'package:ebazarx/admin/sellers/presentation/notifiers/seller_list_notifier.dart';
import 'package:ebazarx/admin/sellers/presentation/states/seller_crud_state.dart';
import 'package:ebazarx/admin/sellers/presentation/states/seller_list_state.dart';
import 'package:ebazarx/core/network/api_client.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ============================================================
// DATA SOURCE
// ============================================================

final sellerRemoteDataSourceProvider = Provider<SellerRemoteDataSource>(
  (ref) => SellerRemoteDataSource(ref.read(apiClientProvider)),
);

// ============================================================
// REPOSITORY
// ============================================================

final sellerRepositoryProvider = Provider<SellerRepository>(
  (ref) => SellerRepositoryImpl(ref.read(sellerRemoteDataSourceProvider)),
);

// ============================================================
// USE CASES
// ============================================================

// ------------------------------------------------------------
// GET ALL SELLERS
// ------------------------------------------------------------

final getAllSellersUseCaseProvider = Provider<GetAllSellersUseCase>(
  (ref) => GetAllSellersUseCase(ref.read(sellerRepositoryProvider)),
);

// ------------------------------------------------------------
// GET PENDING SELLERS
// ------------------------------------------------------------

final getPendingSellersUseCaseProvider = Provider<GetPendingSellersUseCase>(
  (ref) => GetPendingSellersUseCase(ref.read(sellerRepositoryProvider)),
);

// ------------------------------------------------------------
// UPDATE SELLER STATUS
// ------------------------------------------------------------

final updateSellerStatusUseCaseProvider = Provider<UpdateSellerStatusUseCase>(
  (ref) => UpdateSellerStatusUseCase(ref.read(sellerRepositoryProvider)),
);

// ============================================================
// LIST NOTIFIER
// ============================================================

final sellerListNotifierProvider =
    StateNotifierProvider<SellerListNotifier, SellerListState>(
      (ref) => SellerListNotifier(
        getAllSellersUseCase: ref.read(getAllSellersUseCaseProvider),
        getPendingSellersUseCase: ref.read(getPendingSellersUseCaseProvider),
      ),
    );

// ============================================================
// CRUD NOTIFIER
// ============================================================

final sellerCrudNotifierProvider =
    StateNotifierProvider<SellerCrudNotifier, SellerCrudState>(
      (ref) => SellerCrudNotifier(
        updateSellerStatusUseCase: ref.read(updateSellerStatusUseCaseProvider),
      ),
    );
