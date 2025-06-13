import 'package:acumulapp/models/CategoryModel.dart';
import 'package:acumulapp/models/LinkModel.dart';
import 'package:acumulapp/models/UbicationModel.dart';
import 'package:flutter/foundation.dart';

class BusinessModel {
  int _id;
  String _name;
  String _direction;
  String _logoUrl;
  List<LinkModel> _links;
  UbicationModel? _ubication;
  List<CategoryModel> _categories;
  double _rating;

  BusinessModel(
    this._id,
    this._name,
    this._direction,
    this._logoUrl,
    this._links,
    this._ubication,
    this._categories,
    this._rating,
  );

  int get id => _id;
  set id(int value) => _id = value;

  String get name => _name;
  set name(String value) => _name = value;

  String get direction => _direction;
  set direction(String value) => _direction = value;

  String get logoUrl => _logoUrl;
  set logoUrl(String value) => _logoUrl = value;

  List<LinkModel> get links => _links;
  set links(List<LinkModel> value) => _links = value;

  UbicationModel? get ubication => _ubication;
  set ubication(UbicationModel? value) => _ubication = value;

  List<CategoryModel> get categories => _categories;
  set categories(List<CategoryModel> value) => _categories = value;

  double get rating => _rating;
  set rating(double value) => _rating = value;

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    List<LinkModel> linksList = [];
    if (json['links'] != null) {
      final l = json['links'] as List;
      linksList = l
          .map((item) => LinkModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    UbicationModel? ubication;
    if (json.containsKey('ubication') && json['ubication'] != null) {
      ubication = UbicationModel.fromJson(
        json['ubication'] as Map<String, dynamic>,
      );
    }

    List<CategoryModel> categoriesList = [];
    if (json['categories'] != null) {
      final l = json['categories'] as List;
      linksList = l
          .map((item) => LinkModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return BusinessModel(
      json['id'] as int,
      json['name'] as String,
      json['direction'] as String,
      json['logoUrl'] as String,
      linksList,
      ubication,
      categoriesList,
      (json['rating'] ?? 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'direction': _direction,
      'logoUrl': _logoUrl,
      'links': _links.map((link) => link.toJson()).toList(),
      // Solo incluyo ubication si no es null
      if (_ubication != null) 'ubication': _ubication!.toJson(),
      'categories': _categories.map((category) => category.toJson()).toList(),
      'rating': _rating,
    };
  }
}
