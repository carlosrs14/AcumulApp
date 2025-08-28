import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:acumulapp/screens/user/business_cards_info_screen.dart';
import 'package:acumulapp/screens/user/qr_code_screen.dart';
import 'package:acumulapp/widgets/stamp_container.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ClientCardItem extends StatelessWidget {
  final UserCard userCard;
  final User user;
  final int selectedState;

  const ClientCardItem({
    super.key,
    required this.userCard,
    required this.user,
    required this.selectedState,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final navigator = Navigator.of(context);
          Business? businessResponse = await BusinessProvider().get(
            userCard.idBusinessCard,
          );
          if (context.mounted) {
            if (businessResponse != null) {
              navigator.push(
                MaterialPageRoute(
                  builder: (_) => BusinessInfoCards(
                    business: businessResponse,
                    user: user,
                    businessCard: userCard.businessCard!,
                    userCard: userCard,
                  ),
                ),
              );
            }
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userCard.businessCard!.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 10),
                        StampContainer(
                          stamps: _stampsGenerator(
                            userCard.currentStamps!,
                            userCard.businessCard!.maxStamp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStampsInfo(context),
                ],
              ),
            ),
            _buildQrButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStampsInfo(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInfoRow(context, "Meta", "${userCard.businessCard!.maxStamp}", MdiIcons.starCircle),
            _buildInfoRow(context, "Actual", "${userCard.currentStamps}", MdiIcons.starCircle),
            _buildInfoRow(context, "Faltan", "${userCard.businessCard!.maxStamp - userCard.currentStamps!}", MdiIcons.starCircleOutline),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        SizedBox(width: 4),
        Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ],
    );
  }

  Widget _buildQrButton(BuildContext context) {
    switch (selectedState) {
      case 1:
        return _qrButton(
          context,
          true,
          "Presenta este QR en el negocio para recibir tus sellos.",
          "Añadir Sellos",
        );
      case 2:
        return _qrButton(
          context,
          true,
          "Presenta este QR en el negocio para recibir tu recompensa.",
          "Redimir",
        );
      case 3:
        return Container();
      case 4:
        return _qrButton(
          context,
          true,
          "Presenta este QR al negocio para que te activen tu tarjeta",
          "Activar",
        );
      case 5:
        return Container();
      default:
        return Container();
    }
  }

  Widget _qrButton(
    BuildContext context,
    bool show,
    String text,
    String buttonLabel,
  ) {
    if (!show) {
      return Container();
    }
    return ElevatedButton.icon(
      onPressed: () async {
        if (userCard.code != null) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => QrCodeScreen(code: userCard.code!, text: text),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error de conexión',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12),
          ),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      icon: Icon(MdiIcons.qrcode),
      iconAlignment: IconAlignment.end,
      label: Text(
        buttonLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }

  List<bool> _stampsGenerator(int current, int max) {
    List<bool> result = [];
    for (int i = 0; i < current; i++) {
      result.add(true);
    }
    for (int i = 0; i < max - current; i++) {
      result.add(false);
    }
    return result;
  }
}
