import 'package:ott_platform_task/features/movie_details/domain/entity/movie_details.dart';

import '../../../../shared/data/remote/movie_remote_data_source.dart';
import '../../domain/repositories/movie_details_repository.dart';

class MovieDetailsRepositoryImpl implements MovieDetailsRepository {

  final MovieRemoteDataSource remote;

  MovieDetailsRepositoryImpl(this.remote);

  @override
  Future<MovieDetails> getMovieDetails(String imdbID) => remote.fetchMovieDetails(imdbID);

}
