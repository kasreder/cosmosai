// File: frontend/lib/providers/auth_provider.dart
// Description: Authentication provider managing dummy sessions and placeholder OAuth key configuration.

import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/login_method.dart';
import '../models/user_profile.dart';

/// Provider responsible for tracking the currently authenticated user.
class AuthProvider extends ChangeNotifier {
  /// Dummy credential store to simulate backend authentication.
  final DummyDatabase _database = DummyDatabase.instance;

  /// OAuth client keys for each provider. Replace placeholders when real keys exist.
  final Map<LoginMethod, String> oauthClientKeys = <LoginMethod, String>{
    LoginMethod.kakao: '실제 사용키 삽입',
    LoginMethod.google: '실제 사용키 삽입',
    LoginMethod.naver: '실제 사용키 삽입',
  };

  /// Currently authenticated user profile.
  UserProfile? _currentUser;

  /// Exposes the current user.
  UserProfile? get currentUser => _currentUser;

  /// Returns whether a user is logged in.
  bool get isAuthenticated => _currentUser != null;

  /// Attempts a local login by matching email and password against dummy data.
  Future<bool> signInWithLocal({
    required String email,
    required String password,
  }) async {
    // Filter dummy users by email and password for simulation purposes.
    final UserProfile? match = _database.users.firstWhere(
      (user) =>
          user.email == email &&
          user.loginMethod == LoginMethod.local &&
          user.localPassword == password,
      orElse: () => const UserProfile(
        id: '',
        name: '',
        email: '',
        nickname: '',
        loginMethod: LoginMethod.local,
        point: 0,
        createdAt: DateTime(1970),
        updatedAt: DateTime(1970),
      ),
    );

    if (match.id.isEmpty) {
      return false;
    }
    _currentUser = match;
    notifyListeners();
    return true;
  }

  /// Simulates social login flows by selecting the first matching dummy user.
  Future<bool> signInWithSocial(LoginMethod method) async {
    // OAuth flow would be implemented here once backend integration is ready.
    final UserProfile? match = _database.users.firstWhere(
      (user) => user.loginMethod == method,
      orElse: () => const UserProfile(
        id: '',
        name: '',
        email: '',
        nickname: '',
        loginMethod: LoginMethod.local,
        point: 0,
        createdAt: DateTime(1970),
        updatedAt: DateTime(1970),
      ),
    );
    if (match.id.isEmpty) {
      return false;
    }
    _currentUser = match;
    notifyListeners();
    return true;
  }

  /// Clears the current session.
  void signOut() {
    _currentUser = null;
    notifyListeners();
  }
}
