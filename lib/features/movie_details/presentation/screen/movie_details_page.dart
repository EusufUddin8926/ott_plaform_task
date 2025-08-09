import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ott_platform_task/features/movie_details/presentation/screen/widgets/responsive_video_player.dart';
import '../../../../core/constants/app_constant.dart';
import '../../../../core/di/di.dart';
import '../bloc/movie_details_bloc.dart';
import '../bloc/movie_details_event.dart';
import '../bloc/movie_details_state.dart';

class MovieDetailsPage extends StatelessWidget {
  final String imdbID;
  final String title;

  const MovieDetailsPage({super.key, required this.imdbID, required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MovieDetailsBloc>()..add(FetchMovieDetails(imdbID)),
      child: Scaffold(
        appBar: AppBar(
          title:  Text(title),
          automaticallyImplyLeading: kIsWeb ? false : true,
        ),
        body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailsFailure) {
              return Center(child: Text(state.error));
            } else if (state is MovieDetailsSuccess) {
              final md = state.movieDetails;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  videoPlayer(context, imdbID, title, md.poster),
                  const SizedBox(height: 16),
                  buildMovieDetailsText(md)
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }


  Widget buildMovieDetailsText(md) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Text('${AppConstant.director}: ${md.director}'),
        Text('${AppConstant.writer}: ${md.writer}'),
        Text('${AppConstant.actors}: ${md.actors}'),
        Text('${AppConstant.language}: ${md.language}'),
        Text('${AppConstant.country}: ${md.country}'),
        Text('${AppConstant.awards}: ${md.awards}'),
        Text('${AppConstant.imdbRating}: ${md.imdbRating}'),
      ],
    );
  }


  Widget videoPlayer(BuildContext context, String imdbID, String title, String poster){
    const isWeb = kIsWeb;
    return  SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: isWeb ? MediaQuery.sizeOf(context).height*0.80 : null,
      child: ResponsiveVideoPlayer(
        imdbId: imdbID,
        videoUrl: AppConstant.videoUrl,
        videoKey: 'video_$imdbID',
      ),
    );
  }
}

