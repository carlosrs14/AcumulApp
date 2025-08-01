import 'dart:convert';
import 'dart:developer';

import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/utils/jwt.dart';
import 'package:http/http.dart' as http;
import 'package:acumulapp/utils/utils.dart';
import 'package:localstorage/localstorage.dart';

class BusinessService {
  JwtController? jwt;
  BusinessService() {
    jwt = JwtController(localStorage);
  }

  Future<http.Response> all(
    String? name,
    int? category,
    int page,
    int size,
  ) async {
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'size': size.toString(),
      if (name != null && name.isNotEmpty) 'name': name,
      if (category != null && category != 0) 'category': category.toString(),
    };

    final Uri url = Uri.parse(urlApi).replace(
      path: '${Uri.parse(urlApi).path}/business',
      queryParameters: queryParams,
    );

    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
    );
  }

  Future<http.Response> getById(int id) async {
    final Uri url = Uri.parse("$urlApi/business/$id");
    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
    );
  }

  // TODO
  Future<http.Response> filterByCategory(String category) async {
    final Uri url = Uri.parse("$urlApi/business");
    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
    );
  }

  Future<http.Response> updateBusiness(Business business) async {
    final Uri url = Uri.parse("$urlApi/business/${business.id}");

    final body = business.toUpdateJson();
    log("Body enviado: ${jsonEncode(body)}");
    return http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> updateCategories(Business business) async {
    final Uri url = Uri.parse("$urlApi/business/${business.id}/categories");

    final categoryIds = business.categories!.map((c) => c.id).toList();

    final body = {'categories': categoryIds};

    return http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}',
      },
      body: jsonEncode(body),
    );
  }
}
