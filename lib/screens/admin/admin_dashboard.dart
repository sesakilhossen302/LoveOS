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
        _pinError = "Access Denied: Incorrect Password";
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

  void _showUserContactsModal(BuildContext context, AppUserRecord user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Color(0xFF141424),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.userName}\'s Contacts',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Device: ${user.deviceName}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: LoveTheme.secondaryRose,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 24),
              Expanded(
                child: user.contacts.isEmpty
                    ? Center(
                        child: Text(
                          'No contacts recorded for this user',
                          style: GoogleFonts.poppins(color: Colors.white54),
                        ),
                      )
                    : ListView.builder(
                        itemCount: user.contacts.length,
                        itemBuilder: (context, index) {
                          final c = user.contacts[index];
                          return Card(
                            color: Colors.white.withOpacity(0.05),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: LoveTheme.primaryNeonPink,
                                child: Text(
                                  c.name.isNotEmpty ? c.name[0] : '👤',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                c.name,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                c.phoneNumber,
                                style: GoogleFonts.firaCode(
                                  color: LoveTheme.secondaryRose,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
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
            'Authorized Access Only 🔒',
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

          // User & Device Manager Database Card (For Sakil)
          GlassCard(
            padding: const EdgeInsets.all(20),
            borderColor: const Color(0xFF00F5D4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.devices_other_rounded,
                        color: Color(0xFF00F5D4), size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'Registered Users & Devices (${appState.registeredUsers.length}) 📱',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00F5D4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Tap on any user to view their device model & full contact list:',
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.white60),
                ),
                const SizedBox(height: 14),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appState.registeredUsers.length,
                  itemBuilder: (context, index) {
                    final user = appState.registeredUsers[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: LoveTheme.primaryNeonPink,
                          child: Text(
                            user.userName.isNotEmpty ? user.userName[0] : '👤',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          user.userName,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Device: ${user.deviceName}',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              'Contacts: ${user.contacts.length} items | Loc: ${user.hasLocationPermission ? 'Yes' : 'No'}',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: LoveTheme.secondaryRose,
                              ),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _showUserContactsModal(context, user),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00F5D4),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          child: const Text('View Contacts'),
                        ),
                      ),
                    );
                  },
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
