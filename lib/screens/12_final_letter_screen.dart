import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/app_state.dart';
import '../core/theme.dart';
import '../widgets/fireworks_canvas.dart';
import '../widgets/glass_card.dart';

class FinalLetterScreen extends StatefulWidget {
  final VoidCallback onRestart;

  const FinalLetterScreen({super.key, required this.onRestart});

  @override
  State<FinalLetterScreen> createState() => _FinalLetterScreenState();
}

class _FinalLetterScreenState extends State<FinalLetterScreen> {
  final ScrollController _scrollController = ScrollController();
  int _visibleParagraphCount = 0;
  Timer? _timer;

  List<String> _getParagraphs(String name) => [
        "Dear $name,",
        "Thank you for being a part of my life.",
        "I don't know what tomorrow holds...",
        "But today, I wanted you to know that you are very special to me. ❤️",
        "---",
        "No pressure. No expectations.",
        "I just wanted to be honest about my feelings.",
        "And this little app is my way of saying that. 😊",
        "---",
        "Thank You For Opening My Heart.",
      ];

  @override
  void initState() {
    super.initState();
    _startLetterSequence();
  }

  void _startLetterSequence() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (!mounted) return;
      final appState = Provider.of<LoveAppState>(context, listen: false);
      final paragraphs = _getParagraphs(appState.herName);

      setState(() {
        if (_visibleParagraphCount < paragraphs.length) {
          _visibleParagraphCount++;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<LoveAppState>(context);
    final paragraphs = _getParagraphs(appState.herName);

    return FireworksCanvas(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // Top Heart Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_rounded,
                      color: LoveTheme.primaryNeonPink, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'MISSION ACCOMPLISHED',
                    style: GoogleFonts.firaCode(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: LoveTheme.secondaryRose,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ).animate().fadeIn(),

              const SizedBox(height: 12),

              Text(
                'Tap screen for fireworks ✨',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 12),

              // Scrollable Envelope Letter
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(24),
                  borderRadius: 28,
                  borderColor: LoveTheme.primaryNeonPink.withOpacity(0.5),
                  child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (int i = 0; i < _visibleParagraphCount; i++) ...[
                            if (paragraphs[i] == "---") ...[
                              const SizedBox(height: 12),
                              Divider(
                                color: LoveTheme.secondaryRose.withOpacity(0.3),
                                indent: 40,
                                endIndent: 40,
                              ),
                              const SizedBox(height: 12),
                            ] else if (i == 0) ...[
                              Text(
                                paragraphs[i],
                                style: GoogleFonts.dancingScript(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: LoveTheme.primaryNeonPink,
                                ),
                              ).animate().fadeIn(duration: 600.ms),
                              const SizedBox(height: 16),
                            ] else if (i == paragraphs.length - 1) ...[
                              const SizedBox(height: 12),
                              Text(
                                paragraphs[i],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00F5D4),
                                ),
                              ).animate().fadeIn(duration: 800.ms).scale(),
                              const SizedBox(height: 8),
                              const Text(
                                '❤️',
                                style: TextStyle(fontSize: 36),
                              ).animate().scale(
                                  duration: 1000.ms, curve: Curves.elasticOut),
                            ] else ...[
                              Text(
                                paragraphs[i],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: i == 3
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: i == 3
                                      ? LoveTheme.secondaryRose
                                      : Colors.white.withOpacity(0.9),
                                  height: 1.5,
                                ),
                              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                              const SizedBox(height: 12),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Bottom Actions (Close / Replay)
              if (_visibleParagraphCount >= paragraphs.length) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: widget.onRestart,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: LoveTheme.secondaryRose),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      icon: const Icon(Icons.refresh_rounded,
                          color: LoveTheme.secondaryRose),
                      label: Text(
                        'Replay Experience 🔄',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
