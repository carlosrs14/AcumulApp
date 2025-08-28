import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/screens/business/customer_management/card_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InactiveCard extends StatelessWidget {
  final UserCard userCard;
  final Function onActivate;

  const InactiveCard({
    super.key,
    required this.userCard,
    required this.onActivate,
  });

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
      body: ElevatedButton.icon(
        icon: Icon(MdiIcons.check),
        label: Text("Activar"),
        iconAlignment: IconAlignment.end,
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
        onPressed: () => onActivate(),
      ),
    );
  }
}
