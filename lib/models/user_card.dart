import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/models/client.dart';

class UserCard {
  int id;
  int idClient;
  int businessCard;
  String? state;
  int? currentStamps;
  String? code;
  DateTime? date;

  UserCard(
    this.id,
    this.idClient,
    this.businessCard, {
      this.state,
      this.currentStamps,
      this.code,
      this.date
    }
  );

    // fromJson: convierte campo "date" de string ISO 8601 a DateTime
  factory UserCard.fromJson(Map<String, dynamic> json) {
    // Puede ser que json['date'] sea null o distinto formato; aquí asumo ISO 8601 String
    String dateStr = json['expirationDate'] as String;
    DateTime parsedDate = DateTime.parse(dateStr);
    return UserCard(
      json['id'] as int,
      json['idClient'],
      json['idCard'],
      currentStamps: json['currentStamps']
    );
  }

  // toJson: convierte DateTime a String ISO 8601
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currentStamps': currentStamps,
      'code': code,
      'state': state,
      'date': date!.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonCreate() {
    return {
      'idClient': idClient,
      'idCard': businessCard,
      'maxStamp': businessCard
    };
  }
}
