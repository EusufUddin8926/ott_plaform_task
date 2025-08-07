import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ott_platform_task/features/movie_details/presentation/screen/responsive_video_player.dart';
import '../../../../core/constants/app_constant.dart';
import '../../../../core/di/di.dart';
import '../../domain/usecase/get_movie_details_usecase.dart';
import '../bloc/movie_details_bloc.dart';
import '../bloc/movie_details_event.dart';
import '../bloc/movie_details_state.dart';

class MovieDetailsPage extends StatelessWidget {
  final String imdbID;

  const MovieDetailsPage({super.key, required this.imdbID});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MovieDetailsBloc>()..add(FetchMovieDetails(imdbID)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Movie Details')),
        body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailsError) {
              return Center(child: Text(state.message));
            } else if (state is MovieDetailsLoaded) {
              final md = state.movieDetails;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ResponsiveVideoPlayer(
                    videoUrl: AppConstant.videoUrl,
                    videoKey: 'video_$imdbID',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    md.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${md.year} | ${md.genre} | Rated: ${md.rated}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: CachedNetworkImage(
                          imageUrl: md.poster != 'N/A' ? md.poster : '',
                          placeholder: (context, url) =>
                              Container(color: Colors.grey.shade800),
                          errorWidget: (context, url, error) =>
                              Container(color: Colors.grey.shade800),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          md.plot,
                          style: const TextStyle(fontSize: 16, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Director: ${md.director}'),
                  Text('Writer: ${md.writer}'),
                  Text('Actors: ${md.actors}'),
                  Text('Language: ${md.language}'),
                  Text('Country: ${md.country}'),
                  Text('Awards: ${md.awards}'),
                  Text('IMDb Rating: ${md.imdbRating}'),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

