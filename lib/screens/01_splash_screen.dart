import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../core/theme.dart';
import '../screens/admin/admin_dashboard.dart';
import '../widgets/glass_card.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const SplashScreen({super.key, required this.onContinue});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  String _statusText = "Initializing...";
  bool _isCompleted = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startLoadingSequence();
  }

  void _startLoadingSequence() {
    _timer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (!mounted) return;
      setState(() {
        _progress += 0.02;

        if (_progress < 0.3) {
          _statusText = "Loading Memories... 💭";
        } else if (_progress < 0.7) {
          _statusText = "Loading Emotions... ❤️";
        } else if (_progress < 0.98) {
          _statusText = "Preparing Something Special... ✨";
        } else {
          _progress = 1.0;
          _statusText = "Completed ✓";
          _isCompleted = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _openSecretAdminDashboard() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 100% Invisible Secret Top Left Admin Portal Trigger Area (For Sakil Only)
        Positioned(
          top: 0,
          left: 0,
          child: GestureDetector(
            onTap: _openSecretAdminDashboard,
            child: Container(
              width: 70,
              height: 70,
              color: Colors.transparent,
            ),
          ),
        ),

        // Main Content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Heart Logo (Double tap secret trigger)
              GestureDetector(
                onDoubleTap: _openSecretAdminDashboard,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LoveTheme.buttonGradient,
                    boxShadow: [
                      BoxShadow(
                        color: LoveTheme.primaryNeonPink.withOpacity(0.6),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(
                    duration: 1200.ms,
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1.08, 1.08),
                    curve: Curves.easeInOut,
                  ),

              const SizedBox(height: 36),

              // Title & Subtitle
              Text(
                'Secret Message',
                style: GoogleFonts.outfit(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),

              const SizedBox(height: 8),

              Text(
                '"Some feelings are better experienced than read."',
                textAlign: TextAlign.center,
                style: GoogleFonts.dancingScript(
                  fontSize: 20,
                  color: LoveTheme.secondaryRose,
                  fontWeight: FontWeight.w600,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 800.ms),

              const SizedBox(height: 48),

              // Progress Glass Card
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _statusText,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: _isCompleted
                                ? const Color(0xFF00F5D4)
                                : Colors.white.withOpacity(0.9),
                          ),
                        ),
                        Text(
                          '${(_progress * 100).toInt()}%',
                          style: GoogleFonts.firaCode(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: LoveTheme.secondaryRose,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearPercentIndicator(
                      lineHeight: 10.0,
                      percent: _progress.clamp(0.0, 1.0),
                      backgroundColor: Colors.white10,
                      progressColor: _isCompleted
                          ? const Color(0xFF00F5D4)
                          : LoveTheme.primaryNeonPink,
                      barRadius: const Radius.circular(10),
                      padding: EdgeInsets.zero,
                      animation: false,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 40),

              // Continue Button
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _isCompleted ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !_isCompleted,
                  child: ElevatedButton(
                    onPressed: widget.onContinue,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10,
                      shadowColor: LoveTheme.primaryNeonPink.withOpacity(0.5),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LoveTheme.buttonGradient,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Continue to App 🚀',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
