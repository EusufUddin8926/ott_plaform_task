import '../entity/movie_details.dart';
import '../repositories/movie_details_repository.dart';

class GetMovieDetailsUseCase {
  final MovieDetailsRepository repository;

  GetMovieDetailsUseCase(this.repository);

  Future<MovieDetails> call(String imdbID) {
    return repository.getMovieDetails(imdbID);
  }
}
