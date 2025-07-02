class Card {
  int _id;
  int _totalStamps;
  String _name;
  String _bounty;
  String _restrictions;
  
  Card(
    this._id,
    this._totalStamps,
    this._name,
    this._bounty,
    this._restrictions
  );

  int get id => _id;
  set id(int value) => _id = value;

  int get totalStamps => _totalStamps;
  set totalStamps(int value) => _totalStamps = value;
  
  String get name => _name;
  set name(String value) => _name = value;
  
  String get bounty => _bounty;
  set bounty(String value) => _bounty = value;

  String get restrictions => _restrictions;
  set restrictions(String value) => _restrictions = value;
}