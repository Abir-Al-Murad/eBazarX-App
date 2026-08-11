import 'package:ebazarx/admin/categories/notifiers/admin_category_crud_notifier.dart';
import 'package:ebazarx/admin/categories/notifiers/admin_category_list_notifier.dart';
import 'package:ebazarx/admin/categories/states/admin_category_crud_state.dart';
import 'package:ebazarx/admin/categories/states/admin_category_list_state.dart';
import 'package:ebazarx/features/category/domain/usecases/create_category_usecase.dart';
import 'package:ebazarx/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:ebazarx/features/category/domain/usecases/fetch_all_categories_usecase.dart';
import 'package:ebazarx/features/category/domain/usecases/update_category_usecase.dart';
import 'package:ebazarx/features/category/presentation/providers/category_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createCategoryUseCaseProvider = Provider<CreateCategoryUseCase>((ref) {
  return CreateCategoryUseCase(ref.watch(categoryRepositoryProvider));
});

final updateCategoryUseCaseProvider = Provider<UpdateCategoryUseCase>((ref) {
  return UpdateCategoryUseCase(ref.watch(categoryRepositoryProvider));
});

final deleteCategoryUseCaseProvider = Provider<DeleteCategoryUseCase>((ref) {
  return DeleteCategoryUseCase(ref.watch(categoryRepositoryProvider));
});

final fetchAllCategoriesUseCaseProvider = Provider<FetchAllCategories>((ref) {
  return FetchAllCategories(ref.watch(categoryRepositoryProvider));
});

final adminCategoryCrudNotifierProvider =
StateNotifierProvider<AdminCategoryCrudNotifier, AdminCategoryCrudState>(
      (ref) => AdminCategoryCrudNotifier(ref),
    );

final adminCategoryListNotifierProvider = StateNotifierProvider<AdminCategoryListNotifier, AdminCategoryListState>((ref){
  return AdminCategoryListNotifier(ref);
});