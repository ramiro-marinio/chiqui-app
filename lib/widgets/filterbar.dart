import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final Function(String value) onChanged;
  const FilterBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search), hintText: 'Search'),
      onChanged: onChanged,
    );
  }
}
