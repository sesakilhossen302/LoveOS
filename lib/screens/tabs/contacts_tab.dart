import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../widgets/glass_card.dart';

class ContactsTab extends StatefulWidget {
  const ContactsTab({super.key});

  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _addNameController = TextEditingController();
  final TextEditingController _addPhoneController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    _addNameController.dispose();
    _addPhoneController.dispose();
    super.dispose();
  }

  void _showAddContactDialog(BuildContext context) {
    final appState = Provider.of<LoveAppState>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF141424),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: LoveTheme.primaryNeonPink),
          ),
          title: Text(
            'Add Phone Contact 📞',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _addNameController,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Contact Name",
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _addPhoneController,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _addNameController.text.trim();
                final phone = _addPhoneController.text.trim();
                if (name.isNotEmpty && phone.isNotEmpty) {
                  appState.addContact(
                    ContactItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      phoneNumber: phone,
                      category: 'Personal',
                    ),
                  );
                  _addNameController.clear();
                  _addPhoneController.clear();
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: LoveTheme.primaryNeonPink,
              ),
              child: const Text('Save Contact', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showContactDetailsModal(BuildContext context, ContactItem contact) {
    final appState = Provider.of<LoveAppState>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF141424),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: LoveTheme.primaryNeonPink,
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LoveTheme.buttonGradient,
                  border: Border.all(color: LoveTheme.secondaryRose, width: 2),
                ),
                child: Center(
                  child: Text(
                    contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '👤',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                contact.name,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                contact.phoneNumber,
                style: GoogleFonts.firaCode(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: LoveTheme.secondaryRose,
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        appState.makePhoneCall(contact.phoneNumber);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.call_rounded, color: Colors.white),
                      label: Text(
                        'Call Now 📞',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<LoveAppState>(context);
    final contacts = appState.currentDeviceContacts.where((c) {
      final query = _searchQuery.toLowerCase();
      return c.name.toLowerCase().contains(query) ||
          c.phoneNumber.contains(query);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Device Contacts 📞',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Real Device Address Book',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: LoveTheme.secondaryRose,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                onPressed: () => _showAddContactDialog(context),
                style: IconButton.styleFrom(
                  backgroundColor: LoveTheme.primaryNeonPink,
                ),
                icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
              ),
            ],
          ).animate().fadeIn().slideY(begin: -0.2, end: 0),

          const SizedBox(height: 20),

          // Search Field Card
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            borderRadius: 20,
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                icon: const Icon(Icons.search_rounded, color: Colors.white54),
                hintText: "Search by name or number...",
                hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 14),
                border: InputBorder.none,
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, color: Colors.white54),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = "";
                          });
                        },
                      )
                    : null,
              ),
            ),
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: 20),

          // Contacts List View
          if (contacts.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  const Icon(Icons.contact_support_rounded,
                      size: 48, color: Colors.white38),
                  const SizedBox(height: 12),
                  Text(
                    'No device contacts found yet.',
                    style: GoogleFonts.poppins(color: Colors.white60),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddContactDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LoveTheme.primaryNeonPink,
                    ),
                    icon: const Icon(Icons.add_call, color: Colors.white),
                    label: const Text('Add Phone Contact',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ] else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contacts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return GlassCard(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 18,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LoveTheme.buttonGradient,
                      ),
                      child: Center(
                        child: Text(
                          contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '👤',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      contact.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      contact.phoneNumber,
                      style: GoogleFonts.firaCode(
                        fontSize: 13,
                        color: LoveTheme.secondaryRose,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.phone_in_talk_rounded,
                          color: Colors.greenAccent),
                      onPressed: () {
                        appState.makePhoneCall(contact.phoneNumber);
                      },
                    ),
                    onTap: () => _showContactDetailsModal(context, contact),
                  ),
                ).animate().fadeIn(delay: Duration(milliseconds: 100 + (index * 50)));
              },
            ),
          ],
        ],
      ),
    );
  }
}
