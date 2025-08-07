import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class ResponsiveVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String videoKey; // unique key for saving playback position
  const ResponsiveVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.videoKey,
  });

  @override
  State<ResponsiveVideoPlayer> createState() => _ResponsiveVideoPlayerState();
}

class _ResponsiveVideoPlayerState extends State<ResponsiveVideoPlayer> {
  VideoPlayerController? _videoController;
  Duration lastPosition = Duration.zero;
  SharedPreferences? prefs;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  Future<void> initPlayer() async {
    prefs = await SharedPreferences.getInstance();
    lastPosition = Duration(milliseconds: prefs?.getInt(widget.videoKey) ?? 0);

    if (kIsWeb) {
      // Web fallback message
      setState(() {
        isInitialized = true;
      });
    } else {
      _videoController = VideoPlayerController.network(widget.videoUrl);
      await _videoController!.initialize();

      if (lastPosition != Duration.zero) {
        await _videoController!.seekTo(lastPosition);
      }
      _videoController!.play();

      _videoController!.addListener(() {
        if (_videoController!.value.isPlaying) {
          final pos = _videoController!.value.position;
          if (pos.inSeconds % 5 == 0) {
            prefs?.setInt(widget.videoKey, pos.inMilliseconds);
          }
        }
      });

      setState(() {
        isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      if (_videoController != null) {
        prefs?.setInt(
            widget.videoKey, _videoController!.value.position.inMilliseconds);
        _videoController!.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (kIsWeb) {
      return const Center(
        child: Text(
          'Video playback on web is limited.\nPlease test on mobile for full playback experience.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(_videoController!),
          VideoProgressIndicator(
            _videoController!,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              backgroundColor: Colors.grey,
              playedColor: Colors.redAccent,
              bufferedColor: Colors.white54,
            ),
          ),
          _PlayPauseOverlay(controller: _videoController!),
        ],
      ),
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  final VideoPlayerController controller;
  const _PlayPauseOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.value.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
      },
      child: Center(
        child: controller.value.isPlaying
            ? const SizedBox.shrink()
            : Container(
          decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(48)),
          child: const Icon(Icons.play_arrow, size: 64, color: Colors.white),
        ),
      ),
    );
  }
}