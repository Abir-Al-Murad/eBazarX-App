import 'package:ebazarx/admin/reviews/notifiers/admin_review_crud_notifier.dart';
import 'package:ebazarx/admin/reviews/notifiers/admin_review_list_notifier.dart';
import 'package:ebazarx/admin/reviews/notifiers/admin_review_notifier.dart';
import 'package:ebazarx/admin/reviews/states/admin_review_crud_state.dart';
import 'package:ebazarx/admin/reviews/states/admin_review_list_state.dart';
import 'package:ebazarx/admin/reviews/states/admin_review_state.dart';
import 'package:ebazarx/features/reviews/presentation/providers/review_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// =======================================================
/// Admin
/// =======================================================

// final adminReviewNotifierProvider =
// StateNotifierProvider<AdminReviewNotifier, AdminReviewState>((ref) {
//   return AdminReviewNotifier(
//     ref.read(adminListReviewsUseCaseProvider),
//     ref.read(adminDeleteReviewUseCaseProvider),
//     ref.read(adminToggleHideReviewUseCaseProvider),
//     ref.read(adminListPendingReportsUseCaseProvider),
//     ref.read(adminResolveReportUseCaseProvider),
//   );
// });

// ============================================================
// LIST NOTIFIER
// ============================================================

final adminReviewListNotifierProvider =
    StateNotifierProvider<AdminReviewListNotifier, AdminReviewListState>(
      (ref) => AdminReviewListNotifier(
        ref.read(adminListReviewsUseCaseProvider),
        ref.read(adminListPendingReportsUseCaseProvider),
      ),
    );

// ============================================================
// CRUD NOTIFIER
// ============================================================

final adminReviewCrudNotifierProvider =
    StateNotifierProvider<AdminReviewCrudNotifier, AdminReviewCrudState>(
      (ref) => AdminReviewCrudNotifier(
        ref.read(adminDeleteReviewUseCaseProvider),
        ref.read(adminToggleHideReviewUseCaseProvider),
        ref.read(adminResolveReportUseCaseProvider),
      ),
    );
