import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/user.dart';

class Collaborator extends User {
  late List<Business> business;
  late List<String> roles;

  Collaborator(
    super.id,
    super.name,
    super.email,
    super.password,
    super.userType,
    List<dynamic>? collaboratorDetails,
  ) {
    roles = [];
    business = [];

    if (collaboratorDetails != null) {
      for (int i = 0; i < collaboratorDetails.length; i++) {
        roles.add(collaboratorDetails[i]['role']);
        business.add(
          Business(
            collaboratorDetails[i]['businessId'],
            collaboratorDetails[i]['businessName'],
          ),
        );
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': name,
      'email': email,
      'password': password,
      'userType': userType,
      'business': business,
    };
  }

  factory Collaborator.fromJson(Map<String, dynamic> json) {
    return Collaborator(
      json['id'] as int,
      json['fullName'] as String,
      json['email'] as String,
      '', //json['password'] as String,
      json['userType'] as String,
      json['collaboratorDetails'],
    );
  }
}
