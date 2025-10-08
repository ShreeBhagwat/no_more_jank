import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This provider is used to toggle the jank mode.
/// Setting the default valuse as true to enable jank mode.
/// Set the value to false to disable jank mode.
final jankModeProvider = StateProvider<bool>((ref) => true);

/// This provider is used to toggle the FPS HUD.
/// Setting the default valuse as true to enable FPS HUD.
/// Set the value to false to disable FPS HUD.
final showFpsProvider = StateProvider<bool>((_) => true);

/// This provider is used to set the UI jank time in milliseconds.
/// Setting the default value as 0 to disable UI jank.
/// Set the value to a positive number to enable UI jank.
final uiJankMsProvider = StateProvider<int>((_) => 0);

/// This provider is used to toggle the Matrix HUD.
/// Setting the default value as true to enable Matrix HUD.
/// Set the value to false to disable Matrix HUD.
final showMatrixBgProvider = StateProvider<bool>((_) => true);