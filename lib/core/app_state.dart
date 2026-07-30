import 'package:flutter/material.dart';

class LoveAppState extends ChangeNotifier {
  String _herName = "My Special Someone ❤️";
  int _currentStep = 0;
  int _heartsCollected = 0;
  bool _isSoundEnabled = true;

  String get herName => _herName;
  int get currentStep => _currentStep;
  int get heartsCollected => _heartsCollected;
  bool get isSoundEnabled => _isSoundEnabled;

  void setHerName(String name) {
    if (name.trim().isNotEmpty) {
      _herName = name.trim();
      notifyListeners();
    }
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
