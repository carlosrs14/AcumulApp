import 'package:acumulapp/models/LinkModel.dart';
import 'package:acumulapp/models/UbicationModel.dart';

class BusinessModel {
  int _id;
  String _name;
  String _direction;
  String _logoUrl;
  List<LinkModel> _links;
  UbicationModel? _ubication;

  BusinessModel(
    this._id,
    this._name,
    this._direction,
    this._logoUrl,
    this._links,
    this._ubication
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

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    List<LinkModel> linksList = [];
    if (json['links'] != null) {
      final l = json['links'] as List;
      linksList = l.map((item) => LinkModel.fromJson(item as Map<String, dynamic>)).toList();
    }

    UbicationModel? ubication;
    if (json.containsKey('ubication') && json['ubication'] != null) {
      ubication = UbicationModel.fromJson(json['ubication'] as Map<String, dynamic>);
    }

    return BusinessModel(
      json['id'] as int,
      json['name'] as String,
      json['direction'] as String,
      json['logoUrl'] as String,
      linksList,
      ubication,
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
    };
  }
}
