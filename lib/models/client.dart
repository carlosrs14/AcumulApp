import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/models/user_card.dart';

class Client extends User {
  late List<UserCard> cards;

  Client(super.id, super.name, super.email, super.password, super.userType) {
    cards = [];
  }

  @override
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'fullName': name};
  }

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      json['id'] as int,
      json['fullName'] as String,
      json['email'] as String,
      '', //json['password'] as String,
      json['userType'] as String,
    );
  }
}
