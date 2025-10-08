// Anywhere you want a subtle Matrix feel behind content:
import 'package:flutter/material.dart';
import 'package:no_more_jank/theme/app_theme.dart';

class MatrixCodeBackdrop extends StatelessWidget {
  const MatrixCodeBackdrop({
    super.key,
    required this.child,
    this.showBg = true,
  });
  final Widget child;
  final bool showBg;
  @override
  Widget build(BuildContext context) {
    final mx = context.mx;
    return Stack(
      children: [
        if (showBg)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: mx.codeRainGradient),
            ),
          ),
        child,
      ],
    );
  }
}
