import 'dart:developer';

import 'package:localstorage/localstorage.dart';

class JwtController {
  final LocalStorage storage;

  JwtController(this.storage);

  void saveToken(String token) {
    try {
      storage.setItem('token', token);
    } catch (e) {
      log(e.toString());
    }
  }

  String? loadToken() {
    return storage.getItem('token');
  }
}
