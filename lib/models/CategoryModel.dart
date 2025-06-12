class CategoryModel {
  int _id;
  String _name;
  String _description;

  CategoryModel(this._id, this._name, this._description);

  int get id => _id;
  set id(int value) => _id = value;

  String get name => _name;
  set name(String value) => _name = value;

  String get description => _description;
  set description(String value) => _description = value;
}
