import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayPauseOverlay extends StatelessWidget {
  const PlayPauseOverlay({required this.controller, super.key});
  final VideoPlayerController controller;

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
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: controller.value.isPlaying ? 0.0 : 0.7,
              duration: const Duration(milliseconds: 200),
              child: Container(
                color: Colors.black45,
                child: const Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 56.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
