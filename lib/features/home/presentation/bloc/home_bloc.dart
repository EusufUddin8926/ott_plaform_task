import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/movie_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(
      FetchHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final movies = await repository.getBatmanMovies();
      final latest = await repository.getLatestMovies();

      emit(HomeSuccess(
        bannerMovies: movies.take(5).toList(),
        batmanMovies: movies,
        latestMovies: latest,
      ));
    } catch (e) {
      emit(HomeFailure(message: e.toString()));
    }
  }
}
