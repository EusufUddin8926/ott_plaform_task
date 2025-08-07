import '../../../../core/models/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getBannerMovies();
  Future<List<Movie>> getBatmanMovies();
  Future<List<Movie>> getLatestMovies();
}