import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/models/client.dart';

class UserCard {
  int id;
  int idClient;
  int idBusinessCard;
  String? state;
  int? currentStamps;
  String? code;
  DateTime? date;
  BusinessCard? businessCard;

  UserCard(
    this.id,
    this.idClient,
    this.idBusinessCard, {
    this.state,
    this.currentStamps,
    this.code,
    this.date,
    this.businessCard,
  });

  // fromJson: convierte campo "date" de string ISO 8601 a DateTime
  factory UserCard.fromJson(Map<String, dynamic> json) {
    // Puede ser que json['date'] sea null o distinto formato; aquí asumo ISO 8601 String
    String dateStr = json['expirationDate'] as String;
    DateTime parsedDate = DateTime.parse(dateStr);
    return UserCard(
      json['id'] as int,
      json['idClient'] as int,
      json['idCard'] as int,
      state: json['cardState']?['name'],
      currentStamps: json['currentStamps'] as int?,
      code: json['uniqueCode'] as String?,
      date: json['expirationDate'] != null
          ? DateTime.tryParse(json['expirationDate'])
          : null,
      businessCard: json['card'] != null
          ? BusinessCard.fromJson(json['card'])
          : null,
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
    return {'idClient': idClient, 'idCard': idBusinessCard};
  }
}
