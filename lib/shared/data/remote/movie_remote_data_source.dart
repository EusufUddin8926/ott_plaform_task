import 'package:ott_platform_task/core/constants/app_constant.dart';

import '../../../core/models/movie.dart';
import '../../../features/movie_details/data/models/movie_details_model.dart';
import 'api_service.dart';
import '../../../core/models/movie_model.dart';

class MovieRemoteDataSource {
  final ApiService api;

  MovieRemoteDataSource(this.api);

  Future<List<MovieModel>> searchMovies({required String query, String? year, int? page}) async {
    final response = await api.get(
      endPoint: AppConstant.baseUrl,
      queryParams: {
        'apikey': AppConstant.apiKey,
        's': query,
        if (year != null) 'y': year,
        'page': page.toString(),
      },
    );

    if (response.data['Response'] == 'True') {
      return (response.data['Search'] as List)
          .map((json) => MovieModel.fromJson(json))
          .toList();
    } else {
      throw Exception(response.data['Error']);
    }
  }

  Future<List<Movie>> getAllMovies({
    required String query,
    String? year,
    int page = 1,
  }) async {
    final movieModels = await searchMovies(query: query, year: year, page: page);
    return movieModels;
  }


  Future<MovieDetailsModel> fetchMovieDetails(String imdbID) async {
    final response = await api.get(endPoint: AppConstant.baseUrl, queryParams: {
      'apikey': AppConstant.apiKey,
      'i': imdbID,
    });

    if (response.data['Response'] == 'True') {
      return MovieDetailsModel.fromJson(response.data);
    } else {
      throw Exception(response.data['Error']);
    }
  }




}
