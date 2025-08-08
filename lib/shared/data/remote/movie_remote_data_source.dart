import 'package:ott_platform_task/core/constants/app_constant.dart';
import 'package:ott_platform_task/core/di/di.dart';

import '../../../core/models/movie.dart';
import '../../../core/utils/network_info.dart';
import '../../../features/movie_details/data/models/movie_details_model.dart';
import 'api_service.dart';
import '../../../core/models/movie_model.dart';

class MovieRemoteDataSource {
  final ApiService api;
  final NetworkInfo netwrokInfo;

  MovieRemoteDataSource(this.api, this.netwrokInfo);

  Future<void> _checkNetwork() async {
    final hasInternet = await netwrokInfo.isConnected;
    if (!hasInternet) {
      throw Exception('No internet connection');
    }
  }

  Future<List<MovieModel>> searchMovies({required String query, String? year, int? page}) async {
    await _checkNetwork();

    final response = await api.get(
      endPoint: AppConstant.baseUrl,
      queryParams: {
        'apikey': AppConstant.apiKey,
        's': query,
        if (year != null) 'y': year,
        if (page != null)
        'page': page.toString(),
      },
    );

    if (response.data['Response'] == 'True') {
      return (response.data['Search'] as List).map((json) => MovieModel.fromJson(json)).toList();
    } else {
      throw Exception(response.data['Error']);
    }
  }

  Future<List<Movie>> getAllMovies({
    required String query,
    String? year,
    int page = 1,
  }) async {
    await _checkNetwork();
    final movieModels = await searchMovies(query: query, year: year, page: page);
    return movieModels;
  }

  Future<MovieDetailsModel> fetchMovieDetails(String imdbID) async {
    await _checkNetwork();
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
