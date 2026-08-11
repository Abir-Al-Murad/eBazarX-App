import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:ebazarx/features/category/domain/repositories/category_repository.dart';

class FetchAllCategories {
  final CategoryRepository repository;
  const FetchAllCategories(this.repository);
  Future<List<Category>> call({int skip = 0, int limit = 20, String? name, String? slug, String? parentId, bool? isActive, bool includeDeleted = false}) {
    return repository.fetchAdminCategories(skip: skip, limit: limit, name: name, slug: slug, parentId: parentId, isActive: isActive, includeDeleted: includeDeleted,);
  }
}
