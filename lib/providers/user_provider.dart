import 'dart:convert';
import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

import 'package:acumulapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:acumulapp/models/user.dart';

class UserProvider with ChangeNotifier {
  UserService userService = UserService();
  
  UserProvider();

  Future<User?> login(String email, String password) async {
    User user;
    Map<String, String> map = {
      'email': email,
      'password': password
    };

    try {
      final response = await userService.login(map);

      if (response.statusCode != 200) return null;
    
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      user = User.fromJson(jsonData);
    } catch (e) {
      log(e.toString());
      return null;
    }
    return user;
  }

  Future<User?> register(User user) async {
    User? userResponse;

    try {
      final response = await userService.register(user);

      if (response.statusCode != 200) {
        return null;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      final userData = jsonData["account"];

      userResponse = User.fromJson(userData);

    } catch (e) {
      log(e.toString());
      return null;
    }
    return userResponse;
  }

  Future<User?> registerBusiness(User user) async {
    User? userResponse;
    try {
      final response = await userService.registroBusiness(user);

      if (response.statusCode != 200) {
        return null;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      final userData = jsonData["account"];

      userResponse = User.fromJson(userData);

    } catch (e) {
      log(e.toString());
    }
    return userResponse;
  }

  Future<User?> getById(int id) async {
    User? userResponse;
    try {
      final response = await userService.getById(id);

      if (response.statusCode != 200) {
        return null;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      final userData = jsonData["account"];

      userResponse = User.fromJson(userData);

    } catch (e) {
      log(e.toString());
    }
    return userResponse;
  }

  Future<User?> getByEmail(String email) async {
    User? userResponse;
    try {
      final response = await userService.getByEmail(email);

      if (response.statusCode != 200) {
        return null;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      final userData = jsonData["account"];

      userResponse = User.fromJson(userData);

    } catch (e) {
      log(e.toString());
    }
    return userResponse;
  }
}