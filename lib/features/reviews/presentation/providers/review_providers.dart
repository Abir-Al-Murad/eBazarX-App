import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/reviews/data/datasources/review_remote_data_source.dart';
import 'package:ebazarx/features/reviews/data/repositories/review_repository_impl.dart';
import 'package:ebazarx/features/reviews/domain/repositories/review_repository.dart';
import 'package:ebazarx/features/reviews/domain/usecases/admin_delete_review_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/admin_list_pending_reports_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/admin_list_reviews_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/admin_resolve_report_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/admin_toggle_hide_review_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/create_review_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/delete_review_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/get_product_reviews_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/get_review_details_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/get_review_statistics_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/reply_review_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/report_review_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/update_review_usecase.dart';
import 'package:ebazarx/features/reviews/domain/usecases/vote_review_usecase.dart';
import 'package:ebazarx/features/reviews/presentation/notifiers/admin_review_notifier.dart';
import 'package:ebazarx/features/reviews/presentation/notifiers/customer_review_notifier.dart';
import 'package:ebazarx/features/reviews/presentation/notifiers/seller_review_notifier.dart';
import 'package:ebazarx/features/reviews/presentation/states/admin_review_state.dart';
import 'package:ebazarx/features/reviews/presentation/states/customer_review_state.dart';
import 'package:ebazarx/features/reviews/presentation/states/seller_review_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Remote Data Source
final reviewRemoteDataSourceProvider = Provider<ReviewRemoteDataSource>((ref) {
  return ReviewRemoteDataSource(ref.read(apiClientProvider));
});

/// Repository
final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(ref.read(reviewRemoteDataSourceProvider));
});

/// Customer
final createReviewUseCaseProvider = Provider(
  (ref) => CreateReviewUseCase(ref.read(reviewRepositoryProvider)),
);

final updateReviewUseCaseProvider = Provider(
  (ref) => UpdateReviewUseCase(ref.read(reviewRepositoryProvider)),
);

final deleteReviewUseCaseProvider = Provider(
  (ref) => DeleteReviewUseCase(ref.read(reviewRepositoryProvider)),
);

final voteReviewUseCaseProvider = Provider(
  (ref) => VoteReviewUseCase(ref.read(reviewRepositoryProvider)),
);

final reportReviewUseCaseProvider = Provider(
  (ref) => ReportReviewUseCase(ref.read(reviewRepositoryProvider)),
);

/// Public
final getProductReviewsUseCaseProvider = Provider(
  (ref) => GetProductReviewsUseCase(ref.read(reviewRepositoryProvider)),
);

final getReviewDetailsUseCaseProvider = Provider(
  (ref) => GetReviewDetailsUseCase(ref.read(reviewRepositoryProvider)),
);

final getReviewStatisticsUseCaseProvider = Provider(
  (ref) => GetReviewStatisticsUseCase(ref.read(reviewRepositoryProvider)),
);

/// Seller
final replyReviewUseCaseProvider = Provider(
  (ref) => ReplyReviewUseCase(ref.read(reviewRepositoryProvider)),
);

/// Admin
final adminListReviewsUseCaseProvider = Provider(
  (ref) => AdminListReviewsUseCase(ref.read(reviewRepositoryProvider)),
);

final adminToggleHideReviewUseCaseProvider = Provider(
  (ref) => AdminToggleHideReviewUseCase(ref.read(reviewRepositoryProvider)),
);

final adminDeleteReviewUseCaseProvider = Provider(
  (ref) => AdminDeleteReviewUseCase(ref.read(reviewRepositoryProvider)),
);

final adminListPendingReportsUseCaseProvider = Provider(
  (ref) => AdminListPendingReportsUseCase(ref.read(reviewRepositoryProvider)),
);

final adminResolveReportUseCaseProvider = Provider(
  (ref) => AdminResolveReportUseCase(ref.read(reviewRepositoryProvider)),
);

final customerReviewNotifierProvider =
    StateNotifierProvider<CustomerReviewNotifier, CustomerReviewState>((ref) {
      return CustomerReviewNotifier(
        ref.read(getProductReviewsUseCaseProvider),
        ref.read(getReviewDetailsUseCaseProvider),
        ref.read(getReviewStatisticsUseCaseProvider),
        ref.read(createReviewUseCaseProvider),
        ref.read(updateReviewUseCaseProvider),
        ref.read(deleteReviewUseCaseProvider),
        ref.read(voteReviewUseCaseProvider),
        ref.read(reportReviewUseCaseProvider),
      );
    });

/// =======================================================
/// Seller
/// =======================================================

final sellerReviewNotifierProvider =
    StateNotifierProvider<SellerReviewNotifier, SellerReviewState>((ref) {
      return SellerReviewNotifier(
        ref.read(replyReviewUseCaseProvider),
        ref.read(getReviewDetailsUseCaseProvider),
      );
    });

/// =======================================================
/// Admin
/// =======================================================

final adminReviewNotifierProvider =
    StateNotifierProvider<AdminReviewNotifier, AdminReviewState>((ref) {
      return AdminReviewNotifier(
        ref.read(adminListReviewsUseCaseProvider),
        ref.read(adminDeleteReviewUseCaseProvider),
        ref.read(adminToggleHideReviewUseCaseProvider),
        ref.read(adminListPendingReportsUseCaseProvider),
        ref.read(adminResolveReportUseCaseProvider),
      );
    });
