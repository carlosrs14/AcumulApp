import 'package:acumulapp/models/category.dart';
import 'package:acumulapp/models/link.dart';

class Business {
  int id;
  String name;
  String? email;
  String? direction;
  String? logoIconoUrl;
  String? logoBannerImage;
  String? descripcion;
  int? ratingCount;
  double? ratingAverage;
  String? createdAt;
  List<Link>? links;
  List<Category>? categories;

  Business(
    this.id,
    this.name, {
    this.email,
    this.direction,
    this.logoIconoUrl,
    this.logoBannerImage,
    this.descripcion,
    this.ratingAverage,
    this.ratingCount,
    this.createdAt,
    this.links,
    this.categories,
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

    if (json['categories'] != null) {
      final l = json['categories'] as List;
      categoryList = l
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    double ratinggAverage;
    if (json['rating_average'] == 0 || json['rating_average'] == null) {
      ratinggAverage = 0.0;
    } else {
      ratinggAverage = (json['rating_average'] as num).toDouble();
    }

    Business business = Business(
      json['id'] as int,
      json['name'] as String,
      email: json['email'] as String?,
      direction: json['address'] as String?,
      logoIconoUrl: json['logoImage'] as String?,
      logoBannerImage: json['bannerImage'] as String?,
      links: linksList,
      descripcion: json['description'] as String?,
      createdAt: json['createdAt'] as String?,
      categories: categoryList,
      ratingAverage: ratinggAverage,
    );

    return business;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'direction': direction,
      'logoUrl': logoIconoUrl,
      'links': links!.map((link) => link.toJson()).toList(),

      'categories': categories!.map((category) => category.toJson()).toList(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'email': email,
      'description': descripcion,
      'logoImage': logoIconoUrl,
      'bannerImage': logoBannerImage,
      'address': direction,
      'categories': categories?.map((c) => c.id).toList() ?? [],
      'links':
          links?.map((l) => {"value": l.url, "name": l.redSocial}).toList() ??
          [],
    };
  }
}
