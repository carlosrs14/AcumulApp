import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/utils/utils.dart';
import 'package:http/http.dart' as http;

class CardService {
  CardService();

  Future<http.Response> all() async {
    final Uri url = Uri.parse("$urlApi/card");
    return await http.get(url);
  }

  Future<http.Response> filterByBusiness(int idBusiness) async {
    final Uri url = Uri.parse("$urlApi/card/business/$idBusiness");
    return await http.get(url);
  }

  Future<http.Response> create(Card card) async {
    final Uri url = Uri.parse("$urlApi/card");
    return await http.post(
      url,
      body: card.toJson()
    );
  }
}