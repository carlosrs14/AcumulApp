import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/screens/home_client_screen.dart';
import 'package:acumulapp/screens/ejemplo.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppbarClient extends StatefulWidget implements PreferredSizeWidget {
  final User user;
  final String currentScreen;
  const AppbarClient({
    super.key,
    required this.currentScreen,
    required this.user,
  });

  @override
  State<AppbarClient> createState() => _AppbarState();

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class _AppbarState extends State<AppbarClient> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                if (widget.currentScreen != "InicioClientView") {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Inicioclienteview(user: widget.user),
                      transitionDuration: Duration(seconds: 0),
                    ),
                  );
                }
              },
              icon: Icon(MdiIcons.home),
              iconSize: 33,
            ),
            SizedBox(width: 30),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Ejemplo(user: widget.user),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
              },
              icon: Icon(MdiIcons.cards),
              iconSize: 33,
            ),
            SizedBox(width: 30),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Ejemplo(user: widget.user),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
              },
              icon: Icon(MdiIcons.bell),
              iconSize: 33,
            ),
            SizedBox(width: 30),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Ejemplo(user: widget.user),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
              },
              icon: Icon(MdiIcons.accountCircle),
              iconSize: 33,
            ),
            SizedBox(width: 90),
          ],
        ),
      ],
    );
  }
}
