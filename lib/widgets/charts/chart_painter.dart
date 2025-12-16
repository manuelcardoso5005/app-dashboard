import 'package:app/models/chart_data.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ChartPainter extends CustomPainter {
  final List<ChartData> data;

  ChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || data.length < 2) return;

    final paint1 = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paint2 = Paint()
      ..color = Colors.orange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path1 = Path();
    final path2 = Path();

    final maxValue = data.map((e) => max(e.value1, e.value2)).reduce(max);

    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y1 = size.height - (data[i].value1 / maxValue) * size.height;
      final y2 = size.height - (data[i].value2 / maxValue) * size.height;

      if (i == 0) {
        path1.moveTo(x, y1);
        path2.moveTo(x, y2);
      } else {
        path1.lineTo(x, y1);
        path2.lineTo(x, y2);
      }
    }

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant ChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
