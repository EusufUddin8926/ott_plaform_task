import 'package:ott_platform_task/core/constants/app_constant.dart';

import '../../../../core/models/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../../../shared/data/remote/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remote;

  MovieRepositoryImpl(this.remote);

  @override
  Future<List<Movie>> getBatmanMovies() => remote.searchMovies(query: AppConstant.batmanMovies);

  @override
  Future<List<Movie>> getLatestMovies() => remote.searchMovies(query: AppConstant.movies, year: '2022');
}