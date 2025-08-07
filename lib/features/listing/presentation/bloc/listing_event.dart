abstract class ListingEvent {}

class FetchListingMovies extends ListingEvent {
  final String filterTitle;
  final String? filterYear;

  FetchListingMovies({required this.filterTitle, this.filterYear});
}

class FetchMoreMovies extends ListingEvent {}
