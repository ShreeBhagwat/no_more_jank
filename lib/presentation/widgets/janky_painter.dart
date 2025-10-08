import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class JankyPainter extends CustomPainter {
  JankyPainter(this.ticker);
  final double ticker;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = ui.Gradient.radial(rect.center, size.shortestSide / 2, [Colors.deepPurple, Colors.pink, Colors.orange, Colors.yellow], [0, .4, .7, 1], TileMode.clamp, Matrix4.rotationZ(ticker * 2 * math.pi).storage);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(36)), paint);
    final blurPaint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawCircle(rect.center, 40, blurPaint);
  }
  @override
  bool shouldRepaint(covariant JankyPainter old) => old.ticker != ticker;
}