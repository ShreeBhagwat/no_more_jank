import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// =====================
/// GLOBAL UI JANK INJECTOR (per-frame busy-wait on UI thread)
/// =====================
class FrameJankInjector extends StatefulWidget {
  const FrameJankInjector({super.key, required this.milliseconds});
  final int milliseconds; // 0 = off
  @override
  State<FrameJankInjector> createState() => _FrameJankInjectorState();
}

class _FrameJankInjectorState extends State<FrameJankInjector>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      final ms = widget.milliseconds;
      if (ms <= 0) return;
      final sw = Stopwatch()..start();
      // Busy-wait to simulate synchronous UI-thread work (demo only!).
      while (sw.elapsedMilliseconds < ms) {
        // spin
      }
    });
    if (widget.milliseconds > 0) _ticker.start();
  }

  @override
  void didUpdateWidget(covariant FrameJankInjector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.milliseconds > 0 && !_ticker.isActive) _ticker.start();
    if (widget.milliseconds <= 0 && _ticker.isActive) _ticker.stop();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
