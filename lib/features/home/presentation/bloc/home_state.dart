import '../../domain/entities/movie.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<Movie> bannerMovies;
  final List<Movie> batmanMovies;
  final List<Movie> latestMovies;

  HomeSuccess({
    required this.bannerMovies,
    required this.batmanMovies,
    required this.latestMovies,
  });
}

class HomeFailure extends HomeState {
  final String message;

  HomeFailure(this.message);
}
