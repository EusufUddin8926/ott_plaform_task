import '../../../../core/models/movie.dart';

abstract class ListingState {}

class ListingInitial extends ListingState {}

class ListingLoading extends ListingState {}

class ListingSuccess extends ListingState {
  final List<Movie> movies;
  final bool hasMore;
  final bool isLoadingMore;

  ListingSuccess({
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
}


class ListingFailure extends ListingState {
  final String error;

  ListingFailure(this.error);
}
