import 'package:flutter/material.dart';
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

        return GestureDetector(
          onTap: () => toggle(cat),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjoiZKXKK0QE9L6irH-kxQAR74aaG5aYLSLg&s",
                    ),
                    fit: BoxFit.cover,
                    colorFilter: isSelected
                        ? ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.darken,
                          )
                        : null,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    cat.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
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
