import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/utils/utils.dart';

class UserProvider {
  String urlApiUser = "$urlApi/auth/user";
  
  Future<UserModel?> login(String email, String password) async {
    String url = "$urlApiUser/login/";
    UserModel user;
    Map map = {
      'email': email,
      'password': password
    };

    try {
      final response = await http.post(Uri.parse(url), body: map);
    
      if (response.statusCode != 200) return null;
    
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      user = UserModel.fromJson(jsonData);
    } catch (e) {
      print(e);
      return null;
    }
    return user;
  }

  Future<UserModel?> register(UserModel user) async {
    String url = "$urlApiUser/register/";
    UserModel? userResponse;

    try {
      final response = await http.post(Uri.parse(url), body: user.toJson());

      if (response.statusCode != 200) return null;

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      userResponse = UserModel.fromJson(jsonData);

    } catch (e) {
      print(e);
      return null;
    }
    return userResponse;
  }
}