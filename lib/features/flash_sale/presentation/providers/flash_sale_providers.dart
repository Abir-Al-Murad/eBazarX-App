import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/flash_sale/data/datasources/flash_sale_remote_data_source.dart';
import 'package:ebazarx/features/flash_sale/data/repositories/flash_sale_repository_impl.dart';
import 'package:ebazarx/features/flash_sale/domain/repositories/flash_sale_repository.dart';

import 'package:ebazarx/features/flash_sale/domain/usecases/create_flash_sale_usecase.dart';
import 'package:ebazarx/features/flash_sale/domain/usecases/delete_flash_sale_usecase.dart';
import 'package:ebazarx/features/flash_sale/domain/usecases/fetch_admin_flash_sales_usecase.dart';
import 'package:ebazarx/features/flash_sale/domain/usecases/fetch_flash_sale_by_id_usecase.dart';
import 'package:ebazarx/features/flash_sale/domain/usecases/fetch_flash_sales_usecase.dart';
import 'package:ebazarx/features/flash_sale/domain/usecases/update_flash_sale_usecase.dart';

import 'package:ebazarx/features/flash_sale/presentation/notifiers/flash_sale_list_notifier.dart';
import 'package:ebazarx/features/flash_sale/presentation/states/flash_sale_list_state.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ============================================================
// DATA SOURCE
// ============================================================

final flashSaleRemoteDataSourceProvider = Provider<FlashSaleRemoteDataSource>(
  (ref) => FlashSaleRemoteDataSource(ref.read(apiClientProvider)),
);

// ============================================================
// REPOSITORY
// ============================================================

final flashSaleRepositoryProvider = Provider<FlashSaleRepository>(
  (ref) => FlashSaleRepositoryImpl(ref.read(flashSaleRemoteDataSourceProvider)),
);

// ============================================================
// USE CASES
// ============================================================

// GET ALL
final fetchFlashSalesUseCaseProvider = Provider<FetchFlashSalesUseCase>(
  (ref) => FetchFlashSalesUseCase(ref.read(flashSaleRepositoryProvider)),
);
final fetchAllFlashSalesUseCaseProvider = Provider<FetchAdminFlashSales>(
  (ref) => FetchAdminFlashSales(ref.read(flashSaleRepositoryProvider)),
);

// GET SINGLE
final fetchFlashSaleByIdUseCaseProvider = Provider<FetchFlashSaleByIdUseCase>(
  (ref) => FetchFlashSaleByIdUseCase(ref.read(flashSaleRepositoryProvider)),
);

// CREATE
final createFlashSaleUseCaseProvider = Provider<CreateFlashSaleUseCase>(
  (ref) => CreateFlashSaleUseCase(ref.read(flashSaleRepositoryProvider)),
);

// UPDATE
final updateFlashSaleUseCaseProvider = Provider<UpdateFlashSaleUseCase>(
  (ref) => UpdateFlashSaleUseCase(ref.read(flashSaleRepositoryProvider)),
);

// DELETE
final deleteFlashSaleUseCaseProvider = Provider<DeleteFlashSaleUseCase>(
  (ref) => DeleteFlashSaleUseCase(ref.read(flashSaleRepositoryProvider)),
);

// ============================================================
// LIST NOTIFIER
// ============================================================

final flashSaleListNotifierProvider =
    StateNotifierProvider<FlashSaleListNotifier, FlashSaleListState>(
      (ref) => FlashSaleListNotifier(ref.read(fetchFlashSalesUseCaseProvider)),
    );
