import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  final int selectedState;
  final Map<int, String> stateList;
  final Function(int?) onChanged;

  const FilterDropdown({
    super.key,
    required this.selectedState,
    required this.stateList,
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
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(1, 2)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedState,
          icon: Icon(Icons.arrow_drop_down),
          items: stateList.entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(
                entry.value,
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
