abstract class MovieDetailsEvent {}

class FetchMovieDetails extends MovieDetailsEvent {
  final String imdbID;
  FetchMovieDetails(this.imdbID);
}
