import 'package:equatable/equatable.dart';

abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchMovieDetails extends MovieDetailsEvent {
  final String imdbID;

  const FetchMovieDetails(this.imdbID);

  @override
  List<Object?> get props => [imdbID];
}

