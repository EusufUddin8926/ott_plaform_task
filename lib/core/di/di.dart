import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ott_platform_task/features/home/presentation/bloc/home_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/data/datasources/movie_remote_data_source.dart';
import '../../features/home/data/repositories/movie_repository_impl.dart';
import '../../features/home/domain/repositories/movie_repository.dart';
import '../network/api_service.dart';
import '../network/dio_factory.dart';
import '../route/routes.dart';
import '../theme/bloc/theme_bloc.dart';
import '../utils/network_info.dart';

final getIt = GetIt.instance;

Future<void> init() async {

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);


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

  getIt.registerLazySingleton<MovieRemoteDataSource>(() => MovieRemoteDataSource(getIt()));
  getIt.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(getIt()));
  getIt.registerFactory(() => HomeBloc(movieRepository: getIt()));

  getIt.registerSingleton(AppRouter());
}