import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_more_jank/presentation/screens/home_screen.dart';
import 'package:no_more_jank/presentation/widgets/matrix_code_backdrop.dart';
import 'package:no_more_jank/provider/jank_mode_provider.dart';
import 'package:no_more_jank/theme/app_theme.dart';

void main() {
  runApp(ProviderScope(child: FlutterFlix()));
}

class FlutterFlix extends ConsumerWidget {
  const FlutterFlix({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMatrixBg = ref.watch(showMatrixBgProvider);
    return MaterialApp(
      // debugShowMaterialGrid: true,
      debugShowCheckedModeBanner: false,
      theme: matrixDarkTheme, // <-- use matrix theme
      darkTheme: matrixDarkTheme, // optional: force dark
      themeMode: ThemeMode.dark, // force dark for Matrix vibe
      home: MatrixCodeBackdrop(child: const HomeScreen()),
    );
  }
}
