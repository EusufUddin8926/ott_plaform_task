import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart'; // your getIt or DI setup
import '../bloc/listing_bloc.dart';
import '../bloc/listing_event.dart';
import '../bloc/listing_state.dart';

class MovieListingPage extends StatefulWidget {
  final String? filterTitle;
  final String? filterYear;
  final String title;

  const MovieListingPage({
    Key? key,
    required this.title,
    this.filterTitle,
    this.filterYear,
  }) : super(key: key);

  @override
  State<MovieListingPage> createState() => _MovieListingPageState();
}

class _MovieListingPageState extends State<MovieListingPage> {
  late final ScrollController _scrollController;
  late final ListingBloc _listingBloc;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _listingBloc = getIt<ListingBloc>();

    // Dispatch initial fetch after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listingBloc.add(FetchListingMovies(
        filterTitle: widget.filterTitle ?? '',
        filterYear: widget.filterYear,
      ));
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    const thresholdPixels = 200;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    final state = _listingBloc.state;
    if (currentScroll > maxScroll - thresholdPixels) {
      if (state is ListingSuccess && state.hasMore && !state.isLoadingMore) {
        _listingBloc.add(FetchMoreMovies());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _listingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _listingBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: BlocBuilder<ListingBloc, ListingState>(
          builder: (context, state) {
            if (state is ListingLoading && state is! ListingSuccess) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ListingSuccess) {
              if (state.movies.isEmpty) {
                return const Center(child: Text('No movies found.'));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  _listingBloc.add(FetchListingMovies(
                    filterTitle: widget.filterTitle ?? '',
                    filterYear: widget.filterYear,
                  ));
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.isLoadingMore
                      ? state.movies.length + 1
                      : state.movies.length,
                  itemBuilder: (context, index) {
                    if (index < state.movies.length) {
                      final movie = state.movies[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 70,
                              height: 90,
                              child: CachedNetworkImage(
                                imageUrl:
                                movie.poster != 'N/A' ? movie.poster : '',
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: Colors.grey.shade800),
                                errorWidget: (context, url, error) =>
                                    Container(color: Colors.grey.shade800),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(movie.title),
                                  const SizedBox(height: 4),
                                  Text(movie.year),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Loading indicator for pagination
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              );
            } else if (state is ListingFailure) {
              return Center(child: Text(state.error));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
