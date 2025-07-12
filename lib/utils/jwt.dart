import 'package:localstorage/localstorage.dart';

class JwtController {
  final LocalStorage storage;

  JwtController(this.storage);
  
  void saveToken(String token) {
    storage.setItem('token', token);
  }

  String? loadToken() {
    return storage.getItem('token');
  }
}
