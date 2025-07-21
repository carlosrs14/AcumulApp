class User {
  int _id;
  String _name;
  String _email;
  String _password;
  String _role;

  User(this._id, this._name, this._email, this._password, this._role);

  int get id => _id;
  set id(int value) => _id = value;

  String get name => _name;
  set name(String value) => _name = value;

  String get email => _email;
  set email(String value) => _email = value;

  String get password => _password;
  set password(String value) => _password = value;

  String get role => _role;
  set role(String value) => _role = value;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'] as int,
      json['fullName'] as String,
      json['email'] as String,
      "",
      json['userType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'fullName': _name, 'email': _email, 'password': _password, 'userType': _role};
  }
}
