import 'package:acumulapp/utils/utils.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  CategoryService();
  
  Future<http.Response> all() async {
    final Uri url = Uri.parse("$urlApi/business/categories");
    return http.get(url);
  }
}