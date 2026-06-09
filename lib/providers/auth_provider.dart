import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _service = AuthService();
  User? _user;
  bool _loading = false;
  String? _error;

  User? get user => _user;
  bool get loading => _loading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  String get displayName =>
      (_user?.userMetadata?['full_name'] as String? ?? '').split(' ').first;

  String get email => _user?.email ?? '';

  AuthProvider() {
    _user = _service.currentUser;
    _service.authStateChanges.listen((state) {
      _user = state.session?.user;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.signIn(email: email, password: password);
      _loading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Unexpected error. Please try again.';
    }
    _loading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signUp(
      String email, String password, String fullName) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.signUp(
          email: email, password: password, fullName: fullName);
      _loading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Unexpected error. Please try again.';
    }
    _loading = false;
    notifyListeners();
    return false;
  }

  Future<void> signOut() => _service.signOut();
}
