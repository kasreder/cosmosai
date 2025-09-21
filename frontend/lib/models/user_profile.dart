// File: frontend/lib/models/user_profile.dart
// Description: Immutable user profile model storing authentication and metadata used throughout the service.

import 'package:intl/intl.dart';

import 'login_method.dart';

/// Represents a single user within the ecosystem.
class UserProfile {
  /// Creates a new immutable user profile instance.
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.nickname,
    required this.loginMethod,
    required this.point,
    required this.createdAt,
    required this.updatedAt,
    this.localPassword,
    this.memo1,
    this.memo2,
    this.memo3,
  });

  /// Unique identifier that doubles as login email.
  final String id;

  /// Real name of the user.
  final String name;

  /// Email value also used as ID.
  final String email;

  /// Nickname displayed on posts and comments.
  final String nickname;

  /// Stored only for local login users.
  final String? localPassword;

  /// Selected login method used by this user.
  final LoginMethod loginMethod;

  /// Gamification points.
  final int point;

  /// Joined timestamp.
  final DateTime createdAt;

  /// Last update timestamp.
  final DateTime updatedAt;

  /// Reserved for Web3 wallet information.
  final String? memo1;

  /// Reserved for Web3 wallet information.
  final String? memo2;

  /// Reserved for Web3 wallet information.
  final String? memo3;

  /// Formats the creation timestamp for UI rendering.
  String get createdLabel => DateFormat('yyyy-MM-dd').format(createdAt);

  /// Formats the last update timestamp for UI rendering.
  String get updatedLabel => DateFormat('yyyy-MM-dd').format(updatedAt);

  /// Returns a copy with an updated point balance.
  UserProfile copyWithPoint(int nextPoint) => UserProfile(
        id: id,
        name: name,
        email: email,
        nickname: nickname,
        loginMethod: loginMethod,
        point: nextPoint,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
        localPassword: localPassword,
        memo1: memo1,
        memo2: memo2,
        memo3: memo3,
      );
}
