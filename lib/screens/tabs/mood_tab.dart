import 'package:flutter/material.dart';
import '../09_mood_selector_screen.dart';

class MoodTab extends StatelessWidget {
  const MoodTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MoodSelectorScreen(
      onContinue: () {
        // Stay in mood tab
      },
    );
  }
}
