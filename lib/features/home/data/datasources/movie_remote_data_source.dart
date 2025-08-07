import 'package:ott_platform_task/core/constants/app_constant.dart';

import '../../../../core/network/api_service.dart';
import '../models/movie_model.dart';

class MovieRemoteDataSource {
  final ApiService api;

  MovieRemoteDataSource(this.api);

  Future<List<MovieModel>> searchMovies({required String query, String? year}) async {
    final response = await api.get(
      endPoint: '',
      queryParams: {
        'apikey': AppConstant.apiKey,
        's': query,
        if (year != null) 'y': year,
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
}
