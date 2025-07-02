import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/utils/utils.dart';

class UserProvider {
  String urlApiUser = "$urlApi/auth/user";
  
  Future<User?> login(String email, String password) async {
    String url = "$urlApiUser/login/";
    User user;
    Map map = {
      'email': email,
      'password': password
    };

    try {
      final response = await http.post(Uri.parse(url), body: map);
    
      if (response.statusCode != 200) return null;
    
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      user = User.fromJson(jsonData);
    } catch (e) {
      print(e);
      return null;
    }
    return user;
  }

  Future<User?> register(User user) async {
    String url = "$urlApiUser/register/";
    User? userResponse;

    try {
      final response = await http.post(Uri.parse(url), body: user.toJson());

      if (response.statusCode != 200) return null;

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      userResponse = User.fromJson(jsonData);

    } catch (e) {
      print(e);
      return null;
    }
    return userResponse;
  }
}