
import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/category/domain/entities/category_entity.dart';

class AdminCategoryCrudState {
final bool isCreating;
final bool isUpdating;
final bool isDeleting;

final Category? category;

final Failure? failure;

const AdminCategoryCrudState({
this.isCreating = false,
this.isUpdating = false,
this.isDeleting = false,
this.category,
this.failure,
});

AdminCategoryCrudState copyWith({
bool? isCreating,
bool? isUpdating,
bool? isDeleting,
Category? category,
Failure? failure,
bool clearFailure = false,
bool clearCategory = false,
}) {
return AdminCategoryCrudState(
isCreating:
isCreating ?? this.isCreating,

isUpdating:
isUpdating ?? this.isUpdating,

isDeleting:
isDeleting ?? this.isDeleting,

category: clearCategory
? null
    : category ?? this.category,

failure: clearFailure
? null
    : failure ?? this.failure,
);
}
}

