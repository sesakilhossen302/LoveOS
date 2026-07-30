import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';
import '../widgets/glass_card.dart';

class PoetryScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const PoetryScreen({super.key, required this.onContinue});

  @override
  State<PoetryScreen> createState() => _PoetryScreenState();
}

class _PoetryScreenState extends State<PoetryScreen> {
  final List<String> _poetryLines = [
    "You make ordinary days...",
    "feel extraordinary. ✨",
    "",
    "You make me smile",
    "without even trying. 😊",
    "",
    "Thank you for being you. ❤️",
  ];

  int _visibleCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPoetrySequence();
  }

  void _startPoetrySequence() {
    _timer = Timer.periodic(const Duration(milliseconds: 1100), (timer) {
      if (!mounted) return;
      setState(() {
        if (_visibleCount < _poetryLines.length) {
          _visibleCount++;
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
          // Glass Card for Poetry
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            child: Column(
              children: [
                const Icon(
                  Icons.format_quote_rounded,
                  size: 40,
                  color: LoveTheme.secondaryRose,
                ),
                const SizedBox(height: 16),
                for (int i = 0; i < _visibleCount; i++) ...[
                  if (_poetryLines[i].isEmpty)
                    const SizedBox(height: 16)
                  else
                    Text(
                      _poetryLines[i],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dancingScript(
                        fontSize: i >= 5 ? 28 : 24,
                        fontWeight: i >= 5 ? FontWeight.bold : FontWeight.w600,
                        color: i >= 5
                            ? LoveTheme.primaryNeonPink
                            : Colors.white.withOpacity(0.95),
                        height: 1.4,
                      ),
                    ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.2, end: 0),
                ],
              ],
            ),
          ).animate().fadeIn(duration: 800.ms),

          const SizedBox(height: 48),

          if (_visibleCount >= _poetryLines.length)
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
            ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9)),
        ],
      ),
    );
  }
}
