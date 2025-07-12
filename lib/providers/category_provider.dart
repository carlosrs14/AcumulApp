import 'dart:convert';
import 'dart:developer';

import 'package:acumulapp/models/category.dart';
import 'package:acumulapp/services/category_service.dart';

class CategoryProvider {
  CategoryService categoryService = CategoryService();

  CategoryProvider();

  Future<List<Category>> all() async {
    List<Category> categories = [];
    try {
      final response = await categoryService.all();

      if (response.statusCode != 200) return [];

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData["data"]) {
        categories.add(Category.fromJson(element));
      }
    } catch (e) {
      log(e.toString());
    }
    return categories;
  }
}
