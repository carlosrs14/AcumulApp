import 'package:flutter/material.dart';

class CardScaffold extends StatelessWidget {
  final Widget header;
  final Widget body;

  const CardScaffold({
    super.key,
    required this.header,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [header],
              ),
            ),
            body,
          ],
        ),
      ),
    );
  }
}