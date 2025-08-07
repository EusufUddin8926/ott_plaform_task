part of 'theme_bloc.dart';

class ThemeState {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final bool isDarkMode;

  const ThemeState({
    required this.lightTheme,
    required this.darkTheme,
    required this.isDarkMode,
  });

  ThemeData get currentTheme => isDarkMode ? darkTheme : lightTheme;

  ThemeState copyWith({
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    bool? isDarkMode,
  }) {
    return ThemeState(
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}