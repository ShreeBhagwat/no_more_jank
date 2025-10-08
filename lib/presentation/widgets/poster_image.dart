import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_more_jank/utils/constants.dart';

class PosterImage extends ConsumerWidget {
  const PosterImage({super.key, required this.path, required this.janky});
  final String? path; final bool janky;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (path == null) return const SizedBox(width: 56, height: 84);
    final url = janky ? '$kImgBaseOriginal$path' : '$kImgBaseW500$path';
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final targetWidth = (56 * dpr).clamp(120, 400).toInt();
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        width: 56,
        height: 84,
        fit: BoxFit.cover,
        cacheWidth: janky ? null : targetWidth,
        filterQuality: janky ? FilterQuality.high : FilterQuality.low,
      ),
    );
  }
}
