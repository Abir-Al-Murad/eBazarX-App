import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/product/domain/entities/dimension_entity.dart';
import 'package:flutter/material.dart';

class SpecificationSection extends StatelessWidget {
  final ProductDimension dimensions;
  final double? weight;
  final String sku;
  final List<String> tags;

  const SpecificationSection({
    super.key,
    required this.dimensions,
    required this.weight,
    required this.sku,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final specs = [
      (
      Icons.straighten_rounded,
      "Dimensions",
      "${dimensions.width} × ${dimensions.height} × ${dimensions.length} ${dimensions.unit}"
      ),
      if (weight != null)
        (
        Icons.scale_rounded,
        "Weight",
        "${weight!.toStringAsFixed(2)} kg"
        ),
      (
      Icons.qr_code_rounded,
      "SKU",
      sku,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Specifications",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: context.fontSizeLarge,
          ),
        ),

        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cs.outlineVariant.withOpacity(.35),
            ),
          ),
          child: Column(
            children: [
              for (int i = 0; i < specs.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          specs[i].$1,
                          color: cs.primary,
                          size: 22,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              specs[i].$2,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              specs[i].$3,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                if (i != specs.length - 1)
                  Divider(
                    height: 1,
                    indent: 72,
                    endIndent: 16,
                    color: cs.outlineVariant.withOpacity(.3),
                  ),
              ],
            ],
          ),
        ),

        if (tags.isNotEmpty) ...[
          const SizedBox(height: 20),

          Text(
            "Tags",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              return Chip(
                label: Text("#$tag"),
                avatar: const Icon(
                  Icons.sell_rounded,
                  size: 16,
                ),
                backgroundColor: cs.primaryContainer,
                side: BorderSide.none,
                labelStyle: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}