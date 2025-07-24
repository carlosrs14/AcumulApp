import 'dart:convert';
import 'dart:developer';

import 'package:acumulapp/services/user_service.dart';
import 'package:acumulapp/utils/jwt.dart';
import 'package:flutter/material.dart';
import 'package:acumulapp/models/user.dart';
import 'package:localstorage/localstorage.dart';

class UserProvider with ChangeNotifier {
  late UserService userService;

  UserProvider();

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initLocalStorage();
    userService = UserService(localStorage);
  }

  Future<User?> login(String email, String password, String accountType) async {
    User user;
    Map<String, String> map = {
      'email': email,
      'password': password,
      'userType': accountType
    };

    try {
      final response = await userService.login(map);

      if (response.statusCode != 200) return null;

      JwtController jwt = JwtController(localStorage);

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      final userData = jsonData['account'];
      final token = jsonData['token'];
      log(userData.toString());
      log(token.toString());

      jwt.saveToken(token);
      user = userFactory(userData);
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
      JwtController jwt = JwtController(localStorage);

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      final userData = jsonData['account'];
      final token = jsonData['token'];

      jwt.saveToken(token);
      userResponse = userFactory(userData);
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

      userResponse = userFactory(userData);
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

      userResponse = userFactory(userData);
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

      userResponse = userFactory(userData);
    } catch (e) {
      log(e.toString());
    }
    return userResponse;
  }
}
