import '../../../../core/models/movie.dart';
import '../../../../shared/data/remote/movie_remote_data_source.dart';
import '../../domain/repositories/listing_movie_repository.dart';

class ListingMovieRepositoryImpl implements ListingMovieRepository {
  final MovieRemoteDataSource remote;

  ListingMovieRepositoryImpl(this.remote);

  @override
  Future<List<Movie>> getAllMovies({
    required String query,
    String? year,
    int page = 1,
  }) =>
      remote.getAllMovies(query: query, year: year, page: page);
}

