import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/screens/login_screen.dart';
import 'package:acumulapp/screens/theme_provider.dart';
import 'package:acumulapp/utils/jwt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:localstorage/localstorage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;
  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  late double screenWidth;
  late double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(12),
          child: cuerpo(),
        ),
      ),
      floatingActionButton: SpeedDial(
        direction: SpeedDialDirection.left,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: MdiIcons.pencil,
        children: [
          SpeedDialChild(child: Icon(MdiIcons.palette), onTap: customizeTheme),
          //SpeedDialChild(child: Icon(MdiIcons.accountEdit)),
        ],
      ),
    );
  }

  Widget cuerpo() {
    return SafeArea(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.only(
          bottom: screenHeight * 0.1,
          right: screenWidth * 0.03,
          left: screenWidth * 0.03,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 3,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [buttomSignOut()],
                          ),
                          SizedBox(height: 20),
                          imagenUser(),
                          SizedBox(height: 30),
                          name(),
                          SizedBox(height: 12),
                          email(),
                          SizedBox(height: 8),
                          role(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget imagenUser() {
    return Container(
      width: 120,
      height: 120,
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(70),
      ),
      child: Center(
        child: ClipOval(
          child: Image.network(
            "url",
            fit: BoxFit.cover,
            width: 120,
            height: 120,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Text(
                widget.user.name[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 40,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget name() {
    return Text(
      widget.user.name,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget email() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(MdiIcons.email, size: 18),
        SizedBox(width: 6),
        Text(widget.user.email, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget role() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(MdiIcons.security, size: 18),
        SizedBox(width: 6),
        Text(widget.user.userType, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget buttomSignOut() {
    return TextButton.icon(
      onPressed: () {
        JwtController(localStorage).clearCache();

        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => InicioLogin()),
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
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  void customizeTheme() {
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

  Widget buttomEditProfile() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(MdiIcons.accountEdit, size: 20),
        iconAlignment: IconAlignment.end,
        label: Text("Edit profile"),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: TextStyle(fontSize: 11),
          elevation: 4,
        ),
      ),
    );
  }
}
