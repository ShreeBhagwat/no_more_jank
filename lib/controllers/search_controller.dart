import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_more_jank/core/data/model/movie_model.dart';
import 'package:no_more_jank/repository/tmdb_movie_repo.dart';

/// Search controller with debounce and cache
class SearchController extends StateNotifier<AsyncValue<List<Movie>>> {
  SearchController(this.ref) : super(const AsyncValue.data([]));
  final Ref ref;
  Timer? _debounce;
  int requests = 0; // For demo UI

  void onQueryChanged(String searchQuery, {required bool janky}) {
    if (janky) {
      _search(searchQuery); // fire on every keystroke (bad)
      return;
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(searchQuery));
  }

  Future<void> _search(String searchQuery) async {
    if (searchQuery.trim().isEmpty) { state = const AsyncValue.data([]); return; }
    // serve from cache if available
    final cache = ref.read(searchCacheProvider);
    if (cache.containsKey(searchQuery)) {
      state = AsyncValue.data(cache[searchQuery]!);
      return;
    }
    state = const AsyncValue.loading();
    requests++;
    final api = ref.read(tmdbMovieRepoProvider);
    try {
      final results = await api.search(searchQuery);
      ref.read(searchCacheProvider.notifier).state = {...cache, searchQuery: results};
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final searchControllerProvider = StateNotifierProvider<SearchController, AsyncValue<List<Movie>>>(
  (ref) => SearchController(ref),
);


final searchCacheProvider = StateProvider<Map<String, List<Movie>>>((_) => {});
