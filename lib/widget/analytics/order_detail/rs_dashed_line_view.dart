import 'package:flutter/material.dart';

enum RSLineType {
  /// 虚线
  dashedLine,

  /// 直线
  solidLine,
}

class RSCustomLineView extends StatelessWidget {
  const RSCustomLineView({super.key, required this.lineColor, required this.height, required this.lineType});

  final Color lineColor;
  final double height;
  final RSLineType lineType;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: RSCustomLinePainter(lineColor, height, lineType),
    );
  }
}

class RSCustomLinePainter extends CustomPainter {
  final Color lineColor;
  final double height;
  final RSLineType lineType;

  RSCustomLinePainter(this.lineColor, this.height, this.lineType);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = height
      ..style = PaintingStyle.stroke;
    // ..strokeCap = StrokeCap.square
    // ..strokeJoin = StrokeJoin.bevel;

    if (lineType == RSLineType.dashedLine) {
      double dashWidth = 4;
      double dashSpace = 3;
      double startX = 0;
      double endX = 0;
      while (startX < size.width) {
        endX = startX + dashWidth;
        canvas.drawLine(Offset(startX, (size.height - height) / 2), Offset(endX, (size.height - height) / 2), paint);
        startX = endX + dashSpace;
      }
    } else {
      canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
