import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:ebazarx/features/category/domain/repositories/category_repository.dart';

class GetChildCategoriesUseCase {
  final CategoryRepository _repository;
  GetChildCategoriesUseCase(this._repository);

  Future<List<Category>> call(String parentId) {
    return _repository.getChildren(parentId);
  }
}