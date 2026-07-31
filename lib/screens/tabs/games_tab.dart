import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme.dart';
import '../../widgets/glass_card.dart';
import '../06_quiz_screen.dart';
import '../10_mini_game_screen.dart';

class GamesTab extends StatefulWidget {
  const GamesTab({super.key});

  @override
  State<GamesTab> createState() => _GamesTabState();
}

class _GamesTabState extends State<GamesTab> {
  int _activeGameIndex = 0; // 0 = Selector, 1 = Heart Catcher, 2 = Quiz

  @override
  Widget build(BuildContext context) {
    if (_activeGameIndex == 1) {
      return MiniGameScreen(
        onGameComplete: () {
          setState(() {
            _activeGameIndex = 0;
          });
        },
      );
    } else if (_activeGameIndex == 2) {
      return QuizScreen(
        onCorrectAnswer: () {
          setState(() {
            _activeGameIndex = 0;
          });
        },
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Love Arcade 🎮',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn().slideY(begin: -0.2, end: 0),

          const SizedBox(height: 6),

          Text(
            'Play mini-games & unlock special hearts ❤️',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: LoveTheme.secondaryRose,
            ),
          ),

          const SizedBox(height: 28),

          // Game 1: Heart Catcher
          GestureDetector(
            onTap: () {
              setState(() {
                _activeGameIndex = 1;
              });
            },
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              borderRadius: 24,
              borderColor: LoveTheme.primaryNeonPink,
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LoveTheme.buttonGradient,
                    ),
                    child: const Icon(Icons.favorite, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catch 10 Hearts ❤️',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap floating hearts as fast as you can!',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.play_arrow_rounded,
                      color: LoveTheme.primaryNeonPink, size: 32),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: 16),

          // Game 2: Love Quiz
          GestureDetector(
            onTap: () {
              setState(() {
                _activeGameIndex = 2;
              });
            },
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              borderRadius: 24,
              borderColor: const Color(0xFF00F5D4),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF00F5D4),
                    ),
                    child: const Icon(Icons.quiz_rounded, color: Colors.black, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Romantic Quiz ❓',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Answer who is the most amazing person!',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.play_arrow_rounded,
                      color: Color(0xFF00F5D4), size: 32),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}
