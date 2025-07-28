import 'package:acumulapp/models/category.dart';
import 'package:acumulapp/models/link.dart';
import 'package:acumulapp/models/ubication.dart';

class Business {
  int id;
  String name;
  String? email;
  String? direction;
  String? logoUrl;
  List<Link>? links;
  Ubication? ubication;
  List<Category>? categories;
  double? rating;

  Business(
    this.id,
    this.name, {
    this.email,
    this.direction,
    this.logoUrl,
    this.links,
    this.ubication,
    this.categories,
    this.rating,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    List<Link> linksList = [];
    List<Category> categoryList = [];
    if (json['links'] != null) {
      final l = json['links'] as List;
      linksList = l
          .map((item) => Link.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    Ubication? ubication;
    if (json.containsKey('ubication') && json['ubication'] != null) {
      ubication = Ubication.fromJson(json['ubication'] as Map<String, dynamic>);
    }

    if (json['categories'] != null) {
      final l = json['categories'] as List;
      categoryList = l
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return Business(
      json['id'] as int,
      json['name'] as String,
      email: json['email'] as String,
      direction: json['address'] as String,
      logoUrl: json['logoImage'] as String,
      links: linksList,
      ubication: ubication,
      categories: categoryList,
      rating: (json['rating'] ?? 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'direction': direction,
      'logoUrl': logoUrl,
      'links': links!.map((link) => link.toJson()).toList(),
      'ubication': ubication!.toJson(),
      'categories': categories!.map((category) => category.toJson()).toList(),
      'rating': rating,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'email': email,
      'idLocation': ubication?.id,
      'logoImage': logoUrl,
      'address': direction,
      'categories': categories?.map((c) => c.id).toList() ?? [],
    };
  }
}
