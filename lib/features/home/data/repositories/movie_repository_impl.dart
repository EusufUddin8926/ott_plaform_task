import '../../../../core/models/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../../../shared/data/remote/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remote;

  MovieRepositoryImpl(this.remote);

  @override
  Future<List<Movie>> getBannerMovies() async {
    final movies = await remote.searchMovies(query: 'Batman');
    return movies.take(5).toList();
  }

  @override
  Future<List<Movie>> getBatmanMovies() => remote.searchMovies(query: 'Batman');

  @override
  Future<List<Movie>> getLatestMovies() => remote.searchMovies(query: 'movie', year: '2022');
}