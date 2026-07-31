import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/app_state.dart';
import '../core/theme.dart';
import '../widgets/glass_card.dart';

class MoodSelectorScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const MoodSelectorScreen({super.key, required this.onContinue});

  @override
  State<MoodSelectorScreen> createState() => _MoodSelectorScreenState();
}

class _MoodSelectorScreenState extends State<MoodSelectorScreen> {
  int? _selectedMoodIndex;
  bool _hugSent = false;

  final List<Map<String, dynamic>> _moods = [
    {
      'emoji': '😊',
      'label': 'Happy',
      'color': Colors.amber,
      'title': 'Yay! Keep Shining ✨',
      'response':
          'Your happiness is literally my favorite thing in the world! Keep wearing that beautiful smile all day long! 💖',
    },
    {
      'emoji': '😴',
      'label': 'Tired',
      'color': Colors.purpleAccent,
      'title': 'Rest Your Eyes 🍵',
      'response':
          'You worked so hard today! Please rest well, take a deep breath, and remember I am so proud of you. 💆‍♀️❤️',
    },
    {
      'emoji': '🥺',
      'label': 'Sad',
      'color': Colors.blueAccent,
      'title': 'It’s Okay Hug 🤗',
      'response':
          'Hey, it’s completely okay to feel down sometimes. I am right here with you. Sending you the tightest virtual hug! ❤️',
    },
    {
      'emoji': '💭',
      'label': 'Missing You',
      'color': Colors.pinkAccent,
      'title': 'Always In My Heart 🌌',
      'response':
          'I miss you so much too! Distance means nothing when someone means everything. You are always in my thoughts. 💌',
    },
    {
      'emoji': '😤',
      'label': 'Stressed',
      'color': Colors.orangeAccent,
      'title': 'Deep Breaths 🌿',
      'response':
          'Take 3 deep breaths... Inhale peace, exhale stress. Everything is going to be perfectly fine. I believe in you! ✨',
    },
  ];

  void _sendVirtualHug() {
    setState(() {
      _hugSent = true;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('🤗 ', style: TextStyle(fontSize: 18)),
            Text(
              'Warm Virtual Hug Delivered to your heart! ❤️',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: LoveTheme.primaryNeonPink,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        children: [
          // Title Header
          Text(
            'How Are You Feeling Today?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn().slideY(begin: -0.2, end: 0),

          const SizedBox(height: 6),

          Text(
            'Tap your current mood for a special response 🌸',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: LoveTheme.secondaryRose,
            ),
          ),

          const SizedBox(height: 24),

          // Mood Buttons Row
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: List.generate(_moods.length, (index) {
              final mood = _moods[index];
              final isSelected = _selectedMoodIndex == index;

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedMoodIndex = index;
                    _hugSent = false;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (mood['color'] as Color).withOpacity(0.25)
                        : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? (mood['color'] as Color)
                          : Colors.white12,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: (mood['color'] as Color).withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 1,
                            )
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mood['emoji']!,
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        mood['label']!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 28),

          // Dynamic Comforting Response Card
          if (_selectedMoodIndex != null) ...[
            GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 28,
              borderColor: _moods[_selectedMoodIndex!]['color'] as Color,
              child: Column(
                children: [
                  Text(
                    _moods[_selectedMoodIndex!]['emoji']!,
                    style: const TextStyle(fontSize: 48),
                  ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 12),
                  Text(
                    _moods[_selectedMoodIndex!]['title']!,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: LoveTheme.secondaryRose,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _moods[_selectedMoodIndex!]['response']!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dancingScript(
                      fontSize: 22,
                      color: Colors.white.withOpacity(0.95),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Virtual Hug Button
                  OutlinedButton.icon(
                    onPressed: _sendVirtualHug,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: LoveTheme.primaryNeonPink),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: Icon(
                      _hugSent
                          ? Icons.favorite_rounded
                          : Icons.volunteer_activism_rounded,
                      color: LoveTheme.primaryNeonPink,
                      size: 20,
                    ),
                    label: Text(
                      _hugSent ? 'Virtual Hug Received 🤗' : 'Receive Virtual Hug 🤗',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                '👆 Select any mood above to hear what I want to tell you! ❤️',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Continue Button
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 44, vertical: 16),
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
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }
}
