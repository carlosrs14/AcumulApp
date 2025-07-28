import 'dart:developer';

import 'package:acumulapp/models/business_datails_arguments.dart';
import 'package:acumulapp/models/client.dart';
import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/screens/business/business_home_screen.dart';
import 'package:acumulapp/screens/business/update_info_screen.dart';
import 'package:acumulapp/screens/user/business_cards_screen.dart';
import 'package:acumulapp/screens/user/business_info_screen.dart';
import 'package:acumulapp/screens/user/home_screen.dart';
import 'package:acumulapp/screens/login_screen.dart';
import 'package:acumulapp/screens/register_screen.dart';
import 'package:acumulapp/utils/jwt.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:acumulapp/screens/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final user = await getLoggedUser();
  final savedColor = await ThemeProvider.getSavedColor();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(savedColor),
      child: MyApp(isLogged: user != null, user: user),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  final User? user;
  const MyApp({super.key, required this.isLogged, required this.user});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: themeProvider.themeData,
      home: user != null ? HomeScreen(user: user!) : InicioLogin(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            final args = settings.arguments;

            if (args == null || args is! User) {
              return MaterialPageRoute(builder: (_) => InicioLogin());
            }

            final user = args;
            if (user.userType == 'collaborator') {
              user as Collaborator;
              var indice = user.roles.indexWhere(
                (roles) => "owner" == roles.toLowerCase(),
              );
              if (-1 != indice && "N/A" == user.business[indice].name) {
                return MaterialPageRoute(
                  builder: (_) => UpdateInfoScreen(user: user),
                );
              } else {
                return MaterialPageRoute(
                  builder: (_) => BusinessHomeScreen(user: user),
                );
              }
            }

            return MaterialPageRoute(
              builder: (_) => HomeScreen(user: user as Client),
            );

          case '/register':
            return MaterialPageRoute(builder: (_) => RegisterScreen());

          case '/login':
            return MaterialPageRoute(builder: (_) => InicioLogin());
          case '/business_details':
            final args = settings.arguments;
            final businessDetails = args as BusinessDetailsArguments;
            return MaterialPageRoute(
              builder: (_) => BusinessInfo(
                business: businessDetails.business,
                user: businessDetails.user,
              ),
            );
          case '/business_cards':
            final args = settings.arguments;
            final businessDetails = args as BusinessDetailsArguments;
            return MaterialPageRoute(
              builder: (_) => BusinessCardsScreen(
                business: businessDetails.business,
                user: businessDetails.user,
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(body: Center(child: Text('Ruta no encontrada'))),
            );
        }
      },
    );
  }
}

Future<User?> getLoggedUser() async {
  // Aquí va tu lógica real (ej. verificar token guardado)
  return null; // o true
}

Future<bool> checkLoginStatus() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  JwtController jwt = JwtController(localStorage);
  return jwt.loadToken() != null;
}
