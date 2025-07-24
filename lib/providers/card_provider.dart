import 'dart:convert';
import 'dart:developer';

import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/models/pagination_data.dart';
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

  Future<PaginationData?> filterByBusiness(
    int idBusiness,
    int size,
    int page,
  ) async {
    List<BusinessCard> cards = [];
    PaginationData? paginationData;
    try {
      final response = await cardService.filterByBusiness(
        idBusiness,
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
        cards.add(BusinessCard.fromJson(element));
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

  Future<BusinessCard?> update(BusinessCard card) async {
    BusinessCard? cardResponse;
    try {
      final response = await cardService.update(card);

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

  Future<bool> delete(int id) async {
    try {
      final response = await cardService.delete(id);

      if (response.statusCode != 200) {
        log(response.body);
        return false;
      }

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
