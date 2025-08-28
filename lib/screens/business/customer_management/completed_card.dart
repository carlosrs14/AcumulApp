import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/screens/business/customer_management/card_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CompletedCard extends StatelessWidget {
  final UserCard userCard;
  final Function onRedeem;

  const CompletedCard({
    super.key,
    required this.userCard,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    return CardScaffold(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(userCard.code ?? ''),
          const SizedBox(height: 4),
          Text(
            'Sellos: ${userCard.currentStamps}/${userCard.businessCard!.maxStamp}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            'Restictions: ${userCard.businessCard!.restrictions}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
      body: ElevatedButton.icon(
        icon: Icon(MdiIcons.check),
        label: Text("Redimir"),
        iconAlignment: IconAlignment.end,
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
        onPressed: () => onRedeem(),
      ),
    );
  }
}
