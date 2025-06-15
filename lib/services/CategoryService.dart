import 'dart:convert';

import 'package:acumulapp/models/CategoryModel.dart';
import '../utils/utils.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  String urlApiCategory = "$urlApi/categories/";

   Future<List<CategoryModel>> all() async {
    List<CategoryModel> categories = [];
    try {
      final response = await http.get(Uri.parse(urlApiCategory));

      if (response.statusCode != 200) return [];

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData) {
        categories.add(CategoryModel.fromJson(element));
      }
    } catch (e) {
      print(e);
    }
    return categories;
  }
}