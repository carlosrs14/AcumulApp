import 'dart:convert';

import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/utils/utils.dart';
import 'package:http/http.dart' as http;

class UserService {
  UserService();

  Future<http.Response> login(Map<String, String> data) async {
    final Uri url = Uri.parse("$urlApi/auth/login");
    return await http.post(
      url,
      body: json.encode(data)
    );
  }

  Future<http.Response> register(User user) async {
    final Uri url = Uri.parse("$urlApi/auth/register/client");
    return await http.post(
      url,
      body: user.toJson()
    );
  }

  Future<http.Response> registroBusiness(User user) async {
    final Uri url = Uri.parse("$urlApi/auth/register/business");
    return await http.post(
      url,
      body: user.toJson()
    );
  }

  Future<http.Response> getById(int id) async {
    final Uri url = Uri.parse("$urlApi/auth/$id");
    return await http.get(url);
  }

  Future<http.Response> getByEmail(String email) async {
    final Uri url = Uri.parse("$urlApi/auth/$email");
    return await http.get(url);
  }
}