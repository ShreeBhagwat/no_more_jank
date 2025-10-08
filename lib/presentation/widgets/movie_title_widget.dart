import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_more_jank/core/data/model/movie_model.dart';
import 'package:no_more_jank/presentation/screens/movie_detail_screen.dart';
import 'package:no_more_jank/presentation/widgets/heavy_number_widget.dart';
import 'package:no_more_jank/presentation/widgets/poster_image.dart';

class MovieTile extends ConsumerWidget {
  const MovieTile({super.key, required this.movie, required this.janky});
  final Movie movie;
  final bool janky;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: PosterImage(path: movie.posterPath, janky: janky),
      title: Text(movie.title),
      subtitle: HeavyNumber(janky: janky, vote: movie.vote),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie)),
      ),
    );
  }
}
