import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/audio/audio_state.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  @override
  void initState() {
    super.initState();
    final audioState = Provider.of<AudioState>(context, listen: false);
    // Replace with your audio URL or local file URI
    audioState.audioController('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Playback'),
      ),
      body: Consumer<AudioState>(
        builder: (context, audioState, _) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(audioState.formatDuration(audioState.audioDuration)),

                    // Play/Pause button
                    IconButton(
                      icon: Icon(audioState.audioPlayer.playing
                          ? Icons.pause
                          : Icons.play_arrow),
                      onPressed: () {
                        audioState.handleAudio();
                      },
                    ),
                  ],
                ),
                
                // Seek slider for progress
                Slider(
                  value: audioState.audioPosition.inSeconds.toDouble(),
                  min: 0,
                  max: audioState.audioDuration.inSeconds.toDouble(),
                  onChanged: (value) {
                    audioState.handleSeek(value);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
