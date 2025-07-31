import 'dart:developer';

import 'package:acumulapp/models/user_card.dart';
import 'package:acumulapp/providers/user_card_provider.dart';
import 'package:acumulapp/utils/corner.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  final String funcionalidad;
  const QRScannerPage({super.key, required this.funcionalidad});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final UserCardProvider userCardProvider = UserCardProvider();
  bool _hasPermission = false;
  bool _isScanning = false;

  final TextEditingController stampTextEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    requestCameraPermission();
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Permiso de cámara denegado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.funcionalidad)),
      body: _hasPermission
          ? Stack(
              children: [
                MobileScanner(
                  onDetect: (BarcodeCapture capture) async {
                    if (_isScanning) return;

                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      final String? code = barcode.rawValue;
                      if (code != null) {
                        setState(() {
                          _isScanning = true;
                        });

                        // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('Código: $code')),
                        // );

                        if ("Activate Card" == widget.funcionalidad) {
                          await activateCard(code);
                        } else if ("Redeem Card" == widget.funcionalidad) {
                          await redeemCard(code);
                        } else if ("Add Stamps" == widget.funcionalidad) {
                          UserCard? userCard = await userCardProvider.getByCode(
                            code,
                          );
                          if (userCard != null) {
                            await addStampsDialog(
                              code,
                              userCard.businessCard!.maxStamp -
                                  userCard.currentStamps!,
                            );
                          }
                        } else {
                          Navigator.pop(context);
                          break;
                        }
                      }
                    }
                  },
                ),

                Center(
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: Stack(
                      children: [
                        Positioned(top: 0, left: 0, child: Corner()),

                        Positioned(top: 0, right: 0, child: Corner(rotate: 90)),

                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Corner(rotate: 270),
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Corner(rotate: 180),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Center(child: Text('Esperando permiso de cámara...')),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isScanning = false;
            });
          },
          child: Icon(MdiIcons.reload),
        ),
      ),
    );
  }

  Future<void> addStampsDialog(String code, int remainingStamps) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add stamps'),

        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sellos restantes $remainingStamps, ingresa la cantidad de sellos que vas a añadir',
              ),
              const SizedBox(height: 10),
              Form(key: _formKey, child: textFieldStamp(remainingStamps)),
            ],
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await addStamp(code, remainingStamps);
    }
  }

  Widget textFieldStamp(int remainingStamps) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextFormField(
        controller: stampTextEditingController,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          errorMaxLines: 2,
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Este campo es obligatorio';
          }
          final parsed = int.tryParse(value);
          if (parsed == null) {
            return 'Debe ser un número válido';
          } else if (parsed > remainingStamps) {
            return 'Debe ser menor o igual a los sellos restantes';
          }
          return null;
        },
      ),
    );
  }

  Future<void> addStamp(String code, int remainingStamps) async {
    final success = await userCardProvider.addStamp(
      code,
      int.parse(stampTextEditingController.text),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (success != null) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sellos agregados exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al agregar sellos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> activateCard(String code) async {
    final success = await userCardProvider.activateCard(code);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (success != null) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarjeta activada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al activar tarjeta'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> redeemCard(String code) async {
    final success = await userCardProvider.redeemCard(code);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (success != null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarjeta redimida exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al redimir tarjeta'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
