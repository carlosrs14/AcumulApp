import 'dart:convert';

import 'package:acumulapp/models/category.dart';
import '../utils/utils.dart';
import 'package:http/http.dart' as http;

class CategoryProvider {
  String urlApiCategory = "$urlApi/categories/";

   Future<List<Category>> all() async {
    List<Category> categories = [];
    try {
      final response = await http.get(Uri.parse(urlApiCategory));

      if (response.statusCode != 200) return [];

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData) {
        categories.add(Category.fromJson(element));
      }
    } catch (e) {
      print(e);
    }
    return categories;
  }
}