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
    this._date,
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
}
