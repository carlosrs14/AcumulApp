class BusinessCard {
  int _id;
  int _idBusiness;
  int _expiration;
  int _maxStamp;
  String _description;
  String _restrictions;
  String _reward;

  BusinessCard(
    this._id,
    this._idBusiness,
    this._expiration,
    this._maxStamp,
    this._description,
    this._restrictions,
    this._reward,
  );

  int get id => _id;
  set id(int value) => _id = value;

  int get idBusiness => _idBusiness;
  set idBusiness(int value) => _idBusiness = value;

  int get expiration => _expiration;
  set expiration(int value) => _expiration = value;

  int get maxStamp => _maxStamp;
  set maxStamp(int value) => _maxStamp = value;

  String get restrictions => _restrictions;
  set restrictions(String value) => _restrictions = value;

  String get reward => _reward;
  set reward(String value) => _reward = value;

  String get description => _description;
  set description(String value) => _description = value;

  factory BusinessCard.fromJson(Map<String, dynamic> json) {
    return BusinessCard(
      json['id'] as int,
      json['idBusiness'] as int,
      json['expiration'] as int,
      json['maxStamp'] as int,
      json['description'] as String,
      json['restrictions'] as String,
      json['reward'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "idBusiness": _idBusiness,
      "expiration": _expiration,
      "maxStamp": _maxStamp,
      "description": _description,
      "restrictions": _restrictions,
      "reward": _reward,
    };
  }
}
