import 'dart:convert';

import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/utils/jwt.dart';
import 'package:acumulapp/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class UserCardService {
  JwtController? jwt;

  UserCardService() {
    jwt = JwtController(localStorage);
  }

  Future<http.Response> create(UserCard userCard) async {
    final Uri url = Uri.parse("$urlApi/client-card");
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
      body: jsonEncode(userCard.toJsonCreate()),
    );
  }

  Future<http.Response> filterByClient(int idUser, int idState) async {
    final Uri url = Uri.parse(
      "$urlApi/client-card/client?idClient=$idUser&idState=$idState",
    );
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
    );
  }

  Future<http.Response> filterByBusiness(int idBusiness) async {
    final Uri url = Uri.parse("$urlApi/client-card/business/$idBusiness");
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
    );
  }

  Future<http.Response> getById(int id) async {
    final Uri url = Uri.parse("$urlApi/client-card/$id");
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
    );
  }

  Future<http.Response> getByCode(String code) async {
    final Uri url = Uri.parse("$urlApi/client-card/unique-code/$code");
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
    );
  }

  Future<http.Response> activateCard(String code) async {
    final Uri url = Uri.parse("$urlApi/client-card/activate/$code");
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
    );
  }

  Future<http.Response> addStamp(String code, int stamps) async {
    final Uri url = Uri.parse("$urlApi/client-card/add-stamp/$code");
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
      body: {
        jsonEncode({"stamps": stamps}),
      },
    );
  }

  Future<http.Response> redeemCard(String code) async {
    final Uri url = Uri.parse("$urlApi/client-card/mark-as-redeemed/$code");
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
    );
  }
}
