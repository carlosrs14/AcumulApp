import 'package:http/http.dart' as http;
import 'package:acumulapp/utils/utils.dart';

class BusinessService {
  BusinessService();

  Future<http.Response> all() async {
    final Uri url = Uri.parse("$urlApi/business");
    return http.get(url);
  }

  Future<http.Response> getById(int id) async {
    final Uri url = Uri.parse("$urlApi/business/$id");
    return http.get(url);
  }

  // TODO
  Future<http.Response> filterByCategory(String category) async {
    final Uri url = Uri.parse("$urlApi/business");
    return http.get(url);
  }
}