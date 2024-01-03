import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;

  LinePainter(this.startPoint, this.endPoint);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;
    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
