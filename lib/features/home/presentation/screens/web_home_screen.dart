import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:ott_platform_task/core/theme/widgets/theme_switch.dart';
import '../../../../core/constants/app_constant.dart';
import '../../../../core/models/movie.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  int _selectedBannerIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final isScrolledNow = _scrollController.offset > 50;
      if (_isScrolled != isScrolledNow) {
        setState(() => _isScrolled = isScrolledNow);
      }
    });

    context.read<HomeBloc>().add(FetchHomeData());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildMovieItem(BuildContext context, Movie movie) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth * 0.3).clamp(120.0, 180.0);
    final titleFontSize = (screenWidth / 40).clamp(12.0, 18.0);
    final yearFontSize = (screenWidth / 55).clamp(10.0, 14.0);

    return GestureDetector(
      onTap: () => context.push('/details?imdbID=${movie.imdbID}&title=${movie.title}'),
      child: SizedBox(
        width: itemWidth.toDouble(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 2 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: movie.poster != 'N/A' ? movie.poster : '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey.shade800),
                    errorWidget: (context, url, error) =>
                        Container(color: Colors.grey.shade800),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: titleFontSize.toDouble(),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                movie.year,
                style: TextStyle(
                  fontSize: yearFontSize.toDouble(),
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMovieRail(String title, List<Movie> movies, double width) {
    final isWideScreen = width > 800;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
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
                    final filterTitle = title == AppConstant.batmanMovies ? AppConstant.batmanMovies : AppConstant.movies;
                    final filterYear = title == AppConstant.latestMovies ? '2022' : null;
                    context.push(
                      '/listing?title=$title&filterTitle=$filterTitle${filterYear != null ? '&filterYear=$filterYear' : ''}',
                    );
                  },
                  child: const Text(AppConstant.seeAll),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: isWideScreen
                ? GridView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: 160,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) => buildMovieItem(context, movies[index]),
            )
                : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => buildMovieItem(context, movies[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCarousel(List<Movie> bannerMovies) {
    return SizedBox(
      width:
      MediaQuery.sizeOf(context).width * 0.15,
      child: CarouselSlider.builder(
        itemCount: bannerMovies.length,
        options: CarouselOptions(
          height: 100,
          autoPlay: true,
          viewportFraction: 0.4,
          enableInfiniteScroll: true,
          enlargeCenterPage: true,
          onPageChanged: (index, _) {
            setState(() =>
            _selectedBannerIndex = index);
          },
        ),
        itemBuilder: (context, index, _) {
          final movie = bannerMovies[index];
          return GestureDetector(
            onTap: () => setState(
                    () => _selectedBannerIndex = index),
            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: movie.poster != 'N/A'
                    ? movie.poster
                    : '',
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(
                        color:
                        Colors.grey.shade800),
                errorWidget:
                    (context, url, error) =>
                    Container(
                        color: Colors
                            .grey.shade800),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeSuccess) {
          final bannerMovies = state.bannerMovies;
          final selectedMovie = bannerMovies[_selectedBannerIndex];

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: _isScrolled
                  ? Colors.black.withOpacity(0.9)
                  : Colors.transparent,
              elevation: _isScrolled ? 4 : 0,
              centerTitle: false,
              title: const Text(AppConstant.homeTitle, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              actions: const [
                ThemeToggleButton(),
                SizedBox(width: 16),

              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: selectedMovie.poster != 'N/A'
                                ? selectedMovie.poster
                                : '',
                            width: constraints.maxWidth,
                            height: constraints.maxHeight * 0.78,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: constraints.maxHeight * 0.78,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black,
                                  Colors.transparent,
                                  Colors.black87
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 32,
                            left: 32,
                            right: 32,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedMovie.title,
                                  style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  selectedMovie.year,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white70),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () async{
                                    context.push('/details?imdbID=${selectedMovie.imdbID}&title=${selectedMovie.title}');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                  ),
                                  child: const Text(AppConstant.watchNow),
                                ),
                                const SizedBox(height: 40),
                                buildCarousel(bannerMovies)
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildMovieRail(AppConstant.batmanMovies, state.batmanMovies,
                                constraints.maxWidth),
                            buildMovieRail(AppConstant.latestMovies, state.latestMovies,
                                constraints.maxWidth),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
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
}
