import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/get_movie_details_usecase.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMovieDetailsUseCase getMovieDetails;

  MovieDetailsBloc(this.getMovieDetails) : super(MovieDetailsInitial()) {
    on<FetchMovieDetails>((event, emit) async {
      emit(MovieDetailsLoading());
      try {
        final details = await getMovieDetails(event.imdbID);
        emit(MovieDetailsLoaded(details));
      } catch (e) {
        emit(MovieDetailsError('Failed to load movie details.'));
      }
    });
  }
}
