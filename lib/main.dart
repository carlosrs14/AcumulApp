import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/screens/home_client_screen.dart';
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
      home: user != null ? Inicioclienteview(user: user!) : InicioLogin(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            final args = settings.arguments;

            if (args == null || args is! User) {
              return MaterialPageRoute(builder: (_) => InicioLogin());
            }

            final user = args as User;
            return MaterialPageRoute(
              builder: (_) => Inicioclienteview(user: user),
            );

          case '/register':
            return MaterialPageRoute(builder: (_) => RegisterScreen());

          case '/login':
            return MaterialPageRoute(builder: (_) => InicioLogin());

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
