
import 'package:ebazarx/admin/categories/providers/admin_category_providers.dart';
import 'package:ebazarx/admin/categories/states/admin_category_crud_state.dart';
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/category/domain/usecases/create_category_usecase.dart';
import 'package:ebazarx/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:ebazarx/features/category/domain/usecases/update_category_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminCategoryCrudNotifier
extends StateNotifier<AdminCategoryCrudState> {

final Ref ref;

late final CreateCategoryUseCase _createCategory;
late final UpdateCategoryUseCase _updateCategory;
late final DeleteCategoryUseCase _deleteCategory;

AdminCategoryCrudNotifier(this.ref)
    : super(const AdminCategoryCrudState()) {

_createCategory =
ref.read(createCategoryUseCaseProvider);

_updateCategory =
ref.read(updateCategoryUseCaseProvider);

_deleteCategory =
ref.read(deleteCategoryUseCaseProvider);
}

// ============================================================
// CREATE
// ============================================================

Future<bool> createCategory({
required String name,
required String slug,
String? description,
String? imageUrl,
String? parentId,
}) async {

state = state.copyWith(
isCreating: true,
clearFailure: true,
);

try {

final category = await _createCategory(
name,
slug,
description,
imageUrl,
parentId,
);

state = state.copyWith(
isCreating: false,
category: category,
clearFailure: true,
);

return true;

} on Failure catch (e) {

state = state.copyWith(
isCreating: false,
failure: e,
);

return false;

} catch (e) {

state = state.copyWith(
isCreating: false,
failure: UnknownFailure(
e.toString(),
),
);

return false;
}
}

// ============================================================
// UPDATE
// ============================================================

Future<bool> updateCategory({
required String id,
required String name,
required String slug,
String? description,
String? imageUrl,
String? parentId,
}) async {

state = state.copyWith(
isUpdating: true,
clearFailure: true,
);

try {

final updatedCategory =
await _updateCategory(
name,
slug,
description,
imageUrl,
parentId,
id,
);

state = state.copyWith(
isUpdating: false,
category: updatedCategory,
clearFailure: true,
);

return true;

} on Failure catch (e) {

state = state.copyWith(
isUpdating: false,
failure: e,
);

return false;

} catch (e) {

state = state.copyWith(
isUpdating: false,
failure: UnknownFailure(
e.toString(),
),
);

return false;
}
}

// ============================================================
// DELETE
// ============================================================

Future<bool> deleteCategory(
String id,
) async {

state = state.copyWith(
isDeleting: true,
clearFailure: true,
);

try {

await _deleteCategory(id);

state = state.copyWith(
isDeleting: false,
clearFailure: true,
);

return true;

} on Failure catch (e) {

state = state.copyWith(
isDeleting: false,
failure: e,
);

return false;

} catch (e) {

state = state.copyWith(
isDeleting: false,
failure: UnknownFailure(
e.toString(),
),
);

return false;
}
}

// ============================================================
// CLEAR FAILURE
// ============================================================

void clearFailure() {

state = state.copyWith(
clearFailure: true,
);
}

// ============================================================
// CLEAR STATE
// ============================================================

void clear() {

state = const AdminCategoryCrudState();
}
}
