// lib/perf/fps_meter.dart
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Expose a controller so you can reset when a new screen becomes active.
class FpsMeterController extends ChangeNotifier {
  void reset() => notifyListeners();
}

class FpsOverlay extends StatefulWidget {
  const FpsOverlay({
    super.key,
    required this.controller,
    this.enabled = true,
    this.window = 90, // ~0.75s @120Hz, ~1.5s @60Hz
    this.monospaced = true,
  });

  final FpsMeterController controller;
  final bool enabled;
  final int window;
  final bool monospaced;

  @override
  State<FpsOverlay> createState() => _FpsOverlayState();
}

class _FpsOverlayState extends State<FpsOverlay> {
  final List<ui.FrameTiming> _buf = <ui.FrameTiming>[];
  late final ui.TimingsCallback _cb;
  VoidCallback? _controllerSub;
  bool _active = true; // pause collection when widget is offstage or disabled

  @override
  void initState() {
    super.initState();
    _cb = (List<ui.FrameTiming> timings) {
      if (!_active || !widget.enabled) return;
      setState(() {
        _buf.addAll(timings);
        final keep = widget.window;
        if (_buf.length > keep) _buf.removeRange(0, _buf.length - keep);
      });
    };
    WidgetsBinding.instance.addTimingsCallback(_cb);

    _controllerSub = () {
      // Reset buffer when host asks (e.g., on tab switch)
      setState(() => _buf.clear());
    };
    widget.controller.addListener(_controllerSub!);
  }

  @override
  void didUpdateWidget(covariant FpsOverlay old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_controllerSub!);
      _controllerSub = () => setState(() => _buf.clear());
      widget.controller.addListener(_controllerSub!);
    }
  }

  @override
  void dispose() {
    if (_controllerSub != null) {
      widget.controller.removeListener(_controllerSub!);
    }
    WidgetsBinding.instance.removeTimingsCallback(_cb);
    super.dispose();
  }

  double get _panelHz {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isNotEmpty) {
      final d = views.first.display;
      if (d != null && d.refreshRate > 0) return d.refreshRate.toDouble();
    }
    return 60.0;
  }

  @override
  Widget build(BuildContext context) {
    // Pause sampling if this subtree is not painting (saves noise).
    _active = TickerMode.of(context) && widget.enabled;

    final hz = _panelHz;
    final tgtMs = 1000.0 / hz;

    if (_buf.isEmpty) {
      return _hud('Display ${hz.toStringAsFixed(0)}Hz', 'collecting…');
    }

    // Per-frame total = slower phase (what users feel)
    final perFrameUs = _buf
        .map(
          (t) => math.max(
            t.buildDuration.inMicroseconds,
            t.rasterDuration.inMicroseconds,
          ),
        )
        .toList(growable: false);

    // Rolling window (short) average
    double avgUs(Iterable<int> xs) =>
        xs.isEmpty ? 0 : xs.reduce((a, b) => a + b) / xs.length;
    final avgFrameUs = avgUs(perFrameUs);
    final rollingFps = avgFrameUs == 0 ? 0 : 1e6 / avgFrameUs;
    final appFps = math.min(hz, rollingFps);

    // Phase “capacity” (for debugging)
    final avgBuildUs = avgUs(_buf.map((t) => t.buildDuration.inMicroseconds));
    final avgRasterUs = avgUs(_buf.map((t) => t.rasterDuration.inMicroseconds));
    final fpsBuildCap = avgBuildUs == 0 ? 0 : 1e6 / avgBuildUs;
    final fpsRasterCap = avgRasterUs == 0 ? 0 : 1e6 / avgRasterUs;

    // Instantaneous FPS (last interval) shows spikes immediately
    double? instFps;
    if (_buf.length >= 2) {
      final a = _buf[_buf.length - 2].timestampInMicroseconds(
        ui.FramePhase.rasterFinish,
      );
      final b = _buf.last.timestampInMicroseconds(ui.FramePhase.rasterFinish);
      final dtUs = (b - a).abs();
      if (dtUs > 0) instFps = 1e6 / dtUs;
    }

    // Jank frames in the current rolling window
    final jank = perFrameUs.where((us) => us / 1000.0 > tgtMs).length;

    final title =
        'App FPS ${appFps.toStringAsFixed(0)} / ${hz.toStringAsFixed(0)}Hz'
        '${instFps != null ? '  (inst ${instFps!.toStringAsFixed(0)})' : ''}';
    final sub =
        'build ${(avgBuildUs / 1000).toStringAsFixed(1)}ms (≈${fpsBuildCap.toStringAsFixed(0)}fps) • '
        'raster ${(avgRasterUs / 1000).toStringAsFixed(1)}ms (≈${fpsRasterCap.toStringAsFixed(0)}fps) • '
        'jank $jank/${perFrameUs.length}';

    return _hud(title, sub);
  }

  Widget _hud(String title, String sub) {
    final style = TextStyle(
      color: const Color(0xFF00FF41),
      fontSize: 12,
      fontFeatures: const [FontFeature.tabularFigures()],
      fontFamily: widget.monospaced ? 'RobotoMono' : null,
    );
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.72),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF00FF41), width: 0.8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: DefaultTextStyle(
            style: style,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(height: 4),
                Text(
                  sub,
                  style: style.copyWith(color: const Color(0xCC00FF41)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
