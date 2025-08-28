import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/screens/business/customer_management/card_scaffold.dart';
import 'package:flutter/material.dart';

class RedeemedCard extends StatelessWidget {
  final UserCard userCard;

  const RedeemedCard({super.key, required this.userCard});

  @override
  Widget build(BuildContext context) {
    return CardScaffold(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(userCard.businessCard!.name),
          const SizedBox(height: 4),
          Text(
            "Esta tarjeta a sido redimida",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
