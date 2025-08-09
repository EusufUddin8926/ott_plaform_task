import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ott_platform_task/features/home/presentation/bloc/home_bloc.dart';
import 'package:ott_platform_task/features/movie_details/data/repositories/MovieDetailsRepositoryImpl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/listing/data/repositories/listing_movie_repository_impl.dart';
import '../../features/listing/domain/repositories/listing_movie_repository.dart';
import '../../features/listing/domain/usecases/get_all_movies.dart';
import '../../features/listing/presentation/bloc/listing_bloc.dart';
import '../../features/movie_details/domain/repositories/movie_details_repository.dart';
import '../../features/movie_details/domain/usecase/get_movie_details_usecase.dart';
import '../../features/movie_details/presentation/bloc/movie_details_bloc.dart';
import '../../shared/data/remote/movie_remote_data_source.dart';
import '../../features/home/data/repositories/movie_repository_impl.dart';
import '../../features/home/domain/repositories/movie_repository.dart';
import '../../shared/data/remote/api_service.dart';
import '../network/dio_factory.dart';
import '../preferences/app_prefs.dart';
import '../route/routes.dart';
import '../theme/bloc/theme_bloc.dart';
import '../utils/network_info.dart';

final getIt = GetIt.instance;

Future<void> init() async {

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<AppPreferences>(() => AppPreferences(getIt<SharedPreferences>()));


  if (!getIt.isRegistered<Connectivity>()) {
    getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  }

  // Register NetworkInfo with Connectivity dependency
  if (!getIt.isRegistered<NetworkInfo>()) {
    getIt.registerLazySingleton<NetworkInfo>(
          () => NetworkInfoImpl(getIt<Connectivity>()),
    );
  }

  getIt.registerLazySingleton<DioFactory>(() => DioFactory());
  final dio = await getIt<DioFactory>().getDio();
  getIt.registerLazySingleton<Dio>(() => dio);
  getIt.registerLazySingleton(() => ApiService(dio));

  getIt.registerLazySingleton<ThemeBloc>(() => ThemeBloc());

  getIt.registerLazySingleton<MovieRemoteDataSource>(() => MovieRemoteDataSource(getIt(), getIt()));
  getIt.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(getIt()));
  getIt.registerFactory(() => HomeBloc( getIt()));


  getIt.registerLazySingleton<ListingMovieRepository>(() => ListingMovieRepositoryImpl(getIt()));
  getIt.registerLazySingleton<GetAllMovies>(() => GetAllMovies(getIt<ListingMovieRepository>()));
  getIt.registerFactory(() => ListingBloc(getAllMoviesUseCase: getIt()));

  getIt.registerLazySingleton<GetMovieDetailsUseCase>(() => GetMovieDetailsUseCase(getIt()));
  getIt.registerLazySingleton<MovieDetailsRepository>(() => MovieDetailsRepositoryImpl(getIt()));
  getIt.registerFactory(() => MovieDetailsBloc(repository: getIt()));

  getIt.registerSingleton(AppRouter());
}