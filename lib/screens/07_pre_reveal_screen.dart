import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';
import '../widgets/confetti_canvas.dart';
import '../widgets/glass_card.dart';

class PreRevealScreen extends StatelessWidget {
  final VoidCallback onOpen;

  const PreRevealScreen({super.key, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti Canvas background
        const Positioned.fill(
          child: ConfettiCanvas(),
        ),

        // Foreground Content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Celebration Gift Box Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LoveTheme.buttonGradient,
                  boxShadow: [
                    BoxShadow(
                      color: LoveTheme.primaryNeonPink.withOpacity(0.6),
                      blurRadius: 30,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  size: 52,
                  color: Colors.white,
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(
                    duration: 1000.ms,
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1.1, 1.1),
                  ),

              const SizedBox(height: 36),

              GlassCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                child: Column(
                  children: [
                    Text(
                      'Correct! 🎉',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00F5D4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'One More Thing...',
                      style: GoogleFonts.dancingScript(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),

              const SizedBox(height: 48),

              ElevatedButton(
                onPressed: onOpen,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 12,
                  shadowColor: LoveTheme.primaryNeonPink.withOpacity(0.7),
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
                          Icons.mark_email_unread_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Open Secret Box 🎁',
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
              ).animate().fadeIn(delay: 400.ms).scale(
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
