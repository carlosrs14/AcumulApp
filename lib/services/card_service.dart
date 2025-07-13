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
        'Authorization': 'Bearer ${jwt?.loadToken()}'
      }
    );
  }

  Future<http.Response> filterByBusiness(int idBusiness) async {
    final Uri url = Uri.parse("$urlApi/card/business/$idBusiness");
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}'
      }
    );
  }

  Future<http.Response> create(Card card) async {
    final Uri url = Uri.parse("$urlApi/card");
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}'
      },
      body: jsonEncode(card.toJson())
    );
  }
}