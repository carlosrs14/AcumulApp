import 'package:flutter/material.dart';

class Corner extends StatelessWidget {
  final double rotate;
  const Corner({this.rotate = 0});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotate * 3.1416 / 180, // grados a radianes
      child: SizedBox(
        width: 30,
        height: 30,
        child: CustomPaint(painter: CornerPainter()),
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height * 2.0)
      ..lineTo(0, 0)
      ..lineTo(size.width * 2.0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
