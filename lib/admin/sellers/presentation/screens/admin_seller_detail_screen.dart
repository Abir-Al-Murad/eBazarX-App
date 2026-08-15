// admin/sellers/presentation/screens/seller_detail_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebazarx/admin/sellers/domain/entities/seller_entity.dart';
import 'package:ebazarx/admin/sellers/presentation/providers/seller_providers.dart';
import 'package:ebazarx/common/widgets/confirm_dialog.dart';
import 'package:ebazarx/common/widgets/status_chip.dart';
import 'package:ebazarx/core/utils/app_snackbar.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminSellerDetailScreen extends ConsumerStatefulWidget {
  final SellerEntity seller;

  const AdminSellerDetailScreen({super.key, required this.seller});

  @override
  ConsumerState<AdminSellerDetailScreen> createState() =>
      _AdminSellerDetailScreenState();
}

class _AdminSellerDetailScreenState extends ConsumerState<AdminSellerDetailScreen> {
  final TextEditingController _adminNotesController = TextEditingController();
  final _dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

  @override
  void dispose() {
    _adminNotesController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus(String status, {bool destructive = false}) async {
    if (destructive) {
      final confirmed = await ConfirmDialog(
        title: status == 'rejected' ? 'Reject seller?' : 'Confirm action',
        message: status == 'rejected'
            ? 'This will reject "${widget.seller.shopName}". They can be reconsidered later.'
            : 'Are you sure you want to continue?',
        confirmLabel: status == 'rejected' ? 'Reject' : 'Confirm',
      );
      if (confirmed != true) return;
    }

    final notifier = ref.read(sellerCrudNotifierProvider.notifier);
    final success = await notifier.updateSellerStatus(
      sellerId: widget.seller.id,
      status: status,
      adminNotes: _adminNotesController.text.trim().isEmpty
          ? null
          : _adminNotesController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      AppSnackBar.success(context: context, 'Seller ${widget.seller.shopName} $status');
      Navigator.pop(context, true);
    } else {
      final failure = ref.read(sellerCrudNotifierProvider).failure;
      AppSnackBar.error(context: context, failure?.toString() ?? 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final crudState = ref.watch(sellerCrudNotifierProvider);
    final seller = widget.seller;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _Header(seller: seller)),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    context.paddingSizeLarge,
                    0,
                    context.paddingSizeLarge,
                    context.paddingSizeLarge,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: context.paddingSizeLarge),
                            _StatsRow(seller: seller),
                            SizedBox(height: context.paddingSizeLarge),
                            _SectionCard(
                              title: 'Contact & Location',
                              icon: Icons.place_outlined,
                              children: [
                                _InfoRow(label: 'Email', value: seller.userEmail ?? seller.email),
                                _InfoRow(label: 'Phone', value: seller.userPhone ?? seller.phone),
                                _InfoRow(label: 'Address', value: seller.address),
                                _InfoRow(
                                  label: 'City / District',
                                  value: [seller.city, seller.district]
                                      .whereType<String>()
                                      .where((e) => e.isNotEmpty)
                                      .join(', '),
                                ),
                                _InfoRow(label: 'Country', value: seller.country),
                              ],
                            ),
                            SizedBox(height: context.paddingSizeDefault),
                            _SectionCard(
                              title: 'Business Documents',
                              icon: Icons.description_outlined,
                              children: [
                                _InfoRow(label: 'Trade License', value: seller.tradeLicense),
                                _InfoRow(label: 'NID', value: seller.nid),
                                _InfoRow(label: 'TIN', value: seller.tin),
                              ],
                            ),
                            SizedBox(height: context.paddingSizeDefault),
                            _SectionCard(
                              title: 'Account Info',
                              icon: Icons.info_outline_rounded,
                              children: [
                                _InfoRow(label: 'Seller ID', value: seller.id),
                                _InfoRow(label: 'User ID', value: seller.userId),
                                _InfoRow(label: 'Commission Rate', value: '${seller.commissionRate.toStringAsFixed(1)}%'),
                                _InfoRow(label: 'Joined', value: _dateFormat.format(seller.joinedAt)),
                                _InfoRow(label: 'Created', value: _dateFormat.format(seller.createdAt)),
                                _InfoRow(label: 'Updated', value: _dateFormat.format(seller.updatedAt)),
                              ],
                            ),
                            SizedBox(height: context.paddingSizeDefault),
                            _SectionCard(
                              title: 'Admin Notes',
                              icon: Icons.edit_note_rounded,
                              children: [
                                TextField(
                                  controller: _adminNotesController,
                                  maxLines: 3,
                                  style: TextStyle(fontSize: context.fontSizeDefault),
                                  decoration: InputDecoration(
                                    hintText: 'Add a note visible to other admins (optional)',
                                    filled: true,
                                    fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(context.radiusDefault),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: context.paddingSizeExtraLarge),
                            if (crudState.isFailure)
                              Padding(
                                padding: EdgeInsets.only(bottom: context.paddingSizeDefault),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline_rounded, size: 16, color: AppColors.error),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        crudState.failure?.toString() ?? 'Error',
                                        style: TextStyle(color: AppColors.error, fontSize: context.fontSizeSmall),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            _ActionButtons(
                              status: seller.status,
                              isLoading: crudState.isLoading,
                              onApprove: () => _updateStatus('active'),
                              onReject: () => _updateStatus('rejected', destructive: true),
                              onSetPending: () => _updateStatus('pending'),
                            ),
                            SizedBox(height: context.paddingSizeLarge),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (crudState.isLoading)
              Container(
                color: theme.colorScheme.scrim.withValues(alpha: 0.15),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

// ================================
// Header: back button + avatar + name + status
// ================================
class _Header extends StatelessWidget {
  const _Header({required this.seller});

  final SellerEntity seller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        context.paddingSizeLarge,
        context.paddingSizeDefault,
        context.paddingSizeLarge,
        context.paddingSizeLarge,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.paddingSizeDefault),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Avatar(seller: seller, size: 56),
                  SizedBox(width: context.paddingSizeDefault),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                seller.shopName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(width: context.paddingSizeSmall),
                            StatusChip(status: seller.status, showDot: false),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '@${seller.shopSlug}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.seller, required this.size});

  final SellerEntity seller;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoUrl = seller.logo;

    if (logoUrl != null && logoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(context.radiusDefault),
        child: CachedNetworkImage(
          imageUrl: logoUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            width: size,
            height: size,
            color: theme.dividerColor.withValues(alpha: 0.2),
          ),
          errorWidget: (_, __, ___) => _InitialAvatar(seller: seller, size: size),
        ),
      );
    }

    return _InitialAvatar(seller: seller, size: size);
  }
}

class _InitialAvatar extends StatelessWidget {
  const _InitialAvatar({required this.seller, required this.size});

  final SellerEntity seller;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(context.radiusDefault),
      ),
      alignment: Alignment.center,
      child: Text(
        seller.shopName.isNotEmpty ? seller.shopName[0].toUpperCase() : '?',
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}

// ================================
// Stats row: rating / products / orders / commission
// ================================
class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.seller});

