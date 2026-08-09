import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/category/data/datasources/category_remote_data_source.dart';
import 'package:ebazarx/features/category/data/repositories/category_repository_impl.dart';
import 'package:ebazarx/features/category/domain/usecases/fetch_categories_usecase.dart';
import 'package:ebazarx/features/category/domain/usecases/get_child_categories.dart';
import 'package:ebazarx/features/category/presentation/notifiers/category_selection_notifier.dart';
import 'package:ebazarx/features/category/presentation/notifiers/children_category_list_notifier.dart';
import 'package:ebazarx/features/category/presentation/notifiers/fetch_category_list_notifier.dart';
import 'package:ebazarx/features/category/presentation/states/category_selection_state.dart';
import 'package:ebazarx/features/category/presentation/states/children_category_list_state.dart';
import 'package:ebazarx/features/category/presentation/states/fetch_category_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>(
  (ref) => CategoryRemoteDataSource(ref.read(apiClientProvider)),
);
final categoryRepositoryProvider = Provider(
  (ref) => CategoryRepositoryImpl(ref.read(categoryRemoteDataSourceProvider)),
);

final fetchCategoryListUseCaseProvider = Provider(
  (ref) => FetchCategoriesUseCase(ref.read(categoryRepositoryProvider)),
);
final getChildrenCategoryUseCaseProvider = Provider(
  (ref) => GetChildCategoriesUseCase(ref.read(categoryRepositoryProvider)),
);

final categoryListNotifierProvider =
    StateNotifierProvider<FetchCategoryListNotifier, FetchCategoryListState>((
      ref,
    ) {
      return FetchCategoryListNotifier(
        ref.read(fetchCategoryListUseCaseProvider),
      );
    });

final childrenCategoryListNotifierProvider =
    StateNotifierProvider<
      ChildrenCategoryListNotifier,
      ChildrenCategoryListState
    >((ref) {
      return ChildrenCategoryListNotifier(
        ref.read(getChildrenCategoryUseCaseProvider),
      );
    });

final categorySelectionNotifierProvider =
    StateNotifierProvider<CategorySelectionNotifier, CategorySelectionState>((
      ref,
    ) {
      return CategorySelectionNotifier(
        ref.read(fetchCategoryListUseCaseProvider),
        ref.read(getChildrenCategoryUseCaseProvider),
      );
    });
