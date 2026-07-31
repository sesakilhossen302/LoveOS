import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/app_state.dart';
import '../core/theme.dart';
import '../widgets/glass_card.dart';

class TerminalScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const TerminalScreen({super.key, required this.onContinue});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final List<String> _terminalLogs = [];
  bool _isSearchComplete = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _runTerminalSequence();
  }

  void _runTerminalSequence() async {
    final appState = Provider.of<LoveAppState>(context, listen: false);
    final String herName = appState.herName;

    final List<Map<String, dynamic>> sequence = [
      {'text': '> Initializing LoveOS Kernel v2.4...', 'delay': 400},
      {'text': '> Connecting to heart matrix...', 'delay': 700},
      {'text': '> Searching database for most amazing person...', 'delay': 900},
      {'text': '> Searching [■■□□□□□□□□] 20%', 'delay': 500},
      {'text': '> Searching [■■■■■■□□□□] 60%', 'delay': 600},
      {'text': '> Searching [■■■■■■■■■■] 100%', 'delay': 700},
      {'text': '> Matching biometric emotion signature...', 'delay': 800},
      {'text': '> SUCCESS: Found exactly 1 Person!', 'delay': 800},
    ];

    for (var item in sequence) {
      await Future.delayed(Duration(milliseconds: item['delay']));
      if (!mounted) return;
      setState(() {
        _terminalLogs.add(item['text']);
      });
    }

    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isSearchComplete = true;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<LoveAppState>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cyber Terminal Box
          Container(
            height: 240,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LoveTheme.terminalGradient,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF00F5D4).withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00F5D4).withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Terminal Header
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: Colors.redAccent, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: Colors.amberAccent, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: Colors.greenAccent, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'bash - heart_scan.sh',
                      style: GoogleFonts.firaCode(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white12, height: 20),

                // Terminal Logs
                Expanded(
                  child: ListView.builder(
                    itemCount: _terminalLogs.length,
                    itemBuilder: (context, index) {
                      final isSuccess =
                          _terminalLogs[index].contains('SUCCESS');
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Text(
                          _terminalLogs[index],
                          style: GoogleFonts.firaCode(
                            fontSize: 13,
                            color: isSuccess
                                ? const Color(0xFF00F5D4)
                                : LoveTheme.secondaryRose.withOpacity(0.9),
                            fontWeight: isSuccess
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms),

          const SizedBox(height: 28),

          // Found Result Card
          if (_isSearchComplete) ...[
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.favorite, color: LoveTheme.primaryNeonPink),
                      const SizedBox(width: 8),
                      Text(
                        'TARGET IDENTIFIED',
                        style: GoogleFonts.firaCode(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Name:',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.white60,
                        ),
                      ),
                      Text(
                        appState.herName,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: LoveTheme.secondaryRose,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status:',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.white60,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: LoveTheme.primaryNeonPink.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: LoveTheme.primaryNeonPink,
                          ),
                        ),
                        child: Text(
                          'Very Special ❤️',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),

            const SizedBox(height: 32),

            // Continue Button
            Center(
              child: ElevatedButton(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 44, vertical: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Enter Main App 🚀',
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
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
          ],
        ],
      ),
    );
  }
}
