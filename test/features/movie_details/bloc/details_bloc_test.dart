import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ott_platform_task/features/movie_details/domain/entity/movie_details.dart';
import 'package:ott_platform_task/features/movie_details/presentation/bloc/movie_details_bloc.dart';
import 'package:ott_platform_task/features/movie_details/presentation/bloc/movie_details_event.dart';
import 'package:ott_platform_task/features/movie_details/presentation/bloc/movie_details_state.dart';
import '../mocks/MockMovieDetailsRepository.dart';

void main() {
  late MovieDetailsBloc bloc;
  late MockMovieDetailsRepository mockRepository;

  final testMovieDetails = MovieDetails(
    title: 'Inception',
    year: '2010',
    genre: 'Action, Sci-Fi',
    rated: 'PG-13',
    poster: 'https://m.media-amazon.com/images/M/MV5BZjlhMTQxYTctNTgyOS00ZDE5LTgwYjMtMDhjMTc1MGQzYWQ4XkEyXkFqcGc@._V1_SX300.jpg',
    plot: 'A mind-bending thriller...',
    director: 'Christopher Nolan',
    writer: 'Christopher Nolan',
    actors: 'Leonardo DiCaprio, Joseph Gordon-Levitt',
    language: 'English',
    country: 'USA',
    awards: 'Oscar Winner',
    imdbRating: '8.8',
  );

  setUp(() {
    mockRepository = MockMovieDetailsRepository();
    bloc = MovieDetailsBloc(repository: mockRepository);
  });

  group('MovieDetailsBloc', () {
    test('initial state is MovieDetailsInitial', () {
      expect(bloc.state, equals(const MovieDetailsInitial()));
    });

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'emits [MovieDetailsLoading, MovieDetailsSuccess] when movie details fetched successfully',
      build: () {
        when(() => mockRepository.getMovieDetails('tt1375666'))
            .thenAnswer((_) async => testMovieDetails);
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetails('tt1375666')),
      expect: () => [
        const MovieDetailsLoading(),
        MovieDetailsSuccess(testMovieDetails),
      ],
    );

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'emits [MovieDetailsLoading, MovieDetailsFailure] when repository throws error',
      build: () {
        when(() => mockRepository.getMovieDetails('tt1375666'))
            .thenThrow(Exception('Failed to fetch'));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetails('tt1375666')),
      expect: () => [
        const MovieDetailsLoading(),
        isA<MovieDetailsFailure>().having((state) => state.error, 'error', contains('Failed to fetch')),
      ],
    );
  });
}
