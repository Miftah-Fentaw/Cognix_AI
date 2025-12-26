import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 800));
    _isAuthenticated = true;
    _setLoading(false);
  }

  Future<void> signUp(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 800));
    _isAuthenticated = true;
    _setLoading(false);
  }

  Future<void> continueWithGoogle() async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 800));
    _isAuthenticated = true;
    _setLoading(false);
  }

  void signOut() {
    _isAuthenticated = false;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
