import 'package:flutter/material.dart';
import '../09_gallery_screen.dart';
import '../12_final_letter_screen.dart';

class MemoriesTab extends StatefulWidget {
  const MemoriesTab({super.key});

  @override
  State<MemoriesTab> createState() => _MemoriesTabState();
}

class _MemoriesTabState extends State<MemoriesTab> {
  bool _showLetter = false;

  @override
  Widget build(BuildContext context) {
    if (_showLetter) {
      return FinalLetterScreen(
        onRestart: () {
          setState(() {
            _showLetter = false;
          });
        },
      );
    }

    return GalleryScreen(
      onContinue: () {
        setState(() {
          _showLetter = true;
        });
      },
    );
  }
}
