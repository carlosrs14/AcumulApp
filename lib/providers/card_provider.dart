import 'dart:convert';
import 'dart:developer';

import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/services/card_service.dart';

class CardProvider {
  CardService cardService = CardService();

  CardProvider();

  Future<List<Card>> all() async {
    List<Card> cards = [];
    try {
      final response = await cardService.all();

      if (response.statusCode != 200) {
        log(response.body);
        return cards;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData) {
        cards.add(Card.fromJson(element));
      }
    } catch (e) {
      log(e.toString());
    }
    return cards;
  }

  Future<List<Card>> filterByBusiness(int idBusiness) async {
    List<Card> cards = [];
    try {
      final response = await cardService.filterByBusiness(idBusiness);

      if (response.statusCode != 200) {
        log(response.body);
        return cards;
      }
      
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var element in jsonData) {
        cards.add(Card.fromJson(element));
      }
    } catch (e) {
      log(e.toString());
    }
    return cards;
  }

  Future<Card?> create(Card card) async {
    Card? cardResponse;
    try {
      final response = await cardService.create(card);

      if (response.statusCode != 200) {
        log(response.body);
        return cardResponse;
      }
      
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      cardResponse = Card.fromJson(jsonData);
    } catch (e) {
      log(e.toString());
    }
    return cardResponse;
  }
}
