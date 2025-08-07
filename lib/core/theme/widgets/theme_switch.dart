import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme_bloc.dart';



// Or with toggle action
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(context.select(
              (ThemeBloc bloc) => bloc.state.isDarkMode
              ? Icons.light_mode
              : Icons.dark_mode
      )),
      onPressed: () => context.read<ThemeBloc>().add(ToggleThemeEvent()),
    );
  }
}