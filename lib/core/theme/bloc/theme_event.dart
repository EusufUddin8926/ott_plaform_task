part of 'theme_bloc.dart';

abstract class ThemeEvent {}
class ToggleThemeEvent extends ThemeEvent {} // Toggle between dark/light
class ForceThemeEvent extends ThemeEvent {   // Force specific theme
  final bool forceDark;
  ForceThemeEvent(this.forceDark);
}