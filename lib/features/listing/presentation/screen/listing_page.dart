import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/listing_bloc.dart';
import '../bloc/listing_event.dart';
import '../bloc/listing_state.dart';

class ListingPage extends StatefulWidget {
  final String title;
  final String filterTitle;
  final String? filterYear;

  const ListingPage({
    super.key,
    required this.title,
    required this.filterTitle,
    this.filterYear,
  });

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  final ScrollController _scrollController = ScrollController();
  late ListingBloc listingBloc;

  @override
  void initState() {
    super.initState();
    listingBloc = context.read<ListingBloc>();
    listingBloc.add(FetchListingMovies(
      filterTitle: widget.filterTitle,
      filterYear: widget.filterYear,
    ));

    _scrollController.addListener(() {
      final state = listingBloc.state;
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 300 &&
          state is ListingSuccess &&
          !state.isLoadingMore &&
          state.hasMore) {
        listingBloc.add(FetchMoreMovies());
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                listingBloc.add(FetchListingMovies(
                  filterTitle: widget.filterTitle,
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 70,
                            height: 90,
                            child: CachedNetworkImage(
                              imageUrl: movie.poster != 'N/A' ? movie.poster : '',
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
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
