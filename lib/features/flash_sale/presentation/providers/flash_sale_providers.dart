
import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/flash_sale/data/datasources/flash_sale_remote_data_source.dart';
import 'package:ebazarx/features/flash_sale/data/repositories/flash_sale_repository_impl.dart';
import 'package:ebazarx/features/flash_sale/domain/repositories/flash_sale_repository.dart';
import 'package:ebazarx/features/flash_sale/presentation/states/flash_sale_list_state.dart';
import 'package:ebazarx/features/flash_sale/domain/usecases/fetch_flash_sales_usecase.dart';
import 'package:ebazarx/features/flash_sale/presentation/notifiers/flash_sale_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flashSaleRemoteDataSourceProvider = Provider<FlashSaleRemoteDataSource>((ref)=>FlashSaleRemoteDataSource(ref.read(apiClientProvider)));
final flashSaleRepositoryProvider = Provider<FlashSaleRepository>((ref)=>FlashSaleRepositoryImpl(ref.read(flashSaleRemoteDataSourceProvider)));

final fetchFlashSalesUseCaseProvider = Provider<FetchFlashSalesUseCase>((ref)=>FetchFlashSalesUseCase(ref.read(flashSaleRepositoryProvider)));

final flashSaleListNotifierProvider = StateNotifierProvider<FlashSaleListNotifier, FlashSaleListState>((ref)=>FlashSaleListNotifier(ref.read(fetchFlashSalesUseCaseProvider)));