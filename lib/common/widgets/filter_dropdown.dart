import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class FilterDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? value;
  final IconData? icon;
  final ValueChanged<T?> onChanged;

  /// Converts T -> String
  final String Function(T) labelBuilder;

  const FilterDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.labelBuilder,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
          value: item,
          child: Text(labelBuilder(item)),
        ),
      )
          .toList(),
      onChanged: onChanged,
    );
  }
}