import 'package:flutter/material.dart';
import 'package:allwork/controllers/category_detail_controller.dart';

class AudioPlayerWidget extends StatelessWidget {
  final String audioUrl;
  final CategoryDetailController controller;

  const AudioPlayerWidget(
      {super.key, required this.audioUrl, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // controller.playAudio(audioUrl);
          },
          child: const Text("Play Audio"),
        ),
        // Add a slider or any audio controls
        StreamBuilder<Duration>(
          stream: controller.audioPlayer.positionStream,
          builder: (context, snapshot) {
            final position = snapshot.data ?? Duration.zero;
            final totalDuration =
                controller.audioPlayer.duration ?? Duration.zero;
            return Row(
              children: [
                Text("${position.inSeconds} / ${totalDuration.inSeconds}"),
                Slider(
                  value: position.inSeconds.toDouble(),
                  min: 0,
                  max: totalDuration.inSeconds.toDouble(),
                  onChanged: (value) {
                    controller.audioPlayer
                        .seek(Duration(seconds: value.toInt()));
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
