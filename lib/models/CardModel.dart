class CardModel {
  int _id;
  int _currentStamps;
  int _totalStamps;
  String _code;
  String _name;
  String _bounty;
  String _restrictions;
  String _state;
  DateTime _date;

  CardModel(
    this._id,
    this._currentStamps,
    this._totalStamps,
    this._code,
    this._name,
    this._bounty,
    this._restrictions,
    this._state,
    this._date
  );

  int get id => _id;
  set id(int value) => _id = value;

  int get currentStamps => _currentStamps;
  set currentStamps(int value) => _currentStamps = value;
  

  int get totalStamps => _totalStamps;
  set totalStamps(int value) => _totalStamps = value;

  String get code => _code;
  set code(String value) => _code = value;

  String get name => _name;
  set name(String value) => _name = value;

  String get bounty => _bounty;
  set bounty(String value) => _bounty = value;

  String get restrictions => _restrictions;
  set restrictions(String value) => _restrictions = value;

  String get state => _state;
  set state(String value) => _state = value;

  DateTime get date => _date;
  set date(DateTime value) => _date = value;
    // fromJson: convierte campo "date" de string ISO 8601 a DateTime
  factory CardModel.fromJson(Map<String, dynamic> json) {
    // Puede ser que json['date'] sea null o distinto formato; aquí asumo ISO 8601 String
    String dateStr = json['date'] as String;
    DateTime parsedDate = DateTime.parse(dateStr);
    return CardModel(
      json['id'] as int,
      json['currentStamps'] as int,
      json['totalStamps'] as int,
      json['code'] as String,
      json['name'] as String,
      json['bounty'] as String,
      json['restrictions'] as String,
      json['state'] as String,
      parsedDate
    );
  }

  // toJson: convierte DateTime a String ISO 8601
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'currentStamps': _currentStamps,
      'totalStamps': _totalStamps,
      'code': _code,
      'name': _name,
      'bounty': _bounty,
      'restrictions': _restrictions,
      'state': _state,
      'date': _date.toIso8601String(),
    };
  }
}
