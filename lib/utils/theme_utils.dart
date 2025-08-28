import 'package:acumulapp/screens/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

void showColorPicker(BuildContext context) {
  Color selectedColor = Theme.of(context).colorScheme.primary;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Selecciona un color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              selectedColor = color;
            },
            enableAlpha: false,
            displayThumbColor: true,
            showLabel: true,
            pickerAreaHeightPercent: 0.7,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Aplicar'),
            onPressed: () {
              final brightness = Theme.of(context).brightness;
              final currentMode = brightness == Brightness.dark
                  ? ThemeMode.dark
                  : ThemeMode.light;
              Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).setPrimaryColor(selectedColor, currentMode);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
