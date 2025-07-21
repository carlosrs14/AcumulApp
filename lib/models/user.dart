class User {
  int _id;
  String _name;
  String _email;
  String _password;
  String _role;
  int? _idBusiness;

  User(this._id, this._name, this._email, this._password, this._role);

  int get id => _id;
  set id(int value) => _id = value;

  int? get idBusiness => _idBusiness;
  set idBusiness(int? value) => _idBusiness = value;

  String get name => _name;
  set name(String value) => _name = value;

  String get email => _email;
  set email(String value) => _email = value;

  String get password => _password;
  set password(String value) => _password = value;

  String get role => _role;
  set role(String value) => _role = value;

  factory User.fromJson(Map<String, dynamic> json) {
    User user = User(
      json['id'] as int,
      json['fullName'] as String,
      json['email'] as String,
      "",
      json['userType'] as String,
    );
    user._idBusiness = json['collaboratorDetails'][0]['businessId'] as int;
    //log(json['collaboratorDetails']);
    //log(user._idBusiness.toString());
    return user;
  }

  Map<String, dynamic> toJson() {
    return {'fullName': _name, 'email': _email, 'password': _password, 'userType': _role};
  }
}
