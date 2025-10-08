import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_more_jank/core/data/model/movie_model.dart';
import 'package:no_more_jank/repository/tmdb_movie_repo.dart';

class PopularController extends StateNotifier<AsyncValue<List<Movie>>> {
  PopularController(this.ref) : super(const AsyncValue.loading()) { _fetchMore(); }
  final Ref ref;
  int _page = 1;
  bool _loading = false;

  Future<void> _fetchMore() async {
    if (_loading) return;
    _loading = true;
    final api = ref.read(tmdbMovieRepoProvider);
    try {
      final current = [
        ...?state.value,
        ...ref.read(popularCacheProvider),
      ];
      final next = await api.popular(page: _page);
      current.addAll(next);
      ref.read(popularCacheProvider.notifier).state = current; // cache
      state = AsyncValue.data(current);
      _page++;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _loading = false;
    }
  }

  void maybeFetchMore(ScrollNotification notification) {
    if (notification.metrics.pixels > notification.metrics.maxScrollExtent - 600) {
      _fetchMore();
    }
  }
}

final popularControllerProvider = StateNotifierProvider<PopularController, AsyncValue<List<Movie>>>(
  (ref) => PopularController(ref),
);


final popularCacheProvider = StateProvider<List<Movie>>((_) => const []);
