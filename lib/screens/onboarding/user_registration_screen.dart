import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../widgets/glass_card.dart';

class UserRegistrationScreen extends StatefulWidget {
  final VoidCallback onSetupComplete;

  const UserRegistrationScreen({super.key, required this.onSetupComplete});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  late TextEditingController _nameController;
  bool _grantContacts = true;
  bool _grantLocation = true;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<LoveAppState>(context, listen: false);
    _nameController = TextEditingController(
      text: appState.herName.contains("Special") ? "" : appState.herName,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitRegistration() async {
    final String nameText = _nameController.text.trim();
    final appState = Provider.of<LoveAppState>(context, listen: false);

    if (_grantContacts) {
      await appState.requestContactsPermission();
    }
    if (_grantLocation) {
      await appState.requestLocationPermission();
    }

    appState.registerNewUser(
      name: nameText.isEmpty ? "My Special Someone ❤️" : nameText,
      grantContacts: _grantContacts,
      grantLocation: _grantLocation,
      deviceModel: 'Mobile Phone Device',
    );

    widget.onSetupComplete();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<LoveAppState>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LoveTheme.romanticGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Animated Header Icon
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LoveTheme.buttonGradient,
                      boxShadow: [
                        BoxShadow(
                          color: LoveTheme.primaryNeonPink.withOpacity(0.5),
                          blurRadius: 25,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_pin_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                ),

                const SizedBox(height: 24),

                Text(
                  'Welcome to LoveOS ❤️',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ).animate().fadeIn().slideY(begin: -0.2, end: 0),

                const SizedBox(height: 6),

                Text(
                  'Please set up your profile and device permissions to continue.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: LoveTheme.secondaryRose,
                  ),
                ),

                const SizedBox(height: 32),

                // Name Input Card
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 20,
                  borderColor: LoveTheme.primaryNeonPink,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.badge_rounded,
                              color: LoveTheme.primaryNeonPink, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Enter Your Name',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "Type your name here...",
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: LoveTheme.secondaryRose.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: LoveTheme.primaryNeonPink,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 150.ms),

                const SizedBox(height: 20),

                // Permission Requests Card
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Device Permissions',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: LoveTheme.secondaryRose,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to grant permission access on your phone.',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Contacts Permission Toggle
                      SwitchListTile(
                        value: _grantContacts,
                        activeThumbColor: LoveTheme.primaryNeonPink,
                        onChanged: (val) async {
                          setState(() {
                            _grantContacts = val;
                          });
                          if (val) {
                            await appState.requestContactsPermission();
                          }
                        },
                        title: Text(
                          'Contacts Permission 📞',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          _grantContacts
                              ? 'Status: Permission Enabled ✓'
                              : 'Tap to request contacts permission',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: _grantContacts
                                ? const Color(0xFF00F5D4)
                                : Colors.white60,
                          ),
                        ),
                      ),

                      const Divider(color: Colors.white12),

                      // Location Permission Toggle
                      SwitchListTile(
                        value: _grantLocation,
                        activeThumbColor: LoveTheme.primaryNeonPink,
                        onChanged: (val) async {
                          setState(() {
                            _grantLocation = val;
                          });
                          if (val) {
                            await appState.requestLocationPermission();
                          }
                        },
                        title: Text(
                          'Location Permission 📍',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          _grantLocation
                              ? 'Status: Permission Enabled ✓'
                              : 'Tap to request location permission',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: _grantLocation
                                ? const Color(0xFF00F5D4)
                                : Colors.white60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitRegistration,
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
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Grant Permissions & Enter App 🚀',
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.3, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
