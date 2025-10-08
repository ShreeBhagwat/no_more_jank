
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_more_jank/presentation/widgets/banner_widget.dart';
import 'package:no_more_jank/presentation/widgets/heavy_card.dart';
import 'package:no_more_jank/presentation/widgets/lean_card.dart';
import 'package:no_more_jank/provider/jank_mode_provider.dart';

/// =====================
///  LAYOUT SHOWCASE TAB – for Repaint Rainbow demo
/// =====================
class LayoutShowcaseTab extends ConsumerWidget {
  const LayoutShowcaseTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isJank = ref.watch(jankModeProvider);
    return Column(children: [
      BannerWidget(
        title: 'Layout & Paint Showcase',
        bullets: isJank
            ? const ['Nested ClipRRect + Opacity + big shadows', 'Deep trees in list items → overdraw', 'No isolation of static parts']
            : const ['Reduce clips/shadows in hot paths', 'Use RepaintBoundary for static subtrees', 'Prefer Animated/FadeTransition over Opacity'],
      ),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: 200,
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: isJank ? const HeavyCard() : const RepaintBoundary(child: LeanCard()),
          ),
        ),
      ),
    ]);
  }
}
