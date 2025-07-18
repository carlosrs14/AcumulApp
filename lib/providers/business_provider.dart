import 'dart:convert';
import 'dart:developer';

import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/services/business_service.dart';

class BusinessProvider {
  BusinessService businessService = BusinessService();

  BusinessProvider();

  Future<List<Business>> all() async {
    List<Business> business = [];
    try {
      final response = await businessService.all();

      if (response.statusCode != 200) {
        log(response.body);
        return business;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      log(jsonData['data'].toString());
      for (var element in jsonData['data']) {
        business.add(Business.fromJson(element));
      }
    } catch (e) {
      log(e.toString());
    }
    return business;
  }

  Future<Business?> get(int id) async {
    Business? business;
    try {
      final response = await businessService.all();

      if (response.statusCode != 200) return business;

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      business = Business.fromJson(jsonData);
    } catch (e) {
      log(e.toString());
    }
    return business;
  }

  Future<List<Business>> filterByName(String Name) async {
    List<Business> business = [];
    try {
      final response = await businessService.all();

      if (response.statusCode != 200) {
        log(response.body);
        return business;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      log(jsonData['data'].toString());
      for (var element in jsonData['data']) {
        business.add(Business.fromJson(element));
      }
      business = business.where((negocio) {
        return negocio.name.toLowerCase().contains(Name.toLowerCase());
      }).toList();
    } catch (e) {
      log(e.toString());
    }
    return business;
  }

  Future<List<Business>> filterByNameAndCategory(
    String Name,
    String categoryName,
  ) async {
    List<Business> business = [];
    try {
      final response = await businessService.all();

      if (response.statusCode != 200) {
        log(response.body);
        return business;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      log(jsonData['data'].toString());
      for (var element in jsonData['data']) {
        business.add(Business.fromJson(element));
      }

      business = business.where((negocio) {
        return negocio.name.toLowerCase().contains(Name.toLowerCase());
      }).toList();

      business = business.where((negocio) {
        return negocio.categories.any(
          (categoria) =>
              categoria.name.toLowerCase() == categoryName.toLowerCase(),
        );
      }).toList();
    } catch (e) {
      log(e.toString());
    }
    return business;
  }

  Future<List<Business>> filterByCategoryId(int categoryId) async {
    return List.empty();
  }
}
