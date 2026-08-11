import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/address/domain/entities/address_entity.dart';
import 'package:ebazarx/features/address/presentation/providers/address_providers.dart';
import 'package:ebazarx/features/cart/presentation/providers/cart_providers.dart';
import 'package:ebazarx/features/coupon/presentation/providers/coupon_providers.dart';
import 'package:ebazarx/features/order/domain/entities/checkout_item_entity.dart';
import 'package:ebazarx/features/order/domain/entities/payment_method.dart';
import 'package:ebazarx/features/order/presentation/providers/order_providers.dart';
import 'package:ebazarx/features/profile/presentation/providers/profile_provider.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.items,
    required this.fromCart,
    required this.subtotal,
  });

  final List<CheckoutItemEntity> items;
  final bool fromCart;
  final double subtotal;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final TextEditingController noteController = TextEditingController();
  final TextEditingController couponController = TextEditingController();

  PaymentMethod _paymentMethod = PaymentMethod.cod;
  AddressEntity? selectedAddress;

  double _discount = 0.0;
  late double _subtotal;

  static const _paymentOptions = [
    (PaymentMethod.cod, 'Cash on Delivery', Icons.payments_outlined),
    (
      PaymentMethod.sslcommerz,
      'SSLCommerz (bKash/Nagad/Cards)',
      Icons.credit_card_rounded,
    ),
  ];

  double get _shipping => 100.0;
  double get _tax => 100.0;
  double get _total => _subtotal + _shipping + _tax - _discount;

  @override
  void initState() {
    super.initState();
    _subtotal = widget.subtotal;
    Future.microtask(() async {
      await ref.read(addressListProvider.notifier).loadAddresses();
      final addresses = ref.read(addressListProvider).addresses;
      if (addresses.isNotEmpty && mounted) {
        setState(() {
          selectedAddress = addresses.firstWhere(
            (e) => e.isDefault,
            orElse: () => addresses.first,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    noteController.dispose();
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressListProvider);
    final orderState = ref.watch(orderNotifierProvider);
    final profileState = ref.watch(profileNotifierProvider);
    final couponState = ref.watch(validateCouponProvider);
    final theme = Theme.of(context);

    final currentDiscount = couponState.coupon?.discountAmount ?? 0.0;
    if (_discount != currentDiscount) {
      _discount = currentDiscount;
    }

    // ✅ Listen for payment redirect (SSLCommerz)
    ref.listen(orderNotifierProvider, (prev, next) {
      if (next.paymentRedirectUrl != null &&
          next.paymentRedirectUrl!.isNotEmpty) {
        // Open WebView for SSLCommerz
        context.push(
          '/payment-webview',
          extra: {
            'url': next.paymentRedirectUrl!,
            'orderId': next.order!.id,
            'paymentId': next.paymentId!,
          },
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(
            fontSize: context.fontSizeLarge,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: addressState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : addressState.addresses.isEmpty
            ? const _NoAddressState()
            : context.isDesktop
            ? _buildDesktopLayout(context, addressState, orderState)
            : _buildMobileLayout(context, addressState, orderState),
      ),
      bottomNavigationBar: context.isDesktop
          ? null
          : _buildPlaceOrderBar(context, orderState, profileState, couponState),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    addressState,
    dynamic orderState,
  ) {
    return ListView(
      padding: EdgeInsets.all(context.paddingSizeDefault),
      children: [
        _buildAddressSection(context, addressState.addresses),
        SizedBox(height: context.paddingSizeDefault),
        _buildPaymentSection(context),
        SizedBox(height: context.paddingSizeDefault),
        _buildCouponSection(context),
        SizedBox(height: context.paddingSizeDefault),
        _buildSummarySection(context),
        SizedBox(height: context.paddingSizeDefault),
        _buildNoteSection(context),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    addressState,
    dynamic orderState,
  ) {
    final profileState = ref.watch(profileNotifierProvider);
    final couponState = ref.watch(validateCouponProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: ListView(
            padding: EdgeInsets.all(context.paddingSizeDefault),
            children: [
              _buildAddressSection(context, addressState.addresses),
              SizedBox(height: context.paddingSizeDefault),
              _buildPaymentSection(context),
              SizedBox(height: context.paddingSizeDefault),
              _buildCouponSection(context),
              SizedBox(height: context.paddingSizeDefault),
              _buildNoteSection(context),
            ],
          ),
        ),
        SizedBox(
          width: 360,
          child: Padding(
            padding: EdgeInsets.all(context.paddingSizeDefault),
            child: Column(
              children: [
                _buildSummarySection(context),
                SizedBox(height: context.paddingSizeDefault),
                _buildPlaceOrderBar(
                  context,
                  orderState,
                  profileState,
                  couponState,
                  isSticky: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ADDRESS SECTION
  // ============================================================

  Widget _buildAddressSection(
    BuildContext context,
    List<AddressEntity> addresses,
  ) {
    final theme = Theme.of(context);

    return _SectionCard(
      title: "Delivery Address",
      icon: Icons.location_on_rounded,
      trailing: TextButton.icon(
        onPressed: () {
          // TODO: Navigate to Add Address
        },
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text("Add new"),
      ),
      child: Column(
        children: addresses.map((address) {
          final isSelected = selectedAddress?.id == address.id;

          return Padding(
            padding: EdgeInsets.only(bottom: context.paddingSizeSmall),
            child: InkWell(
              borderRadius: BorderRadius.circular(context.radiusDefault),
              onTap: () => setState(() => selectedAddress = address),
              child: Container(
                padding: EdgeInsets.all(context.paddingSizeSmall),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.radiusDefault),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.dividerColor,
                    width: isSelected ? 1.5 : 1,
                  ),
                  color: isSelected
                      ? theme.colorScheme.primary.withAlpha(13)
                      : Colors.transparent,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      size: 20,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.hintColor,
                    ),
                    SizedBox(width: context.paddingSizeSmall),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                address.fullName,
                                style: TextStyle(
                                  fontSize: context.fontSizeDefault,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              if (address.isDefault) ...[
                                SizedBox(width: context.paddingSizeExtraSmall),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withAlpha(
                                      31,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "DEFAULT",
                                    style: TextStyle(
                                      fontSize: context.fontSizeExtraSmall,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: context.paddingSizeExtraSmall / 2),
                          Text(
                            address.phone,
                            style: TextStyle(
                              fontSize: context.fontSizeSmall,
                              color: theme.hintColor,
                            ),
                          ),
                          Text(
                            "${address.addressLine}, ${address.area ?? ""}, ${address.upazila ?? ""}, ${address.district ?? ""}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: context.fontSizeSmall,
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================
  // PAYMENT SECTION
  // ============================================================

  Widget _buildPaymentSection(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionCard(
      title: "Payment Method",
      icon: Icons.account_balance_wallet_outlined,
      child: Column(
        children: _paymentOptions.map((option) {
          final (method, label, icon) = option;
          final isSelected = _paymentMethod == method;

          return Padding(
            padding: EdgeInsets.only(bottom: context.paddingSizeSmall),
            child: InkWell(
              borderRadius: BorderRadius.circular(context.radiusDefault),
              onTap: () => setState(() => _paymentMethod = method),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.paddingSizeDefault,
                  vertical: context.paddingSizeSmall,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.radiusDefault),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.dividerColor,
                    width: isSelected ? 1.5 : 1,
                  ),
                  color: isSelected
                      ? theme.colorScheme.primary.withAlpha(20)
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.hintColor,
                    ),
                    SizedBox(width: context.paddingSizeSmall),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: context.fontSizeDefault,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          if (method == PaymentMethod.sslcommerz)
                            Text(
                              "Secure payment via SSLCommerz (bKash, Nagad, Rocket, Cards)",
                              style: TextStyle(
                                fontSize: context.fontSizeExtraSmall,
                                color: theme.hintColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      size: 20,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.hintColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================
  // COUPON SECTION
  // ============================================================

  Widget _buildCouponSection(BuildContext context) {
    final theme = Theme.of(context);
    final couponState = ref.watch(validateCouponProvider);
    final couponNotifier = ref.read(validateCouponProvider.notifier);

    return _SectionCard(
      title: "Coupon Code",
      icon: Icons.local_offer_outlined,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: couponController,
              style: TextStyle(fontSize: context.fontSizeSmall),
              decoration: InputDecoration(
                hintText: "Enter coupon code",
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.paddingSizeSmall,
                  vertical: context.paddingSizeSmall,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.radiusDefault),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
              ),
            ),
          ),
          SizedBox(width: context.paddingSizeSmall),
          FilledButton(
            onPressed: () async {
              final code = couponController.text.trim();
              if (code.isEmpty) {
                AppSnackBar.warning(
                  context: context,
                  "Please enter a coupon code",
                );
                return;
              }

              final profile = ref.read(profileNotifierProvider).profile;
              if (profile == null) {
                AppSnackBar.error(context: context, "User profile not loaded");
                return;
              }

              final res = await couponNotifier.validateCoupon(
                code: code,
                subtotal: widget.subtotal,
                userId: profile.id,
              );

              if (!mounted) return;

              if (res && couponState.coupon!.valid) {
                setState(() {
                  _discount =
                      ref.read(validateCouponProvider).coupon?.discountAmount ??
                      0;
                });
                AppSnackBar.success(
                  context: context,
                  "Coupon applied successfully",
                );
                couponController.clear();
              } else {
                final failure = ref.read(validateCouponProvider).failure;
                AppSnackBar.error(
                  context: context,
                  failure?.message ?? "Invalid coupon code",
                );
              }
            },
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: context.paddingSizeDefault,
                vertical: context.paddingSizeSmall,
              ),
            ),
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUMMARY SECTION
  // ============================================================

  Widget _buildSummarySection(BuildContext context) {
    final theme = Theme.of(context);

    Widget row(
      String label,
      String value, {
      bool isTotal = false,
      Color? valueColor,
    }) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.paddingSizeExtraSmall / 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isTotal
                    ? context.fontSizeDefault
                    : context.fontSizeSmall,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? theme.colorScheme.onSurface : theme.hintColor,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: isTotal
                    ? context.fontSizeLarge
                    : context.fontSizeSmall,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                color: valueColor ?? theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    return _SectionCard(
      title: "Order Summary",
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          row("Subtotal", "৳ ${widget.subtotal.toStringAsFixed(2)}"),
          row("Shipping Fee", "৳ ${_shipping.toStringAsFixed(2)}"),
          row("Tax", "৳ ${_tax.toStringAsFixed(2)}"),
          row(
            "Discount",
            "- ৳ ${_discount.toStringAsFixed(2)}",
            valueColor: AppColors.success,
          ),
          Divider(height: context.paddingSizeLarge, color: theme.dividerColor),
          row("Total", "৳ ${_total.toStringAsFixed(2)}", isTotal: true),
        ],
      ),
    );
  }

  // ============================================================
  // NOTE SECTION
  // ============================================================

  Widget _buildNoteSection(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionCard(
      title: "Order Note (optional)",
      icon: Icons.edit_note_rounded,
      child: TextField(
        controller: noteController,
        maxLines: 3,
        style: TextStyle(fontSize: context.fontSizeSmall),
        decoration: InputDecoration(
          hintText: "Any delivery instructions...",
          isDense: true,
          contentPadding: EdgeInsets.all(context.paddingSizeSmall),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.radiusDefault),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PLACE ORDER BAR
  // ============================================================

  Widget _buildPlaceOrderBar(
    BuildContext context,
    dynamic orderState,
    dynamic profileState,
    dynamic couponState, {
    bool isSticky = false,
  }) {
    final theme = Theme.of(context);

    final canPlace =
        !orderState.isLoading &&
        selectedAddress != null &&
        profileState.profile != null;

    final button = SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        onPressed: canPlace
            ? () async {
                if (_paymentMethod == PaymentMethod.sslcommerz) {
                  await _handleSslCommerzCheckout();
                } else {
                  await _handleCodCheckout();
                }
              }
            : null,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radiusDefault),
          ),
        ),
        child: orderState.isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.onPrimary,
                ),
              )
            : Text(
                "Place Order  •  ৳ ${_total.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: context.fontSizeDefault,
                ),
              ),
      ),
    );

    if (isSticky) return button;

    return Container(
      padding: EdgeInsets.all(context.paddingSizeDefault),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: SafeArea(top: false, child: button),
    );
  }

  // ============================================================
  // PAYMENT HANDLERS
  // ============================================================

  Future<void> _handleCodCheckout() async {
    final coupon = ref.read(validateCouponProvider).coupon;

    final success = await ref
        .read(orderNotifierProvider.notifier)
        .placeOrder(
          addressId: selectedAddress!.id,
          items: widget.items,
          couponCode: coupon?.couponId,
          notes: noteController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      if (widget.fromCart) {
        await ref.read(cartNotifierProvider.notifier).clearCart();
      }
      AppSnackBar.success(context: context, "Order placed successfully");
      ref.read(orderListNotifierProvider.notifier).loadOrders();
      context.pop();
      // TODO: Navigate to order success screen
    } else {
      final failure =
          ref.read(orderNotifierProvider).failure?.message ??
          "Failed to place order";
      AppSnackBar.error(context: context, failure);
    }
  }

  Future<void> _handleSslCommerzCheckout() async {
    final notifier = ref.read(orderNotifierProvider.notifier);
    final coupon = ref.read(validateCouponProvider).coupon;

    // Step 1: Place order and initiate SSLCommerz payment
    await notifier.initiateCheckout(
      addressId: selectedAddress!.id,
      items: widget.items,
      paymentMethod: PaymentMethod.sslcommerz,
      couponCode: coupon?.couponId,
      notes: noteController.text.trim(),
      successUrl: 'ebazar://payment/success', // deep link
      cancelUrl: 'ebazar://payment/fail',
    );

    if (!mounted) return;

    final state = ref.read(orderNotifierProvider);

    if (state.failure != null) {
      AppSnackBar.error(context: context, state.failure!.message);
    }
    // If paymentRedirectUrl is set, the listener will open WebView
  }
}

// ============================================================
// HELPER WIDGETS
// ============================================================

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(context.paddingSizeDefault),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(context.radiusLarge),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              SizedBox(width: context.paddingSizeExtraSmall),
              Text(
                title,
                style: TextStyle(
                  fontSize: context.fontSizeDefault,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: context.paddingSizeDefault),
          child,
        ],
      ),
    );
  }
}

class _NoAddressState extends StatelessWidget {
  const _NoAddressState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.paddingSizeDefault),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off_outlined, size: 56, color: theme.hintColor),
            SizedBox(height: context.paddingSizeDefault),
            Text(
              "No delivery address found",
              style: TextStyle(
                fontSize: context.fontSizeDefault,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: context.paddingSizeSmall),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Navigate to Add Address
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text("Add Address"),
            ),
          ],
        ),
      ),
    );
  }
}
