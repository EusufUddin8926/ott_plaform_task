import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ott_platform_task/core/theme/widgets/theme_switch.dart';
import 'package:ott_platform_task/features/home/presentation/bloc/home_event.dart';
import '../../../../core/models/movie.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _carouselIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(

      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeSuccess) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('VOD Home'),
              actions: const [ThemeToggleButton()],
            ),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                buildCarousel(state.bannerMovies),
                const SizedBox(height: 12),
                buildRail('Batman', state.batmanMovies),
                const SizedBox(height: 12),
                buildRail('Latest Movies', state.latestMovies),
              ],
            ),
          );
        } else if (state is HomeFailure) {
          return Center(child: Text("Error: ${state.message}"));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget buildMovieItem(Movie movie, {double width = 110}) {
    return GestureDetector(
      onTap: () {
        // Navigate to the movie details page
        context.push('/details?imdbID=${movie.imdbID}');

      },
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: movie.poster != 'N/A' ? movie.poster : '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey.shade800),
                  errorWidget: (context, url, error) => Container(color: Colors.grey.shade800),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              movie.year,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRail(String title, List<Movie> movies) {
    return LayoutBuilder(builder: (context, constraints) {
      // Adjust item width based on available width
      double itemWidth = 130;
      if (constraints.maxWidth > 600) {
        itemWidth = 180;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Navigate to the listing page with the filter
                    final filterTitle = title == 'Batman' ? 'Batman' : 'movie';
                    final filterYear = title == 'Latest Movies' ? '2022' : null;
                    context.push(
                      '/listing?title=$title&filterTitle=$filterTitle${filterYear != null ? '&filterYear=$filterYear' : ''}',
                    );
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: itemWidth * 1.9, // increased height to prevent overflow
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (_, i) => buildMovieItem(movies[i], width: itemWidth),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: movies.length,
            ),
          ),
        ],
      );
    });
  }

  Widget buildCarousel(List<Movie> bannerMovies) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: bannerMovies.length,
            options: CarouselOptions(
              height: 220,
              viewportFraction: 0.8,
              enlargeCenterPage: true,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _carouselIndex = index;
                });
              },
            ),
            itemBuilder: (context, index, realIdx) {
              final movie = bannerMovies[index];
              return GestureDetector(
                onTap: (){
                  context.push('/details?imdbID=${movie.imdbID}');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: movie.poster != 'N/A' ? movie.poster : '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey.shade800),
                        errorWidget: (context, url, error) => Container(color: Colors.grey.shade800),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Text(
                          movie.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bannerMovies.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _carouselIndex == entry.key ? Colors.white : Colors.grey,
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
