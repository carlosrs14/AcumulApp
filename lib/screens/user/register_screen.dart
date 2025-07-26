import 'package:acumulapp/models/client.dart';
import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/user_provider.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final UserProvider userProvider = UserProvider();

  @override
  void initState() {
    userProvider.init();
    super.initState();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  String _accountType = "client";
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: cuerpo());
  }

  Widget cuerpo() {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(
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
                    userName(),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: Text("Email", style: TextStyle(fontSize: 15)),
                    ),
                    campoEmail(),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: Text("Password", style: TextStyle(fontSize: 15)),
                    ),
                    campoContrasena(passwordController),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password confirm",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    campoContrasena(passwordConfirmController),
                    acountypes(),
                    SizedBox(height: 30),
                    botonEntrar(),
                    SizedBox(height: 30),
                    botonGoogle(),
                  ],
                ),
              ),
            ),
          );
        },
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

  Widget userName() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextField(
        controller: userNameController,
        decoration: InputDecoration(fillColor: Colors.white, filled: true),
      ),
    );
  }

  Widget campoEmail() {
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

  Widget botonEntrar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
        onPressed: () async {
          late User userRequest;
          User? userResponse;

          if (_accountType == "client") {
            userRequest = Client(
              0,
              userNameController.text,
              emailController.text,
              passwordController.text,
              "client",
            );

            userResponse = await userProvider.register(userRequest);
          } else {
            userRequest = Collaborator(
              0,
              userNameController.text,
              emailController.text,
              passwordController.text,
              "collaborator",
              null,
            );
            userResponse = await userProvider.registerBusiness(userRequest);
          }

          if (userResponse != null) {
            Navigator.pushNamed(context, '/home', arguments: userResponse);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
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

  Widget acountypes() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonFormField<String>(
        value: _accountType,
        items: [
          DropdownMenuItem(value: 'client', child: Text('Client')),
          DropdownMenuItem(value: 'business', child: Text('Business')),
        ],
        onChanged: (String? newValue) {
          setState(() {
            _accountType = newValue!;
          });
        },
        decoration: InputDecoration(
          labelText: 'Account Type',
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
