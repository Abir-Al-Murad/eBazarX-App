import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/product/domain/entities/product_variant_entity.dart';
import 'package:flutter/material.dart';

// TODO: adjust these imports to match your actual paths
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/extensions/context_extensions.dart';

class VariantSection extends StatefulWidget {
  final List<ProductVariant> variants;
  final void Function(ProductVariant)? onVariantChanged;

  const VariantSection({
    super.key,
    required this.variants,
    this.onVariantChanged,
  });

  @override
  State<VariantSection> createState() => _VariantSectionState();
}

class _VariantSectionState extends State<VariantSection> {
  late Map<String, String> _selectedValues;
  late ProductVariant _selectedVariant;

  @override
  void initState() {
    super.initState();

    _selectedValues = {};

    if (widget.variants.isNotEmpty) {
      _selectedValues.addAll(widget.variants.first.attributes);
      _selectedVariant = widget.variants.first;
    }

    // Notify parent AFTER first frame instead of inside build().
    // Calling it in build() risks "setState() called during build"
    // if the parent reacts by calling setState synchronously.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onVariantChanged?.call(_selectedVariant);
    });
  }

  Map<String, Set<String>> get _attributeOptions {
    final map = <String, Set<String>>{};
    for (final variant in widget.variants) {
      variant.attributes.forEach((key, value) {
        map.putIfAbsent(key, () => {}).add(value);
      });
    }
    return map;
  }

  /// True only if NO variant anywhere carries this value for this key.
  /// (Kept as a safety net — with options derived from the variant list
  /// itself this is normally always true, but protects against stale
  /// option lists e.g. after filtering.)
  bool _valueExists(String attributeKey, String value) {
    return widget.variants.any((v) => v.attributes[attributeKey] == value);
  }

  /// Resolves the best variant when [attributeKey] is set to [value].
  ///
  /// Catalogs are usually sparse — not every attribute combination has a
  /// matching variant (e.g. 48GB only ships in Space Black / 2TB here).
  /// So instead of requiring an exact match against ALL currently selected
  /// attributes (which blocks valid options), we:
  ///   1. Look only at variants that have the tapped value for this key.
  ///   2. Among those, prefer the one that keeps the most of the other
  ///      currently selected attributes intact.
  ///   3. Adopt that variant's full attribute set as the new selection —
  ///      this is what auto-adjusts the other chips (e.g. Storage jumps
  ///      to 2TB when you pick 48GB).
  ProductVariant _resolveVariant(String attributeKey, String value) {
    final candidates = widget.variants
        .where((v) => v.attributes[attributeKey] == value)
        .toList();

    if (candidates.isEmpty) return _selectedVariant;

    candidates.sort((a, b) {
      int overlapScore(ProductVariant v) {
        var score = 0;
        for (final entry in _selectedValues.entries) {
          if (entry.key == attributeKey) continue;
          if (v.attributes[entry.key] == entry.value) score++;
        }
        return score;
      }

      return overlapScore(b).compareTo(overlapScore(a));
    });

    return candidates.first;
  }

  void _onAttributeSelected(String attributeKey, String value) {
    final matched = _resolveVariant(attributeKey, value);

    setState(() {
      _selectedValues = Map<String, String>.from(matched.attributes);
      _selectedVariant = matched;
    });

    widget.onVariantChanged?.call(matched);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final attributes = _attributeOptions;
    final inStock = _selectedVariant.stock > 0;

    // Replace context.paddingSizeX / fontSizeX / radiusX / bold/medium/regular
    // with your actual extension getters — placeholders used below.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Variants",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),

        ...attributes.entries.map((attribute) {
          final currentValue = _selectedValues[attribute.key] ?? '';

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(text: attribute.key),
                      TextSpan(
                        text: '  •  $currentValue',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: attribute.value.map((value) {
                    final selected = currentValue == value;
                    final available = _valueExists(attribute.key, value);

                    return _VariantChip(
                      label: value,
                      selected: selected,
                      enabled: available,
                      onTap: available
                          ? () => _onAttributeSelected(attribute.key, value)
                          : null,
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }),

        // Selected variant summary card
        Container(
          padding: EdgeInsets.all(context.paddingSizeDefault),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(context.radiusDefault),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.5),
            ),
          ),
          child: Row(
            children: [
              // Left Side: SKU and Stock Status Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SKU Label
                    Row(
                      children: [
                        Text(
                          "SKU:",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _selectedVariant.sku,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            fontSize: context.fontSizeSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Stock Pill Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: inStock
                            ? Colors.green.withOpacity(0.12)
                            : theme.colorScheme.errorContainer.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(context.radiusSmall),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: inStock ? Colors.green.shade700 : theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            inStock
                                ? "${_selectedVariant.stock} in stock"
                                : "Out of stock",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: inStock
                                  ? Colors.green.shade800
                                  : theme.colorScheme.error,
                              fontWeight: FontWeight.w600,
                              fontSize: context.fontSizeExtraSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Right Side: Price Override Section
              if (_selectedVariant.priceOverride != null) ...[
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Variant Price",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: context.fontSizeExtraSmall,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "৳${_selectedVariant.priceOverride}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        fontSize: context.fontSizeLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        )
      ],
    );
  }
}

class _VariantChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  const _VariantChip({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    late final Color backgroundColor;
    late final Color borderColor;
    late final Color textColor;

    if (!enabled) {
      backgroundColor = theme.disabledColor.withOpacity(0.06);
      borderColor = theme.dividerColor;
      textColor = theme.disabledColor;
    } else if (selected) {
      backgroundColor = theme.colorScheme.primary.withOpacity(0.10);
      borderColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.primary;
    } else {
      backgroundColor = theme.cardColor;
      borderColor = theme.dividerColor;
      textColor = theme.colorScheme.onSurface;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: textColor,
            decoration: enabled ? null : TextDecoration.lineThrough,
            decorationColor: theme.disabledColor,
          ),
        ),
      ),
    );
  }
}