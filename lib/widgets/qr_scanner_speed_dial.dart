import 'package:acumulapp/screens/qr_scaneer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class QrScannerSpeedDial extends StatelessWidget {
  const QrScannerSpeedDial({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      direction: SpeedDialDirection.up,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.primary,
      icon: MdiIcons.qrcodeScan,
      children: [
        SpeedDialChild(
          child: Icon(MdiIcons.stamper),
          label: 'Add Stamps',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    const QRScannerPage(funcionalidad: "Add Stamps"),
              ),
            );
          },
        ),
        SpeedDialChild(
          child: Icon(MdiIcons.walletGiftcard),
          label: 'Redeem Card',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    const QRScannerPage(funcionalidad: "Redeem Card"),
              ),
            );
          },
        ),
        SpeedDialChild(
          child: Icon(MdiIcons.toggleSwitch),
          label: 'Activate Card',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    const QRScannerPage(funcionalidad: "Activate Card"),
              ),
            );
          },
        ),
      ],
    );
  }
}
