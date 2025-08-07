import '../../../../core/models/movie.dart';
import '../repositories/movie_repository.dart';

class GetBannerMovies {
  final MovieRepository repository;

  GetBannerMovies(this.repository);

  Future<List<Movie>> call() => repository.getBatmanMovies();
}
