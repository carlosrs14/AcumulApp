import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/screens/qrScaneer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BusinessHomeScreen extends StatefulWidget {
  final int indexSelected;
  final Collaborator user;
  const BusinessHomeScreen({
    super.key,
    required this.user,
    required this.indexSelected,
  });

  @override
  State<BusinessHomeScreen> createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Bienvenido al Panel de Negocio')),
      floatingActionButton: SpeedDial(
        direction: SpeedDialDirection.up,
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: MdiIcons.qrcodeScan,
        children: [
          SpeedDialChild(
            child: Icon(MdiIcons.stamper),
            label: 'Add Stamps',
            labelStyle: TextStyle(fontSize: 12),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => QRScannerPage(funcionalidad: "Add Stamps"),
                ),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(MdiIcons.walletGiftcard),
            label: 'Redeem Card',
            labelStyle: TextStyle(fontSize: 12),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => QRScannerPage(funcionalidad: "Redeem Card"),
                ),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(MdiIcons.toggleSwitch),
            label: 'Activate Card',
            labelStyle: TextStyle(fontSize: 12),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => QRScannerPage(funcionalidad: "Activate Card"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
