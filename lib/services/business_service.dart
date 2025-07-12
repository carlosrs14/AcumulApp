import 'package:acumulapp/utils/jwt.dart';
import 'package:http/http.dart' as http;
import 'package:acumulapp/utils/utils.dart';
import 'package:localstorage/localstorage.dart';

class BusinessService {
  JwtController? jwt;
  BusinessService() {
    jwt = JwtController(localStorage);
  }

  Future<http.Response> all() async {
    final Uri url = Uri.parse("$urlApi/business");
    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}'
      }
    );
  }

  Future<http.Response> getById(int id) async {
    final Uri url = Uri.parse("$urlApi/business/$id");
    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}'
      }
    );
  }

  // TODO
  Future<http.Response> filterByCategory(String category) async {
    final Uri url = Uri.parse("$urlApi/business");
    return http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${jwt?.loadToken()}'
      }
    );
  }
}