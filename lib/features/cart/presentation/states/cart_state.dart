import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/cart/domain/entities/cart_entity.dart';
import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  final CartEntity? cart;
  final bool isLoading;
  final bool isUpdating;
  final bool isClearing;
  final Failure? failure;
  final Failure? cartListFailure;
  final Set<String> updatingItemIds;
  final Set<String> removingItemIds;

  const CartState({
    this.cart,
    this.isLoading = false,
    this.isUpdating = false,
    this.isClearing = false,
    this.failure,
    this.cartListFailure,
    this.updatingItemIds = const {},
    this.removingItemIds = const {},
  });

  CartState copyWith({
    CartEntity? cart,
    bool? isLoading,
    bool? isUpdating,
    bool? isClearing,
    Failure? failure,
    Failure? cartListFailure,
    bool clearFailure = false,
    Set<String>? updatingItemIds,
    Set<String>? removingItemIds,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isClearing: isClearing ?? this.isClearing,
      failure: clearFailure ? null : (failure ?? this.failure),
      cartListFailure: clearFailure ? null : cartListFailure ?? this.cartListFailure,
      updatingItemIds: updatingItemIds ?? this.updatingItemIds,
      removingItemIds: removingItemIds ?? this.removingItemIds,
    );
  }

  bool isUpdatingItem(String itemId) => updatingItemIds.contains(itemId);
  bool isRemovingItem(String itemId) => removingItemIds.contains(itemId);
  int get totalItems => cart?.totalItems ?? 0;
  double get subtotal => cart?.subtotal ?? 0.0;
  bool get isEmpty => cart?.items.isEmpty ?? true;

  @override
  List<Object?> get props => [
    cart,
    isLoading,
    isUpdating,
    isClearing,
    failure,
    updatingItemIds,
    removingItemIds,
  ];
}