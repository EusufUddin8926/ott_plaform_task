import 'package:equatable/equatable.dart';

import '../../domain/entity/movie_details.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();

  @override
  List<Object?> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {
  const MovieDetailsInitial();
}

class MovieDetailsLoading extends MovieDetailsState {
  const MovieDetailsLoading();
}

class MovieDetailsSuccess extends MovieDetailsState {
  final MovieDetails movieDetails;

  const MovieDetailsSuccess(this.movieDetails);

  @override
  List<Object?> get props => [movieDetails];
}

class MovieDetailsFailure extends MovieDetailsState {
  final String error;

  const MovieDetailsFailure(this.error);

  @override
  List<Object?> get props => [error];
}
