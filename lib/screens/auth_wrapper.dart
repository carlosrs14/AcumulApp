import 'dart:developer';

import 'package:acumulapp/providers/user_provider.dart';
import 'package:acumulapp/screens/user/home_screen.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ClerkErrorListener(
      child: ClerkAuthBuilder(
        signedInBuilder: (context, authState) {
          // cuando Clerk dice que está firmado, mostramos un widget que hará
          // el intercambio (obtener token y crear/obtener usuario en backend)
          return SignedIndHandler(authState: authState);
        },
        signedOutBuilder: (context, authState) {
          return Scaffold(
            appBar: AppBar(title: const Text('Login with google'),),
            body: const Center(child: ClerkAuthentication(),),
          );
        },
      )
      );
  }
}

class SignedIndHandler extends StatefulWidget {
  final ClerkAuthState authState;
  const SignedIndHandler({required this.authState, super.key});

  @override
  State<SignedIndHandler> createState() => _SignedIndHandlerState();
}

class _SignedIndHandlerState extends State<SignedIndHandler> {
  UserProvider userProvider = UserProvider();
  bool _working = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _exchangeTokenWithBackend();
  }

  Future<void> _exchangeTokenWithBackend() async {
    userProvider.init();
    try {
      final sessionToken = await widget.authState.sessionToken();
      final jwt = sessionToken.jwt;

      final user = await userProvider.authClerk(jwt);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home', arguments: user);
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: HomeScreen(user: user)));
      }

    } catch (e) {
      setState(() {
        _error = e.toString();
        _working = false;
        log(_error!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_working) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
        body: Center(child: Text('Error: $_error')),
      );
    }
  }
}