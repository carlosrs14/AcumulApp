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
      'userType': accountType,
    };

    try {
      final response = await userService.login(map);

      if (response.statusCode != 200) return null;

      JwtController jwt = JwtController(localStorage);

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      final userData = jsonData['account'];
      Map<String, String> tokens = {
        'token': jsonData['token'],
        'refreshToken': jsonData['refreshToken']
      };

      log(userData.toString());
      log(tokens.toString());

      jwt.saveToken(tokens);
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
      Map<String, String> tokens = {
        'token': jsonData['token'],
        'refreshToken': jsonData['refreshToken']
      };

      log(jsonEncode(userData));
      log(tokens.toString());

      jwt.saveToken(tokens);
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
      JwtController jwt = JwtController(localStorage);
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      
      final userData = jsonData["account"];
      Map<String, String> tokens = {
        'token': jsonData['token'],
        'refreshToken': jsonData['refreshToken']
      };

      log(jsonEncode(userData));
      log(tokens.toString());

      jwt.saveToken(tokens);
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

  Map<String, dynamic> decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');

      if (parts.length != 3) return {};
      
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = base64Url.decode(normalized);
      final jsonStr = utf8.decode(decoded);
      final Map<String, dynamic> map = jsonDecode(jsonStr);
      
      return map;
    } catch (e) {
      return {};
    }
  }

  Future<User?> getLoggedUser() async {
    await initLocalStorage();  
    JwtController jwt = JwtController(localStorage);

    String? token = jwt.loadToken();
    if (token == null) {
      log("token from cache is null");
      return null;
    }

    Map<String, dynamic> payload = decodeJwtPayload(token);
    if (payload.isEmpty)  {
      log("payload is empty");
      return null;
    }

    bool expired = false;
    try {
      if (payload.containsKey('exp')) {
        final exp = payload['exp'] as int;
        final expiry = DateTime.fromMicrosecondsSinceEpoch(exp * 1000, isUtc: true).toLocal();
        if (DateTime.now().isAfter(expiry)) expired = true;
      }
    } catch (e) {
      log(e.toString());
    }

    if (expired) {
      final refreshToken = jwt.loadRefresh();
      if (refreshToken == null) {
        jwt.clearCache();
        log("refresh token = null");
        return null;
      }

      final refreshResp = await userService.refreshToken(refreshToken);
      if (refreshResp.statusCode != 200) {
        // refresh falló -> limpiar cache y requerir login
        jwt.clearCache();
        log("refresh failed");
        return null;
      }

      final body = utf8.decode(refreshResp.bodyBytes);
      final jsonData = jsonDecode(body);
      final newToken = jsonData['token'] as String?;
      final newRefresh = jsonData['refreshToken'] as String?;

      if (newToken == null || newRefresh == null) {
        jwt.clearCache();
        log("response from back end failed");
        return null;
      }

      jwt.saveToken({'token': newToken, 'refreshToken': newRefresh});
      token = newToken;
      payload = decodeJwtPayload(token);
    }

    dynamic idField = payload['id'];
    if (idField != null) {
      final userId = int.tryParse(idField.toString());
      log("god one id = $userId");
      return getById(userId!);
    }
    log("Not validated error");
    return null;
  }
}
