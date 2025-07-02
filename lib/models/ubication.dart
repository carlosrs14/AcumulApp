class Ubication {
  int _id;
  String _name;

  Ubication(this._id, this._name);

  int get id => _id;
  set id(int value) => _id = value;

  String get name => _name;
  set name(String value) => _name = value;

  factory Ubication.fromJson(Map<String, dynamic> json) {
    return Ubication(
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
