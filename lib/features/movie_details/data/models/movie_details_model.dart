import '../../domain/entity/movie_details.dart';

class MovieDetailsModel extends MovieDetails {
  MovieDetailsModel({
    required super.title,
    required super.year,
    required super.genre,
    required super.rated,
    required super.poster,
    required super.plot,
    required super.director,
    required super.writer,
    required super.actors,
    required super.language,
    required super.country,
    required super.awards,
    required super.imdbRating,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      genre: json['Genre'] ?? '',
      rated: json['Rated'] ?? '',
      poster: json['Poster'] ?? '',
      plot: json['Plot'] ?? '',
      director: json['Director'] ?? '',
      writer: json['Writer'] ?? '',
      actors: json['Actors'] ?? '',
      language: json['Language'] ?? '',
      country: json['Country'] ?? '',
      awards: json['Awards'] ?? '',
      imdbRating: json['imdbRating'] ?? '',
    );
  }
}
