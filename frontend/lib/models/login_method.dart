// File: frontend/lib/models/login_method.dart
// Description: Enumerations and helpers describing the supported login providers for the multi-board service.

/// Supported login methods for authenticating a user.
enum LoginMethod {
  /// Local login that validates the password managed inside the platform.
  local,

  /// Kakao social login integration.
  kakao,

  /// Google social login integration.
  google,

  /// Naver social login integration.
  naver,
}

/// Helper extension to convert the enum into a user facing label.
extension LoginMethodLabel on LoginMethod {
  /// Returns the localized label for each login method.
  String get label {
    switch (this) {
      case LoginMethod.local:
        return '로컬';
      case LoginMethod.kakao:
        return '카카오';
      case LoginMethod.google:
        return '구글';
      case LoginMethod.naver:
        return '네이버';
    }
  }
}
