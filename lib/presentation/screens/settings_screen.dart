import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_more_jank/provider/jank_mode_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        spacing: 10,
        children: [
          SwitchListTile(
            title: Text('Jank Toggle'),
            value: ref.watch(jankModeProvider),
            onChanged: (value) =>
                ref.read(jankModeProvider.notifier).state = value,
          ),
          SwitchListTile(
            title: Text('Show FPS'),
            value: ref.watch(showFpsProvider),
            onChanged: (value) =>
                ref.read(showFpsProvider.notifier).state = value,
          ),
        ],
      ),
    );
  }
}
