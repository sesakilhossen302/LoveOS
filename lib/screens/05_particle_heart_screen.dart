import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';
import '../widgets/particle_heart_canvas.dart';

class ParticleHeartScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const ParticleHeartScreen({super.key, required this.onContinue});

  @override
  State<ParticleHeartScreen> createState() => _ParticleHeartScreenState();
}

class _ParticleHeartScreenState extends State<ParticleHeartScreen> {
  final List<String> _textSequence = [
    "You probably already know...",
    "But...",
    "I wanted to say it differently. ❤️",
  ];

  int _currentLineIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTextSequence();
  }

  void _startTextSequence() {
    _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      if (!mounted) return;
      setState(() {
        if (_currentLineIndex < _textSequence.length) {
          _currentLineIndex++;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Particle Heart Animation Canvas
          const SizedBox(
            height: 240,
            width: 240,
            child: ParticleHeartCanvas(),
          ).animate().fadeIn(duration: 1000.ms).scale(),

          const SizedBox(height: 36),

          // Message Box
          Container(
            height: 120,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _currentLineIndex; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      _textSequence[i],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: i == 2 ? 19 : 17,
                        fontWeight: i == 2 ? FontWeight.bold : FontWeight.w500,
                        color: i == 2
                            ? LoveTheme.secondaryRose
                            : Colors.white.withOpacity(0.9),
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          if (_currentLineIndex >= _textSequence.length)
            ElevatedButton(
              onPressed: widget.onContinue,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 10,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LoveTheme.buttonGradient,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continue',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}
