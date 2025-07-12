import 'dart:convert';

import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/utils/jwt.dart';
import 'package:acumulapp/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class UserService {
  JwtController? jwt;
  UserService() {
    jwt = JwtController(localStorage);
  }

  Future<http.Response> login(Map<String, String> data) async {
    final Uri url = Uri.parse("$urlApi/auth/login");
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json'
      },
      body: json.encode(data)
    );
  }

  Future<http.Response> register(User user) async {
    final Uri url = Uri.parse("$urlApi/auth/register/client");
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json'
      },
      body: user.toJson()
    );
  }

  Future<http.Response> registroBusiness(User user) async {
    final Uri url = Uri.parse("$urlApi/auth/register/business");
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json'
      },
      body: user.toJson()
    );
  }

  Future<http.Response> getById(int id) async {
    final Uri url = Uri.parse("$urlApi/auth/$id");
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}'
      }
    );
  }

  Future<http.Response> getByEmail(String email) async {
    final Uri url = Uri.parse("$urlApi/auth/email/$email");
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}'
      }
    );
  }
}