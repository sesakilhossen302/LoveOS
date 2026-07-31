import 'dart:async';
import 'package:flutter/material.dart';

class LoveAppState extends ChangeNotifier {
  // Girlfriend Profile Information
  String _herName = "My Special Someone ❤️";
  String _herEmail = "love@special.com";
  String _profilePicUrl = "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80";
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 365));

  // Live Admin Broadcast Message (Sent by Sakil from Dashboard!)
  String _adminBroadcastMessage = "I am thinking of you right now, my love! Hope you have an amazing day ❤️";
  DateTime _broadcastTimestamp = DateTime.now();

  // Customizable Custom Letter Content
  String _customLetterText =
      "Thank you for being a part of my life.\nI don't know what tomorrow holds...\nBut today, I wanted you to know that you are very special to me. ❤️\n\nNo pressure. No expectations.\nI just wanted to be honest about my feelings.\nAnd this little app is my way of saying that. 😊";

  // App Navigation & State
  bool _isOnboardingCompleted = false;
  int _currentTabIndex = 0;
  int _heartsCollected = 0;
  int _virtualHugsSent = 0;
  bool _isSoundEnabled = true;
  bool _isAdminAuthenticated = false;

  late Timer _timer;

  LoveAppState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });
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

  Duration get relationshipDuration => DateTime.now().difference(_startDate);

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

  void setHerName(String name) {
    if (name.trim().isNotEmpty) {
      _herName = name.trim();
      notifyListeners();
    }
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

  void resetHearts() {
    _heartsCollected = 0;
    notifyListeners();
  }

  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    notifyListeners();
  }

  bool authenticateAdmin(String pin) {
    if (pin == "1234") {
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
