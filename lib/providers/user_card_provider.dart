import 'dart:convert';
import 'dart:developer';

import 'package:acumulapp/models/pagination_data.dart';
import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/services/user_card_service.dart';

class UserCardProvider {
  UserCardService userCardService = UserCardService();

  UserCardProvider();

  Future<UserCard?> create(UserCard userCard) async {
    UserCard? userCardResponse;
    try {
      final response = await userCardService.create(userCard);

      if (response.statusCode != 200) {
        log(response.body);
        return userCardResponse;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      userCardResponse = UserCard.fromJson(jsonData);
    } catch (e) {
      log(e.toString());
    }
    return userCardResponse;
  }

  Future<PaginationData?> filterByClient(
    int idUser,
    int idState,
    int size,
    int page,
  ) async {
    List<UserCard> cards = [];
    PaginationData? paginationData;
    try {
      final response = await userCardService.filterByClient(
        idUser,
        idState,
        size,
        page,
      );

      if (response.statusCode != 200) {
        log(response.body);
        return null;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      log(jsonData.toString());
      for (var element in jsonData["data"]) {
        cards.add(UserCard.fromJson(element));
      }
      paginationData = PaginationData(
        cards,
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

  Future<PaginationData?> filterByBusiness(int idBusiness, int idState) async {
    List<UserCard> cards = [];
    PaginationData? paginationData;
    try {
      final response = await userCardService.filterByBusiness(idBusiness, idState);

      if (response.statusCode != 200) {
        log(response.body);
        return null;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      log(jsonData.toString());
      for (var element in jsonData["data"]) {
        cards.add(UserCard.fromJson(element));
      }
      paginationData = PaginationData(
        cards,
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

  Future<UserCard?> getById(int id) async {
    UserCard? userCardResponse;
    try {
      final response = await userCardService.getById(id);

      if (response.statusCode != 200) {
        log(response.body);
        return userCardResponse;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      userCardResponse = UserCard.fromJson(jsonData);
    } catch (e) {
      log(e.toString());
    }
    return userCardResponse;
  }

  Future<UserCard?> getByCode(String code) async {
    UserCard? userCardResponse;
    try {
      final response = await userCardService.getByCode(code);

      if (response.statusCode != 200) {
        log(response.body);
        return userCardResponse;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      userCardResponse = UserCard.fromJson(jsonData);
    } catch (e) {
      log(e.toString());
    }
    return userCardResponse;
  }

  Future<UserCard?> activateCard(String code) async {
    UserCard? userCardResponse;
    try {
      final response = await userCardService.activateCard(code);

      if (response.statusCode != 200) {
        log(response.body);
        return userCardResponse;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      userCardResponse = UserCard.fromJson(jsonData);
    } catch (e) {
      log(e.toString());
    }
    return userCardResponse;
  }

  Future<UserCard?> addStamp(String code, int stamps) async {
    UserCard? userCardResponse;
    try {
      final response = await userCardService.addStamp(code, stamps);

      if (response.statusCode != 200) {
        log(response.body);
        return userCardResponse;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      userCardResponse = UserCard.fromJson(jsonData);
    } catch (e) {
      log(e.toString());
    }
    return userCardResponse;
  }

  Future<UserCard?> redeemCard(String code) async {
    UserCard? userCardResponse;
    try {
      final response = await userCardService.redeemCard(code);

      if (response.statusCode != 200) {
        log(response.body);
        return userCardResponse;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      userCardResponse = UserCard.fromJson(jsonData);
    } catch (e) {
      log(e.toString());
    }
    return userCardResponse;
  }
}
