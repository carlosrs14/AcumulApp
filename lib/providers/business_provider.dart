import 'dart:convert';
import 'dart:developer';

import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/pagination_data.dart';
import 'package:acumulapp/services/business_service.dart';

class BusinessProvider {
  BusinessService businessService = BusinessService();

  BusinessProvider();

  Future<PaginationData?> all(
    String? name,
    int? category,
    int page,
    int size,
  ) async {
    List<Business> business = [];
    PaginationData? paginationData;
    try {
      final response = await businessService.all(name, category, page, size);

      if (response.statusCode != 200) {
        log(response.body);
        return null;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      log(jsonData['data'].toString());
      for (var element in jsonData['data']) {
        business.add(Business.fromJson(element));
      }
      paginationData = PaginationData(
        business,
        jsonData["pagination"]["total_pages"],
        jsonData["pagination"]["total_items"],
        jsonData["pagination"]["current_page"],
        jsonData["pagination"]["page_size"],
      );
    } catch (e) {
      log(e.toString());
    }
    return paginationData;
  }

  Future<Business?> get(int id) async {
    Business? business;
    try {
      final response = await businessService.getById(id);

      if (response.statusCode != 200) return business;

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      business = Business.fromJson(jsonData);
    } catch (e) {
      log(e.toString());
    }
    return business;
  }
}
