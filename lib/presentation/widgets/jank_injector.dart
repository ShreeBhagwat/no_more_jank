import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Busy-waits N ms on the UI isolate *each frame* to simulate UI jank.
/// DEMO ONLY — never ship this.
class UiJankInjector extends StatefulWidget {
  const UiJankInjector({super.key, required this.stallMs});
  final int stallMs; // 0 = off

  @override
  State<UiJankInjector> createState() => _UiJankInjectorState();
}

class _UiJankInjectorState extends State<UiJankInjector>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      final n = widget.stallMs;
      if (n <= 0) return;
      final sw = Stopwatch()..start();
      // intentional busy-wait to block the UI thread
      while (sw.elapsedMilliseconds < n) {/* spin */}
    });
    // Do NOT start here — wait for didChangeDependencies (TickerMode safe).
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reconsider();
  }

  @override
  void didUpdateWidget(covariant UiJankInjector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stallMs != widget.stallMs) {
      _reconsider(); // value changed -> start/stop as needed
    }
  }

  void _reconsider() {
    final shouldRun = TickerMode.of(context) && widget.stallMs > 0;
    if (shouldRun && !_ticker.isActive) {
      _ticker.start();
    } else if (!shouldRun && _ticker.isActive) {
      _ticker.stop();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
