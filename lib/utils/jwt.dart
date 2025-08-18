import 'dart:developer';

import 'package:localstorage/localstorage.dart';

class JwtController {
  final LocalStorage storage;

  JwtController(this.storage);

  void saveToken(Map<String, String> tokens) {
    try {
      storage.setItem('token', tokens['token'] as String);
      storage.setItem('refreshToken', tokens['refreshToken'] as String);
    } catch (e) {
      log(e.toString());
    }
  }

  String? loadToken() {
    return storage.getItem('token');
  }

  Map<String, String> loadTokens() {
    Map<String, String> tokens = {
      'token': storage.getItem('token') as String,
      'refreshToken': storage.getItem('refreshToken') as String
    };
    return tokens;
  }

  String? loadRefresh() {
      return storage.getItem('refreshToken');
  }

  void clearCache() {
    storage.clear();
  }
}
