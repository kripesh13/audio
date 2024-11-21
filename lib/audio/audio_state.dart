import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_service/audio_service.dart';

class AudioState extends ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration audioPosition = Duration.zero;
  Duration audioDuration = Duration.zero;

  // Initialize the audio player and notification background
  audioController(String uri) async {
    await audioPlayer.setAudioSource(
      AudioSource.uri(Uri.parse(uri),
        tag: MediaItem(
          id: "1",
          title: "Sample Audio",
          artist: 'Artist Name',
          artUri: Uri.parse('https://avatars.githubusercontent.com/u/106339511?v=4'),
        ),
      ),
    );

    // Start playing the audio
    audioPlayer.play();

    // Update position and duration streams
    audioPlayer.positionStream.listen((p) {
      audioPosition = p;
      notifyListeners();
      _updateBackgroundNotification();
    });

    audioPlayer.durationStream.listen((d) {
      audioDuration = d ?? Duration.zero;
      notifyListeners();
      _updateBackgroundNotification();
    });

    // Handle playback completion
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        audioPlayer.seek(Duration.zero);
        audioPlayer.pause();
      }
      _updateBackgroundNotification();
    });
  }

  // Update the notification for background audio controls
  void _updateBackgroundNotification() {
    if (audioPlayer.playing) {
      AudioServiceBackground.setState(
        controls: [
          MediaControl.play, // Play control
          MediaControl.pause, // Pause control
          MediaControl.skipToNext,
          MediaControl.skipToPrevious,
        ],
        playing: true,
        position: audioPosition,
        bufferedPosition: audioPlayer.bufferedPosition,
        // duration: audioDuration,
      );
    } else {
      AudioServiceBackground.setState(
        controls: [
          MediaControl.play, // Play control
          MediaControl.pause, // Pause control
          MediaControl.skipToNext,
          MediaControl.skipToPrevious,
        ],
        playing: false,
        position: audioPosition,
        bufferedPosition: audioPlayer.bufferedPosition,
        // duration: audioDuration,
      );
    }
  }

  // Handle play/pause button press
  void handleAudio() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    _updateBackgroundNotification();
  }

  // Seek audio to a specific position
  void handleSeek(double value) {
    audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  // Format duration as MM:SS
  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  }
}
