import 'dart:async';
import 'package:flutter/foundation.dart';

class AudioService {
  static bool _isPlaying = false;
  static bool get isPlaying => _isPlaying;

  static void togglePlay(bool enable) {
    _isPlaying = enable;
    if (kIsWeb && enable) {
      _playWebMelody();
    }
  }

  static void _playWebMelody() {
    // Soft web audio chime / ambient sound controller
  }
}
