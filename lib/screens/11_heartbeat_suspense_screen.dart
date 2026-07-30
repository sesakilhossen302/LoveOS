import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';

class HeartbeatSuspenseScreen extends StatefulWidget {
  final VoidCallback onRevealLetter;

  const HeartbeatSuspenseScreen({super.key, required this.onRevealLetter});

  @override
  State<HeartbeatSuspenseScreen> createState() =>
      _HeartbeatSuspenseScreenState();
}

class _HeartbeatSuspenseScreenState extends State<HeartbeatSuspenseScreen> {
  bool _showText = false;
  bool _showButton = false;
  Timer? _timer1;
  Timer? _timer2;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() {
    _timer1 = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _showText = true;
        });
      }
    });

    _timer2 = Timer(const Duration(milliseconds: 3200), () {
      if (mounted) {
        setState(() {
          _showButton = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer1?.cancel();
    _timer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Dark mood for deep suspense
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rhythmic Pulsing Beating Heart
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LoveTheme.buttonGradient,
              boxShadow: [
                BoxShadow(
                  color: LoveTheme.primaryNeonPink.withOpacity(0.8),
                  blurRadius: 45,
                  spreadRadius: 12,
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite_rounded,
              size: 80,
              color: Colors.white,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                duration: 600.ms,
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.15, 1.15),
                curve: Curves.easeInOut,
              ),

          const SizedBox(height: 56),

          // Suspense Typewriter Text
          if (_showText)
            Text(
              'There is only one thing left to say...',
              textAlign: TextAlign.center,
              style: GoogleFonts.dancingScript(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.95),
                height: 1.4,
              ),
            ).animate().fadeIn(duration: 1000.ms).slideY(begin: 0.3, end: 0),

          const SizedBox(height: 56),

          // Open Final Letter Button
          if (_showButton)
            ElevatedButton(
              onPressed: widget.onRevealLetter,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 15,
                shadowColor: LoveTheme.primaryNeonPink.withOpacity(0.8),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LoveTheme.buttonGradient,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 48, vertical: 18),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Read My Heart ❤️',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 600.ms).scale(
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                ),
        ],
      ),
    );
  }
}
