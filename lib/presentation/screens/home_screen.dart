import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_more_jank/presentation/screens/layout_showcase_tab_screen.dart';
import 'package:no_more_jank/presentation/screens/popular_tab_screen.dart';
import 'package:no_more_jank/presentation/screens/search_tab_screen.dart';
import 'package:no_more_jank/presentation/screens/settings_screen.dart';
import 'package:no_more_jank/presentation/screens/shaders_showcase_tab_screen.dart';
import 'package:no_more_jank/presentation/widgets/fps_overlay_widget.dart';
import 'package:no_more_jank/presentation/widgets/frame_jank_injector.dart';
import 'package:no_more_jank/presentation/widgets/jank_injector.dart';
import 'package:no_more_jank/provider/jank_mode_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int index = 0;
  final List<Widget> tabs = const [
    PopularTab(),
    SearchTab(),
    LayoutShowcaseTab(),
    ShaderShowcaseTab(),
    SettingsScreen(),
  ];
  String get title =>
      ['Popular', 'Search', 'Layout', 'Shaders', 'Settings'][index];
  final _fpsControllers = List.generate(5, (_) => FpsMeterController());

  void _openJankControls(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final ms = ref.watch(uiJankMsProvider);
          final hz =
              WidgetsBinding
                  .instance
                  .platformDispatcher
                  .views
                  .first
                  .display
                  ?.refreshRate ??
              60.0;
          final maxMs = (1000.0 / hz).clamp(1, 20); // frame budget
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UI Jank Controls',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add synchronous work per frame on the UI isolate to intentionally drop FPS.',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Per-frame delay:'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Slider(
                        value: ms.toDouble(),
                        min: 0,
                        max: 16, // up to one 60Hz frame budget
                        divisions: maxMs.round(),
                        label: '${ms}ms',
                        onChanged: (v) =>
                            ref.read(uiJankMsProvider.notifier).state = v
                                .round(),
                      ),
                    ),
                    SizedBox(width: 48, child: Text('${ms}ms')),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Tip: Set 6–10ms on a 60Hz device or 4–6ms on a 120Hz device to visibly reduce App FPS.',
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showFpsWidget = ref.watch(showFpsProvider);
    final ms = ref.watch(uiJankMsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              IconButton(
                tooltip: 'Jank controls',
                icon: const Icon(Icons.tune),
                onPressed: () => _openJankControls(context),
              ),
              Text('Jank Toggle'),
              Switch(
                value: ref.watch(jankModeProvider),
                onChanged: (value) =>
                    ref.read(jankModeProvider.notifier).state = value,
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          UiJankInjector(stallMs: ms),
          tabs[index],
          if (showFpsWidget)
            Positioned(
              bottom: 12,
              right: 12,
              child: FpsOverlay(
                controller: _fpsControllers[index],
                enabled: true, // or bind to your FPS toggle
                window: 90, // tweak the window size if you want
              ),
            ),
          FrameJankInjector(milliseconds: ms),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_movies_outlined),
            label: 'Popular',
          ),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.view_agenda), label: 'Layout'),
          NavigationDestination(icon: Icon(Icons.animation), label: 'Shaders'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
