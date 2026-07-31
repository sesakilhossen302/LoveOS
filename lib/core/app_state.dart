import 'dart:async';
import 'package:flutter/material.dart';

class LoveAppState extends ChangeNotifier {
  String _herName = "My Special Someone ❤️";
  int _currentStep = 0;
  int _heartsCollected = 0;
  bool _isSoundEnabled = true;

  // Relationship start date (default to 1 year ago, customizable)
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 365));
  late Timer _timer;

  LoveAppState() {
    // Update live counter every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get herName => _herName;
  int get currentStep => _currentStep;
  int get heartsCollected => _heartsCollected;
  bool get isSoundEnabled => _isSoundEnabled;
  DateTime get startDate => _startDate;

  Duration get relationshipDuration => DateTime.now().difference(_startDate);

  void setHerName(String name) {
    if (name.trim().isNotEmpty) {
      _herName = name.trim();
      notifyListeners();
    }
  }

  void setStartDate(DateTime date) {
    _startDate = date;
    notifyListeners();
  }

  void nextStep() {
    _currentStep++;
    notifyListeners();
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void incrementHearts() {
    _heartsCollected++;
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
}
