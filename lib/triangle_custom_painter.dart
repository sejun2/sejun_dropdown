import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TriangleCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    Path trianglePath = Path();
    trianglePath.moveTo(30, 0);
    trianglePath.lineTo(23, 10);
    trianglePath.lineTo(37, 10);
    trianglePath.lineTo(30, 0);

    Paint trianglePaint = Paint();
    trianglePaint.color = Colors.white;
    trianglePaint.style = PaintingStyle.fill;
    canvas.drawPath(trianglePath, trianglePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
