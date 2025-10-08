import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_more_jank/controllers/popular_controller.dart';
import 'package:no_more_jank/presentation/widgets/banner_widget.dart';
import 'package:no_more_jank/presentation/widgets/movie_title_widget.dart';
import 'package:no_more_jank/provider/jank_mode_provider.dart';

class PopularTab extends ConsumerWidget {
  const PopularTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isJank = ref.watch(jankModeProvider);
    final popularAsync = ref.watch(popularControllerProvider.select((s) => s));
    return Column(
      children: [
        BannerWidget(
          title: 'Popular Movies',
          bullets: isJank
              ? const [
                  'Heavy CPU in itemBuilder',
                  'Loads ORIGINAL poster textures',
                  'Deep clip/shadow every tile',
                ]
              : const [
                  'Offload CPU to compute()/cache',
                  'Use w500 + cacheWidth',
                  'Lean tile + RepaintBoundary',
                ],
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              ref.read(popularControllerProvider.notifier).maybeFetchMore(n);
              return false;
            },
            child: popularAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (movies) => ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: movies.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) =>
                    MovieTile(movie: movies[i], janky: isJank),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
