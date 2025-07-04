import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: cuerpo(context));
  }
}

Widget cuerpo(BuildContext context) {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

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
          child: Text("User name", style: TextStyle(fontSize: 15)),
        ),
        userName(userNameController),
        Container(
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text("Email", style: TextStyle(fontSize: 15)),
        ),
        campoEmail(emailController),
        Container(
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text("Password", style: TextStyle(fontSize: 15)),
        ),
        campoContrasena(passwordController),

        Container(
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text("Password confirm", style: TextStyle(fontSize: 15)),
        ),
        campoContrasena(passwordConfirmController),
        SizedBox(height: 30),
        botonEntrar(emailController, passwordController, context),
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

Widget userName(TextEditingController userNameController) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
    child: TextField(
      controller: userNameController,
      decoration: InputDecoration(fillColor: Colors.white, filled: true),
    ),
  );
}

Widget campoEmail(TextEditingController emailController) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
    child: TextField(
      controller: emailController,
      decoration: InputDecoration(fillColor: Colors.white, filled: true),
    ),
  );
}

Widget campoContrasena(TextEditingController passwordController) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
    child: TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(fillColor: Colors.white, filled: true),
    ),
  );
}

Widget botonEntrar(
  TextEditingController emailController,
  TextEditingController passwordController,
  BuildContext context,
) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
      onPressed: () {},
      child: Text(
        "Registrar",
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
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
        "Register with Google",
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    ),
  );
}
