import 'package:ebazarx/admin/flash_sale/states/flash_sale_crud_state.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/flash_sale/domain/usecases/create_flash_sale_usecase.dart';
import 'package:ebazarx/features/flash_sale/domain/usecases/delete_flash_sale_usecase.dart';
import 'package:ebazarx/features/flash_sale/domain/usecases/fetch_flash_sale_by_id_usecase.dart';
import 'package:ebazarx/features/flash_sale/domain/usecases/update_flash_sale_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashSaleCrudNotifier extends StateNotifier<FlashSaleCrudState> {
  final CreateFlashSaleUseCase _createFlashSaleUseCase;
  final FetchFlashSaleByIdUseCase _fetchFlashSaleByIdUseCase;
  final UpdateFlashSaleUseCase _updateFlashSaleUseCase;
  final DeleteFlashSaleUseCase _deleteFlashSaleUseCase;

  FlashSaleCrudNotifier({
    required CreateFlashSaleUseCase createFlashSaleUseCase,
    required FetchFlashSaleByIdUseCase fetchFlashSaleByIdUseCase,
    required UpdateFlashSaleUseCase updateFlashSaleUseCase,
    required DeleteFlashSaleUseCase deleteFlashSaleUseCase,
  })  : _createFlashSaleUseCase = createFlashSaleUseCase,
        _fetchFlashSaleByIdUseCase = fetchFlashSaleByIdUseCase,
        _updateFlashSaleUseCase = updateFlashSaleUseCase,
        _deleteFlashSaleUseCase = deleteFlashSaleUseCase,
        super(const FlashSaleCrudState());

  // ============================================================
  // CREATE
  // ============================================================

  Future<bool> createFlashSale({
    required String name,
    String? description,
    required DateTime startDate,
    required DateTime endDate,
    bool isActive = true,
    List<Map<String, dynamic>> products = const [],
  }) async {
    state = state.copyWith(
      status: FlashSaleCrudStatus.loading,
      clearFailure: true,
    );

    try {
      final flashSale = await _createFlashSaleUseCase(
        name: name,
        description: description,
        startDate: startDate,
        endDate: endDate,
        isActive: isActive,
        products: products,
      );

      state = state.copyWith(
        status: FlashSaleCrudStatus.success,
        flashSale: flashSale,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: FlashSaleCrudStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: FlashSaleCrudStatus.failure,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  // ============================================================
  // GET SINGLE
  // ============================================================

  Future<bool> fetchFlashSaleById(
      String flashSaleId,
      ) async {
    state = state.copyWith(
      status: FlashSaleCrudStatus.loading,
      clearFailure: true,
    );

    try {
      final flashSale = await _fetchFlashSaleByIdUseCase(
        flashSaleId: flashSaleId,
      );

      state = state.copyWith(
        status: FlashSaleCrudStatus.success,
        flashSale: flashSale,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: FlashSaleCrudStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: FlashSaleCrudStatus.failure,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  // ============================================================
  // UPDATE
  // ============================================================

  Future<bool> updateFlashSale({
    required String flashSaleId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    List<Map<String, dynamic>>? products,
  }) async {
    state = state.copyWith(
      status: FlashSaleCrudStatus.loading,
      clearFailure: true,
    );

    try {
      final flashSale = await _updateFlashSaleUseCase(
        flashSaleId: flashSaleId,
        name: name,
        description: description,
        startDate: startDate,
        endDate: endDate,
        isActive: isActive,
        products: products,
      );

      state = state.copyWith(
        status: FlashSaleCrudStatus.success,
        flashSale: flashSale,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: FlashSaleCrudStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: FlashSaleCrudStatus.failure,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<bool> deleteFlashSale(
      String flashSaleId,
      ) async {
    state = state.copyWith(
      status: FlashSaleCrudStatus.loading,
      clearFailure: true,
    );

    try {
      await _deleteFlashSaleUseCase(
        flashSaleId: flashSaleId,
      );

      state = state.copyWith(
        status: FlashSaleCrudStatus.success,
        clearFlashSale: true,
        clearFailure: true,
      );

      return true;
    } on Failure catch (e) {
      state = state.copyWith(
        status: FlashSaleCrudStatus.failure,
        failure: e,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: FlashSaleCrudStatus.failure,
        failure: UnknownFailure(e.toString()),
      );

      return false;
    }
  }

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    state = const FlashSaleCrudState();
  }
}