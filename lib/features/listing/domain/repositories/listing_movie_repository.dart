import '../../../../core/models/movie.dart';

abstract class ListingMovieRepository {
  Future<List<Movie>> getAllMovies({
    required String query,
    String? year,
    int page,
  });
}

