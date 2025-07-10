import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/utils/utils.dart';
import 'package:http/http.dart' as http;

class UserCardService {
  Future<http.Response> create(UserCard userCard) async {
    final Uri url = Uri.parse("$urlApi/client-card");
    return await http.post(
      url,
      body: userCard.toJson()
    );
  }

  //TODO
  Future<http.Response> filterByClient(int idUser) async {
    final Uri url = Uri.parse("$urlApi/client-card/client");
    return await http.get(
      url
    );
  }

  //TODO
  Future<http.Response> filterByBusiness(int idBusiness) async {
    final Uri url = Uri.parse("$urlApi/client-card/business");
    return await http.get(
      url
    );
  }

  Future<http.Response> getById(int id) async {
    final Uri url = Uri.parse("$urlApi/client-card/$id");
    return await http.get(
      url
    );
  }

  Future<http.Response> getByCode(String code) async {
    final Uri url = Uri.parse("$urlApi/client-card/unique-code/$code");
    return await http.get(
      url
    );
  }

  Future<http.Response> activateCard(String code) async {
    final Uri url = Uri.parse("$urlApi/client-card/activate/$code");
    return await http.post(
      url
    );
  }

  Future<http.Response> addStamp(String code, int stamps) async {
    final Uri url = Uri.parse("$urlApi/client-card/add-stamp/$code");
    return await http.post(
      url,
      body: {
        "stamps": stamps
      }
    );
  }

  Future<http.Response> redeemCard(String code) async {
    final Uri url = Uri.parse("$urlApi/client-card/mark-as-redeemed/$code");
    return await http.post(
      url,
    );
  }
}