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
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(90, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: currentPage > 1
                ? () async => await onPageChanged(currentPage - 1)
                : null,
            child: const Text('Anterior'),
          ),

          DropdownButton<int>(
            value: itemsPerPage,
            underline: const SizedBox(),
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
            items: [5, 10, 15, 20].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value pág.'),
              );
            }).toList(),
            onChanged: (newValue) async {
              if (newValue != null) {
                await onItemsPerPageChanged(newValue);
              }
            },
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(90, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: currentPage < totalPages
                ? () async => await onPageChanged(currentPage + 1)
                : null,
            child: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }
}
