import 'package:flutter/material.dart';

class ImagePickerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ImagePickerButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
