import '../entity/movie_details.dart';

abstract class MovieDetailsRepository {
  Future<MovieDetails> getMovieDetails(String imdbID);
}
