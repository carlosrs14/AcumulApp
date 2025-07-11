import 'dart:convert';
import 'dart:developer';

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

  
  Future<List<UserCard>> filterByClient(int idUser) async {
    List<UserCard> cards = [];
    try {
      final response = await userCardService.filterByClient(idUser);

      if (response.statusCode != 200) {
        log(response.body);
        return cards;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData) {
       cards.add(UserCard.fromJson(element));
      }
    } catch (e) {
      log(e.toString());
    }
    return cards;
  }

  Future<List<UserCard>> filterByBusiness(int idBusiness) async {
        List<UserCard> cards = [];
    try {
      final response = await userCardService.filterByClient(idBusiness);

      if (response.statusCode != 200) {
        log(response.body);
        return cards;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData) {
       cards.add(UserCard.fromJson(element));
      }
    } catch (e) {
      log(e.toString());
    }
    return cards;
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
