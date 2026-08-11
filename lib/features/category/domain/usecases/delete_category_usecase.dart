import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:ebazarx/features/category/domain/repositories/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository _categoryRepository;
  DeleteCategoryUseCase(this._categoryRepository);

  Future<void> call(String categoryId) async {
    return _categoryRepository.deleteCategory(categoryId);
  }
}