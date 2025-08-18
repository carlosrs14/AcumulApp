import 'dart:developer';

import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/user_provider.dart';
import 'package:acumulapp/screens/logo_app.dart';
import 'package:flutter/material.dart';

class InicioLogin extends StatefulWidget {
  const InicioLogin({super.key});

  @override
  State<InicioLogin> createState() => _InicioLoginState();
}

class _InicioLoginState extends State<InicioLogin> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
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
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  LogoApp(),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 160),
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Email",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              textFile(emailController, 3, true, false),
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Password",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              textFile(passwordController, 3, false, true),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 3,
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _accountType,
                                  items: [
                                    DropdownMenuItem(
                                      value: 'client',
                                      child: Text('Client'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'business',
                                      child: Text('Business'),
                                    ),
                                  ],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _accountType = newValue!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                    labelText: 'Account Type',
                                    fillColor: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    filled: true,
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              _botonEntrar(context),
                              //SizedBox(height: 30),
                              //_botonGoogle(context),
                              SizedBox(height: 30),
                              _irARegistrar(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget textFile(
    TextEditingController controller,
    int minimumQuantity,
    bool email,
    bool password,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextFormField(
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        obscureText: password,
        controller: controller,
        decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Este campo es obligatorio';
          } else if (value.length < minimumQuantity) {
            return 'Requiere una cantidad minima de $minimumQuantity caracteres';
          } else if (email &&
              !(value.contains("@") && value.contains(".com"))) {
            return 'Debe ser un correo';
          }
          return null;
        },
      ),
    );
  }

  Widget _botonEntrar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            await Future.delayed(Duration(milliseconds: 100));
            _scrollController.animateTo(
              0.0,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
            return;
          }
          try {
            User? user = await userProvider.login(
              emailController.text,
              passwordController.text,
              _accountType,
            );
            if (user != null) {
              log(user.toString());
              Navigator.pushNamed(context, '/home', arguments: user);
            }
          } catch (e) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  e.toString().replaceAll("Exception: ", ""),
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 3),
              ),
            );
            return;
          }
        },
        child: Text("Login", style: TextStyle(fontSize: 15)),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("¿No tienes una cuenta? "),
          Text(
            "Ingresa aqui ",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
