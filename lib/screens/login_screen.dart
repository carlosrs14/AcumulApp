import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/user_provider.dart';
import 'package:flutter/material.dart';

class InicioLogin extends StatefulWidget {
  const InicioLogin({super.key});

  @override
  State<InicioLogin> createState() => _InicioLoginState();
}

class _InicioLoginState extends State<InicioLogin> {
  String _accountType = 'client';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserProvider userProvider = UserProvider();

  @override
  void initState() {
    super.initState();
    userProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      _nombre(),
                      SizedBox(height: 160),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        alignment: Alignment.centerLeft,
                        child: Text("Email", style: TextStyle(fontSize: 15)),
                      ),
                      _campoEmail(emailController),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        alignment: Alignment.centerLeft,
                        child: Text("Password", style: TextStyle(fontSize: 15)),
                      ),
                      _campoContrasena(passwordController),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                        child: DropdownButtonFormField<String>(
                          value: _accountType,
                          items: [
                            DropdownMenuItem(
                                value: 'client', child: Text('Client')),
                            DropdownMenuItem(
                                value: 'business', child: Text('Business')),
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
                      ),
                      SizedBox(height: 30),
                      _botonEntrar(context),
                      SizedBox(height: 30),
                      _botonGoogle(context),
                      SizedBox(height: 30),
                      _irARegistrar(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _nombre() {
    return Text(
      "AcumulApp",
      style: TextStyle(
        color: Color(0xFF212121),
        fontSize: 35,
        fontFamily: 'sans-serif',
      ),
    );
  }

  Widget _campoEmail(TextEditingController emailController) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(fillColor: Colors.white, filled: true),
      ),
    );
  }

  Widget _campoContrasena(TextEditingController passwordController) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(fillColor: Colors.white, filled: true),
      ),
    );
  }

  Widget _botonEntrar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () async {
          User? user = await userProvider.login(
            emailController.text,
            passwordController.text,
            _accountType,
          );

          if (user != null) {
            Navigator.pushNamed(context, '/home', arguments: user);
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Usuario o contraseña incorrectos',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 15)),
      ),
    );
  }

  Widget _botonGoogle(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {},
        child: Text(
          "Login with Google",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  Widget _irARegistrar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/register');
      },
      child: Text("¿No tienes una cuenta? ingresa aqui"),
    );
  }
}
