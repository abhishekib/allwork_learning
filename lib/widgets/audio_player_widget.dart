import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({
    Key? key,
    required this.audioUrl,
  }) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration currentTime = Duration.zero;
  Duration totalTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    try {
      await _audioPlayer.setUrl(widget.audioUrl);
      _audioPlayer.durationStream.listen((duration) {
        if (duration != null && mounted) {
          setState(() {
            totalTime = duration;
          });
        }
      });
      _audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            currentTime = position;
          });
        }
      });
      _audioPlayer.playerStateStream.listen((playerState) {
        if (mounted) {
          setState(() {
            isPlaying = playerState.playing;
          });
        }
      });
    } catch (e) {
      // Handle load error here
      print("Error loading audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer
        .dispose(); // Properly dispose of the AudioPlayer to release resources.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Playback Progress Slider
          Row(
            children: [
              Text(
                _formatDuration(currentTime),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              Expanded(
                child: Slider(
                  value: currentTime.inSeconds.toDouble(),
                  min: 0,
                  max: totalTime.inSeconds.toDouble(),
                  onChanged: (value) async {
                    await _audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.white54,
                ),
              ),
              Text(
                _formatDuration(totalTime),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Volume Control Button
              IconButton(
                onPressed: () {
                  _audioPlayer.setVolume(_audioPlayer.volume == 0 ? 1 : 0);
                },
                icon: Icon(
                  _audioPlayer.volume == 0 ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                ),
              ),
              // Play/Pause Button
              IconButton(
                onPressed: () async {
                  if (isPlaying) {
                    await _audioPlayer.pause();
                  } else {
                    await _audioPlayer.play();
                  }
                },
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              // Settings Button (Placeholder)
              IconButton(
                onPressed: () {
                  // Handle settings action
                },
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper function to format Duration to mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
