import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/screens/business/customer_management/card_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ExpiredCard extends StatelessWidget {
  final UserCard userCard;

  const ExpiredCard({super.key, required this.userCard});

  @override
  Widget build(BuildContext context) {
    return CardScaffold(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(userCard.code ?? ''),
          const SizedBox(height: 4),
        ],
      ),
      body: ElevatedButton(
        onPressed: null,
        child: Icon(MdiIcons.alert),
      ),
    );
  }
}
