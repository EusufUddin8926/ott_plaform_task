import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/movie.dart';
import '../../domain/usecases/get_all_movies.dart';
import 'listing_event.dart';
import 'listing_state.dart';

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  final GetAllMovies getAllMoviesUseCase;

  ListingBloc({required this.getAllMoviesUseCase}) : super(ListingInitial()) {
    on<FetchListingMovies>(_onFetchListingMovies);
    on<FetchMoreMovies>(_onFetchMoreMovies);
  }

  final List<Movie> _movies = [];
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  String _currentQuery = '';
  String? _currentYear;

  Future<void> _onFetchListingMovies(
      FetchListingMovies event, Emitter<ListingState> emit) async {
    emit(ListingLoading());
    _movies.clear();
    _page = 1;
    _hasMore = true;
    _currentQuery = event.filterTitle;
    _currentYear = event.filterYear;

    try {
      final newMovies = await getAllMoviesUseCase(
        query: _currentQuery,
        year: _currentYear,
        page: _page,
      );
      _movies.addAll(newMovies);
      _hasMore = newMovies.isNotEmpty;
      _page++;
      emit(ListingSuccess(movies: List.from(_movies), hasMore: _hasMore));
    } catch (e) {
      emit(ListingFailure(e.toString()));
    }
  }

  Future<void> _onFetchMoreMovies(
      FetchMoreMovies event, Emitter<ListingState> emit) async {
    if (!_hasMore || _isLoadingMore) return;

    _isLoadingMore = true;

    // Emit current state but with loadingMore true
    emit(ListingSuccess(
      movies: List.from(_movies),
      hasMore: _hasMore,
      isLoadingMore: true,
    ));

    try {
      final newMovies = await getAllMoviesUseCase(
        query: _currentQuery,
        year: _currentYear,
        page: _page,
      );
      if (newMovies.isEmpty) {
        _hasMore = false;
      } else {
        _movies.addAll(newMovies);
        _page++;
      }
      emit(ListingSuccess(
        movies: List.from(_movies),
        hasMore: _hasMore,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(ListingFailure(e.toString()));
    }

    _isLoadingMore = false;
  }

}
