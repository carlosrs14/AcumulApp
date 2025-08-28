import 'package:acumulapp/models/category.dart';
import 'package:flutter/material.dart';

class CategoryFilterDropdown extends StatelessWidget {
  final String selectedCategory;
  final List<Category> categories;
  final Function(String?) onChanged;

  const CategoryFilterDropdown({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(1, 2)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          icon: Icon(Icons.arrow_drop_down),
          items: categories.map((Category value) {
            return DropdownMenuItem<String>(
              value: value.name,
              child: Text(
                value.name,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          iconEnabledColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
