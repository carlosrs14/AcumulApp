import 'package:acumulapp/screens/login_screen.dart';
import 'package:acumulapp/utils/jwt.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        JwtController(localStorage).clearCache();

        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const InicioLogin()),
          (Route<dynamic> route) => false,
        );
      },
      icon: Icon(
        MdiIcons.logout,
        color: Theme.of(context).colorScheme.primary,
        size: 20,
      ),
      iconAlignment: IconAlignment.end,
      label: Text(
        "Sign out",
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
