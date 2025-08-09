import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';
import '../../domain/repositories/movie_details_repository.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MovieDetailsRepository repository;

  MovieDetailsBloc({required this.repository}) : super(const MovieDetailsInitial()) {
    on<FetchMovieDetails>(_onFetchMovieDetails);
  }

  Future<void> _onFetchMovieDetails(FetchMovieDetails event, Emitter<MovieDetailsState> emit) async {
    emit(const MovieDetailsLoading());
    try {
      final movieDetails = await repository.getMovieDetails(event.imdbID);
      emit(MovieDetailsSuccess(movieDetails));
    } catch (e) {
      emit(MovieDetailsFailure(e.toString()));
    }
  }
}
