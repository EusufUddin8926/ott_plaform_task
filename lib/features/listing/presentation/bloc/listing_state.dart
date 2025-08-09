import 'package:equatable/equatable.dart';
import '../../../../core/models/movie.dart';

abstract class ListingState extends Equatable {
  const ListingState();

  @override
  List<Object?> get props => [];
}

class ListingInitial extends ListingState {
  const ListingInitial();
}

class ListingLoading extends ListingState {
  const ListingLoading();
}

class ListingSuccess extends ListingState {
  final List<Movie> movies;
  final bool hasMore;
  final bool isLoadingMore;

  const ListingSuccess({
    required this.movies,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  ListingSuccess copyWith({
    List<Movie>? movies,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ListingSuccess(
      movies: movies ?? this.movies,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [movies, hasMore, isLoadingMore];
}

class ListingFailure extends ListingState {
  final String error;

  const ListingFailure(this.error);

  @override
  List<Object?> get props => [error];
}
