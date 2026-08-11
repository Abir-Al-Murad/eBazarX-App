import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:ebazarx/features/category/domain/repositories/category_repository.dart';

class CreateCategoryUseCase {
  final CategoryRepository _categoryRepository;
  CreateCategoryUseCase(this._categoryRepository);

  Future<Category> call(String name, String slug, String? description, String? imageUrl, String? parentId) async {
    return _categoryRepository.createCategory(name: name, slug: slug, description: description, imageUrl: imageUrl, parentId: parentId);
  }
}