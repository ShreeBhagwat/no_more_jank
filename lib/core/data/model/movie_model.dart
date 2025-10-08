class Movie {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final double vote;
  Movie({required this.id, required this.title, this.posterPath, this.backdropPath, this.overview, required this.vote});
  factory Movie.fromJson(Map<String, dynamic> movieJson) => Movie(
    id: movieJson['id'],
    title: movieJson['title'] ?? movieJson['name'] ?? 'Untitled',
    posterPath: movieJson['poster_path'],
    backdropPath: movieJson['backdrop_path'],
    overview: movieJson['overview'],
    vote: (movieJson['vote_average'] is num) ? (movieJson['vote_average'] as num).toDouble() : 0,
  );
}
