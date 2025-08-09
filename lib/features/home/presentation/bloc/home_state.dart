import 'package:equatable/equatable.dart';

import '../../../../core/models/movie.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

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

  @override
  List<Object?> get props => [bannerMovies, batmanMovies, latestMovies];
}

class HomeFailure extends HomeState {
  final String message;

  HomeFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
