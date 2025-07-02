import 'package:acumulapp/screens/app_bar_client.dart';
import 'package:flutter/material.dart';

class Ejemplo extends StatefulWidget {
  const Ejemplo({super.key});

  @override
  State<Ejemplo> createState() => _EjemploState();
}

class _EjemploState extends State<Ejemplo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppbarClient(currentScreen: "ejemplo"));
  }
}
