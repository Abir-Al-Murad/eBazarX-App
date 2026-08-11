import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:ebazarx/features/category/domain/repositories/category_repository.dart';

class GetAdminCategoryById {
  final CategoryRepository repository;
  const GetAdminCategoryById(this.repository);
  Future<Category> call(String categoryId, {bool includeDeleted = false}) {
    return repository.getAdminCategoryById(
      categoryId,
      includeDeleted: includeDeleted,
    );
  }
}
