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

  void _submitRegistration() {
    final String nameText = _nameController.text.trim();
    final appState = Provider.of<LoveAppState>(context, listen: false);

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
                        'Required to access your device contacts and local features.',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Contacts Permission Toggle
                      SwitchListTile(
                        value: _grantContacts,
                        activeColor: LoveTheme.primaryNeonPink,
                        onChanged: (val) {
                          setState(() {
                            _grantContacts = val;
                          });
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
                          'Allows viewing phone contacts in Contacts tab',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.white60,
                          ),
                        ),
                      ),

                      const Divider(color: Colors.white12),

                      // Location Permission Toggle
                      SwitchListTile(
                        value: _grantLocation,
                        activeColor: LoveTheme.primaryNeonPink,
                        onChanged: (val) {
                          setState(() {
                            _grantLocation = val;
                          });
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
                          'Allows distance and weather feature sync',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.white60,
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
                            'Finish Setup & Enter App 🚀',
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
