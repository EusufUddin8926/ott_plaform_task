import '../../../../core/models/movie.dart';
import '../repositories/listing_movie_repository.dart';

class GetAllMovies {
  final ListingMovieRepository repository;

  GetAllMovies(this.repository);

  Future<List<Movie>> call({
    required String query,
    String? year,
    int page = 1,
  }) => repository.getAllMovies(query: query, year: year, page: page);
}

