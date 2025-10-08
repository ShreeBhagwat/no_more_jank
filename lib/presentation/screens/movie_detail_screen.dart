import 'package:flutter/material.dart';
import 'package:no_more_jank/core/data/model/movie_model.dart';
import 'package:no_more_jank/utils/constants.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key, required this.movie});
  final Movie movie;
  @override
  Widget build(BuildContext context) {
    final poster = movie.posterPath != null ? '$kImgBaseW500${movie.posterPath}' : null;
    final backdrop = movie.backdropPath != null ? '$kImgBaseOriginal${movie.backdropPath}' : null;
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (backdrop != null)
          ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(backdrop, height: 200, fit: BoxFit.cover, cacheWidth: 1200)),
        const SizedBox(height: 12),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (poster != null)
            RepaintBoundary(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(poster, width: 100, height: 150, fit: BoxFit.cover, cacheWidth: 300))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(movie.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('⭐️ ${movie.vote.toStringAsFixed(1)}'),
            const SizedBox(height: 12),
            Text(movie.overview ?? 'No overview available.'),
          ])),
        ]),
      ]),
    );
  }
}