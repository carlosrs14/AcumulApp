import 'package:acumulapp/models/client.dart';
import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/user_provider.dart';
import 'package:acumulapp/screens/business/update_info_screen.dart';
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
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: cuerpo());
  }

  Widget cuerpo() {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            nombre(),
                            SizedBox(height: 40),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "User name",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            textFile(userNameController, 3, false, false, null),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Email",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            textFile(emailController, 3, true, false, null),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Password",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            textFile(
                              passwordController,
                              3,
                              false,
                              true,
                              passwordConfirmController,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Password confirm",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            textFile(
                              passwordConfirmController,
                              3,
                              false,
                              true,
                              passwordController,
                            ),
                            acountypes(),
                            SizedBox(height: 30),
                            botonEntrar(),
                            SizedBox(height: 30),
                            //botonGoogle(),
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
    );
  }

  Widget nombre() {
    return Image.asset("assets/images/AcumulappLogo.png", scale: 4);
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
        style: ElevatedButton.styleFrom(
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

          if (userResponse != null && "client" == userResponse.userType) {
            Navigator.pushNamed(context, '/home', arguments: userResponse);
          } else if (userResponse != null &&
              "collaborator" == userResponse.userType) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    UpdateInfoScreen(user: userResponse as Collaborator),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

  Widget textFile(
    TextEditingController controller,
    int minimumQuantity,
    bool email,
    bool password,
    TextEditingController? matchController,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextFormField(
        obscureText: password,
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
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
          } else if (matchController != null && value != matchController.text) {
            return 'Las contraseñas no coinciden';
          }
          return null;
        },
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
