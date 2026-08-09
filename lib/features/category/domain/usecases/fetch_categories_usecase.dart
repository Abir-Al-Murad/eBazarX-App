import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:ebazarx/features/category/domain/repositories/category_repository.dart';

class FetchCategoriesUseCase{
  final CategoryRepository _repository;
  FetchCategoriesUseCase(this._repository);
  Future<List<Category>> call({
    int skip = 0,
    int limit = 100,
  }) async {
    return await _repository.fetchCategories(
      skip: skip,
      limit: limit,
    );
  }
}