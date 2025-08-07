import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ott_platform_task/features/home/presentation/bloc/home_bloc.dart';
import 'core/di/di.dart';
import 'core/route/routes.dart';
import 'core/theme/bloc/theme_bloc.dart';
import 'features/listing/presentation/bloc/listing_bloc.dart';
import 'features/movie_details/presentation/bloc/movie_details_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<HomeBloc>()),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: getIt<AppRouter>().router,
                theme: themeState.lightTheme,
                darkTheme: themeState.darkTheme,
                themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                builder: (context, child) {
                  ErrorWidget.builder = (FlutterErrorDetails details) {
                    return Scaffold(
                      body: Center(
                        child: Text(
                          'App Error: ${details.exception}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    );
                  };
                  return child!;
                },
              );
            },
          );
        },
      ),
    );
  }
}