// import 'package:flutter/material.dart';
//
// class VariantSelector extends StatefulWidget {
//   final List<Variant> variants;
//   final Function(Variant) onVariantSelected;
//
//   const VariantSelector({
//     super.key,
//     required this.variants,
//     required this.onVariantSelected,
//   });
//
//   @override
//   State<VariantSelector> createState() => _VariantSelectorState();
// }
//
// class _VariantSelectorState extends State<VariantSelector> {
//   Map<String, String> selectedOptions = {};
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize with default selections
//     for (var variant in widget.variants) {
//       selectedOptions[variant.id] = variant.selected;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: widget.variants.map((variant) {
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 variant.name,
//                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 8,
//                 children: variant.options.map((option) {
//                   final isSelected = selectedOptions[variant.id] == option;
//                   return ChoiceChip(
//                     label: Text(option),
//                     selected: isSelected,
//                     onSelected: (selected) {
//                       if (selected) {
//                         setState(() {
//                           selectedOptions[variant.id] = option;
//                         });
//                         // Update selected variant
//                         final updatedVariant = Variant(
//                           id: variant.id,
//                           name: variant.name,
//                           options: variant.options,
//                           selected: option,
//                         );
//                         widget.onVariantSelected(updatedVariant);
//                       }
//                     },
//                   );
//                 }).toList(),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
// }