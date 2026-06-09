import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login(String user, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (user.trim() == 'Miau' && password == '1234') {
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
