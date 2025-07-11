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

      if (response.statusCode != 200){
        log(response.body);
        return business;
      }
      
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData) {
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

  Future<List<Business>> filterByCategoryName(String categoryName) async {
    return List.empty();
  }

  Future<List<Business>> filterByCategoryId(int categoryId) async {
    return List.empty();
  }

}
