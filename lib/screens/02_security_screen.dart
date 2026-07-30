import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/app_state.dart';
import '../core/theme.dart';
import '../widgets/glass_card.dart';

class SecurityScreen extends StatefulWidget {
  final VoidCallback onUnlock;

  const SecurityScreen({super.key, required this.onUnlock});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  late TextEditingController _nameController;
  bool _isEditingName = false;
  bool _isUnlocking = false;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<LoveAppState>(context, listen: false);
    _nameController = TextEditingController(text: appState.herName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleUnlock() {
    final appState = Provider.of<LoveAppState>(context, listen: false);
    if (_nameController.text.trim().isNotEmpty) {
      appState.setHerName(_nameController.text.trim());
    }

    setState(() {
      _isUnlocking = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        widget.onUnlock();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<LoveAppState>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Security Warning Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⚠️ ', style: TextStyle(fontSize: 16)),
                Text(
                  'CONFIDENTIAL & PRIVATE',
                  style: GoogleFonts.firaCode(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().shake(duration: 600.ms),

          const SizedBox(height: 28),

          // Main Glass Security Vault Card
          GlassCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                // Lock Icon
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isUnlocking
                        ? const Color(0xFF00F5D4).withOpacity(0.2)
                        : LoveTheme.primaryNeonPink.withOpacity(0.2),
                    border: Border.all(
                      color: _isUnlocking
                          ? const Color(0xFF00F5D4)
                          : LoveTheme.primaryNeonPink,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _isUnlocking
                        ? Icons.lock_open_rounded
                        : Icons.lock_rounded,
                    size: 40,
                    color: _isUnlocking
                        ? const Color(0xFF00F5D4)
                        : LoveTheme.primaryNeonPink,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Encrypted File',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'ACCESS LEVEL:',
                  style: GoogleFonts.firaCode(
                    fontSize: 12,
                    color: Colors.white60,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 8),

                // Name Box (Tap to customize for your gf!)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditingName = !_isEditingName;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: LoveTheme.secondaryRose.withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        if (!_isEditingName) ...[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                appState.herName,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: LoveTheme.secondaryRose,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.edit_rounded,
                                size: 16,
                                color: Colors.white54,
                              ),
                            ],
                          ),
                        ] else ...[
                          TextField(
                            controller: _nameController,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: LoveTheme.secondaryRose,
                            ),
                            decoration: const InputDecoration(
                              hintText: "Enter Her Name...",
                              border: InputBorder.none,
                            ),
                            onSubmitted: (val) {
                              if (val.trim().isNotEmpty) {
                                appState.setHerName(val.trim());
                              }
                              setState(() {
                                _isEditingName = false;
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '(Tap to personalize name)',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white38,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: 36),

          // Unlock Button
          ElevatedButton(
            onPressed: _isUnlocking ? null : _handleUnlock,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 12,
              shadowColor: LoveTheme.primaryNeonPink.withOpacity(0.6),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LoveTheme.buttonGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 48, vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.key_rounded,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Unlock File 🔒',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().scale(
                delay: 400.ms,
                duration: 400.ms,
                curve: Curves.elasticOut,
              ),
        ],
      ),
    );
  }
}
