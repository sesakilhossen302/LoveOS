import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/particle_heart_canvas.dart';

class HomeTab extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const HomeTab({super.key, required this.onNavigateToTab});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ✨';
    if (hour < 17) return 'Good Afternoon ☀️';
    if (hour < 21) return 'Good Evening 🌇';
    return 'Good Night 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<LoveAppState>(context);
    final duration = appState.relationshipDuration;
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Greeting & Profile Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: LoveTheme.secondaryRose,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    appState.herName,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => onNavigateToTab(4), // Go to Profile tab
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LoveTheme.buttonGradient,
                    border: Border.all(color: LoveTheme.secondaryRose, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: LoveTheme.primaryNeonPink.withOpacity(0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ),
            ],
          ).animate().fadeIn().slideY(begin: -0.2, end: 0),

          const SizedBox(height: 24),

          // Live Days Together Card
          GlassCard(
            padding: const EdgeInsets.all(20),
            borderRadius: 24,
            borderColor: LoveTheme.primaryNeonPink,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite_rounded,
                        color: LoveTheme.primaryNeonPink, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'TOGETHER FOR',
                      style: GoogleFonts.firaCode(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: LoveTheme.secondaryRose,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeUnit('$days', 'DAYS'),
                    _buildTimeUnit('$hours', 'HOURS'),
                    _buildTimeUnit('$minutes', 'MINS'),
                    _buildTimeUnit('$seconds', 'SECS'),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).scale(),

          const SizedBox(height: 24),

          // Glowing Particle Heart Display Container
          GlassCard(
            padding: const EdgeInsets.all(16),
            borderRadius: 28,
            child: Column(
              children: [
                const SizedBox(
                  height: 180,
                  width: 180,
                  child: ParticleHeartCanvas(),
                ),
                Text(
                  '"Out of 8 billion people, my heart chose you."',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dancingScript(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 24),

          // Quick Action Cards Row
          Row(
            children: [
              // Mood Shortcut Button
              Expanded(
                child: GestureDetector(
                  onTap: () => onNavigateToTab(1),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🌸', style: TextStyle(fontSize: 28)),
                        const SizedBox(height: 8),
                        Text(
                          'Mood Booster',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'How are you today?',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Arcade Shortcut Button
              Expanded(
                child: GestureDetector(
                  onTap: () => onNavigateToTab(2),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🎮', style: TextStyle(fontSize: 28)),
                        const SizedBox(height: 8),
                        Text(
                          'Arcade Games',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Catch Hearts & Quiz',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 24),

          // Read Secret Letter Banner
          GestureDetector(
            onTap: () => onNavigateToTab(3), // Go to Memories/Letter tab
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LoveTheme.buttonGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: LoveTheme.primaryNeonPink.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.mark_email_unread_rounded,
                      color: Colors.white, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Read Your Secret Letter 💌',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Tap to open your special note',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white, size: 18),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.firaCode(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00F5D4),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.white54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
