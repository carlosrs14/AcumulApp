import 'dart:convert';
import 'dart:developer';

import 'package:acumulapp/services/rating_service.dart';

class RatingProvider {
  RatingService ratingService = RatingService();

  RatingProvider();

  Future<bool> create(int idBusiness, double valoracion) async {
    try {
      final response = await ratingService.rating(idBusiness, valoracion);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return true;
      } else {
        log(" Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      log(" Exception: $e");
      return false;
    }
  }
}
