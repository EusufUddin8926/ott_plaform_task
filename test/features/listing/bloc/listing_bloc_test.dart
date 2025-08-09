import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ott_platform_task/core/models/movie.dart';
import 'package:ott_platform_task/features/listing/presentation/bloc/listing_bloc.dart';
import 'package:ott_platform_task/features/listing/presentation/bloc/listing_event.dart';
import 'package:ott_platform_task/features/listing/presentation/bloc/listing_state.dart';

import '../mocks/mock_get_all_movies_usecase.dart';

void main() {
  late MockGetAllMoviesUseCase mockUseCase;
  late ListingBloc listingBloc;

  final testMoviesPage1 = [
    Movie(title: 'Batman Begins', year: '2005', imdbID: '1', poster: 'https://m.media-amazon.com/images/M/MV5BZjlhMTQxYTctNTgyOS00ZDE5LTgwYjMtMDhjMTc1MGQzYWQ4XkEyXkFqcGc@._V1_SX300.jpg'),
    Movie(title: 'The Dark Knight', year: '2008', imdbID: '2', poster: 'https://m.media-amazon.com/images/M/MV5BZjlhMTQxYTctNTgyOS00ZDE5LTgwYjMtMDhjMTc1MGQzYWQ4XkEyXkFqcGc@._V1_SX300.jpg'),
  ];

  final testMoviesPage2 = [
    Movie(title: 'Batman Forever', year: '1995', imdbID: '3', poster: 'https://m.media-amazon.com/images/M/MV5BZjlhMTQxYTctNTgyOS00ZDE5LTgwYjMtMDhjMTc1MGQzYWQ4XkEyXkFqcGc@._V1_SX300.jpg'),
  ];

  setUp(() {
    mockUseCase = MockGetAllMoviesUseCase();
    listingBloc = ListingBloc(getAllMoviesUseCase: mockUseCase);
  });

  test('initial state should be ListingInitial', () {
    expect(listingBloc.state, equals(ListingInitial()));
  });

  blocTest<ListingBloc, ListingState>(
    'emits [ListingLoading, ListingSuccess] on successful initial fetch',
    build: () {
      when(() => mockUseCase(query: 'Batman', year: null, page: 1))
          .thenAnswer((_) async => testMoviesPage1);
      return listingBloc;
    },
    act: (bloc) => bloc.add(FetchListingMovies(filterTitle: 'Batman')),
    expect: () => [
      ListingLoading(),
      ListingSuccess(movies: testMoviesPage1, hasMore: true, isLoadingMore: false),
    ],
  );

  blocTest<ListingBloc, ListingState>(
    'emits [ListingSuccess (loadingMore true), ListingSuccess (loadingMore false)] when fetching more movies',
    build: () {
      when(() => mockUseCase(query: 'Batman', year: null, page: 1))
          .thenAnswer((_) async => testMoviesPage1);
      when(() => mockUseCase(query: 'Batman', year: null, page: 2))
          .thenAnswer((_) async => testMoviesPage2);
      return listingBloc;
    },
    act: (bloc) async {
      bloc.add(FetchListingMovies(filterTitle: 'Batman'));
      await Future.delayed(Duration.zero);
      bloc.add(FetchMoreMovies());
    },
    expect: () => [
      ListingLoading(),
      ListingSuccess(movies: testMoviesPage1, hasMore: true, isLoadingMore: false),
      ListingSuccess(movies: testMoviesPage1, hasMore: true, isLoadingMore: true),
      ListingSuccess(
        movies: [...testMoviesPage1, ...testMoviesPage2],
        hasMore: true,
        isLoadingMore: false,
      ),
    ],
  );

  blocTest<ListingBloc, ListingState>(
    'emits [ListingLoading, ListingFailure] on initial fetch failure',
    build: () {
      when(() => mockUseCase(query: 'Batman', year: null, page: 1))
          .thenThrow(Exception('Initial fetch error'));
      return listingBloc;
    },
    act: (bloc) => bloc.add(FetchListingMovies(filterTitle: 'Batman')),
    expect: () => [
      ListingLoading(),
      isA<ListingFailure>().having((state) => state.error, 'error', contains('Initial fetch error')),
    ],
  );

  blocTest<ListingBloc, ListingState>(
    'emits [ListingSuccess (loadingMore true), ListingFailure] on fetch more failure',
    build: () {
      when(() => mockUseCase(query: 'Batman', year: null, page: 1))
          .thenAnswer((_) async => testMoviesPage1);
      when(() => mockUseCase(query: 'Batman', year: null, page: 2))
          .thenThrow(Exception('Load more error'));
      return listingBloc;
    },
    act: (bloc) async {
      bloc.add(FetchListingMovies(filterTitle: 'Batman'));
      await Future.delayed(Duration.zero);
      bloc.add(FetchMoreMovies());
    },
    expect: () => [
      ListingLoading(),
      ListingSuccess(movies: testMoviesPage1, hasMore: true, isLoadingMore: false),
      ListingSuccess(movies: testMoviesPage1, hasMore: true, isLoadingMore: true),
      isA<ListingFailure>().having((state) => state.error, 'error', contains('Load more error')),
    ],
  );
}
