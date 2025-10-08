import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class LeanPainter extends CustomPainter {
  LeanPainter(this.ticker);
  final double ticker;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()..shader = ui.Gradient.linear(rect.topLeft, rect.bottomRight, [Colors.indigo, Colors.cyan]);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(24)), paint);
  }
  @override
  bool shouldRepaint(covariant LeanPainter old) => old.ticker != ticker;
}