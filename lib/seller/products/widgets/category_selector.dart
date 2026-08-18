import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ebazarx/features/category/domain/entities/category_entity.dart';
import 'package:ebazarx/features/category/presentation/providers/category_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySelector extends ConsumerStatefulWidget {
  final ValueChanged<String> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.onCategorySelected,
  });

  @override
  ConsumerState<CategorySelector> createState() =>
      _CategorySelectorState();
}

class _CategorySelectorState
    extends ConsumerState<CategorySelector> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(categorySelectionNotifierProvider.notifier)
          .loadRootCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state =
    ref.watch(categorySelectionNotifierProvider);

    final notifier =
    ref.read(categorySelectionNotifierProvider.notifier);

    if (state.isLoadingRoot) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.rootFailure != null) {
      return Center(
        child: Text(state.rootFailure!.message),
      );
    }

    List<Widget> dropdowns = [];

    //-------------------------------------------------
    // ROOT
    //-------------------------------------------------

    dropdowns.add(
      _CategoryDropdown(
        label: "Category",
        items: state.rootCategories,
        selectedId:
        state.selectedPath.isNotEmpty
            ? state.selectedPath[0]
            : null,
        onChanged: (id) async {
          if (id == null) return;

          await notifier.selectCategory(0, id);

          _notifyLeaf();
        },
      ),
    );

    //-------------------------------------------------
    // CHILDREN
    //-------------------------------------------------

    for (int level = 0;
    level < state.selectedPath.length;
    level++) {

      final parentId = state.selectedPath[level];

      if (state.isLoading(parentId)) {
        dropdowns.add(
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: LinearProgressIndicator(),
          ),
        );

        continue;
      }

      final children = state.childrenOf(parentId);

      if (children.isEmpty) break;

      dropdowns.add(
        const SizedBox(height: 16),
      );

      dropdowns.add(
        _CategoryDropdown(
          label: "Sub Category ${level + 1}",
          items: children,
          selectedId:
          state.selectedPath.length > level + 1
              ? state.selectedPath[level + 1]
              : null,
          onChanged: (id) async {
            if (id == null) return;

            await notifier.selectCategory(
              level + 1,
              id,
            );

            _notifyLeaf();
          },
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dropdowns,
    );
  }

  void _notifyLeaf() {
    final notifier =
    ref.read(categorySelectionNotifierProvider.notifier);

    final state =
    ref.read(categorySelectionNotifierProvider);

    final leaf = state.selectedLeaf;

    if (leaf == null) return;

    final children = state.childrenOf(leaf);

    if (children.isEmpty) {
      widget.onCategorySelected(leaf);
    }
  }
}


class _CategoryDropdown extends StatelessWidget {
  final String label;
  final List<Category> items;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const _CategoryDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField2<String>(
      value: selectedId,
      isExpanded: true,

      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.zero,
      ),

      items: items
          .map(
            (category) => DropdownMenuItem<String>(
          value: category.id,
          child: Text(
            category.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
          .toList(),

      onChanged: onChanged,

      buttonStyleData: const ButtonStyleData(
        height: 56,
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),

      iconStyleData: const IconStyleData(
        icon: Icon(Icons.keyboard_arrow_down_rounded),
        iconSize: 24,
      ),

      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),

      menuItemStyleData: const MenuItemStyleData(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }
}