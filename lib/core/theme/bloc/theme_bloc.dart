import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_theme.dart';
part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(
    lightTheme: AppTheme.light,
    darkTheme: AppTheme.dark,
    isDarkMode: true,
  )) {
    on<ToggleThemeEvent>((event, emit) {
      emit(state.copyWith(isDarkMode: !state.isDarkMode));
    });
    on<ForceThemeEvent>((event, emit) {
      emit(state.copyWith(isDarkMode: event.forceDark));
    });
  }
}