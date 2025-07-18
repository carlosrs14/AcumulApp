import 'dart:convert';
import 'dart:developer';

import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/services/card_service.dart';

class CardProvider {
  CardService cardService = CardService();

  CardProvider();

  Future<List<BusinessCard>> all() async {
    List<BusinessCard> cards = [];
    try {
      final response = await cardService.all();

      if (response.statusCode != 200) {
        log(response.body);
        return cards;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData) {
        cards.add(BusinessCard.fromJson(element));
      }
    } catch (e) {
      log(e.toString());
    }
    return cards;
  }

  Future<List<BusinessCard>> filterByBusiness(int idBusiness) async {
    List<BusinessCard> cards = [];
    try {
      final response = await cardService.filterByBusiness(idBusiness);

      if (response.statusCode != 200) {
        log(response.body);
        return cards;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      log(jsonData["data"].toString());
      for (var element in jsonData["data"]) {
        cards.add(BusinessCard.fromJson(element));
      }
    } catch (e) {
      log(e.toString());
    }
    return cards;
  }

  Future<BusinessCard?> create(BusinessCard card) async {
    BusinessCard? cardResponse;
    try {
      final response = await cardService.create(card);

      if (response.statusCode != 200) {
        log(response.body);
        return cardResponse;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      cardResponse = BusinessCard.fromJson(jsonData);
    } catch (e) {
      log(e.toString());
    }
    return cardResponse;
  }
}
