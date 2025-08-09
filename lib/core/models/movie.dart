class Movie {
  final String title;
  final String year;
  final String imdbID;
  final String poster;

  Movie({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.poster,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Movie &&
              runtimeType == other.runtimeType &&
              title == other.title &&
              year == other.year &&
              imdbID == other.imdbID &&
              poster == other.poster;

  @override
  int get hashCode => title.hashCode ^ year.hashCode ^ imdbID.hashCode ^ poster.hashCode;
}
