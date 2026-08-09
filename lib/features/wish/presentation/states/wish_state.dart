import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/wish/domain/entities/wishlist_entity.dart';
import 'package:equatable/equatable.dart';

class WishState extends Equatable {
  /// Entire wishlist
  final WishlistEntity? wishlist;

  /// Initial loading
  final bool isLoading;

  /// Pagination
  final bool isLoadingMore;

  /// Refresh
  final bool isRefreshing;

  /// Whether more items exist
  final bool hasMore;

  /// Pagination values
  final int skip;
  final int limit;

  /// Failure
  final Failure? failure;

  /// Variant IDs currently being added
  final Set<String> addingVariantIds;

  /// Wishlist Item IDs currently being removed
  final Set<String> removingItemIds;

  bool isInWishlist(String variantId) {
    return wishlist?.items.any((e) => e.variantId == variantId) ?? false;
  }

  const WishState({
    this.wishlist,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.hasMore = true,
    this.skip = 0,
    this.limit = 20,
    this.failure,
    this.addingVariantIds = const {},
    this.removingItemIds = const {},
  });

  WishState copyWith({
    WishlistEntity? wishlist,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    bool? hasMore,
    int? skip,
    int? limit,
    Failure? failure,
    bool clearFailure = false,
    Set<String>? addingVariantIds,
    Set<String>? removingItemIds,
  }) {
    return WishState(
      wishlist: wishlist ?? this.wishlist,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasMore: hasMore ?? this.hasMore,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      failure: clearFailure ? null : (failure ?? this.failure),
      addingVariantIds: addingVariantIds ?? this.addingVariantIds,
      removingItemIds: removingItemIds ?? this.removingItemIds,
    );
  }

  /// UI Helpers

  bool isAdding(String variantId) =>
      addingVariantIds.contains(variantId);

  bool isRemoving(String itemId) =>
      removingItemIds.contains(itemId);

  bool isWishlisted(String variantId) {
    final list = wishlist?.items ?? [];
    return list.any((e) => e.variantId == variantId);
  }



  @override
  List<Object?> get props => [
    wishlist,
    isLoading,
    isLoadingMore,
    isRefreshing,
    hasMore,
    skip,
    limit,
    failure,
    addingVariantIds,
    removingItemIds,
  ];
}