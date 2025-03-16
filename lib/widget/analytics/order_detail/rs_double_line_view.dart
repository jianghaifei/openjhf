import 'package:flutter/material.dart';

class RSDoubleLineView extends StatelessWidget {
  const RSDoubleLineView({super.key, required this.lineColor});

  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 10),
      painter: RSDoubleLinePainter(lineColor),
    );
  }
}

class RSDoubleLinePainter extends CustomPainter {
  final Color lineColor;

  RSDoubleLinePainter(this.lineColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    double topLineY = size.height / 3;
    double bottomLineY = size.height * 2 / 3;

    canvas.drawLine(Offset(0, topLineY), Offset(size.width, topLineY), linePaint);
    canvas.drawLine(Offset(0, bottomLineY), Offset(size.width, bottomLineY), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
