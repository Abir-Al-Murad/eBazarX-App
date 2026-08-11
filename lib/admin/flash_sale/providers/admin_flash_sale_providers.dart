// ============================================================
// ADMIN LIST NOTIFIER
// ============================================================

import 'package:ebazarx/admin/flash_sale/notifiers/flash_sale_admin_list_notifier.dart';
import 'package:ebazarx/admin/flash_sale/notifiers/flash_sale_curd_notifier.dart';
import 'package:ebazarx/admin/flash_sale/states/flash_sale_admin_list_state.dart';
import 'package:ebazarx/admin/flash_sale/states/flash_sale_crud_state.dart';
import 'package:ebazarx/features/flash_sale/presentation/providers/flash_sale_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flashSaleAdminListNotifierProvider =
    StateNotifierProvider<FlashSaleAdminListNotifier, FlashSaleAdminListState>(
      (ref) => FlashSaleAdminListNotifier(
        ref.read(fetchAllFlashSalesUseCaseProvider),
      ),
    );

// ============================================================
// CRUD NOTIFIER
// ============================================================

final flashSaleCrudNotifierProvider =
    StateNotifierProvider<FlashSaleCrudNotifier, FlashSaleCrudState>(
      (ref) => FlashSaleCrudNotifier(
        createFlashSaleUseCase: ref.read(createFlashSaleUseCaseProvider),
        fetchFlashSaleByIdUseCase: ref.read(fetchFlashSaleByIdUseCaseProvider),
        updateFlashSaleUseCase: ref.read(updateFlashSaleUseCaseProvider),
        deleteFlashSaleUseCase: ref.read(deleteFlashSaleUseCaseProvider),
      ),
    );
