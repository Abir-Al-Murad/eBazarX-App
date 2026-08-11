import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:ebazarx/features/category/domain/repositories/category_repository.dart';

class GetCategoryById {
  final CategoryRepository repository;
  const GetCategoryById(this.repository);
  Future<Category> call(String categoryId) {
    return repository.getCategoryById(categoryId);
  }
}
