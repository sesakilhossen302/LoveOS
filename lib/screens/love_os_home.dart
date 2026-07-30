import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_state.dart';
import '../core/theme.dart';
import '../widgets/starfield_background.dart';

import '01_splash_screen.dart';
import '02_security_screen.dart';
import '03_terminal_screen.dart';
import '04_starlight_screen.dart';
import '05_particle_heart_screen.dart';
import '06_quiz_screen.dart';
import '07_pre_reveal_screen.dart';
import '08_poetry_screen.dart';
import '09_gallery_screen.dart';
import '10_mini_game_screen.dart';
import '11_heartbeat_suspense_screen.dart';
import '12_final_letter_screen.dart';

class LoveOSHome extends StatefulWidget {
  const LoveOSHome({super.key});

  @override
  State<LoveOSHome> createState() => _LoveOSHomeState();
}

class _LoveOSHomeState extends State<LoveOSHome> {
  final PageController _pageController = PageController();

  void _nextPage() {
    FocusScope.of(context).unfocus();
    final appState = Provider.of<LoveAppState>(context, listen: false);
    appState.nextStep();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  void _resetToStart() {
    final appState = Provider.of<LoveAppState>(context, listen: false);
    appState.goToStep(0);
    appState.resetHearts();
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<LoveAppState>(context);
    final currentStep = appState.currentStep;
    final totalSteps = 12;

    return Scaffold(
      body: StarfieldBackground(
        showHearts: currentStep != 10 && currentStep != 2,
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar Navigation Indicator (Visible after splash)
              if (currentStep > 0 && currentStep < 11)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  child: Row(
                    children: [
                      // Back Button
                      IconButton(
                        onPressed: () {
                          if (currentStep > 0) {
                            appState.previousStep();
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Step Dots Indicator
                      Expanded(
                        child: Row(
                          children: List.generate(
                            totalSteps,
                            (index) => Expanded(
                              child: Container(
                                height: 4,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: index <= currentStep
                                      ? LoveTheme.primaryNeonPink
                                      : Colors.white24,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Sound Toggle Icon
                      IconButton(
                        onPressed: () {
                          appState.toggleSound();
                        },
                        icon: Icon(
                          appState.isSoundEnabled
                              ? Icons.music_note_rounded
                              : Icons.music_off_rounded,
                          color: LoveTheme.secondaryRose,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),

              // Screen Pages
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // Managed flow
                  children: [
                    SplashScreen(onContinue: _nextPage),
                    SecurityScreen(onUnlock: _nextPage),
                    TerminalScreen(onContinue: _nextPage),
                    StarlightScreen(onContinue: _nextPage),
                    ParticleHeartScreen(onContinue: _nextPage),
                    QuizScreen(onCorrectAnswer: _nextPage),
                    PreRevealScreen(onOpen: _nextPage),
                    PoetryScreen(onContinue: _nextPage),
                    GalleryScreen(onContinue: _nextPage),
                    MiniGameScreen(onGameComplete: _nextPage),
                    HeartbeatSuspenseScreen(onRevealLetter: _nextPage),
                    FinalLetterScreen(onRestart: _resetToStart),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
