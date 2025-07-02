class UbicationModel {
  int _id;
  String _name;

  UbicationModel(this._id, this._name);

  int get id => _id;
  set id(int value) => _id = value;

  String get name => _name;
  set name(String value) => _name = value;

  factory UbicationModel.fromJson(Map<String, dynamic> json) {
    return UbicationModel(
      json['id'] as int,
      json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
    };
  }
}
