import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScreen extends StatefulWidget {
  final String code;
  final String text;

  const QrCodeScreen({super.key, required this.code, required this.text});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Código QR")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 39.0),
              child: Text(widget.text, style: TextStyle(fontSize: 19)),
            ),
            QrImageView(
              data: widget.code,
              version: QrVersions.auto,
              size: 300.0,
            ),
            Text(widget.code, style: TextStyle(fontSize: 19)),
          ],
        ),
      ),
    );
  }
}
