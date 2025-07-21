import 'dart:convert';

import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/utils/jwt.dart';
import 'package:acumulapp/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class CardService {
  JwtController? jwt;
  CardService() {
    jwt = JwtController(localStorage);
  }

  Future<http.Response> all() async {
    final Uri url = Uri.parse("$urlApi/card");
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
    );
  }

  Future<http.Response> filterByBusiness(int idBusiness) async {
    final Uri url = Uri.parse("$urlApi/card/business/$idBusiness");
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
    );
  }

  Future<http.Response> create(BusinessCard card) async {
    final Uri url = Uri.parse("$urlApi/card");
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
      body: jsonEncode(card.toJson()),
    );
  }

  Future<http.Response> update(BusinessCard card) async {
    final Uri url = Uri.parse("$urlApi/card/${card.id}");
    return await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
      body: jsonEncode(card.toJson()),
    );
  }

  Future<http.Response> delete(int id) async {
    final Uri url = Uri.parse("$urlApi/card/$id");
    return await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
    );
  }
}
