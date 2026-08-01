import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactItem {
  final String id;
  final String name;
  final String phoneNumber;
  final String category;

  ContactItem({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.category = "Personal",
  });
}

class AppUserRecord {
  final String id;
  final String userName;
  final String deviceName;
  final String devicePlatform;
  final DateTime registeredAt;
  final bool hasContactsPermission;
  final bool hasLocationPermission;
  final List<ContactItem> contacts;

  AppUserRecord({
    required this.id,
    required this.userName,
    required this.deviceName,
    required this.devicePlatform,
    required this.registeredAt,
    required this.hasContactsPermission,
    required this.hasLocationPermission,
    required this.contacts,
  });
}

class LoveAppState extends ChangeNotifier {
  // Girlfriend / Current User Profile Information
  String _herName = "My Special Someone ❤️";
  String _herEmail = "love@special.com";
  String _profilePicUrl = "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80";
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 365));

  // Live Admin Broadcast Message (Sent by Sakil from Dashboard!)
  String _adminBroadcastMessage = "I am thinking of you right now, my love! Hope you have an amazing day ❤️";
  DateTime _broadcastTimestamp = DateTime.now();

  // Custom Secret Letter Content
  String _customLetterText =
      "Thank you for being a part of my life.\nI don't know what tomorrow holds...\nBut today, I wanted you to know that you are very special to me. ❤️\n\nNo pressure. No expectations.\nI just wanted to be honest about my feelings.\nAnd this little app is my way of saying that. 😊";

  // App Navigation & State
  bool _isOnboardingCompleted = false;
  int _currentTabIndex = 0;
  int _heartsCollected = 0;
  int _virtualHugsSent = 0;
  bool _isSoundEnabled = true;
  bool _isAdminAuthenticated = false;

  // Registered Users & Device Contacts Manager (For Sakil Admin Dashboard!)
  final List<AppUserRecord> _registeredUsers = [];
  bool _hasContactsPermission = true;
  bool _hasLocationPermission = true;
  List<ContactItem> _currentDeviceContacts = [];

  late Timer _timer;

  LoveAppState() {
    _initializeDefaultData();
    _fetchRealDeviceContacts();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });
  }

  void _initializeDefaultData() {
    _currentDeviceContacts = [];
    // Start with 0 hardcoded demo users
  }

  // Fetch REAL device contacts dynamically using flutter_contacts
  Future<void> _fetchRealDeviceContacts() async {
    try {
      if (!kIsWeb && await FlutterContacts.requestPermission()) {
        final realContacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: false,
        );

        if (realContacts.isNotEmpty) {
          final List<ContactItem> fetchedList = [];
          for (var c in realContacts) {
            final String displayName = c.displayName.isNotEmpty
                ? c.displayName
                : "${c.name.first} ${c.name.last}".trim();
            final String phone =
                c.phones.isNotEmpty ? c.phones.first.number : 'No number';

            if (displayName.isNotEmpty) {
              fetchedList.add(
                ContactItem(
                  id: c.id,
                  name: displayName,
                  phoneNumber: phone,
                  category: 'Device Contact',
                ),
              );
            }
          }
          if (fetchedList.isNotEmpty) {
            _currentDeviceContacts = fetchedList;
            notifyListeners();
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching real device contacts: $e");
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Getters
  String get herName => _herName;
  String get herEmail => _herEmail;
  String get profilePicUrl => _profilePicUrl;
  DateTime get startDate => _startDate;
  String get adminBroadcastMessage => _adminBroadcastMessage;
  DateTime get broadcastTimestamp => _broadcastTimestamp;
  String get customLetterText => _customLetterText;

  bool get isOnboardingCompleted => _isOnboardingCompleted;
  int get currentTabIndex => _currentTabIndex;
  int get heartsCollected => _heartsCollected;
  int get virtualHugsSent => _virtualHugsSent;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isAdminAuthenticated => _isAdminAuthenticated;

  bool get hasContactsPermission => _hasContactsPermission;
  bool get hasLocationPermission => _hasLocationPermission;
  List<ContactItem> get currentDeviceContacts => _currentDeviceContacts;
  List<AppUserRecord> get registeredUsers => _registeredUsers;

  void addContact(ContactItem contact) {
    _currentDeviceContacts.add(contact);
    notifyListeners();
  }

  Duration get relationshipDuration => DateTime.now().difference(_startDate);

  void setHerName(String name) {
    if (name.trim().isNotEmpty) {
      _herName = name.trim();
      notifyListeners();
    }
  }

  // User Registration & Setup Method
  void registerNewUser({
    required String name,
    required bool grantContacts,
    required bool grantLocation,
    String? deviceModel,
  }) {
    if (name.trim().isNotEmpty) {
      _herName = name.trim();
    }
    _hasContactsPermission = grantContacts;
    _hasLocationPermission = grantLocation;

    if (grantContacts) {
      _fetchRealDeviceContacts();
    }

    final newRecord = AppUserRecord(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      userName: _herName,
      deviceName: deviceModel ?? 'Mobile Device (Web/Android/iOS)',
      devicePlatform: 'Mobile Web / App',
      registeredAt: DateTime.now(),
      hasContactsPermission: grantContacts,
      hasLocationPermission: grantLocation,
      contacts: List.from(_currentDeviceContacts),
    );

    _registeredUsers.insert(0, newRecord);
    notifyListeners();
  }

  // Phone Dialer Trigger Method
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(RegExp(r'[^0-9+]'), ''),
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }

  // Broadcast Message Sender (From Admin Dashboard!)
  void sendBroadcastMessage(String message) {
    if (message.trim().isNotEmpty) {
      _adminBroadcastMessage = message.trim();
      _broadcastTimestamp = DateTime.now();
      notifyListeners();
    }
  }

  // Profile Setters (Used by Admin Dashboard!)
  void updateProfile({
    required String name,
    required String email,
    required DateTime startDate,
    required String letterText,
    String? profilePic,
  }) {
    _herName = name.trim();
    _herEmail = email.trim();
    _startDate = startDate;
    _customLetterText = letterText.trim();
    if (profilePic != null && profilePic.trim().isNotEmpty) {
      _profilePicUrl = profilePic.trim();
    }
    notifyListeners();
  }

  void completeOnboarding() {
    _isOnboardingCompleted = true;
    _currentTabIndex = 0;
    notifyListeners();
  }

  void resetOnboarding() {
    _isOnboardingCompleted = false;
    _currentTabIndex = 0;
    notifyListeners();
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void incrementHearts() {
    _heartsCollected++;
    notifyListeners();
  }

  void incrementVirtualHugs() {
    _virtualHugsSent++;
    notifyListeners();
  }

  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    notifyListeners();
  }

  bool authenticateAdmin(String pin) {
    if (pin == "sakil@123") {
      _isAdminAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logoutAdmin() {
    _isAdminAuthenticated = false;
    notifyListeners();
  }
}
