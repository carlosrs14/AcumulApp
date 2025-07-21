import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/business_datails_arguments.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/screens/business/business_home_screen.dart';
import 'package:acumulapp/screens/business_cards_screen.dart';
import 'package:acumulapp/screens/business_info_screen.dart';
import 'package:acumulapp/screens/home_client_screen.dart';
import 'package:acumulapp/screens/home_screen.dart';
import 'package:acumulapp/screens/user/login_screen.dart';
import 'package:acumulapp/screens/user/register_screen.dart';
import 'package:acumulapp/utils/jwt.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

void main() async {
  final user = await getLoggedUser();
  runApp(MyApp(isLogged: user != null, user: user));
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  final User? user;
  const MyApp({super.key, required this.isLogged, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: user != null ? HomeScreen(user: user!) : InicioLogin(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            final args = settings.arguments;

            if (args == null || args is! User) {
              return MaterialPageRoute(builder: (_) => InicioLogin());
            }

            final user = args as User;
            if (user.role == 'collaborator') {
              return MaterialPageRoute(
                builder: (_) => BusinessHomeScreen(user: user),
              );
            }

            return MaterialPageRoute(builder: (_) => HomeScreen(user: user));

          case '/register':
            return MaterialPageRoute(builder: (_) => RegisterScreen());

          case '/login':
            return MaterialPageRoute(builder: (_) => InicioLogin());
          case '/business_details':
            final args = settings.arguments;
            final business_details = args as BusinessDetailsArguments;
            return MaterialPageRoute(
              builder: (_) => BusinessInfo(
                business: business_details.business,
                user: business_details.user,
              ),
            );
          case '/business_cards':
            final args = settings.arguments;
            final business_details = args as BusinessDetailsArguments;
            return MaterialPageRoute(
              builder: (_) => BusinessCardsScreen(
                business: business_details.business,
                user: business_details.user,
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
