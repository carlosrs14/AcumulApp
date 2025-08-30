import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:acumulapp/models/link.dart';
import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/business_stat.dart';
import 'package:acumulapp/models/image_upload.dart';
import 'package:acumulapp/models/pagination_data.dart';
import 'package:acumulapp/services/business_service.dart';

class BusinessProvider {
  BusinessService businessService = BusinessService();

  BusinessProvider();

  Future<PaginationData?> all(
    String? name,
    int? category,
    int page,
    int size,
  ) async {
    List<Business> business = [];
    PaginationData? paginationData;
    try {
      final response = await businessService.all(name, category, page, size);

      if (response.statusCode != 200) {
        log(response.body);
        return null;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      log(jsonData.toString());
      for (var element in jsonData['data']) {
        business.add(Business.fromJson(element));
      }
      paginationData = PaginationData(
        business,
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

  Future<Business?> get(int id) async {
    Business? business;
    try {
      final response = await businessService.getById(id);

      if (response.statusCode != 200) return business;

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      log(jsonData.toString());
      business = Business.fromJson(jsonData);
    } catch (e) {
      log(e.toString());
    }
    return business;
  }

  Future<bool> updateLinks(Business business, List<Link> links) async {
    try {
      final response = await businessService.updateLinks(business, links);
      final body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      if (response.statusCode != 200) {
        log(
          "Error HTTP al actualizar links: ${response.statusCode} - ${response.body}",
        );
        final message = jsonData['message'];
        throw Exception(message);
      }
      return true;
    } catch (e) {
      log("Excepción en updateLinks: $e");
      rethrow;
    }
  }

  Future<BusinessStat?> getBusinessStats(int id) async {
    BusinessStat? businessStats;
    try {
      final response = await businessService.cardsStats(id);

      if (response.statusCode != 200) return businessStats;

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      businessStats = BusinessStat.fromJson(jsonData);
      log(businessStats.cardStats.toString());
    } catch (e) {
      log(e.toString());
    }
    return businessStats;
  }

  Future<ImageUpload?> uploadImage(File image) async {
    ImageUpload? imageUpload;
    try {
      final response = await businessService.uploadImage(image);

      if (response.statusCode != 200) {
        log(response.body.toString());
        return imageUpload;
      }

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      imageUpload = ImageUpload.fromJson(jsonData);
      log(imageUpload.toString());
    } catch (e) {
      log(e.toString());
    }
    return imageUpload;
  }

  Future<Business?> update(Business business) async {
    try {
      final response = await businessService.updateBusiness(business);

      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        return Business.fromJson(jsonData);
      } else {
        log('Error al actualizar negocio: ${response.body}');
        return null;
      }
    } catch (e) {
      log('Excepción en update(): $e');
      return null;
    }
  }
  
  Future<List<Business>> getFavorites(int idUser) async {
    try {
      final response = await businessService.getFavorites(idUser);
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        
        List<Business> favorites = [];
        
        for (var element in jsonData) {
          favorites.add(Business.fromJson(element));
        }
        return favorites;
      } else {
        log(response.body);
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> updateFavorite(int idBusiness) async {
    try {
      final response = await businessService.updateFavorite(idBusiness);

      if (response.statusCode == 200) {
        return true;
      } else {
        log('Error al poner como favorito el negocio: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Excepción en update(): $e');
      return false;
    }
  }

  Future<bool> updateCategories(Business business) async {
    try {
      final response = await businessService.updateCategories(business);

      if (response.statusCode != 200) {
        log(
          "Error HTTP al actualizar categorías: ${response.statusCode} - ${response.body}",
        );
        return false;
      }

      final Map<String, dynamic> jsonData = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (jsonData['message'] == 'Categorías actualizadas exitosamente.') {
        return true;
      } else {
        log("Mensaje inesperado del servidor: ${jsonData['message']}");
        return false;
      }
    } catch (e) {
      log("Excepción en updateCategories: $e");
      return false;
    }
  }
}
