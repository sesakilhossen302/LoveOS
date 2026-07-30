import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';
import '../widgets/glass_card.dart';

class QuizScreen extends StatefulWidget {
  final VoidCallback onCorrectAnswer;

  const QuizScreen({super.key, required this.onCorrectAnswer});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _shakeCount = 0;
  String? _errorMessage;

  void _handleWrongAnswer() {
    setState(() {
      _shakeCount++;
      _errorMessage = "Wrong Answer 😂 Try again!";
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('❌ ', style: TextStyle(fontSize: 18)),
            Text(
              'Wrong Answer 😂 There is only 1 right answer!',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _handleRightAnswer() {
    setState(() {
      _errorMessage = null;
    });

    widget.onCorrectAnswer();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Question Header Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: LoveTheme.primaryNeonPink.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: LoveTheme.primaryNeonPink),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.help_outline_rounded,
                    color: LoveTheme.secondaryRose, size: 18),
                const SizedBox(width: 8),
                Text(
                  'QUESTION 01',
                  style: GoogleFonts.firaCode(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: LoveTheme.secondaryRose,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),

          const SizedBox(height: 28),

          // Quiz Card
          GlassCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Text(
                  'Who is the most amazing person in the world?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 32),

                // Option 1: Me ❤️ (CORRECT)
                InkWell(
                  onTap: _handleRightAnswer,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          LoveTheme.primaryNeonPink.withOpacity(0.3),
                          LoveTheme.secondaryRose.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: LoveTheme.primaryNeonPink,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: LoveTheme.primaryNeonPink.withOpacity(0.3),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: LoveTheme.primaryNeonPink,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Me ❤️',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                ).animate().scale(
                      delay: 200.ms,
                      duration: 400.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 16),

                // Option 2: Someone Else (WRONG)
                KeyedSubtree(
                  key: ValueKey(_shakeCount),
                  child: InkWell(
                    onTap: _handleWrongAnswer,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white24,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white38),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Someone Else 🙈',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate(target: _shakeCount > 0 ? 1 : 0).shake(
                      duration: 500.ms,
                      hz: 5,
                    ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}