  final SellerEntity seller;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (Icons.star_rounded, 'Rating', seller.averageRating > 0 ? seller.averageRating.toStringAsFixed(1) : '—', AppColors.warning),
      (Icons.inventory_2_outlined, 'Products', '${seller.totalProducts}', null),
      (Icons.receipt_long_outlined, 'Orders', '${seller.totalOrders}', null),
      (Icons.percent_rounded, 'Commission', '${seller.commissionRate.toStringAsFixed(1)}%', null),
    ];

    return context.responsive<Widget>(
      mobile: Wrap(
        spacing: context.paddingSizeSmall,
        runSpacing: context.paddingSizeSmall,
        children: stats.map((s) => _StatCard(icon: s.$1, label: s.$2, value: s.$3, color: s.$4, compact: true)).toList(),
      ),
      tablet: Row(
        children: stats
            .map((s) => Expanded(child: _StatCard(icon: s.$1, label: s.$2, value: s.$3, color: s.$4)))
            .toList()
            .let((list) => _withGaps(list, context.paddingSizeSmall)),
      ),
      desktop: Row(
        children: stats
            .map((s) => Expanded(child: _StatCard(icon: s.$1, label: s.$2, value: s.$3, color: s.$4)))
            .toList()
            .let((list) => _withGaps(list, context.paddingSizeDefault)),
      ),
    );
  }

  static List<Widget> _withGaps(List<Widget> children, double gap) {
    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) result.add(SizedBox(width: gap));
      result.add(children[i]);
    }
    return result;
  }
}

