import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/common/widgets/confirm_dialog.dart';
import 'package:ebazarx/common/widgets/empty_state.dart';
import 'package:ebazarx/common/widgets/loading_state.dart';
import 'package:ebazarx/common/widgets/page_loading_container.dart';
import 'package:ebazarx/common/widgets/state_card.dart';
import 'package:ebazarx/common/widgets/status_chip.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/seller/products/providers/seller_product_providers.dart';
import 'package:ebazarx/seller/products/widgets/seller_product_card_mt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ============================================================================
// Main Products Screen
// ============================================================================

class SellerProductsScreen extends ConsumerStatefulWidget {
  const SellerProductsScreen({super.key});

  @override
  ConsumerState<SellerProductsScreen> createState() =>
      _SellerProductsScreenState();
}

class _SellerProductsScreenState extends ConsumerState<SellerProductsScreen> {
  // Filter state
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedBrand = 'All';
  String _selectedStatus = 'All';
  String _selectedSort = 'Newest';
  RangeValues _priceRange = const RangeValues(0, 1000);
  bool _showFilters = false;

  // Cache for unique categories/brands from products
  List<String> _categoryOptions = ['All'];
  List<String> _brandOptions = ['All'];
  final horizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref
          .read(sellerProductListNotifierProvider.notifier)
          .fetchSellerProducts();
    });
  }

  @override
  void dispose() {
    horizontalController.dispose();
    super.dispose();
  }

  // ---- Helpers to extract data from Product ----

  // Compute total stock from variants
  int _totalStock(Product product) {
    return product.variants.fold(0, (sum, v) => sum + v.stock);
  }

  // Compute stats from the full product list
  Map<String, dynamic> _computeStats(List<Product> products) {
    final total = products.length;
    final active = products.where((p) => p.approvalStatus == 'active').length;
    final draft = products.where((p) => p.approvalStatus == 'draft').length;
    final pending = products.where((p) => p.approvalStatus == 'pending').length;
    final outOfStock = products.where((p) => _totalStock(p) == 0).length;
    final lowStock = products
        .where((p) => _totalStock(p) > 0 && _totalStock(p) < 20)
        .length;
    final totalSales = products.fold<int>(0, (sum, p) => sum + p.totalSales);
    final totalRevenue = products.fold<double>(
      0,
      (sum, p) => sum + (p.effectivePrice * p.totalSales),
    );
    return {
      'total': total,
      'active': active,
      'draft': draft,
      'pending': pending,
      'outOfStock': outOfStock,
      'lowStock': lowStock,
      'totalSales': totalSales,
      'totalRevenue': totalRevenue,
    };
  }

  // ---- Filtering logic ----

  List<Product> _filterProducts(List<Product> allProducts) {
    // Update category/brand options from the product list
    final categories = allProducts.map((p) => p.categoryId).toSet().toList();
    final brands = allProducts
        .map((p) => p.brandId)
        .where((b) => b != null)
        .cast<String>()
        .toSet()
        .toList();
    if (categories.isNotEmpty && _categoryOptions.length == 1) {
      setState(() {
        _categoryOptions = ['All', ...categories];
        _brandOptions = ['All', ...brands];
      });
    }

    return allProducts.where((p) {
      final matchesSearch =
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.sku.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || p.categoryId == _selectedCategory;
      final matchesBrand =
          _selectedBrand == 'All' || p.brandId == _selectedBrand;
      final matchesStatus =
          _selectedStatus == 'All' ||
          p.approvalStatus == _selectedStatus.toLowerCase();
      final matchesPrice =
          p.price >= _priceRange.start && p.price <= _priceRange.end;
      return matchesSearch &&
          matchesCategory &&
          matchesBrand &&
          matchesStatus &&
          matchesPrice;
    }).toList();
  }

  // ---- Build ----

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final productListState = ref.watch(sellerProductListNotifierProvider);

    // Show loading indicator while fetching
    if (productListState.isLoading) {
      return const Scaffold(body: Center(child: LoadingContainer()));
    }

    final allProducts = productListState.products;
    final filteredProducts = allProducts;
    final stats = _computeStats(allProducts);

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : const Color(0xFFF7F8FA),
      floatingActionButton: !isDesktop
          ? FloatingActionButton.extended(
              onPressed:(){
                context.pushNamed(AppRoutesName.addEditProduct);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
              backgroundColor: theme.colorScheme.primary,
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(sellerProductListNotifierProvider.notifier)
              .fetchSellerProducts();
        },
        child: CustomScrollView(
          slivers: [
            // Title + Add Product button (desktop)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Text(
                      'Products',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (isDesktop) ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          context.pushNamed(AppRoutesName.addEditProduct);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Product'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Statistics Cards
            SliverToBoxAdapter(
              child: _buildStatsSection(context, stats, isDesktop, isTablet),
            ),

            // Filter Bar
            SliverToBoxAdapter(child: _buildFilterBar(context, isDesktop)),

            // Product List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              sliver: isDesktop
                  ? _buildDataTableSliver(context, filteredProducts)
                  : _buildCardListSliver(context, filteredProducts),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- Stats Section --------------------
  Widget _buildStatsSection(
    BuildContext context,
    Map<String, dynamic> stats,
    bool isDesktop,
    bool isTablet,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    int crossAxisCount;
    if (isDesktop) {
      crossAxisCount = 4;
    } else if (isTablet) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        childAspectRatio: 2.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          StatCard(
            title: 'Total Products',
            value: stats['total'].toString(),
            icon: Icons.inventory_2_rounded,
            color: const Color(0xFF2563EB),
          ),
          StatCard(
            title: 'Active',
            value: stats['active'].toString(),
            icon: Icons.check_circle_rounded,
            color: const Color(0xFF22C55E),
          ),
          StatCard(
            title: 'Draft',
            value: stats['draft'].toString(),
            icon: Icons.edit_rounded,
            color: const Color(0xFFF59E0B),
          ),
          StatCard(
            title: 'Pending Approval',
            value: stats['pending'].toString(),
            icon: Icons.hourglass_top_rounded,
            color: const Color(0xFF8B5CF6),
          ),
          StatCard(
            title: 'Out of Stock',
            value: stats['outOfStock'].toString(),
            icon: Icons.warning_rounded,
            color: const Color(0xFFEF4444),
          ),
          StatCard(
            title: 'Low Stock',
            value: stats['lowStock'].toString(),
            icon: Icons.inventory_rounded,
            color: const Color(0xFFF97316),
          ),
          StatCard(
            title: 'Total Sales',
            value: stats['totalSales'].toString(),
            icon: Icons.trending_up_rounded,
            color: const Color(0xFF06B6D4),
          ),
          StatCard(
            title: 'Revenue',
            value: '\$${stats['totalRevenue'].toStringAsFixed(0)}',
            icon: Icons.attach_money_rounded,
            color: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  // -------------------- Filter Bar --------------------
  Widget _buildFilterBar(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Search
              Expanded(
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.grey[800]
                        : const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Filter toggle
              IconButton(
                onPressed: () => setState(() => _showFilters = !_showFilters),
                icon: Icon(
                  _showFilters
                      ? Icons.filter_alt_off_rounded
                      : Icons.filter_alt_rounded,
                  color: theme.colorScheme.primary,
                ),
                tooltip: 'Toggle filters',
              ),
              // Export button
              if (isDesktop)
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text('Export'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.colorScheme.primary),
                  ),
                ),
            ],
          ),
          if (_showFilters) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            // Filter row
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _FilterDropdown(
                  label: 'Category',
                  value: _selectedCategory,
                  items: _categoryOptions,
                  onChanged: (v) => setState(() => _selectedCategory = v!),
                ),
                _FilterDropdown(
                  label: 'Brand',
                  value: _selectedBrand,
                  items: _brandOptions,
                  onChanged: (v) => setState(() => _selectedBrand = v!),
                ),
                _FilterDropdown(
                  label: 'Status',
                  value: _selectedStatus,
                  items: const [
                    'All',
                    'Active',
                    'Draft',
                    'Pending',
                    'Rejected',
                    'Archived',
                    'Out of Stock',
                  ],
                  onChanged: (v) => setState(() => _selectedStatus = v!),
                ),
                _FilterDropdown(
                  label: 'Sort',
                  value: _selectedSort,
                  items: const [
                    'Newest',
                    'Oldest',
                    'Price: Low to High',
                    'Price: High to Low',
                    'Sales',
                  ],
                  onChanged: (v) => setState(() => _selectedSort = v!),
                ),
                // Price range
                Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price Range',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 1000,
                        divisions: 50,
                        labels: RangeLabels(
                          '\$${_priceRange.start.round()}',
                          '\$${_priceRange.end.round()}',
                        ),
                        onChanged: (values) =>
                            setState(() => _priceRange = values),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = 'All';
                      _selectedBrand = 'All';
                      _selectedStatus = 'All';
                      _priceRange = const RangeValues(0, 1000);
                    });
                  },
                  child: const Text('Reset Filters'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // -------------------- Data Table (Desktop) --------------------
  SliverFillRemaining _buildDataTableSliver(
    BuildContext context,
    List<Product> products,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverFillRemaining(
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB),
          ),
        ),
        child: products.isEmpty
            ? EmptyState(title: 'No products found', message: 'Add your product to sell on eBazar.', icon: Icons.inbox, buttonText: 'Add Product', onPressed: () {
              context.pushNamed(AppRoutesName.addEditProduct);
              },)
            : Scrollbar(
                controller: horizontalController,
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16,
                    headingRowColor: MaterialStateProperty.resolveWith(
                      (states) =>
                          isDark ? Colors.grey[800] : const Color(0xFFF8FAFC),
                    ),
                    columns: const [
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('Product')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Brand')),
                      DataColumn(label: Text('SKU')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Discount')),
                      DataColumn(label: Text('Stock')),
                      DataColumn(label: Text('Sales')),
                      DataColumn(label: Text('Rating')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Updated')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: products.map((product) {
                      final stock = _totalStock(product);
                      return DataRow(
                        cells: [
                          DataCell(
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: product.primaryImage?.url != null
                                  ? CachedNetworkImage(
                                      imageUrl: product.primaryImage!.url,
                                    )
                                  : const Icon(Icons.image_rounded, size: 24),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 180, // Adjust according to your table
                              child: Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 100,
                              child: Text(
                                product.categoryId,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ), // show ID for now
                          DataCell(Text(product.brandId ?? '-')),
                          DataCell(
                            SizedBox(
                              width: 100,
                              child: Text(
                                product.sku,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Text('\$${product.price.toStringAsFixed(2)}'),
                          ),
                          DataCell(
                            product.discountPrice != null && product.hasDiscount
                                ? Text(
                                    '${product.discountPercent}%',
                                    style: const TextStyle(color: Colors.green),
                                  )
                                : const Text('-'),
                          ),
                          DataCell(
                            Text(
                              stock.toString(),
                              style: TextStyle(
                                color: stock == 0
                                    ? Colors.red
                                    : stock < 20
                                    ? Colors.orange
                                    : null,
                              ),
                            ),
                          ),
                          DataCell(Text(product.totalSales.toString())),
                          DataCell(
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(product.averageRating.toStringAsFixed(1)),
                              ],
                            ),
                          ),
                          DataCell(StatusChip(status: product.approvalStatus)),
                          DataCell(
                            Text(
                              product.updatedAt != null
                                  ? '${product.updatedAt!.day}/${product.updatedAt!.month}'
                                  : '-',
                            ),
                          ),
                          DataCell(
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert_rounded),
                              onSelected: (value) {
                                // Handle actions
                                switch (value) {
                                  case 'details':
                                    context.pushNamed(
                                      AppRoutesName.sellerProductDetails,
                                      pathParameters: {
                                        'product_id': product.id,
                                      },
                                    );
                                    break;

                                  case 'edit':
                                    context.pushNamed(
                                      AppRoutesName.addEditProduct,
                                      extra: product,
                                    );
                                    break;

                                  case 'delete':
                                    onDelete(context, product.id, ref);
                                }

                                //   case 'duplicate':
                                //     onDuplicate();
                                //     break;
                                //   case 'archive':
                                //     onArchive();
                                //     break;
                                //   case 'delete':
                                //     onDelete();
                                //     break;
                                // }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'details',
                                  child: ListTile(
                                    leading: Icon(Icons.info_outline_rounded),
                                    title: Text('View Details'),
                                    dense: true,
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: ListTile(
                                    leading: Icon(Icons.edit_rounded),
                                    title: Text('Edit'),
                                    dense: true,
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.delete_rounded,
                                      color: Colors.red,
                                    ),
                                    title: Text('Delete'),
                                    dense: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
      ),
    );
  }

  // -------------------- Grid (Tablet) --------------------
  // SliverPadding _buildGridSliver(BuildContext context, List<Product> products) {
  //   return SliverPadding(
  //     padding: const EdgeInsets.all(8),
  //     sliver: SliverGrid(
  //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
  //         maxCrossAxisExtent: 300,
  //         mainAxisSpacing: 16,
  //         crossAxisSpacing: 16,
  //         childAspectRatio: 0.9,
  //       ),
  //       delegate: SliverChildBuilderDelegate((context, index) {
  //         final product = products[index];
  //         if (index == products.length) {
  //           return const SizedBox(height: 100,);
  //         }
  //         return SellerProductCardMT(
  //           product: product,
  //           onTap: () => _showProductDetails(context, product),
  //           onEdit: () => _showAddProductWizard(context, product: product),
  //           onDelete: () {},
  //         );
  //       }, childCount: products.length+1),
  //     ),
  //   );
  // }

  // -------------------- Card List (Mobile) --------------------
  SliverList _buildCardListSliver(
      BuildContext context,
      List<Product> products,
      ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          // Extra bottom space
          if (index == products.length) {
            return const SizedBox(height: 100);
          }

          final product = products[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SellerProductCardMT(
              product: product,
              onTap: () => _showProductDetails(context, product),
              onEdit: () => _showAddProductWizard(
                context,
                product: product,
              ),
              onDelete: () {
                onDelete(context, product.id, ref);
              },
            ),
          );
        },
        childCount: products.length + 1,
      ),
    );
  }
  void _showProductDetails(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          final stock = _totalStock(product);
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: product.primaryImage?.url != null
                        ? CachedNetworkImage(
                      imageUrl: product.primaryImage!.url,
                      fit: BoxFit.fitHeight,
                      width: double.infinity,
                    )
                        : const Center(
                      child: Icon(Icons.image_rounded, size: 100),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _detailChip('SKU: ${product.sku}'),
                      _detailChip('৳${product.price.toStringAsFixed(2)}'),
                      _detailChip('Stock: $stock'),
                      _detailChip('Sales: ${product.totalSales}'),
                      _detailChip(
                        'Rating: ${product.averageRating.toStringAsFixed(1)}',
                      ),
                      StatusChip(status: product.approvalStatus),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(product.description ?? 'No description provided.'),
                  const SizedBox(height: 16),
                  Text(
                    'Variants (${product.variants.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  if (product.variants.isEmpty)
                    const Text('No variants defined.')
                  else
                    ...product.variants.map(
                      (v) => ListTile(
                        title: Text(v.sku),
                        subtitle: Text(
                          'Price: \$${v.priceOverride ?? product.price} | Stock: ${v.stock}',
                        ),
                        dense: true,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Analytics',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('Total Sales: ${product.totalSales} units'),
                  Text(
                    'Revenue: \$${(product.effectivePrice * product.totalSales).toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _detailChip(String label) {
    return Chip(
      label: Text(label,style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _showAddProductWizard(BuildContext context, {Product? product}) {
    // For demo, just show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
        content: const Text('Multi-step wizard would be shown here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Helper Widgets
// ============================================================================

// -------------------- Filter Dropdown --------------------
class _FilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      items: items.map((e) {
        return DropdownMenuItem(value: e, child: Text(e));
      }).toList(),
      onChanged: onChanged,
    );
  }
}

// -------------------- Status Chip --------------------


// -------------------- Product Card (mobile/grid) --------------------


Future<void> onDelete(
  BuildContext context,
  String productId,
  WidgetRef ref,
) async {
  final bool? result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return ConfirmDialog(
        title: "Delete Product",
        message: "Are you sure you want to delete this product?",
        confirmLabel: "Delete",
      );
    },
  );

  if (result != true) return;

  LoadingState.show(context, message: "Deleting product...");

  try {
    await ref.read(sellerProductProvider.notifier).delete(productId);

    await ref
        .read(sellerProductListNotifierProvider.notifier)
        .fetchSellerProducts();
  } finally {
    LoadingState.hide();
  }
}
