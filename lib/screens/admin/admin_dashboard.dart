import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../widgets/glass_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final TextEditingController _pinController = TextEditingController();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _letterController;
  late TextEditingController _broadcastController;
  DateTime? _selectedDate;
  bool _isAuthenticated = false;
  String? _pinError;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<LoveAppState>(context, listen: false);
    _nameController = TextEditingController(text: appState.herName);
    _emailController = TextEditingController(text: appState.herEmail);
    _letterController = TextEditingController(text: appState.customLetterText);
    _broadcastController =
        TextEditingController(text: appState.adminBroadcastMessage);
    _selectedDate = appState.startDate;
    _isAuthenticated = appState.isAdminAuthenticated;
  }

  @override
  void dispose() {
    _pinController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _letterController.dispose();
    _broadcastController.dispose();
    super.dispose();
  }

  void _verifyPin() {
    final appState = Provider.of<LoveAppState>(context, listen: false);
    if (appState.authenticateAdmin(_pinController.text)) {
      setState(() {
        _isAuthenticated = true;
        _pinError = null;
      });
    } else {
      setState(() {
        _pinError = "Incorrect PIN code! Default is 1234";
      });
    }
  }

  void _sendLiveMessage() {
    final appState = Provider.of<LoveAppState>(context, listen: false);
    appState.sendBroadcastMessage(_broadcastController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Live message broadcasted to her Home screen! 💌',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: LoveTheme.primaryNeonPink,
      ),
    );
  }

  void _saveSettings() {
    final appState = Provider.of<LoveAppState>(context, listen: false);
    appState.updateProfile(
      name: _nameController.text,
      email: _emailController.text,
      startDate: _selectedDate ?? appState.startDate,
      letterText: _letterController.text,
    );
    appState.sendBroadcastMessage(_broadcastController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Settings & Live Message updated successfully! ❤️',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<LoveAppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🔑 Admin Dashboard',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: LoveTheme.backgroundDark,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: LoveTheme.romanticGradient),
        child: SafeArea(
          child: !_isAuthenticated
              ? _buildPinLockView()
              : _buildAdminForm(appState),
        ),
      ),
    );
  }

  Widget _buildPinLockView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_person_rounded,
              size: 64, color: LoveTheme.primaryNeonPink),
          const SizedBox(height: 16),
          Text(
            'Enter Admin Secret PIN',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Default PIN code: 1234',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54),
          ),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              textAlign: TextAlign.center,
              style: GoogleFonts.firaCode(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
                color: LoveTheme.secondaryRose,
              ),
              decoration: const InputDecoration(
                hintText: "PIN",
                border: InputBorder.none,
              ),
            ),
          ),
          if (_pinError != null) ...[
            const SizedBox(height: 12),
            Text(_pinError!,
                style: GoogleFonts.poppins(color: Colors.redAccent)),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _verifyPin,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              backgroundColor: LoveTheme.primaryNeonPink,
            ),
            child: Text(
              'Unlock Dashboard 🔑',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminForm(LoveAppState appState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Live Message Broadcast Box
          GlassCard(
            padding: const EdgeInsets.all(20),
            borderColor: LoveTheme.primaryNeonPink,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.send_rounded,
                        color: LoveTheme.primaryNeonPink, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'Broadcast Live Message To Her App 💌',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: LoveTheme.secondaryRose,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Type a message to instantly display on her Home screen:',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _broadcastController,
                  maxLines: 2,
                  style: GoogleFonts.poppins(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Type message to send her...",
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _sendLiveMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LoveTheme.primaryNeonPink,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  label: Text(
                    'Broadcast Message Now 🚀',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Girlfriend Profile & Letter Settings Box
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Girlfriend Settings',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: LoveTheme.secondaryRose)),
                const SizedBox(height: 16),
                Text('Her Name:',
                    style: GoogleFonts.poppins(color: Colors.white70)),
                TextField(
                  controller: _nameController,
                  style: GoogleFonts.poppins(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Enter name",
                    hintStyle: TextStyle(color: Colors.white38),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Her Email:',
                    style: GoogleFonts.poppins(color: Colors.white70)),
                TextField(
                  controller: _emailController,
                  style: GoogleFonts.poppins(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Enter email",
                    hintStyle: TextStyle(color: Colors.white38),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Anniversary Start Date:',
                    style: GoogleFonts.poppins(color: Colors.white70)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2010),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd')
                              .format(_selectedDate ?? appState.startDate),
                          style: GoogleFonts.firaCode(color: Colors.white),
                        ),
                        const Icon(Icons.calendar_month, color: Colors.white70),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Custom Secret Letter Message:',
                    style: GoogleFonts.poppins(color: Colors.white70)),
                const SizedBox(height: 8),
                TextField(
                  controller: _letterController,
                  maxLines: 5,
                  style: GoogleFonts.poppins(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _saveSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: LoveTheme.primaryNeonPink,
              padding: const EdgeInsets.all(16),
            ),
            child: Text(
              'Save & Apply Live Settings ❤️',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),

          const SizedBox(height: 16),

          OutlinedButton(
            onPressed: () {
              appState.resetOnboarding();
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.amber),
              padding: const EdgeInsets.all(14),
            ),
            child: Text(
              'Reset Onboarding (View Intro Again) 🔄',
              style: GoogleFonts.poppins(color: Colors.amber),
            ),
          ),
        ],
      ),
    );
  }
}
