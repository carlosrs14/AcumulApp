import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/screens/home_screen.dart';
import 'package:flutter/material.dart';

class Ejemplo extends StatefulWidget {
  final User user;
  const Ejemplo({super.key, required this.user});

  @override
  State<Ejemplo> createState() => _EjemploState();
}

class _EjemploState extends State<Ejemplo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Text("hola")));
  }
}
