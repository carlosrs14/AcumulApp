import 'package:acumulapp/utils/categories_icons.dart';
import 'package:flutter/material.dart';
import 'package:acumulapp/models/category.dart';

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;

  const CategoryGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, index) {
        final cat = categories[index];

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent, width: 2),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  categoryIcons[normalize(cat.name)] ?? Icons.category,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    cat.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
