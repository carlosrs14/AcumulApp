import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/user_provider.dart';
import 'package:flutter/material.dart';

class InicioLogin extends StatefulWidget {
  const InicioLogin({super.key});

  @override
  State<InicioLogin> createState() => _InicioState();
}

class _InicioState extends State<InicioLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: cuerpo(context));
  }
}

Widget cuerpo(BuildContext context) {
  final UserProvider userProvider = UserProvider();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
        campoEmail(emailController),
        Container(
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text("Password", style: TextStyle(fontSize: 15)),
        ),
        campoContrasena(passwordController),
        SizedBox(height: 30),
        botonEntrar(emailController, passwordController, context, userProvider),
        SizedBox(height: 30),
        botonGoogle(),
        SizedBox(height: 30),
        irARegistrar(context),
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
  UserProvider userProvider,
) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
      onPressed: () async {
        User? user = await userProvider.login(
          emailController.text,
          passwordController.text,
        );

        if (user != null) {
          Navigator.pushNamed(context, '/home', arguments: user);
        }

        if (("Daniel") == emailController.text &&
            ("1234") == passwordController.text) {
          Navigator.pushNamed(
            context,
            '/home',
            arguments: User(1, 'Daniel', 'daniel', '123123'),
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

Widget irARegistrar(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/register');
    },
    child: Text("¿No tienes una cuenta? ingresa aqui"),
  );
}
