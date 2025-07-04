import 'package:acumulapp/screens/home_client_screen.dart';
import 'package:acumulapp/screens/user/login_screen.dart';
import 'package:acumulapp/screens/user/register_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  bool isLogged = await checkLoginStatus();
  runApp(MyApp(isLogged: isLogged));
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({super.key, required this.isLogged});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: isLogged ? '/' : '/login',
      routes: {
        '/': (context) => Inicioclienteview(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => InicioLogin(),
      },
    );
  }
}

Future<bool> checkLoginStatus() async {
  // Aquí va tu lógica real (ej. verificar token guardado)
  return false; // o true
}
