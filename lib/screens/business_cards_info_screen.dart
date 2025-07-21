import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BusinessInfoCards extends StatefulWidget {
  final Business business;
  final BusinessCard businessCard;
  final User user;

  const BusinessInfoCards({
    super.key,
    required this.business,
    required this.user,
    required this.businessCard,
  });

  @override
  State<BusinessInfoCards> createState() => _BusinessInfoCardsState();
}

class _BusinessInfoCardsState extends State<BusinessInfoCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: buildCardContent(),
          ),
        ),
      ),
    );
  }

  Widget buildCardContent() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.deepPurple.shade300, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.business.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
            Text(
              "Loyalty Card",
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            Divider(height: 30, thickness: 1.5),

            infoTile("Expires on:", "${widget.businessCard.expiration}"),
            infoTile("Stamps required:", "${widget.businessCard.maxStamp}"),
            infoTile("Reward:", widget.businessCard.reward),
            infoTile("Restrictions:", widget.businessCard.restrictions),
            SizedBox(height: 10),
            Text(
              widget.businessCard.description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),

            SizedBox(height: 30),
            addCardButton(),
          ],
        ),
      ),
    );
  }

  Widget infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.purple),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget addCardButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(MdiIcons.cardsOutline),
      label: Text("Add Card"),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: TextStyle(fontSize: 16),
        elevation: 4,
      ),
    );
  }
}
