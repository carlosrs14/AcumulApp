import 'package:acumulapp/models/category.dart';
import 'package:acumulapp/models/link.dart';
import 'package:acumulapp/models/ubication.dart';

class Business {
  int _id;
  String _name;
  String _direction;
  String _logoUrl;
  List<Link> _links;
  Ubication? _ubication;
  List<Category> _categories;
  double _rating;

  Business(
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

  List<Link> get links => _links;
  set links(List<Link> value) => _links = value;

  Ubication? get ubication => _ubication;
  set ubication(Ubication? value) => _ubication = value;

  List<Category> get categories => _categories;
  set categories(List<Category> value) => _categories = value;

  double get rating => _rating;
  set rating(double value) => _rating = value;

  factory Business.fromJson(Map<String, dynamic> json) {
    List<Link> linksList = [];
    if (json['links'] != null) {
      final l = json['links'] as List;
      linksList = l
          .map((item) => Link.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    Ubication? ubication;
    if (json.containsKey('ubication') && json['ubication'] != null) {
      ubication = Ubication.fromJson(
        json['ubication'] as Map<String, dynamic>,
      );
    }

    List<Category> categoriesList = [];
    if (json['categories'] != null) {
      final l = json['categories'] as List;
      linksList = l
          .map((item) => Link.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return Business(
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
