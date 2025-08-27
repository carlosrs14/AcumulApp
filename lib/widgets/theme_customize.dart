import 'package:acumulapp/screens/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentMode = themeProvider.themeMode;

    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case "light":
            themeProvider.setThemeMode(ThemeMode.light);
            break;
          case "dark":
            themeProvider.setThemeMode(ThemeMode.dark);
            break;
          case "system":
          default:
            themeProvider.setThemeMode(ThemeMode.system);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "light",
          child: Row(
            children: [
              const Text("Modo Claro"),
              if (currentMode == ThemeMode.light) const Spacer(),
              if (currentMode == ThemeMode.light)
                const Icon(Icons.check, color: Colors.green, size: 18),
            ],
          ),
        ),
        PopupMenuItem(
          value: "dark",
          child: Row(
            children: [
              const Text("Modo Oscuro"),
              if (currentMode == ThemeMode.dark) const Spacer(),
              if (currentMode == ThemeMode.dark)
                const Icon(Icons.check, color: Colors.green, size: 18),
            ],
          ),
        ),
        PopupMenuItem(
          value: "system",
          child: Row(
            children: [
              const Text("Seguir Sistema"),
              if (currentMode == ThemeMode.system) const Spacer(),
              if (currentMode == ThemeMode.system)
                const Icon(Icons.check, color: Colors.green, size: 18),
            ],
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }
}
