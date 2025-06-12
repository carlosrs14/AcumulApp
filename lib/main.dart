import 'package:acumulapp/views/InicioClienteView.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Inicio());
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: cuerpo(context));
  }
}

Widget cuerpo(BuildContext context) {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  return Container(
    decoration: BoxDecoration(color: Colors.white),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        nombre(),
        SizedBox(height: 160),
        Container(
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text("Email", style: TextStyle(fontSize: 15)),
        ),
        campoEmail(_emailController),
        Container(
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text("Password", style: TextStyle(fontSize: 15)),
        ),
        campoContrasena(_passwordController),
        SizedBox(height: 30),
        botonEntrar(_emailController, _passwordController, context),
        SizedBox(height: 30),
        botonGoogle(),
      ],
    ),
  );
}

Widget nombre() {
  return Text(
    "AcumulApp",
    style: TextStyle(
      color: Color(0xFF212121),
      fontSize: 35,
      fontFamily: 'sans-serif',
    ),
  );
}

Widget campoEmail(TextEditingController _emailController) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
    child: TextField(
      controller: _emailController,
      decoration: InputDecoration(fillColor: Colors.white, filled: true),
    ),
  );
}

Widget campoContrasena(TextEditingController _passwordController) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
    child: TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(fillColor: Colors.white, filled: true),
    ),
  );
}

Widget botonEntrar(
  TextEditingController _emailController,
  TextEditingController _passwordController,
  BuildContext context,
) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
      onPressed: () {
        if (("Daniel") == _emailController.text &&
            ("1234") == _passwordController.text) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Inicioclienteview()),
          );
        }
      },
      child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 15)),
    ),
  );
}

Widget botonGoogle() {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
      onPressed: () {},
      child: Text(
        "Login with Google",
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    ),
  );
}
