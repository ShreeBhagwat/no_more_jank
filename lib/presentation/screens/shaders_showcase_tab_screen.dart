import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_more_jank/presentation/widgets/banner_widget.dart';
import 'package:no_more_jank/presentation/widgets/janky_painter.dart';
import 'package:no_more_jank/presentation/widgets/lean_painter.dart';
import 'package:no_more_jank/provider/jank_mode_provider.dart';

/// =====================
///  SHADER SHOWCASE TAB – first-run hitch vs lean
/// =====================
class ShaderShowcaseTab extends ConsumerStatefulWidget {
  const ShaderShowcaseTab({super.key});
  @override
  ConsumerState<ShaderShowcaseTab> createState() => _ShaderShowcaseTabState();
}

class _ShaderShowcaseTabState extends ConsumerState<ShaderShowcaseTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isJank = ref.watch(jankModeProvider);
    return Column(
      children: [
        BannerWidget(
          title: 'Shader Compilation',
          bullets: isJank
              ? const [
                  'Complex animated gradient + blur',
                  'First-run hitch in profile mode',
                  'No SkSL precompile',
                ]
              : const [
                  'Capture SkSL & bundle',
                  'Warm-up draws on splash',
                  'Reduce shader complexity early',
                ],
        ),
        Expanded(
          child: Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) => CustomPaint(
                size: const Size(280, 280),
                painter: isJank
                    ? JankyPainter(_animationController.value)
                    : LeanPainter(_animationController.value),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Run in PROFILE. Use: flutter run --profile --cache-sksl (press M to dump JSON).',
          ),
        ),
      ],
    );
  }
}
