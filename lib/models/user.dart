import 'package:acumulapp/models/client.dart';
import 'package:acumulapp/models/collaborator.dart';

abstract class User {
  int id;
  String name;
  String email;
  String password;
  String userType;

  User(this.id, this.name, this.email, this.password, this.userType);

  Map<String, dynamic> toJson();
}

User userFactory(Map<String, dynamic> json) {
  switch (json['userType'] as String) {
    case 'collaborator':
      return Collaborator.fromJson(json);
    case 'client':
      return Client.fromJson(json);       
    default:
      throw Exception('Unknown user type');
  }
}