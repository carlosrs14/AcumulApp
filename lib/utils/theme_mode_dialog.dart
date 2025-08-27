import 'package:acumulapp/screens/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showThemeModeDialog(BuildContext context) async {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  ThemeMode currentMode = themeProvider.themeMode;

  final selected = await showDialog<ThemeMode>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Selecciona el tema"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Row(
                children: const [
                  Icon(Icons.wb_sunny, color: Colors.amber),
                  SizedBox(width: 8),
                  Text("Claro"),
                ],
              ),
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (value) {
                Navigator.pop(context, value);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Row(
                children: const [
                  Icon(Icons.nightlight_round, color: Colors.indigo),
                  SizedBox(width: 8),
                  Text("Oscuro"),
                ],
              ),
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (value) {
                Navigator.pop(context, value);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Row(
                children: const [
                  Icon(Icons.settings, color: Colors.grey),
                  SizedBox(width: 8),
                  Text("Seguir sistema"),
                ],
              ),
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (value) {
                Navigator.pop(context, value);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // cancelar sin cambios
          child: const Text("Cancelar"),
        ),
      ],
    ),
  );

  // Aplicamos la selección
  if (selected != null) {
    themeProvider.setThemeMode(selected);
  }
}
