import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';
import '../widgets/glass_card.dart';

class StarlightScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const StarlightScreen({super.key, required this.onContinue});

  @override
  State<StarlightScreen> createState() => _StarlightScreenState();
}

class _StarlightScreenState extends State<StarlightScreen> {
  final List<String> _lines = [
    "I never thought",
    "I would build an app...",
    "",
    "Just to tell someone",
    "how important they are. ✨",
  ];

  int _visibleLinesCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypewriter();
  }

  void _startTypewriter() {
    _timer = Timer.periodic(const Duration(milliseconds: 900), (timer) {
      if (!mounted) return;
      setState(() {
        if (_visibleLinesCount < _lines.length) {
          _visibleLinesCount++;
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
          // Celestial Star Icon
          const Icon(
            Icons.star_rate_rounded,
            size: 48,
            color: LoveTheme.secondaryRose,
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(duration: 1500.ms, begin: const Offset(0.9, 0.9), end: const Offset(1.2, 1.2)),

          const SizedBox(height: 36),

          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            child: Column(
              children: [
                for (int i = 0; i < _visibleLinesCount; i++) ...[
                  if (_lines[i].isEmpty)
                    const SizedBox(height: 16)
                  else
                    Text(
                      _lines[i],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dancingScript(
                        fontSize: i >= 3 ? 26 : 24,
                        fontWeight: i >= 3 ? FontWeight.bold : FontWeight.w600,
                        color: i >= 3
                            ? LoveTheme.primaryNeonPink
                            : Colors.white.withOpacity(0.95),
                        height: 1.4,
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                ],
              ],
            ),
          ),

          const SizedBox(height: 48),

          if (_visibleLinesCount >= _lines.length)
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
                        'Next ❤️',
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
            ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),
        ],
      ),
    );
  }
}
