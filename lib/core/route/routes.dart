import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/listing/presentation/screen/listing_page.dart';

class AppRouter {
  late final GoRouter _router;

  AppRouter() {
    _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        GoRoute(
          path: '/listing',
          name: 'listing',
          builder: (context, state) {
            final title = state.uri.queryParameters['title']!;
            final filterTitle = state.uri.queryParameters['filterTitle'];
            final filterYear = state.uri.queryParameters['filterYear'];

            return ListingPage(
              title: title,
              filterTitle: filterTitle!,
              filterYear: filterYear,
            );
          },
        )
      ],
      errorBuilder: (context, state) => const Scaffold(
        body: Center(child: Text('Route not found: }')),
      ),
    );
  }

  GoRouter get router => _router;
}