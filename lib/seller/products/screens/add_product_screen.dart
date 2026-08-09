import 'dart:async';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/product/data/models/product_model.dart';
import 'package:ebazarx/features/product/domain/entities/dimension_entity.dart';
import 'package:ebazarx/features/product/domain/entities/product_entity.dart';
import 'package:ebazarx/features/product/domain/entities/product_image_entity.dart';
import 'package:ebazarx/features/product/domain/entities/product_variant_entity.dart';
import 'package:ebazarx/features/upload/models/upload_image_item.dart';
import 'package:ebazarx/features/upload/presentation/widgets/reusable_image_uploader.dart';
import 'package:ebazarx/seller/products/providers/seller_product_providers.dart';
import 'package:ebazarx/seller/products/widgets/category_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ============================================================================
// Main Screen
// ============================================================================

class SellerAddProductScreen extends ConsumerStatefulWidget {
  final Product? existingProduct; // For edit mode

  const SellerAddProductScreen({super.key, this.existingProduct});

  @override
  ConsumerState<SellerAddProductScreen> createState() =>
      _SellerAddProductScreenState();
}

class _SellerAddProductScreenState extends ConsumerState<SellerAddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _slugController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _discountPriceController;
  late TextEditingController _skuController;
  late TextEditingController _seoTitleController;
  late TextEditingController _seoDescriptionController;
  late TextEditingController _metaKeywordsController;
  late TextEditingController _weightController;
  late TextEditingController _lengthController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;

  // Category selection
  String _selectedCategoryId = '';

  // Brand (placeholder – implement real brand dropdown)
  String? _selectedBrandId;

  // Tags
  List<String> _tags = [];

  // Variants and images
  List<ProductVariant> _variants = [];
  List<UploadImageItem> _images = [];

  // Status
  bool _isActive = true;
  String _approvalStatus = 'draft';

  // Editing mode
  bool get _isEditing => widget.existingProduct != null;
  String? _productId; // only used when editing

  // Focus nodes
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _slugFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _initControllers();
    _populateFromExisting();
  }

  void _initControllers() {
    _nameController = TextEditingController();
    _slugController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _discountPriceController = TextEditingController();
    _skuController = TextEditingController();
    _seoTitleController = TextEditingController();
    _seoDescriptionController = TextEditingController();
    _metaKeywordsController = TextEditingController();
    _weightController = TextEditingController();
    _lengthController = TextEditingController();
    _widthController = TextEditingController();
    _heightController = TextEditingController();

    _nameController.addListener(_updateSlugFromName);
  }

  void _updateSlugFromName() {
    final name = _nameController.text;
    if (name.isNotEmpty) {
      final slug = name
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
          .replaceAll(RegExp(r'^-+|-+$'), '');
      _slugController.text = slug;
    }
  }

  /// Populate all fields if editing an existing product.
  void _populateFromExisting() {
    final product = widget.existingProduct;
    if (product == null) return;

    _productId = product.id;
    _nameController.text = product.name;
    _slugController.text = product.slug;
    _descriptionController.text = product.description ?? '';
    _priceController.text = product.price.toStringAsFixed(2);
    if (product.discountPrice != null) {
      _discountPriceController.text = product.discountPrice!.toStringAsFixed(2);
    }
    _skuController.text = product.sku;
    _seoTitleController.text = product.seoTitle ?? '';
    _seoDescriptionController.text = product.seoDescription ?? '';
    _metaKeywordsController.text = product.metaKeywords ?? '';
    if (product.weight != null) {
      _weightController.text = product.weight!.toString();
    }
    if (product.dimensions != null) {
      _lengthController.text = product.dimensions!.length.toString();
      _widthController.text = product.dimensions!.width.toString();
      _heightController.text = product.dimensions!.height.toString();
    }

    _selectedCategoryId = product.categoryId;
    _selectedBrandId = product.brandId;
    _tags = List.from(product.tags);
    _isActive = product.isActive;
    _approvalStatus = product.approvalStatus;

    // Convert ProductImage to UploadImageItem
    _images = product.images.map((img) {
      return UploadImageItem(
        url: img.url,
        isPrimary: img.isPrimary, order: img.sortOrder,
      );
    }).toList();

    // Convert ProductVariant to our local model (might need extension)
    _variants = product.variants.map((v) {
      return ProductVariant(
        id: v.id,
        productId: v.productId,
        sku: v.sku,
        priceOverride: v.priceOverride,
        stock: v.stock,
        reservedStock: v.reservedStock,
        attributes: Map.from(v.attributes),
        createdAt: v.createdAt,
        updatedAt: v.updatedAt,
      );
    }).toList();
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateSlugFromName);
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _skuController.dispose();
    _seoTitleController.dispose();
    _seoDescriptionController.dispose();
    _metaKeywordsController.dispose();
    _weightController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _nameFocus.dispose();
    _slugFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  // ----- Helpers -----
  double get _currentPrice => double.tryParse(_priceController.text) ?? 0;
  double get _discountPriceValue => double.tryParse(_discountPriceController.text) ?? 0;
  bool get _hasDiscount => _discountPriceValue > 0 && _discountPriceValue < _currentPrice;
  int get _discountPercent => _hasDiscount ? (((_currentPrice - _discountPriceValue) / _currentPrice) * 100).round() : 0;
  double get _finalPrice => _hasDiscount ? _discountPriceValue : _currentPrice;

  Map<String, dynamic> _buildProductData() {
    final data = {
      'category_id': _selectedCategoryId,
      'brand_id': _selectedBrandId,
      'name': _nameController.text.trim(),
      'slug': _slugController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': _currentPrice,
      'discount_price': _hasDiscount ? _discountPriceValue : 0,
      'sku': _skuController.text.trim(),
      'seo_title': _seoTitleController.text.trim(),
      'seo_description': _seoDescriptionController.text.trim(),
      'meta_keywords': _metaKeywordsController.text.trim(),
      'tags': _tags,
      'weight': double.tryParse(_weightController.text),
      'dimensions': {
        'length': double.tryParse(_lengthController.text) ?? 0,
        'width': double.tryParse(_widthController.text) ?? 0,
        'height': double.tryParse(_heightController.text) ?? 0,
        'unit': 'cm',
      },
      'variants': _variants.map((v) => {
        'sku': v.sku,
        'price_override': v.priceOverride,
        'stock': v.stock,
        'attributes': v.attributes,
      }).toList(),
      'images': _images.asMap().entries.map((entry) {
        final index = entry.key;
        final image = entry.value;
        return {
          "url": image.url,
          "is_primary": image.isPrimary,
          "sort_order": index,
        };
      }).toList(),
      'is_active': _isActive,
      'approval_status': _approvalStatus,
    };

    // If editing, include the product ID
    if (_isEditing && _productId != null) {
      data['id'] = _productId;
    }
    return data;
  }

  // ----- Build -----
  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : const Color(0xFFF7F8FA),
      body: Column(
        children: [
          _buildHeader(context, isDesktop),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isDesktop ? 32 : 16),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _autovalidate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Basic Information
                          BasicInformationCard(
                            nameController: _nameController,
                            slugController: _slugController,
                            descriptionController: _descriptionController,
                            selectedCategoryId: _selectedCategoryId,
                            onCategoryChanged: (id) {
                              setState(() {
                                _selectedCategoryId = id;
                              });
                            },
                            brandId: _selectedBrandId,
                            onBrandChanged: (v) => setState(() => _selectedBrandId = v),
                            nameFocus: _nameFocus,
                            slugFocus: _slugFocus,
                            descriptionFocus: _descriptionFocus,
                          ),
                          const SizedBox(height: 24),

                          // Pricing
                          PricingCard(
                            priceController: _priceController,
                            discountPriceController: _discountPriceController,
                            currentPrice: _currentPrice,
                            discountPriceValue: _discountPriceValue,
                            discountPercent: _discountPercent,
                            finalPrice: _finalPrice,
                          ),
                          const SizedBox(height: 24),

                          // Inventory
                          InventoryCard(
                            skuController: _skuController,
                            isActive: _isActive,
                            onActiveChanged: (v) => setState(() => _isActive = v),
                            approvalStatus: _approvalStatus,
                          ),
                          const SizedBox(height: 24),

                          // Media
                          _SectionCard(
                            title: "Product Images",
                            child: ReusableImageUploader(
                              initialImages: _images,
                              maxImages: 10,
                              onChanged: (images) {
                                setState(() {
                                  _images = images;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Variants
                          VariantsCard(
                            variants: _variants,
                            onVariantsChanged: (newVariants) => setState(() => _variants = newVariants),
                          ),
                          const SizedBox(height: 24),

                          // Shipping
                          ShippingCard(
                            weightController: _weightController,
                            lengthController: _lengthController,
                            widthController: _widthController,
                            heightController: _heightController,
                          ),
                          const SizedBox(height: 24),

                          // SEO
                          SeoCard(
                            seoTitleController: _seoTitleController,
                            seoDescriptionController: _seoDescriptionController,
                            metaKeywordsController: _metaKeywordsController,
                            tags: _tags,
                            onTagsChanged: (newTags) => setState(() => _tags = newTags),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),

                // Right Sidebar (desktop only)
                if (isDesktop)
                  SummarySidebar(
                    categoryId: _selectedCategoryId,
                    price: _currentPrice,
                    discountPrice: _discountPriceValue,
                    finalPrice: _finalPrice,
                    imageCount: _images.length,
                    variantCount: _variants.length,
                    status: _isActive ? 'Active' : 'Draft',
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        isEditing: _isEditing,
        onCancel: () => context.pop(),
        // onSaveDraft: _saveDraft,
        onPublish: _publishProduct,
      ),
    );
  }

  // ----- Header -----
  Widget _buildHeader(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final title = _isEditing ? 'Edit Product' : 'Add New Product';
    final subtitle = _isEditing
        ? 'Update your product details and publish changes.'
        : 'Create a product and publish it to your store.';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        border: Border(bottom: BorderSide(
          color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB),
        )),
      ),
      child: Row(
        children: [
          Navigator.canPop(context) == true? BackButton():SizedBox.shrink(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (isDesktop) ...[
            OutlinedButton(
              onPressed: _saveDraft,
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
              child: Text(_isEditing ? 'Update Draft' : 'Save Draft'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _publishProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(_isEditing ? 'Update Product' : 'Publish Product'),
            ),
          ],
        ],
      ),
    );
  }

  // ----- Actions -----
  void _saveDraft() {
    if (_formKey.currentState!.validate()) {
      final data = _buildProductData();
      if (_isEditing) {
        // Call update use case
        ref.read(sellerProductProvider.notifier).update(data['id'],data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated as draft (simulated)')),
        );
      } else {
        // Call create use case
        ref.read(sellerProductProvider.notifier).create(data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product saved as draft (simulated)')),
        );
      }
      print('Draft data: $data');
    } else {
      setState(() => _autovalidate = AutovalidateMode.always);
    }
  }

  void _publishProduct() async {
    if (_formKey.currentState!.validate()) {
      final data = _buildProductData();
      if (_isEditing) {
        // Call update with publish flag
        await ref.read(sellerProductProvider.notifier).update(data['id'],data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully!')),
        );
      } else {
        // Create and publish
        await ref.read(sellerProductProvider.notifier).create(data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product published successfully!')),
        );
      }
      print('Published data: $data');
      context.pop();
    } else {
      setState(() => _autovalidate = AutovalidateMode.always);
    }
  }
}

// ============================================================================
// Reusable Section Widgets (unchanged, but included for completeness)
// ============================================================================

// ... (all the reusable widgets: _SectionCard, BasicInformationCard, PricingCard,
// InventoryCard, ImageUploaderCard, VariantsCard, _VariantCard, ShippingCard,
// SeoCard, _TagInputField, SummarySidebar, _SummaryItem, BottomActionBar)
// They remain exactly as in the original code. For brevity, they are not repeated
// here, but they should be present in the actual file.

// ... (all the reusable widgets remain unchanged)
// We only need to update the BottomActionBar to accept an `isEditing` flag.

// -------------------- Updated BottomActionBar --------------------
class BottomActionBar extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onCancel;
  // final VoidCallback onSaveDraft;
  final VoidCallback onPublish;

  const BottomActionBar({
    super.key,
    required this.isEditing,
    required this.onCancel,
    // required this.onSaveDraft,
    required this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        border: Border(top: BorderSide(color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(onPressed: onCancel, child: const Text('Cancel')),
          // const SizedBox(width: 12),
          // OutlinedButton(
          //   onPressed: onSaveDraft,
          //   style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
          //   child: Text(isEditing ? 'Update Draft' : 'Save Draft'),
          // ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onPublish,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(isEditing ? 'Update Product' : 'Publish Product'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Reusable Section Widgets
// ============================================================================

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB),
        ),
      ),
      color: isDark ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

// -------------------- Basic Information Card --------------------
class BasicInformationCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController slugController;
  final TextEditingController descriptionController;
  final String selectedCategoryId;
  final ValueChanged<String> onCategoryChanged;
  final String? brandId;
  final ValueChanged<String?> onBrandChanged;
  final FocusNode nameFocus;
  final FocusNode slugFocus;
  final FocusNode descriptionFocus;

  const BasicInformationCard({
    super.key,
    required this.nameController,
    required this.slugController,
    required this.descriptionController,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
    this.brandId,
    required this.onBrandChanged,
    required this.nameFocus,
    required this.slugFocus,
    required this.descriptionFocus,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Basic Information',
      child: Column(
        children: [
          // ---- Category Selector ----
          CategorySelector(
            // initialCategoryId:
            // selectedCategoryId.isEmpty ? null : selectedCategoryId,
            onCategorySelected: onCategoryChanged,
          ),
          const SizedBox(height: 16),

          // ---- Brand dropdown (placeholder) ----
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: brandId,
                  hint: const Text('Select brand (optional)'),
                  decoration: _buildInputDecoration(context, 'Brand'),
                  items: const [
                    // Replace with real brand data from provider
                    DropdownMenuItem(value: 'brand1', child: Text('Nike')),
                    DropdownMenuItem(value: 'brand2', child: Text('Sony')),
                    DropdownMenuItem(value: 'brand3', child: Text('Apple')),
                  ],
                  onChanged: onBrandChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: nameController,
            focusNode: nameFocus,
            decoration: _buildInputDecoration(context, 'Product Name *'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => slugFocus.requestFocus(),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: slugController,
            focusNode: slugFocus,
            decoration: _buildInputDecoration(context, 'Slug (URL) *'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Slug is required' : null,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => descriptionFocus.requestFocus(),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: descriptionController,
            focusNode: descriptionFocus,
            maxLines: 6,
            decoration: _buildInputDecoration(context, 'Description'),
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

// -------------------- Pricing Card --------------------
class PricingCard extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController discountPriceController;
  final double currentPrice;
  final double discountPriceValue;
  final int discountPercent;
  final double finalPrice;

  const PricingCard({
    super.key,
    required this.priceController,
    required this.discountPriceController,
    required this.currentPrice,
    required this.discountPriceValue,
    required this.discountPercent,
    required this.finalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return _SectionCard(
      title: 'Pricing',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration(context, 'Regular Price *'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Price is required';
                    if (double.tryParse(v) == null) return 'Invalid number';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: discountPriceController,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration(context, 'Discount Price (optional)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _PricePreview(label: 'Current Price', value: '\$${currentPrice.toStringAsFixed(2)}', color: theme.colorScheme.onSurface),
                _PricePreview(label: 'Discount', value: discountPriceValue > 0 ? '$discountPercent%' : 'None', color: Colors.green),
                _PricePreview(label: 'Final Price', value: '\$${finalPrice.toStringAsFixed(2)}', color: theme.colorScheme.primary, isBold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

class _PricePreview extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isBold;

  const _PricePreview({required this.label, required this.value, required this.color, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: color)),
      ],
    );
  }
}

// -------------------- Inventory Card --------------------
class InventoryCard extends StatelessWidget {
  final TextEditingController skuController;
  final bool isActive;
  final ValueChanged<bool> onActiveChanged;
  final String approvalStatus;

  const InventoryCard({
    super.key,
    required this.skuController,
    required this.isActive,
    required this.onActiveChanged,
    required this.approvalStatus,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Inventory',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: skuController,
                  decoration: _buildInputDecoration(context, 'SKU *'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'SKU is required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    const Text('Active:'),
                    const SizedBox(width: 8),
                    Switch(value: isActive, onChanged: onActiveChanged),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Approval Status', style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                      child: Text(approvalStatus.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

// -------------------- Image Uploader Card --------------------
class ImageUploaderCard extends StatelessWidget {
  final List<ProductImage> images;
  final ValueChanged<List<ProductImage>> onImagesChanged;

  const ImageUploaderCard({super.key, required this.images, required this.onImagesChanged});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Product Images',
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload_rounded, size: 40, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text('Drag & drop images here, or click to browse', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (images.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(image: NetworkImage(image.url), fit: BoxFit.cover),
                      ),
                    ),
                    if (image.isPrimary)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                          child: const Text('PRIMARY', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          padding: const EdgeInsets.all(4),
                        ),
                        onPressed: () {
                          final newList = List<ProductImage>.from(images)..removeAt(index);
                          onImagesChanged(newList);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

// -------------------- Variants Card --------------------
class VariantsCard extends StatelessWidget {
  final List<ProductVariant> variants;
  final ValueChanged<List<ProductVariant>> onVariantsChanged;

  const VariantsCard({super.key, required this.variants, required this.onVariantsChanged});

  void _addVariant() {
    final newVariant = ProductVariant(
      id: '',
      productId: '',
      sku: '',
      priceOverride: null,
      stock: 0,
      reservedStock: 0,
      attributes: {},
    );
    onVariantsChanged([...variants, newVariant]);
  }

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Variants',
      child: Column(
        children: [
          if (variants.isEmpty)
            const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Text('No variants added yet.')),
          ...variants.asMap().entries.map((entry) {
            final index = entry.key;
            final variant = entry.value;
            return _VariantCard(
              variant: variant,
              onDelete: () {
                final newList = List<ProductVariant>.from(variants)..removeAt(index);
                onVariantsChanged(newList);
              },
              onVariantChanged: (updated) {
                final newList = List<ProductVariant>.from(variants);
                newList[index] = updated;
                onVariantsChanged(newList);
              },
            );
          }).toList(),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _addVariant,
            icon: const Icon(Icons.add),
            label: const Text('Add Variant'),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
          ),
        ],
      ),
    );
  }
}

class _VariantCard extends StatefulWidget {
  final ProductVariant variant;
  final VoidCallback onDelete;
  final ValueChanged<ProductVariant> onVariantChanged;

  const _VariantCard({required this.variant, required this.onDelete, required this.onVariantChanged});

  @override
  State<_VariantCard> createState() => _VariantCardState();
}

class _VariantCardState extends State<_VariantCard> {
  late TextEditingController _skuController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  final TextEditingController _attrKeyController = TextEditingController();
  final TextEditingController _attrValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _skuController = TextEditingController(text: widget.variant.sku);
    _priceController = TextEditingController(text: widget.variant.priceOverride?.toString() ?? '');
    _stockController = TextEditingController(text: widget.variant.stock.toString());
    _skuController.addListener(_updateVariant);
    _priceController.addListener(_updateVariant);
    _stockController.addListener(_updateVariant);
  }

  void _updateVariant() {
    final updated = widget.variant.copyWith(
      sku: _skuController.text,
      priceOverride: double.tryParse(_priceController.text),
      stock: int.tryParse(_stockController.text) ?? 0,
    );
    widget.onVariantChanged(updated);
  }

  void _addAttribute() {
    final key = _attrKeyController.text.trim();
    final value = _attrValueController.text.trim();
    if (key.isNotEmpty && value.isNotEmpty) {
      final newAttrs = Map<String, String>.from(widget.variant.attributes)..[key] = value;
      widget.onVariantChanged(widget.variant.copyWith(attributes: newAttrs));
      _attrKeyController.clear();
      _attrValueController.clear();
    }
  }

  void _removeAttribute(String key) {
    final newAttrs = Map<String, String>.from(widget.variant.attributes)..remove(key);
    widget.onVariantChanged(widget.variant.copyWith(attributes: newAttrs));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB)),
      ),
      color: isDark ? Colors.grey[850] : Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text('Variant ${widget.variant.id.isEmpty ? 'New' : widget.variant.id}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.delete_rounded, color: Colors.red), onPressed: widget.onDelete),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _skuController, decoration: const InputDecoration(labelText: 'SKU', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: _priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price Override', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: _stockController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _attrKeyController, decoration: const InputDecoration(labelText: 'Attribute Key', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: _attrValueController, decoration: const InputDecoration(labelText: 'Value', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)))),
                const SizedBox(width: 12),
                OutlinedButton(onPressed: _addAttribute, child: const Text('Add')),
              ],
            ),
            if (widget.variant.attributes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: widget.variant.attributes.entries.map((entry) {
                  return Chip(
                    label: Text('${entry.key}: ${entry.value}'),
                    onDeleted: () => _removeAttribute(entry.key),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _skuController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _attrKeyController.dispose();
    _attrValueController.dispose();
    super.dispose();
  }
}

// -------------------- Shipping Card --------------------
class ShippingCard extends StatelessWidget {
  final TextEditingController weightController;
  final TextEditingController lengthController;
  final TextEditingController widthController;
  final TextEditingController heightController;

  const ShippingCard({
    super.key,
    required this.weightController,
    required this.lengthController,
    required this.widthController,
    required this.heightController,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Shipping',
      child: Column(
        children: [
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: TextField(controller: lengthController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Length (cm)', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)))),
              const SizedBox(width: 16),
              Expanded(child: TextField(controller: widthController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Width (cm)', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)))),
              const SizedBox(width: 16),
              Expanded(child: TextField(controller: heightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)))),
            ],
          ),
        ],
      ),
    );
  }
}

// -------------------- SEO Card --------------------
class SeoCard extends StatelessWidget {
  final TextEditingController seoTitleController;
  final TextEditingController seoDescriptionController;
  final TextEditingController metaKeywordsController;
  final List<String> tags;
  final ValueChanged<List<String>> onTagsChanged;

  const SeoCard({
    super.key,
    required this.seoTitleController,
    required this.seoDescriptionController,
    required this.metaKeywordsController,
    required this.tags,
    required this.onTagsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'SEO',
      child: Column(
        children: [
          TextField(controller: seoTitleController, decoration: const InputDecoration(labelText: 'SEO Title', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12))),
          const SizedBox(height: 16),
          TextField(controller: seoDescriptionController, maxLines: 3, decoration: const InputDecoration(labelText: 'SEO Description', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12))),
          const SizedBox(height: 16),
          TextField(controller: metaKeywordsController, decoration: const InputDecoration(labelText: 'Meta Keywords', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12))),
          const SizedBox(height: 16),
          _TagInputField(tags: tags, onTagsChanged: onTagsChanged),
        ],
      ),
    );
  }
}

class _TagInputField extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onTagsChanged;

  const _TagInputField({required this.tags, required this.onTagsChanged});

  @override
  State<_TagInputField> createState() => _TagInputFieldState();
}

class _TagInputFieldState extends State<_TagInputField> {
  final TextEditingController _tagController = TextEditingController();

  void _addTag() {
    final text = _tagController.text.trim();
    if (text.isNotEmpty && !widget.tags.contains(text)) {
      widget.onTagsChanged([...widget.tags, text]);
      _tagController.clear();
    }
  }

  void _removeTag(String tag) {
    widget.onTagsChanged(widget.tags.where((t) => t != tag).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagController,
                decoration: const InputDecoration(hintText: 'Add a tag...', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                onSubmitted: (_) => _addTag(),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: _addTag, child: const Text('Add')),
          ],
        ),
        if (widget.tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: widget.tags.map((tag) => Chip(label: Text(tag), onDeleted: () => _removeTag(tag))).toList(),
          ),
        ],
      ],
    );
  }
}

// -------------------- Summary Sidebar --------------------
class SummarySidebar extends StatelessWidget {
  final String categoryId;
  final double price;
  final double discountPrice;
  final double finalPrice;
  final int imageCount;
  final int variantCount;
  final String status;

  const SummarySidebar({
    super.key,
    required this.categoryId,
    required this.price,
    required this.discountPrice,
    required this.finalPrice,
    required this.imageCount,
    required this.variantCount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        border: Border(left: BorderSide(color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _SummaryItem(label: 'Category', value: categoryId.isEmpty ? 'Not set' : categoryId),
          _SummaryItem(label: 'Price', value: '\$${price.toStringAsFixed(2)}'),
          if (discountPrice > 0)
            _SummaryItem(label: 'Discount', value: '\$${discountPrice.toStringAsFixed(2)}', valueColor: Colors.green),
          _SummaryItem(label: 'Final Price', value: '\$${finalPrice.toStringAsFixed(2)}', valueColor: theme.colorScheme.primary, isBold: true),
          const Divider(),
          _SummaryItem(label: 'Images', value: '$imageCount'),
          _SummaryItem(label: 'Variants', value: '$variantCount'),
          _SummaryItem(label: 'Status', value: status, valueColor: status == 'Active' ? Colors.green : Colors.orange),
          const Divider(),
          _SummaryItem(label: 'Estimated Earnings', value: '\$${(finalPrice * 0.85).toStringAsFixed(2)} (after 15% fee)', valueColor: Colors.blue),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _SummaryItem({required this.label, required this.value, this.valueColor, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: valueColor ?? theme.colorScheme.onSurface)),
        ],
      ),
    );
  }
}

