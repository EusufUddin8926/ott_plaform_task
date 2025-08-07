import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  MovieModel({
    required super.title,
    required super.year,
    required super.imdbID,
    required super.poster,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      imdbID: json['imdbID'] ?? '',
      poster: json['Poster'] ?? '',
    );
  }
}