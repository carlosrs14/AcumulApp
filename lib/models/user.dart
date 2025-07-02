class User {
  int _id;
  String _name;
  String _email;
  String _password;

  User(this._id, this._name, this._email, this._password);

  int get id => _id;
  set id(int value) => _id = value;

  String get name => _name;
  set name(String value) => _name = value;

  String get email => _email;
  set email(String value) => _email = value;

  String get password => _password;
  set password(String value) => _password = value;

  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'] as int,
      json['name'] as String,
      json['email'] as String,
      json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'email': _email,
      'password': _password,
    };
  }
}
