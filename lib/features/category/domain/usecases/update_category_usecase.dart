import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:ebazarx/features/category/domain/repositories/category_repository.dart';

class UpdateCategoryUseCase {
  final CategoryRepository _categoryRepository;
  UpdateCategoryUseCase(this._categoryRepository);

  Future<Category> call(String name, String slug, String? description, String? imageUrl, String? parentId,String categoryId) async {
    return _categoryRepository.updateCategory(name: name, slug: slug, description: description, imageUrl: imageUrl, parentId: parentId, id: categoryId);
  }
}