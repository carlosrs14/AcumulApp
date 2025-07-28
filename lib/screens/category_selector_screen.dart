import 'package:acumulapp/utils/categories_icons.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:acumulapp/models/category.dart';

class CategorySelector extends StatefulWidget {
  final List<Category> categories;
  final List<Category> selectedIds;
  final void Function(List<Category>) onChanged;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedIds,
    required this.onChanged,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late List<Category> _selected;

  @override
  void initState() {
    super.initState();

    _selected = [...widget.selectedIds];
  }

  void toggle(Category category) {
    setState(() {
      if (_selected.contains(category)) {
        _selected.remove(category);
      } else {
        _selected.add(category);
      }
      widget.onChanged(_selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, index) {
        final cat = widget.categories[index];
        final isSelected = _selected.contains(cat);
        log(normalize(cat.name).toString());
        return GestureDetector(
          onTap: () => toggle(cat),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.grey[300] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.purple : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categoryIcons[normalize(cat.name)] ?? Icons.category,
                          size: 40,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black54,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            cat.name,
                            style: TextStyle(
                              color: isSelected ? Colors.purple : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isSelected)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 28,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
