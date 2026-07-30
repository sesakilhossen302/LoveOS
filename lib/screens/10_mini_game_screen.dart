import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';
import '../widgets/glass_card.dart';

class MiniGameScreen extends StatefulWidget {
  final VoidCallback onGameComplete;

  const MiniGameScreen({super.key, required this.onGameComplete});

  @override
  State<MiniGameScreen> createState() => _MiniGameScreenState();
}

class _MiniGameScreenState extends State<MiniGameScreen> {
  int _score = 0;
  final int _targetScore = 10;
  final List<_TargetHeart> _activeHearts = [];
  final Random _random = Random();
  Timer? _spawnTimer;

  @override
  void initState() {
    super.initState();
    _startSpawningHearts();
  }

  void _startSpawningHearts() {
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (!mounted) return;
      if (_score >= _targetScore) {
        _spawnTimer?.cancel();
        return;
      }

      setState(() {
        if (_activeHearts.length < 6) {
          _activeHearts.add(_TargetHeart(
            id: DateTime.now().microsecondsSinceEpoch,
            x: _random.nextDouble() * 0.75 + 0.1,
            y: _random.nextDouble() * 0.55 + 0.2,
            size: _random.nextDouble() * 20 + 36,
          ));
        }
      });
    });
  }

  void _popHeart(int id) {
    setState(() {
      _activeHearts.removeWhere((h) => h.id == id);
      if (_score < _targetScore) {
        _score++;
      }
    });
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isCompleted = _score >= _targetScore;

    return Stack(
      children: [
        // Game Interactive Canvas Area
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  for (var heart in _activeHearts)
                    Positioned(
                      left: heart.x * constraints.maxWidth,
                      top: heart.y * constraints.maxHeight,
                      child: GestureDetector(
                        onTap: () => _popHeart(heart.id),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: LoveTheme.primaryNeonPink.withOpacity(0.2),
                            boxShadow: [
                              BoxShadow(
                                color: LoveTheme.primaryNeonPink.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite_rounded,
                            color: LoveTheme.primaryNeonPink,
                            size: heart.size,
                          ),
                        ).animate().scale(
                              duration: 400.ms,
                              curve: Curves.elasticOut,
                            ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),

        // Floating UI Overlay
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Game Score Card Header
                GlassCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MINI GAME',
                            style: GoogleFonts.firaCode(
                              fontSize: 12,
                              color: LoveTheme.secondaryRose,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Catch 10 Hearts ❤️',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: LoveTheme.primaryNeonPink.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: LoveTheme.primaryNeonPink),
                        ),
                        child: Text(
                          '$_score / $_targetScore',
                          style: GoogleFonts.firaCode(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? const Color(0xFF00F5D4)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Victory Card & Unlock Button
                if (isCompleted) ...[
                  GlassCard(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          size: 56,
                          color: Colors.amber,
                        ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                        const SizedBox(height: 12),
                        Text(
                          'Unlocked ❤️',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You caught all the hearts!',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 500.ms).scale(),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: widget.onGameComplete,
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
                            horizontal: 44, vertical: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Final Surprise →',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms).scale(),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TargetHeart {
  final int id;
  final double x;
  final double y;
  final double size;

  _TargetHeart({
    required this.id,
    required this.x,
    required this.y,
    required this.size,
  });
}
