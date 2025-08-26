import 'dart:convert';

import 'package:acumulapp/utils/jwt.dart';
import 'package:acumulapp/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class RatingService {
  JwtController? jwt;
  RatingService() {
    jwt = JwtController(localStorage);
  }

  Future<http.Response> rating(int idBusiness, double valoracion) async {
    final Uri url = Uri.parse("$urlApi/rating");
    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
      body: jsonEncode({"idBusiness": idBusiness, "valoration": valoracion}),
    );
  }
}
