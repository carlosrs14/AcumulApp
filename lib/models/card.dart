class Card {
  int _id;
  int _idBusiness;
  int _expiration;
  int _maxStamp;
  String _description;
  
  Card(
    this._id,
    this._idBusiness,
    this._expiration,
    this._maxStamp,
    this._description
  );

  int get id => _id;
  set id(int value) => _id = value;

  int get idBusiness => _idBusiness;
  set idBusiness(int value) => _idBusiness = value;
  
  int get expiration => _expiration;
  set expiration(int value) => _expiration = value;
  
  int get maxStamp => _maxStamp;
  set maxStamp(int value) => _maxStamp = value;

  String get description => _description;
  set description(String value) => _description = value;

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      json['id'] as int,
      json['idBusiness'] as int,
      json['expiration'] as int,
      json['maxStamp'] as int,
      json['description'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "idBusiness": _idBusiness,
      "expiration": _expiration,
      "maxStamp": _maxStamp,
      "description": _description
    };
  }
}