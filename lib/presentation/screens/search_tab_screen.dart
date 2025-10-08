import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_more_jank/controllers/search_controller.dart';
import 'package:no_more_jank/presentation/screens/movie_detail_screen.dart';
import 'package:no_more_jank/presentation/widgets/banner_widget.dart';
import 'package:no_more_jank/presentation/widgets/poster_image.dart';
import 'package:no_more_jank/presentation/widgets/search_field_widget.dart';
import 'package:no_more_jank/provider/jank_mode_provider.dart';

/// =====================
///  SEARCH TAB – Riverpod controller with debounce + cache; jank toggle
/// =====================
class SearchTab extends ConsumerWidget {
  const SearchTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isJank = ref.watch(jankModeProvider);
    final resultsAsync = ref.watch(searchControllerProvider);
    final requests = ref.watch(searchControllerProvider.notifier.select((n) => n.requests));
    return Column(children: [
      BannerWidget(
        title: 'Search Movies',
        bullets: isJank
            ? const ['API call on every keystroke (no debounce)', 'Whole page rebuilds', 'Out-of-order responses risk']
            : const ['Debounce input (400ms)', 'Scope rebuilds to results', 'Cache per query + cancellation'],
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: SearchField(janky: isJank),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: [Text('Requests fired: $requests'), const Spacer(), resultsAsync.maybeWhen(data: (d) => Text('Results: ${d.length}'), orElse: () => const SizedBox())]),
      ),
      const SizedBox(height: 8),
      Expanded(child: resultsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (results) => ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: results.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) { final m = results[i];
            return ListTile(
              leading: PosterImage(path: m.posterPath, janky: false),
              title: Text(m.title),
              subtitle: Text(m.overview ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: m))),
            );
          },
        ),
      )),
    ]);
  }
}