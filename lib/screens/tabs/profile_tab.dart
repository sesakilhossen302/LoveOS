import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../widgets/glass_card.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<LoveAppState>(context);
    final formattedDate =
        DateFormat('MMMM dd, yyyy').format(appState.startDate);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        children: [
          // Profile Avatar Header
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LoveTheme.buttonGradient,
              border: Border.all(color: LoveTheme.primaryNeonPink, width: 3),
              boxShadow: [
                BoxShadow(
                  color: LoveTheme.primaryNeonPink.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.person, size: 56, color: Colors.white),
            ),
          ).animate().fadeIn().scale(duration: 600.ms, curve: Curves.elasticOut),

          const SizedBox(height: 16),

          Text(
            appState.herName,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            appState.herEmail,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: LoveTheme.secondaryRose,
            ),
          ),

          const SizedBox(height: 12),

          // Compatibility Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF00F5D4).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF00F5D4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars_rounded,
                    color: Color(0xFF00F5D4), size: 16),
                const SizedBox(width: 6),
                Text(
                  'COMPATIBILITY: 100% INFINITE ❤️',
                  style: GoogleFonts.firaCode(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF00F5D4),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 24),

          // Profile Details Glass Card
          GlassCard(
            padding: const EdgeInsets.all(20),
            borderRadius: 24,
            child: Column(
              children: [
                _buildInfoRow(
                    Icons.calendar_today_rounded, 'Anniversary Date', formattedDate),
                const Divider(color: Colors.white12, height: 24),
                _buildInfoRow(
                    Icons.favorite_rounded, 'Hearts Collected', '${appState.heartsCollected} ❤️'),
                const Divider(color: Colors.white12, height: 24),
                _buildInfoRow(
                    Icons.volunteer_activism_rounded, 'Virtual Hugs', '${appState.virtualHugsSent} 🤗'),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: LoveTheme.secondaryRose, size: 20),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white60,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
