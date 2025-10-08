import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:no_more_jank/core/data/model/movie_model.dart';
import 'package:no_more_jank/utils/constants.dart';

class TmdbMovieRepo {
  final http.Client _client;
  final Ref ref;
  TmdbMovieRepo(this._client, this.ref);

  Future<List<Movie>> popular({int page = 1}) async {
    final uri = Uri.parse(
      '$kTmdbBase/movie/popular?api_key=$kTmdbApiKey&page=$page',
    );
    final response = await _client.get(uri);
    if (response.statusCode != 200) throw Exception('TMDB error: ${response.statusCode}');
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = (data['results'] as List).cast<Map<String, dynamic>>();
    return results.map(Movie.fromJson).toList();
  }

  Future<List<Movie>> search(String query, {int page = 1}) async {
    final uri = Uri.parse(
      '$kTmdbBase/search/movie?api_key=$kTmdbApiKey&query=${Uri.encodeQueryComponent(query)}&page=$page',
    );
    final response = await _client.get(uri);
    if (response.statusCode != 200) throw Exception('TMDB error: ${response.statusCode}');
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = (data['results'] as List).cast<Map<String, dynamic>>();
    return results.map(Movie.fromJson).toList();
  }
}

final tmdbMovieRepoProvider = Provider<TmdbMovieRepo>(
  (ref) => TmdbMovieRepo(http.Client(), ref),
);
