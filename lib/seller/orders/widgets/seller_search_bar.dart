import 'package:flutter/material.dart';

class SellerSearchBar extends StatefulWidget {
  const SellerSearchBar({super.key});

  @override
  State<SellerSearchBar> createState() => _SellerSearchBarState();
}

class _SellerSearchBarState extends State<SellerSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Search by Order ID, Product...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
      ),
      onChanged: (query) {
        // TODO: implement search via notifier when available
      },
    );
  }
}