extension _Let<T> on T {
  R let<R>(R Function(T) block) => block(this);
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
    this.compact = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: compact ? 150 : null,
      padding: EdgeInsets.all(context.paddingSizeDefault),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(context.radiusLarge),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color ?? theme.colorScheme.primary),
          SizedBox(height: context.paddingSizeExtraSmall),
          Text(
            value,
            style: TextStyle(fontSize: context.fontSizeLarge, fontWeight: FontWeight.w700),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ================================
// Section card
// ================================
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.icon, required this.children});

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
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
              Icon(icon, size: 17, color: theme.colorScheme.onSurfaceVariant),
              SizedBox(width: context.paddingSizeExtraSmall),
              Text(
                title,
                style: TextStyle(fontSize: context.fontSizeDefault, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: context.paddingSizeSmall),
          Divider(height: 1, color: theme.dividerColor),
          SizedBox(height: context.paddingSizeSmall),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final display = (value == null || value!.isEmpty) ? '—' : value!;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.paddingSizeExtraSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: SelectableText(
              display,
              style: TextStyle(fontSize: context.fontSizeDefault, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================
// Action buttons (status-dependent)
// ================================
class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.status,
    required this.isLoading,
    required this.onApprove,
    required this.onReject,
    required this.onSetPending,
  });

  final String status;
  final bool isLoading;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onSetPending;

  @override
  Widget build(BuildContext context) {
    late final List<Widget> buttons;

    switch (status) {
      case 'pending':
        buttons = [
          Expanded(
            child: FilledButton.icon(
              onPressed: isLoading ? null : onApprove,
              icon: const Icon(Icons.check_rounded),
              label: const Text('Approve'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.success),
            ),
          ),
          SizedBox(width: context.paddingSizeSmall),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : onReject,
              icon: Icon(Icons.close_rounded, color: AppColors.error),
              label: Text('Reject', style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.error)),
            ),
          ),
        ];
      case 'active':
        buttons = [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : onSetPending,
              icon: Icon(Icons.pending_outlined, color: AppColors.warning),
              label: Text('Set Pending', style: TextStyle(color: AppColors.warning)),
              style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.warning)),
            ),
          ),
          SizedBox(width: context.paddingSizeSmall),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : onReject,
              icon: Icon(Icons.close_rounded, color: AppColors.error),
              label: Text('Reject', style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.error)),
            ),
          ),
        ];
      case 'rejected':
        buttons = [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : onSetPending,
              icon: Icon(Icons.pending_outlined, color: AppColors.warning),
              label: Text('Reconsider', style: TextStyle(color: AppColors.warning)),
              style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.warning)),
            ),
          ),
          SizedBox(width: context.paddingSizeSmall),
          Expanded(
            child: FilledButton.icon(
              onPressed: isLoading ? null : onApprove,
              icon: const Icon(Icons.check_rounded),
              label: const Text('Approve'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.success),
            ),
          ),
        ];
      default:
        buttons = [];
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Row(children: buttons);
  }
}