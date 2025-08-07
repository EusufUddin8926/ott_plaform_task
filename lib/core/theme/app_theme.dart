import 'package:flutter/material.dart';
import '../utils/color.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightScaffoldBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightAppBarBackground,
      foregroundColor: AppColors.lightAppBarForeground,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.lightSwitchThumb),
      trackColor: WidgetStateProperty.all(AppColors.lightSwitchTrack),
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkScaffoldBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkAppBarBackground,
      foregroundColor: AppColors.darkAppBarForeground,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.darkSwitchThumb),
      trackColor: WidgetStateProperty.all(AppColors.darkSwitchTrack),
    ),
  );
}
