import 'dart:async';

import 'package:flutter/material.dart';

class BusinessSearchField extends StatefulWidget {
  final Function(String) onSearch;

  const BusinessSearchField({super.key, required this.onSearch});

  @override
  State<BusinessSearchField> createState() => _BusinessSearchFieldState();
}

class _BusinessSearchFieldState extends State<BusinessSearchField> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      height: 40,
      child: TextField(
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 1000), () async {
            widget.onSearch(value);
          });
        },
        controller: _searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
          prefixIcon: Icon(Icons.search),
          prefixIconColor: Theme.of(context).colorScheme.primary,
          hintText: "Search",
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 3,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
