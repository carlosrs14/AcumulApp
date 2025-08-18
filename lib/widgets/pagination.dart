import 'package:flutter/material.dart';

class PaginacionWidget extends StatelessWidget {
  final int currentPage;
  final int itemsPerPage;
  final int totalItems;
  final int totalPages;
  final Future<void> Function(int) onPageChanged;
  final Future<void> Function(int) onItemsPerPageChanged;

  const PaginacionWidget({
    super.key,
    required this.currentPage,
    required this.itemsPerPage,
    required this.totalItems,
    required this.totalPages,
    required this.onPageChanged,
    required this.onItemsPerPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón anterior
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: currentPage > 1
                ? () async => await onPageChanged(currentPage - 1)
                : null,
            child: Text('Anterior'),
          ),

          // Selector de items por página
          DropdownButton<int>(
            value: itemsPerPage,
            items: [1, 5, 10, 15].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value por página'),
              );
            }).toList(),
            onChanged: (newValue) async {
              if (newValue != null) {
                await onItemsPerPageChanged(newValue);
              }
            },
          ),

          // Botón siguiente
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: currentPage < totalPages
                ? () async => await onPageChanged(currentPage + 1)
                : null,
            child: Text('Siguiente'),
          ),
        ],
      ),
    );
  }
}
