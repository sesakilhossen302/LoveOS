import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/app_state.dart';
import '../core/theme.dart';
import '../widgets/glass_card.dart';

class GalleryScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const GalleryScreen({super.key, required this.onContinue});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  final List<Map<String, String>> _loveReasons = [
    {
      'num': '01',
      'title': 'Your Infectious Smile',
      'quote': 'The way your face lights up can turn my darkest days into sunshine.',
      'icon': '😊',
    },
    {
      'num': '02',
      'title': 'Your Warm Heart',
      'quote': 'How genuinely you care for people and make everyone feel loved.',
      'icon': '💖',
    },
    {
      'num': '03',
      'title': 'Your Beautiful Eyes',
      'quote': 'When I look into your eyes, I see my favorite future.',
      'icon': '✨',
    },
    {
      'num': '04',
      'title': 'Our Silly Talks',
      'quote': 'How we can laugh at absolute nonsense and talk for endless hours.',
      'icon': '💬',
    },
    {
      'num': '05',
      'title': 'Your Kind Soul',
      'quote': 'Your sweetness and empathy inspire me to be a better person.',
      'icon': '🌸',
    },
    {
      'num': '06',
      'title': 'How Safe I Feel',
      'quote': 'Whenever I am with you, all my worries disappear into peace.',
      'icon': '🏡',
    },
    {
      'num': '07',
      'title': 'Your Cute Habits',
      'quote': 'All the little unique things you do that you don’t even notice.',
      'icon': '🦋',
    },
    {
      'num': '08',
      'title': 'Unmatched Support',
      'quote': 'The way you believe in me even when I doubt myself.',
      'icon': '🌟',
    },
    {
      'num': '09',
      'title': 'Making Ordinary Special',
      'quote': 'Even doing nothing with you feels like the greatest adventure.',
      'icon': '🌹',
    },
    {
      'num': '10',
      'title': 'Simply Being YOU',
      'quote': 'Because out of 8 billion people, my heart chose YOU.',
      'icon': '👑',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // Live Days Together Counter Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              borderRadius: 24,
              borderColor: LoveTheme.primaryNeonPink,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.favorite, color: LoveTheme.primaryNeonPink, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'WE HAVE BEEN TOGETHER FOR',
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
            ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            '10 Reasons Why I Love You ❤️',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn(),

          const SizedBox(height: 6),

          Text(
            'Swipe cards to read (${_currentPage + 1} / ${_loveReasons.length})',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white60,
            ),
          ),

          const SizedBox(height: 20),

          // Card Carousel
          SizedBox(
            height: 310,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _loveReasons.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final card = _loveReasons[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: GlassCard(
                    padding: const EdgeInsets.all(24),
                    borderRadius: 28,
                    borderColor: index == _currentPage
                        ? LoveTheme.primaryNeonPink
                        : LoveTheme.cardBorderGlass,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: LoveTheme.primaryNeonPink.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '#${card['num']}',
                                style: GoogleFonts.firaCode(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: LoveTheme.secondaryRose,
                                ),
                              ),
                            ),
                            Text(
                              card['icon']!,
                              style: const TextStyle(fontSize: 32),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          card['title']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: LoveTheme.secondaryRose,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          card['quote']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dancingScript(
                            fontSize: 21,
                            color: Colors.white.withOpacity(0.95),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _loveReasons.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == index ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? LoveTheme.primaryNeonPink
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Next Button
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
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Next Mini Game 🎮',
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
