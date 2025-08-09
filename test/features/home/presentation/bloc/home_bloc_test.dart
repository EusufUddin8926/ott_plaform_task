import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ott_platform_task/core/models/movie.dart';
import 'package:ott_platform_task/features/home/presentation/bloc/home_bloc.dart';
import 'package:ott_platform_task/features/home/presentation/bloc/home_event.dart';
import 'package:ott_platform_task/features/home/presentation/bloc/home_state.dart';

import '../../mock/mock_movie_repository.dart';

void main() {
  late MockMovieRepository mockRepository;
  late HomeBloc homeBloc;

  final sharedMovies = [
    Movie(
      title: 'Batman Begins',
      year: '2005',
      imdbID: '1',
      poster:
      'https://m.media-amazon.com/images/M/MV5BODIyMDdhNTgtNDlmOC00MjUxLWE2NDItODA5MTdkNzY3ZTdhXkEyXkFqcGc@._V1_SX300.jpg',
    ),
  ];

  final latestMovies = [
    Movie(
      title: 'Interstellar',
      year: '2014',
      imdbID: '3',
      poster:
      'https://m.media-amazon.com/images/M/MV5BZjlhMTQxYTctNTgyOS00ZDE5LTgwYjMtMDhjMTc1MGQzYWQ4XkEyXkFqcGc@._V1_SX300.jpg',
    ),
  ];

  setUp(() {
    mockRepository = MockMovieRepository();
    homeBloc = HomeBloc(mockRepository);
  });

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoading, HomeSuccess] when data loads successfully',
    build: () {
      when(() => mockRepository.getBatmanMovies())
          .thenAnswer((_) async => sharedMovies);
      when(() => mockRepository.getLatestMovies())
          .thenAnswer((_) async => latestMovies);
      return homeBloc;
    },
    act: (bloc) => bloc.add(FetchHomeData()),
    expect: () => [
      HomeLoading(),
      HomeSuccess(
        bannerMovies: sharedMovies,
        batmanMovies: sharedMovies,
        latestMovies: latestMovies,
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoading, HomeFailure] when getBatmanMovies throws',
    build: () {
      when(() => mockRepository.getBatmanMovies())
          .thenThrow(Exception('Error fetching banner and batman movies'));
      when(() => mockRepository.getLatestMovies())
          .thenAnswer((_) async => latestMovies);
      return homeBloc;
    },
    act: (bloc) => bloc.add(FetchHomeData()),
    expect: () => [
      HomeLoading(),
      isA<HomeFailure>().having((state) => state.message, 'message', contains('Error fetching banner and batman movies')),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoading, HomeFailure] when getLatestMovies throws',
    build: () {
      when(() => mockRepository.getBatmanMovies())
          .thenAnswer((_) async => sharedMovies);
      when(() => mockRepository.getLatestMovies())
          .thenThrow(Exception('Error fetching latest movies'));
      return homeBloc;
    },
    act: (bloc) => bloc.add(FetchHomeData()),
    expect: () => [
      HomeLoading(),
      isA<HomeFailure>().having((state) => state.message, 'message', contains('Error fetching latest movies')),
    ],
  );
}
