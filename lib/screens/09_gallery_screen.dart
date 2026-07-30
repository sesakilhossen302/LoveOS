import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

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

  final List<Map<String, String>> _cards = [
    {
      'title': 'Sweet Moment ✨',
      'quote': 'Every moment spent with you is like a beautiful dream come true.',
      'icon': '💖',
    },
    {
      'title': 'Pure Warmth 🌸',
      'quote': 'Your laugh is literally my favorite sound in the whole world.',
      'icon': '🌟',
    },
    {
      'title': 'My Favorite Place 🏡',
      'quote': 'Wherever you are, that is where I feel most at home.',
      'icon': '🦋',
    },
    {
      'title': 'Infinite Gratitude 💌',
      'quote': 'Thank you for making my life so much brighter just by being in it.',
      'icon': '🌹',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Screen Title
        Text(
          'Moments & Memories',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn().slideY(begin: -0.2, end: 0),

        const SizedBox(height: 8),

        Text(
          'Swipe cards to read 💖',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: LoveTheme.secondaryRose,
          ),
        ),

        const SizedBox(height: 28),

        // Carousel Slider
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _cards.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final card = _cards[index];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: GlassCard(
                  padding: const EdgeInsets.all(24),
                  borderRadius: 28,
                  borderColor: index == _currentPage
                      ? LoveTheme.primaryNeonPink
                      : LoveTheme.cardBorderGlass,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        card['icon']!,
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        card['title']!,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: LoveTheme.secondaryRose,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        card['quote']!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dancingScript(
                          fontSize: 22,
                          color: Colors.white.withOpacity(0.9),
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

        const SizedBox(height: 20),

        // Page Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _cards.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? LoveTheme.primaryNeonPink
                    : Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),

        const SizedBox(height: 36),

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
                    'Next Game 🎮',
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
    );
  }
}
