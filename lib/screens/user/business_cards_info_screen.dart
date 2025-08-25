import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/card.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/providers/user_card_provider.dart';
import 'package:acumulapp/screens/user/qr_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BusinessInfoCards extends StatefulWidget {
  final Business business;
  final BusinessCard businessCard;
  final UserCard? userCard;
  final User user;

  const BusinessInfoCards({
    super.key,
    required this.business,
    required this.user,
    required this.userCard,
    required this.businessCard,
  });

  @override
  State<BusinessInfoCards> createState() => _BusinessInfoCardsState();
}

class _BusinessInfoCardsState extends State<BusinessInfoCards> {
  UserCardProvider userCardProvider = UserCardProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    final businessCard = widget.businessCard;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
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
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
            Text(businessCard.name, style: TextStyle(fontSize: 18)),
            Divider(height: 30, thickness: 1.5),

            infoTile(
              MdiIcons.calendarClock,
              "Expiracion:",
              "${businessCard.expiration}",
            ),
            infoTile(
              MdiIcons.starCircle,
              "Sellos maximos:",
              "${businessCard.maxStamp}",
            ),
            infoTile(MdiIcons.gift, "Recompensa:", businessCard.reward),
            infoTile(
              MdiIcons.alertCircleOutline,
              "Restricciones:",
              businessCard.restrictions,
            ),
            ?widget.userCard == null
                ? null
                : infoTile(
                    MdiIcons.starCircleOutline,
                    "Sellos actuales:",
                    "${widget.userCard!.currentStamps}",
                  ),
            SizedBox(height: 10),
            Text(
              businessCard.description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 30),
            ?widget.userCard != null ? null : addCardButton(),
          ],
        ),
      ),
    );
  }

  Widget infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget addCardButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        UserCard? userCard = await userCardProvider.create(
          UserCard(0, widget.user.id, widget.businessCard.id),
        );
        if (!mounted) return;
        if (userCard != null && userCard.code != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => QrCodeScreen(
                code: userCard.code!,
                text:
                    "Presenta este QR al negocio para que te activen tu tarjeta",
              ),
            ),
          );
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Tarjeta creada exitosamente',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.greenAccent,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '"Alancazaste la cantidad maxima de tarjetas"',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      icon: Icon(MdiIcons.cardsOutline),
      iconAlignment: IconAlignment.end,
      label: Text("Add Card"),
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: TextStyle(fontSize: 16),
        elevation: 4,
      ),
    );
  }
}
