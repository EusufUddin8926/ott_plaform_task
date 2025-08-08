import 'package:flutter/material.dart';
import 'package:ott_platform_task/core/di/di.dart';
import 'package:ott_platform_task/core/preferences/app_prefs.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ResponsiveVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String videoKey;
  final String imdbId;

  const ResponsiveVideoPlayer({
    super.key,
    required this.imdbId,
    required this.videoUrl,
    required this.videoKey,
  });

  @override
  State<ResponsiveVideoPlayer> createState() => _ResponsiveVideoPlayerState();
}

class _ResponsiveVideoPlayerState extends State<ResponsiveVideoPlayer> {
  late final AppPreferences prefs;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    prefs = getIt<AppPreferences>();
    initPlayer();
  }

  Future<void> initPlayer() async {
    final lastPosition = prefs.getCurrentPositionById(widget.imdbId);

    _videoController = VideoPlayerController.network(widget.videoUrl);
    await _videoController!.initialize();

    if (lastPosition > Duration.zero) {
      await _videoController!.seekTo(lastPosition);
    }

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: false,
      autoInitialize: true,
    );

    // Save current position every 5 seconds
    _videoController!.addListener(() {
      if (_videoController!.value.isPlaying) {
        final position = _videoController!.value.position;
        if (position.inSeconds % 5 == 0) {
          prefs.setCurrentPosition(widget.imdbId, _videoController!.value.position.inMilliseconds);
        }
      }
    });

    setState(() {
      isInitialized = true;
    });
  }

  @override
  void dispose() {
    if (_videoController != null) {
      prefs.setCurrentPosition(widget.imdbId, _videoController!.value.position.inMilliseconds);
      _videoController!.dispose();
    }
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }
}
