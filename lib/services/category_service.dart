import 'package:acumulapp/utils/jwt.dart';
import 'package:acumulapp/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class CategoryService {
  JwtController? jwt;
  CategoryService() {
    jwt = JwtController(localStorage);
  }
  
  Future<http.Response> all() async {
    final Uri url = Uri.parse("$urlApi/business/categories");
    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}'
      });
  }
}