import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/movie_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepository movieRepository;

  HomeBloc({required this.movieRepository}) : super(HomeLoading()) {
    on<FetchHomeData>((event, emit) async {
      emit(HomeLoading());
      try {
        final banner = await movieRepository.getBannerMovies();
        final batman = await movieRepository.getBannerMovies();
        final latest = await movieRepository.getLatestMovies();

        emit(HomeSuccess(
          bannerMovies: banner.take(5).toList(),
          batmanMovies: batman,
          latestMovies: latest,
        ));
      } catch (e) {
        emit(HomeFailure(e.toString()));
      }
    });
  }
}
