import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_state.dart';
import '../01_splash_screen.dart';
import '../02_security_screen.dart';
import '../03_terminal_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  void _nextStep() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  void _finishOnboarding() {
    final appState = Provider.of<LoveAppState>(context, listen: false);
    appState.completeOnboarding();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SplashScreen(onContinue: _nextStep),
        SecurityScreen(onUnlock: _nextStep),
        TerminalScreen(onContinue: _finishOnboarding),
      ],
    );
  }
}
