import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_state.dart';
import 'main_navigation.dart';
import 'onboarding/onboarding_screen.dart';

class LoveOSHome extends StatelessWidget {
  const LoveOSHome({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<LoveAppState>(context);

    if (!appState.isOnboardingCompleted) {
      return const Scaffold(
        body: OnboardingScreen(),
      );
    }

    return const MainNavigationScreen();
  }
}
